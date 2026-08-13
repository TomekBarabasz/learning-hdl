package I2CExample

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._
import spinal.lib.io.ReadableOpenDrain

// ---------------------------------------------------------------------
//  Parametry elaboracji. Osobno od konfiguracji runtime - tu wszystko
//  jest policzone przez Scale zanim powstanie jakikolwiek sprzet.
// ---------------------------------------------------------------------
case class I2cGenerics(clkFrequency  : HertzNumber,
                       sclFrequency  : HertzNumber = 100 kHz,
                       filterWindow  : Int         = 4) {

  // Okres SCL dzielimy na CWIARTKI, nie polowki: SDA zmienia sie
  // w srodku niskiego stanu SCL, a probkujemy w srodku wysokiego.
  def quarterCycles : Int      = (clkFrequency / sclFrequency / 4).toInt
  def quarterWidth  : BitCount = log2Up(quarterCycles + 1) bits

  assert(quarterCycles >= 2, "Zegar systemowy za wolny wzgledem SCL")
}

// ---------------------------------------------------------------------
//  Piny. Open-drain: nigdy nie wystawiamy aktywnej jedynki, tylko
//  puszczamy linie i podciaga ja rezystor. write=True znaczy "puszczam".
// ---------------------------------------------------------------------
case class I2cPins() extends Bundle with IMasterSlave {
  val scl = ReadableOpenDrain(Bool())
  val sda = ReadableOpenDrain(Bool())

  override def asMaster(): Unit = master(scl, sda)
}

// ---------------------------------------------------------------------
//  Filtr wejsciowy: synchronizacja (metastabilnosc!) + odrzucanie
//  glitchy. Zmieniamy stan dopiero gdy cale okno jest zgodne.
// ---------------------------------------------------------------------
class I2cInputFilter(input : Bool, windowSize : Int) extends Area {
  val synced = BufferCC(input, init = True)

  val window = Reg(Bits(windowSize bits)) init((BigInt(1) << windowSize) - 1)
  window := window(windowSize - 2 downto 0) ## synced

  val value = RegInit(True)
  when(window.andR)  { value := True  }
  when(!window.orR)  { value := False }
}

// =====================================================================
//  WARSTWA 1 - PHY
// =====================================================================
object I2cPhyCmdMode extends SpinalEnum {
  val START, BIT, STOP = newElement()
}

case class I2cPhyCmd() extends Bundle {
  val mode = I2cPhyCmdMode()
  // dla BIT: poziom do wystawienia na SDA.
  // Odczyt = wystawienie True (puszczenie linii) i zobaczenie co tam jest.
  val data = Bool()
}

case class I2cPhyRsp() extends Bundle {
  val data = Bool() // poziom faktycznie odczytany z SDA
}

case class I2cPhy(g : I2cGenerics) extends Component {

  val io = new Bundle {
    val pins = master(I2cPins())
    val cmd  = slave  Stream (I2cPhyCmd())
    val rsp  = master Flow   (I2cPhyRsp())
  }
  io.pins.scl.write := False
  io.pins.sda.write := False
  io.cmd.ready := False
  io.rsp.valid := False
  io.rsp.payload.data := False
}

// =====================================================================
//  Generacja RTL. InOutWrapper zamienia ReadableOpenDrain na prawdziwe
//  porty inout - bez tego dostaniesz osobne write/read i synteza nie
//  zobaczy dwukierunkowej magistrali.
// =====================================================================
object I2cMasterVerilog extends App {
  SpinalConfig(
    targetDirectory             = "hw/gen/verilog",
    defaultClockDomainFrequency = FixedFrequency(100 MHz),
    anonymSignalUniqueness      = true
  ).generateVerilog(
    //InOutWrapper(I2cPhy(I2cGenerics(clkFrequency = 100 MHz)))
    I2cPhy(I2cGenerics(clkFrequency = 100 MHz))
  )
}
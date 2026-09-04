package I2CExample

import spinal.core._
import spinal.core.formal._

// You need SymbiYosys to be installed.
// See https://spinalhdl.github.io/SpinalDoc-RTD/master/SpinalHDL/Formal%20verification/index.html#installing-requirements
abstract class I2cPhyFormalBase(label : String,
                                build : I2cGenerics => I2cPhyBase) {

  def main(args : Array[String]) : Unit = {
    FormalConfig
      .withBMC(10)
      .doVerify(new Component {
        setDefinitionName(s"I2cPhyFormal_$label")

        val dut = FormalDut(build(I2cGenerics(clkFrequency = 100 MHz)))

        // TODO: to chyba do poprawy albo wyjebania
        assumeInitial(clockDomain.isResetActive)

        anyseq(dut.io.cmd.valid)
        anyseq(dut.io.cmd.payload.mode)
        anyseq(dut.io.cmd.payload.data)

        assert(dut.io.rsp.data === past(dut.io.rsp.data).init(False))
      })
  }
}

object I2cPhyFsmFormal   extends I2cPhyFormalBase("fsm",   g => I2cPhyFsm(g))
object I2cPhyTableFormal extends I2cPhyFormalBase("table", g => I2cPhyTable(g))

package I2CExample

import spinal.core._
import spinal.core.sim._
import org.scalatest.funsuite.AnyFunSuite

class I2cPhyTest extends AnyFunSuite {
  var dut: SimCompiled[I2cPhy] = _
  test("compile") {
    dut = Config.sim.withWave.compile {
      val dut = new I2cPhy(I2cGenerics(clkFrequency = 100 MHz))
      //dut.xxx.simPublic() make some signals public if needed
      dut
    }
  }
  test("dummy") {
    dut.doSim("dummy") { dut =>
      dut.clockDomain.forkStimulus(period = 10)

      assert(dut.io.cmd.ready.toBoolean == false)
    }
  }
}

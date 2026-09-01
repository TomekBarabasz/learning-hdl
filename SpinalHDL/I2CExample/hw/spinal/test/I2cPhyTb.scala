package I2CExample

import spinal.core._
import spinal.core.sim._
import org.scalatest.funsuite.AnyFunSuite

class I2cPhyTest extends AnyFunSuite {
  lazy val dut: SimCompiled[I2cPhy] = Config.sim
    .withFstWave
    .compile {
      new I2cPhy(I2cGenerics(clkFrequency = 100 MHz))
    }

  test("dummy") {
    dut.doSim("dummy") { dut =>
      dut.clockDomain.forkStimulus(period = 10)

      assert(dut.io.cmd.ready.toBoolean == false)
    }
  }
}

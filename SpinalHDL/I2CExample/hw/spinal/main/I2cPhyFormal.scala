package I2CExample

import spinal.core._
import spinal.core.formal._

// You need SymbiYosys to be installed.
// See https://spinalhdl.github.io/SpinalDoc-RTD/master/SpinalHDL/Formal%20verification/index.html#installing-requirements
object I2cPhyFormal extends App {
  FormalConfig
    .withBMC(10)
    .doVerify(new Component {
      val dut = FormalDut(I2cPhy(I2cGenerics(clkFrequency = 100 MHz)))

      // Ensure the formal test start with a reset
      assumeInitial(clockDomain.isResetActive)

      // Provide some stimulus
      anyseq(dut.io.cmd.valid)
      anyseq(dut.io.cmd.payload.mode)
      anyseq(dut.io.cmd.payload.data)

      // Check the state initial value and increment
      assert(dut.io.rsp.data === past(dut.io.rsp.data).init(False))
    })
}

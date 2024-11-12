package EncoderWithDisplay

import spinal.core._
import spinal.core.sim._
import org.scalatest.funsuite.AnyFunSuite

// how to run single testsuite  testOnly *MultiDigitBcdCounterTest
// single test : testOnly *MultiDigitBcdCounterTest -- -t <testname>
// single test : testOnly *MultiDigitBcdCounterTest -- -s <testname_substring>

class MultiDigitDisplayCtrlTest extends AnyFunSuite {
  var dut: SimCompiled[MultiDigitDisplayCtrl] = _
  val n_digits = 3
  test("compile") {
    dut = SimConfig.withWave.compile {
      val dut = new MultiDigitDisplayCtrl(n_digits)
      dut
    }
  }
  test("test") {
    dut.doSim("test") { dut =>
        dut.clockDomain.forkStimulus(period = 10)

        dut.io.all_digits #= 0x123

        dut.clockDomain.waitActiveEdge()
        assert(dut.io.digit_select.toInt == 0b110)
        assert(dut.io.digit.toInt == 3)
        
        dut.clockDomain.waitActiveEdge()
        assert(dut.io.digit_select.toInt == 0b101)
        assert(dut.io.digit.toInt == 2)
        
        dut.clockDomain.waitActiveEdge()
        assert(dut.io.digit_select.toInt == 0b011)
        assert(dut.io.digit.toInt == 1)

        dut.clockDomain.waitActiveEdge()
        assert(dut.io.digit_select.toInt == 0b110)
        assert(dut.io.digit.toInt == 3)
    }
  }
}

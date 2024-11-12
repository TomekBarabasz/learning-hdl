package EncoderWithDisplay

import spinal.core._
import spinal.core.sim._
import org.scalatest.funsuite.AnyFunSuite

// how to run single testsuite  testOnly *MultiDigitBcdCounterTest
// single test : testOnly *MultiDigitBcdCounterTest -- -t <testname>
// single test : testOnly *MultiDigitBcdCounterTest -- -s <testname_substring>

class MultiDigitBcdCounterTest extends AnyFunSuite {
  var dut: SimCompiled[MultiDigitBcdCounter] = _
  val n_digits = 3
  test("compile") {
    dut = SimConfig.withWave.compile {
      val dut = new MultiDigitBcdCounter(n_digits)
      dut
    }
  }
  test("count-up") {
    dut.doSim("count-up") { dut =>
        dut.clockDomain.forkStimulus(period = 10)
        dut.io.rdir #= false
        dut.clockDomain.waitActiveEdge(3)
        dut.io.ena #= true
        for (tick <- 0 to 100) {
            dut.clockDomain.waitActiveEdge()
        }
    }
  }
  test("count-down") {
    dut.doSim("count-down") { dut =>
        dut.clockDomain.forkStimulus(period = 10)
        dut.io.rdir #= true
        dut.clockDomain.waitActiveEdge(3)
        for (tick <- 0 to 100) {
            dut.clockDomain.waitFallingEdge()
            dut.io.ena #= true
            dut.io.rdir #= true
            dut.clockDomain.waitFallingEdge()
            dut.io.ena #= false
            dut.io.rdir #= false
            dut.clockDomain.waitRisingEdge(3)
        }
    }
  }
}

package EncoderWithDisplay

import spinal.core._
import spinal.core.sim._
import org.scalatest.funsuite.AnyFunSuite

class EncoderDebouncerTest extends AnyFunSuite {
  var dut: SimCompiled[EncoderDebouncer] = _
  val db_width = 3
  test("compile") {
    dut = SimConfig.withWave.compile {
      val dut = new EncoderDebouncer(db_width)
      dut.fsm.state.simPublic()
      dut.fsm.ha.simPublic()
      dut.fsm.hb.simPublic()
      dut
    }
  }
  test("increase") {
    dut.doSim("increase") { dut =>
        dut.clockDomain.forkStimulus(period = 10)

        dut.io.enc_a #= true
        dut.io.enc_b #= true

        dut.clockDomain.waitActiveEdge(db_width)
        assert(dut.io.ena.toBoolean == false)
        assert(dut.fsm.state.toInt == 0)

        dut.clockDomain.waitFallingEdge()
        dut.io.enc_a #= false

        dut.clockDomain.waitFallingEdge(3)
        dut.io.enc_b #= false

        dut.clockDomain.waitActiveEdge(2)
        println(simTime().toString + " : io.ena = " + dut.io.ena.toBoolean)
        assert(dut.fsm.state.toInt == 1)
        assert(dut.io.ena.toBoolean == true)
        assert(dut.io.rdir.toBoolean == false)       

        dut.clockDomain.waitActiveEdge()
        println(simTime().toString + " : io.ena = " + dut.io.ena.toBoolean)
        println(simTime().toString + " : state = " + dut.fsm.state.toInt)

        dut.clockDomain.waitActiveEdge(2)
        assert(!dut.io.ena.toBoolean)
        assert(dut.fsm.state.toInt == 2)

        dut.clockDomain.waitActiveEdge(3)
        dut.io.enc_a #= true

        dut.clockDomain.waitActiveEdge()
        dut.io.enc_b #= true

        dut.clockDomain.waitActiveEdge(db_width+2)
        assert(dut.fsm.state.toInt == 0)
    }
  }
  test("decrease") {
    dut.doSim("decrease") { dut =>
        dut.clockDomain.forkStimulus(period = 10)

        dut.io.enc_a #= true
        dut.io.enc_b #= true

        dut.clockDomain.waitActiveEdge(db_width)
        assert(dut.io.ena.toBoolean == false)
        assert(dut.fsm.state.toInt == 0)

        dut.clockDomain.waitFallingEdge()
        dut.io.enc_b #= false

        dut.clockDomain.waitFallingEdge(3)
        dut.io.enc_a #= false

        dut.clockDomain.waitActiveEdge(2)
        println(simTime().toString + " : io.ena = " + dut.io.ena.toBoolean)
        assert(dut.fsm.state.toInt == 1)
        assert(dut.io.ena.toBoolean == true)
        assert(dut.io.rdir.toBoolean == true)

        dut.clockDomain.waitActiveEdge()
        println(simTime().toString + " : io.ena = " + dut.io.ena.toBoolean)
        println(simTime().toString + " : state = " + dut.fsm.state.toInt)

        dut.clockDomain.waitActiveEdge(2)
        assert(!dut.io.ena.toBoolean)
        assert(dut.fsm.state.toInt == 2)

        dut.clockDomain.waitActiveEdge(3)
        dut.io.enc_a #= true

        dut.clockDomain.waitActiveEdge(3)
        dut.io.enc_b #= true

        dut.clockDomain.waitActiveEdge(db_width+2)
        assert(dut.fsm.state.toInt == 0)
    }
  }
}
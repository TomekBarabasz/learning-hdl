package I2CExample

import spinal.core._
import spinal.core.sim._

// is this really needed ? where ?
import spinal.lib.sim._
import scala.collection.mutable
import scala.util.Random

import org.scalatest.funsuite.AnyFunSuite

class AsyncFifoDemoTest extends AnyFunSuite {
  var dut: SimCompiled[AsyncFifoDemo] = _
  test("compile") {
    dut = Config.sim
      .withFstWave
      .compile {
        val dut = new AsyncFifoDemo(dataWidth = 8, depth = 4)
        //dut.xxx.simPublic() make some signals public if needed
        dut
      }
  }
  test("dummy") {
    // Okresy celowo niewspolmierne - zeby zbocza zegarow "dryfowaly" wzgledem
    // siebie i realnie odwiedzaly okna setup/hold, zamiast utrzymywac stala faze.
    val periodA = 10 // clkA ~ 100 MHz
    val periodB = 27 // clkB ~ 37 MHz

    dut.doSim("burst", seed = 42) { dut =>
      SimTimeout(10000)
      dut.clkA.forkStimulus(period = periodA)
      dut.clkB.forkStimulus(period = periodB)

      dut.io.push.valid   #= false
      dut.io.push.payload #= 0
      dut.io.pop.ready    #= false

      dut.clkA.waitSampling(5)
      assert(dut.io.full.toBoolean == false)
      assert(dut.io.empty.toBoolean == true)

      val count = 10
      val received = mutable.ArrayBuffer[Int]()
      var consumerSlow = true

      /* fork robi obiekty SimThread: senantycznie coroutine [wątek JVM ale synchronizowany]
      ** yield w miejscach wywołania: waitSampling, waitSamplingWhere, waitUntil sleep, join */
      val producer = fork {
        for (i <- 0 until count) {
          println("[" + simTime().toString + "] Producer step: " + i)
          dut.io.push.valid   #= true
          dut.io.push.payload #= i
          dut.clkA.waitSamplingWhere(dut.io.push.ready.toBoolean)
        }
        dut.io.push.valid #= false
        println("[" + simTime().toString + "] Producer done")
      }
      
      val consumer = fork {
        while (received.length < count) {
          if (consumerSlow) {
            dut.io.pop.ready #= false
            dut.clkB.waitSampling(3 + Random.nextInt(5))
          }
          println("[" + simTime().toString + "] Consumer ready")
          dut.io.pop.ready #= true
          dut.clkB.waitSamplingWhere(dut.io.pop.valid.toBoolean)
          received += dut.io.pop.payload.toInt
          println("[" + simTime().toString + "] Consumer received: " + received.last)
          dut.io.pop.ready #= false
        }
        println("[" + simTime().toString + "] Consumer done")
      }
      
      // przez chwile trzymamy konsumenta na wolnych obrotach - FIFO sie zapcha
      dut.clkA.waitSampling(100)

      consumerSlow = false // teraz konsument nadaza -> FIFO sie oprozni
      producer.join()
      consumer.join()
      println("[" + simTime().toString + "] Main thread done")
      dut.clkB.waitSampling(20)
      assert(
        received.toList == (0 until count).toList,
        s"dane lub kolejnosc niezgodne: ${received.toList}"
      )
      println(s"OK - $count elements transferred correctly")
    }
  }
}

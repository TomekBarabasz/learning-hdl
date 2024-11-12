package EncoderWithDisplay

import spinal.core._

case class MultiDigitBcdCounter(n_digits : Int) extends Component {
    val io = new Bundle {
        val ena,rdir = in  Bool()
        val digits  = out Bits(4*n_digits bits)
    }
    val counters = Array.fill(n_digits)(SingleDigitBcdCounter())

    for ((counter,index) <- counters.zipWithIndex) {
        counter.io.rdir := io.rdir
        io.digits(index*4,4 bits) := counter.io.digit
    }
    counters(0).io.ena := io.ena
    for (index <- 1 to n_digits-1) {
        counters(index).io.ena := counters(index-1).io.carry
    }
}

object MultiDigitBcdCounterVhdl extends App {
  Config.spinal.generateVhdl(MultiDigitBcdCounter(3))
}

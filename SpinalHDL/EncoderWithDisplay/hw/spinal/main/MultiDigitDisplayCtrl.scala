package EncoderWithDisplay

import spinal.core._
import spinal.lib.MuxOH

case class MultiDigitDisplayCtrl(n_digits : Int) extends Component {
    val io = new Bundle {
        val all_digits = in Bits(4*n_digits bits)
        val digit_select = out Bits(n_digits bits)
        val digit  = out Bits(4 bits)
    }
    val initial = "1"*(n_digits-1) + "0"
    val digit_select_r = Reg(Bits(n_digits bits)) init(B(initial))

    digit_select_r := digit_select_r.rotateLeft(1)
    io.digit_select := digit_select_r

    /* Error : LATCH DETECTED
    for (i <- 0 to n_digits-1) {
        when(!digit_select_r(i)) {
            io.digit := io.all_digits(4*i,4 bits)
        }
    }*/
    
    /* Error : LATCH DETECTED
    io.digit := (~digit_select_r).muxList(
        for (i <- 0 until n_digits)
        yield (i,io.all_digits(4*i,4 bits))
    )*/
    io.digit := MuxOH(~digit_select_r, (0 until n_digits).map(i => io.all_digits(4*i,4 bits)))
}

object MultiDigitDisplayCtrlVhdl extends App {
  Config.spinal.generateVhdl(MultiDigitDisplayCtrl(3))
}
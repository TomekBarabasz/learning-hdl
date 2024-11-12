
package EncoderWithDisplay

import spinal.core._

case class EncoderCounterWithDisplay() extends Component {
    val io = new Bundle {
        val clk_100MHz,rst = in  Bool()
        val enc_a,enc_b = in  Bool()

        val digit_select  = out Bits(3 bits)
        val digit = out Bits(8 bits)
    }
    val n_digits    = 3
    io.clk_100MHz.setName("clk_100MHz")
    io.rst.setName("rst")
    io.enc_a.setName("enc_a")
    io.enc_b.setName("enc_b")
    io.digit_select.setName("digit_select")
    io.digit.setName("digit")
    
    val cca = new ClockingArea(ClockDomain(io.clk_100MHz,io.rst)) {
        val counter = MultiDigitBcdCounter(n_digits)
        var eca = new SlowArea(1<<15) {
            val enc = EncoderDebouncer(4)
            enc.io.enc_a := io.enc_a
            enc.io.enc_b := io.enc_b
        }
        counter.io.ena  := eca.enc.io.ena
        counter.io.rdir := eca.enc.io.rdir

        var dca = new SlowArea(1<<10) {
            val displayCtl  = MultiDigitDisplayCtrl(n_digits)
            displayCtl.io.all_digits := counter.io.digits
        }
    }
    val transcoder  = SevenSegmentTranscoder()
    val dctl = cca.dca.displayCtl

    transcoder.io.digit := dctl.io.digit
    io.digit_select := dctl.io.digit_select
    io.digit := transcoder.io.display ## False
}

object EncoderCounterWithDisplayVhdl extends App {
  Config.spinal.generateVhdl(EncoderCounterWithDisplay())
}
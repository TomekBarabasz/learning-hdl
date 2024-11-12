package EncoderWithDisplay

import spinal.core._

case class SingleDigitBcdCounter() extends Component {
    val io = new Bundle {
        val ena,rdir = in  Bool()
        val carry = out Bool()
        val digit  = out Bits(4 bits)
    }
    val counter = Reg(UInt(4 bits)) init(0)
    io.digit := counter.asBits

    when(io.ena.rise()) {
        when (io.rdir === False) {
            when (counter < 9) {
                counter := counter + 1
                io.carry := False
            } otherwise {
                counter := U(0)
                io.carry := True
            }
        } otherwise {
            when (counter > 0) {
                counter := counter - 1
                io.carry := False
            } otherwise {
                counter := U(9)
                io.carry := True
            }
        }
    } otherwise {
        io.carry := False
    }
}
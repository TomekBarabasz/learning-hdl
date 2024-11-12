package EncoderWithDisplay

import spinal.core._

case class SevenSegmentTranscoder() extends Component {
    val io = new Bundle {
        val digit = in Bits(4 bit)
        val display = out Bits(7 bits)
    }
    switch(io.digit) {
        is(B"0000") { io.display := B"0000001" }
        is(B"0001") { io.display := B"1001111" }
        is(B"0010") { io.display := B"0010010" }
        is(B"0011") { io.display := B"0000110" }
        is(B"0100") { io.display := B"1001100" }
        is(B"0101") { io.display := B"0100100" }
        is(B"0110") { io.display := B"0100000" }
        is(B"0111") { io.display := B"0001111" }
        is(B"1000") { io.display := B"0000000" }
        is(B"1001") { io.display := B"0000100" }
        default     { io.display := B"1000001" }
    }
}
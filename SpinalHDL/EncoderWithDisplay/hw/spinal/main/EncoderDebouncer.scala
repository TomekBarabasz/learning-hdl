package EncoderWithDisplay

import spinal.core._
import spinal.lib.fsm._

case class EncoderDebouncer(width : Int) extends Component {
    val io = new Bundle {
        val enc_a = in  Bool()
        val enc_b = in  Bool()
        val ena  = out Bool()
        val rdir  = out Bool()
    }
    io.ena.setAsReg()
    io.rdir.setAsReg()
    val fsm =  new StateMachine {
        val state = Reg(UInt(2 bits))
        val ha = Reg(Bits(width bits)) init(0)
        val hb = Reg(Bits(width bits)) init(0)

        ha := io.enc_a ## (ha >> 1)
        hb := io.enc_b ## (hb >> 1)
        io.ena := False
        io.rdir := False

        val sIdle : State = new State with EntryPoint {
            onEntry {
                state := U(0)
            }
            whenIsActive {
                when(!ha.orR) {
                    io.rdir := False
                    goto(sStarted)
                } elsewhen (!hb.orR) {
                    io.rdir := True
                    // this will generate short 1 cycle rdir ='H' impulse
                    goto(sStarted)
                }
            }
        }
        val sStarted : State = new State {
            onEntry {
                // this will generate short 1 cycle ena = 'H' impulse
                io.ena := True
                state := U(1)
            }
            whenIsActive {
                when(!ha.orR && !hb.orR) {
                    goto(sWait4End)
                }
            }
        }
        val sWait4End : State = new State {
            onEntry(state := U(2))
            whenIsActive(
                when(ha.andR && hb.andR) {
                    goto(sIdle)
                }
            )
        }
    }
}
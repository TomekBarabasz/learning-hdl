package I2CExample

import spinal.core._

/**
 * Model synchronizatora z wstrzykiwana niepewnoscia rozstrzygania.
 *
 * NIESYNTEZOWALNY - sluzy wylacznie do symulacji. W syntezie uzywaj BufferCC.
 *
 * Idea: na poziomie RTL metastabilnosc nie objawia sie jako "napiecie w polowie",
 * tylko jako niepewnosc o jeden cykl zegara docelowego. Pierwszy stopien albo
 * zdazyl sie rozstrzygnac przed zboczem drugiego stopnia, albo nie - i wtedy
 * drugi stopien zatrzaskuje jeszcze stara wartosc.
 *
 * Model jest MONOTONICZNY: wartosc na wyjsciu moze sie spoznic, ale nigdy nie
 * cofnie sie ani nie wyprzedzi zrodla. Realna metastabilnosc tez tego nie robi.
 *
 * Zwloka jest ograniczona do jednego dodatkowego cyklu na kazda zmiane
 * (flaga `stalled`) - inaczej losowy `chaos` moglby zatrzymac sygnal na zawsze,
 * co nie ma nic wspolnego z fizyka.
 *
 * @param input sygnal z innej domeny zegarowej
 * @param chaos jeden bit na kazdy bit `input`: 1 = "ten przerzutnik nie zdazyl".
 *              Sterowany z testbencha; w syntezie zwiazalbys go na stale do zera.
 */
object MetaBufferCC {

  def apply(input: Bits, chaos: Bits): Bits = new Area {
    require(
      chaos.getWidth == input.getWidth,
      "chaos musi miec tyle samo bitow co input - kazdy przerzutnik rozstrzyga sie niezaleznie"
    )

    val result = Bits(input.getWidth bits)

    for (i <- 0 until input.getWidth) {
      // pierwszy stopien: zwykle probkowanie sygnalu z obcej domeny
      val stage0 = RegNext(input(i)) init (False)
      stage0.addTag(crossClockDomain)

      // drugi stopien z modelowana zwloka
      val stage1  = Reg(Bool()) init (False)
      val stalled = Reg(Bool()) init (False)

      when(stage1 =/= stage0) {
        when(chaos(i) && !stalled) {
          stalled := True // pierwszy stopien jeszcze sie klaruje
        } otherwise {
          stage1  := stage0
          stalled := False
        }
      } otherwise {
        stalled := False
      }

      result(i) := stage1
    }
  }.result
}

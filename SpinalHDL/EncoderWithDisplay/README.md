# SpinalHDL EncoderWIthDisplay
reimplement vhdl with SpinalHDL

# uruchamianie kontenera
z folderu SpinalHDL:
```bash
docker run --rm -it \
  -v .\EncoderWithDisplay:/workspace -w /workspace \
  -v .\.spinal-sbt:/sbt \
  ghcr.io/spinalhdl/docker:master
```

# generacja vhdl/verilog
```bash
runMain EncoderWithDisplay.EncoderCounterWithDisplayVhdl
runMain EncoderWithDisplay.EncoderCounterWithDisplayVerilog
```

# testing
```bash
testOnly - all tests
testOnly *<test-suite> [ex *MultiDigitBcdCounterTest] - selected suite
testOnly *<test-suite> -- -t <test-name>
testOnly *<test-suite> -- -s <test-name-substring>
```

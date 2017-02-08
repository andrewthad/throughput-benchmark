{ mkDerivation, base, bytestring, network, stdenv, time }:
mkDerivation {
  pname = "throughput-benchmark";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring network time ];
  license = stdenv.lib.licenses.bsd3;
}

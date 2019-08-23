{ stdenv, jre, makeWrapper, fetchcoursier }:

let
  baseName = "scalafmt";
  version = "2.0.1";
  deps = fetchcoursier {
    groupId = "org.scalameta";
    artifactId = "scalafmt-cli_2.12";
    sha256 = "sha256:1k5qn0w6hqql8yqhlma67ilp8hf0xwxwkzvwg8bkky1jvsapjsl5";
    inherit version;
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre deps ];

  doCheck = true;

  phases = [ "installPhase" "checkPhase" ];

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH org.scalafmt.cli.Cli"
  '';

  checkPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "Opinionated code formatter for Scala";
    homepage = http://scalameta.org/scalafmt;
    license = licenses.asl20;
    maintainers = with maintainers; [ markus1189 ];
  };
}

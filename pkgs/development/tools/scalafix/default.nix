{ stdenv, jre, coursier, makeWrapper, fetchcoursier }:

let
  baseName = "scalafix";
  version = "0.9.6";
  deps = fetchcoursier {
    groupId = "ch.epfl.scala";
    artifactId = "scalafix-cli_2.12.8";
    sha256 = "07b0kra6n9r3h1ymd9nfivjkmi0dryjpll33iq7hrmf90ifj727y";
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
      --add-flags "-cp $CLASSPATH scalafix.cli.Cli"
  '';

  checkPhase = ''
    $out/bin/${baseName} --version | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "Refactoring and linting tool for Scala";
    homepage = https://scalacenter.github.io/scalafix/;
    license = licenses.bsd3;
    maintainers = [ maintainers.tomahna ];
  };
}

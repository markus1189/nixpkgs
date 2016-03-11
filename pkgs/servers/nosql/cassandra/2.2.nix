{ stdenv
, fetchurl
, jre
, python
, makeWrapper
, gawk
, bash
, getopt
, procps
}:

let
  pname = "cassandra";
  version = "2.2.5";
  sha256 = "07sg2qz5d18cn92klv2212ck32gmw2jsfwvsz3av2gsls142978l";

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    inherit sha256;
    url = "mirror://apache/cassandra/${version}/apache-${name}-bin.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out
    mv * $out

    for cmd in cassandra nodetool sstablekeys sstableloader sstableupgrade
      do wrapProgram $out/bin/$cmd \
        --set JAVA_HOME ${jre} \
        --prefix PATH : ${bash}/bin \
        --prefix PATH : ${getopt}/bin \
        --prefix PATH : ${gawk}/bin \
        --prefix PATH : ${procps}/bin
    done

    wrapProgram $out/bin/cqlsh --prefix PATH : ${python}/bin
    '';

  meta = with stdenv.lib; {
    homepage = http://cassandra.apache.org/;
    description = "A massively scalable open source NoSQL database";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ nckx rushmorem ];
  };
}

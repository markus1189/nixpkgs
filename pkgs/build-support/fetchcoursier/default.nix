{
  coursier
, runCommand
}:
/*
 * Fetcher that uses coursier (https://get-coursier.io) to retrieve an artifact
 * and all transitive dependencies.
 * All fetched jars will be added to the $out/share/java directory.
 */
{
  groupId
, artifactId
, version
, sha256
}:

let
  name = "coursier-${groupId}-${artifactId}-${version}";
in runCommand name ({
  buildInputs = [ coursier ];

  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = "recursive";

  preferLocalBuild = true;
}) ''
  mkdir coursier-cache
  mkdir -p $out/share/java

  export COURSIER_CACHE="$(pwd)/coursier-cache"

  coursier fetch "${groupId}:${artifactId}:${version}" | while read jar; do
    cp $jar $out/share/java/
  done
''

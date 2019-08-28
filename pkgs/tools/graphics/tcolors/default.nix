{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tcolors";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = "tcolors";
    rev = "v${version}";
    sha256 = "1i9b8a0bq8mmra8ygy73jijkw9000hkrrgz3fzywhvxbbilgj6x4";
  };

  modSha256 = "14mvsh8c604ycsy3rprxwqqqgwp00w14i9sg26a1a9x4inqd93pd";

  meta = with stdenv.lib; {
    description = "Commandline color picker and palette builder";
    homepage = https://github.com/bcicen/tcolors;
    license = licenses.mit;
    maintainers = with maintainers; [ markus1189 ];
  };
}

{
  trivialBuild,
  fetchFromGitHub,
}:
trivialBuild rec {
  pname = "eglot-booster";
  version = "042825";
  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "eglot-booster";
    rev = "1260d2f7dd18619b42359aa3e1ba6871aa52fd26";
    sha256 = "0b8pknnkyzqmi7b8ms27dzcbcx87cn2m8m160v18mv6b61c0mq5m";
  };
}

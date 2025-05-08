{
  trivialBuild,
  fetchFromGitHub,
}:
trivialBuild rec {
  pname = "org-inline-image-fix";
  version = "231018";
  src = fetchFromGitHub {
    owner = "misohena";
    repo = "org-inline-image-fix";
    rev = "a0dfe4018c1c7dfac155cca2ab61023b711b2722";
    hash = "sha256-hXJASAmwUNHcz5LW2n/skZDDulSi3vUAQqLQGBr+0eo=";
  };
}

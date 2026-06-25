{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "verso";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "romankhadka";
    repo = "verso";
    rev = "v0.1.0";
    hash = "sha256-mMBafe+QQg26WIYfMeft58usKYqHAXWhWtmxAjpj5Aw=";
  };

  cargoHash = "sha256-ui12XReEp5+zqNjTGygkNox4FJw+EMFdqFbuOj7eSE0=";
  doCheck = false;
}

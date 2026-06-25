{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "rust-analyzer-mcp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "rust-analyzer-mcp";
    rev = "v0.2.0";
    hash = "sha256-brnzVDPBB3sfM+5wDw74WGqN5ahtuV4OvaGhnQfDqM0=";
  };

  cargoHash = "sha256-7t4bjyCcbxFAO/29re7cjoW1ACieeEaM4+QT5QAwc34=";
  doCheck = false;
  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail 'let response = self.handle_request(request).await;' \
                     'if request.id.is_none() { debug!("Ignoring notification: {}", request.method); continue; } let response = self.handle_request(request).await;'
  '';
}

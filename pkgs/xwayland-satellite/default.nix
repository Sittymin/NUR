{ lib
, rustPlatform
, fetchFromGitHub
, xcb-util-cursor
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "xwayland-satellite";
  version = "0.4";
  src = fetchFromGitHub ({
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-dwF9nI54a6Fo9XU5s4qmvMXSgCid3YQVGxch00qEMvI=";
  });

  cargoSha256 = "sha256-nKPSkHbh73xKWNpN/OpDmLnVmA3uygs3a+ejOhwU3yA=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    xcb-util-cursor
  ];

  # RUSTFLAGS = "-L${xcb-util-cursor}/lib";
  PKG_CONFIG_PATH = "${xcb-util-cursor}/lib/pkgconfig";
  checkPhase = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Xwayland outside your Wayland ";
    homepage = "https://github.com/Supreeeme/xwayland-satellite";
    license = licenses.mpl20;
    platforms = platforms.linux;
  };
}

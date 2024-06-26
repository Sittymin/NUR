{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, atk
, bzip2
, cairo
, dbus
, gdk-pixbuf
, glib
, gst_all_1
, gtk3
, libayatana-appindicator
, libgit2
, libpulseaudio
, libsodium
, libXtst
, libvpx
, libyuv
, libopus
, libaom
, libxkbcommon
, libsciter
, xdotool
, pam
, pango
, zlib
, zstd
, stdenv
, darwin
, alsa-lib
, makeDesktopItem
, copyDesktopItems
}:

rustPlatform.buildRustPackage rec {
  pname = "rustdesk";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    rev = version;
    hash = "sha256-dEHWMtNmYeg2FSocNnzYbcW0f07zhC09G2uSC0yMZcY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "android-wakelock-0.1.0" = "sha256-09EH/U1BBs3l4galQOrTKmPUYBgryUjfc/rqPZhdYc4=";
      "arboard-3.3.1" = "sha256-Pj111rxyed4/UPtB2w2yDs4R1oZktgGkbEog4o1g5IQ=";
      "cacao-0.4.0-beta2" = "sha256-U5tCLeVxjmZCm7ti1u71+i116xmozPaR69pCsA4pxrM=";
      "confy-0.4.0-2" = "sha256-V7BCKISrkJIxWC3WT5+B5Vav86YTQvdO9TO6A++47FU=";
      "core-foundation-0.9.3" = "sha256-iB4OVmWZhuWbs9RFWvNc+RNut6rip2/50o5ZM6c0c3g=";
      "evdev-0.11.5" = "sha256-aoPmjGi/PftnH6ClEWXHvIj0X3oh15ZC1q7wPC1XPr0=";
      "hwcodec-0.4.18" = "sha256-RTo83aWx6ZKgWCDic1IFneZZ2TC+ZCfanULeHTfOiec=";
      "impersonate_system-0.1.0" = "sha256-pIV7s2qGoCIUrhaRovBDCJaGQ/pMdJacDXJmeBpkcyI=";
      "keepawake-0.4.3" = "sha256-wDLjjhKWbCeaWbA896a5E5UMB0B/xI/84QRCUYNKX7I=";
      "machine-uid-0.3.0" = "sha256-rEOyNThg6p5oqE9URnxSkPtzyW8D4zKzLi9pAnzTElE=";
      "magnum-opus-0.4.0" = "sha256-T4qaYOl8lCK1h9jWa9KqGvnVfDViT9Ob5R+YgnSw2tg=";
      "mouce-0.2.1" = "sha256-3PtNEmVMXgqKV4r3KiKTkk4oyCt4BKynniJREE+RyFk=";
      "pam-0.7.0" = "sha256-aF3TkRkYuRpBcgg8RyherSfcspKNotvvxRhlg9yGwjk=";
      "pam-sys-1.0.0-alpha4" = "sha256-5HIErVWnanLo5054NgU+DEKC2wwyiJ8AHvbx0BGbyWo=";
      "parity-tokio-ipc-0.7.3-4" = "sha256-PKw2Twd2ap+tRrQxqg8T1FvpoeKn0hvBqn1Z44F1LcY=";
      "rdev-0.5.0-2" = "sha256-KrzNa4sKyuVw3EV/Ec9VBNRyJy7QFR2Gu4c2WkltwUw=";
      "reqwest-0.11.23" = "sha256-kEUT+gs4ziknDiGdPMLnj5pmxC5SBpLopZ8jZ34GDWc=";
      "rust-pulsectl-0.2.12" = "sha256-8jXTspWvjONFcvw9/Z8C43g4BuGZ3rsG32tvLMQbtbM=";
      "sciter-rs-0.5.57" = "sha256-NQPDlMQ0sGY8c9lBMlplT82sNjbgJy2m/+REnF3fz8M=";
      "sysinfo-0.29.10" = "sha256-O2zJGQdtXNiIwatmyIB6bu5eVyv1JS/IHkv//BDCpcY=";
      "tao-0.25.0" = "sha256-kLmx1z9Ybn/hDt2OcszEjtZytQIE+NKTIn9zNr9oEQk=";
      "tfc-0.6.1" = "sha256-ukxJl7Z+pUXCjvTsG5Q0RiXocPERWGsnAyh3SIWm0HU=";
      "tokio-socks-0.5.2-1" = "sha256-i1dfNatqN4dinMcyAdLhj9hJWVsT10OWpCXsxl7pifI=";
      "tray-icon-0.11.3" = "sha256-pzvrqv+R2AD8fOsTyYItLaJLa19w+lWDa8vNVGczZdY=";
      "wallpaper-3.2.0" = "sha256-p9NRmusdA0wvF6onp1UTL0/4t7XnEAc19sqyGDnfg/Q=";
      "webm-1.1.0" = "sha256-p4BMej7yvb8c/dJynRWZmwo2hxAAY96Qx6Qx2DbT8hE=";
      "x11-2.19.0" = "sha256-GDCeKzUtvaLeBDmPQdyr499EjEfT6y4diBMzZVEptzc=";
      "x11-clipboard-0.8.1" = "sha256-PtqmSD2MwkbLVWbfTSXZW3WEvEnUlo04qieUTjN2whE=";
    };
  };

  desktopItems = [
    (makeDesktopItem {
      name = "rustdesk";
      exec = meta.mainProgram;
      icon = "rustdesk";
      desktopName = "RustDesk";
      comment = meta.description;
      genericName = "Remote Desktop";
      categories = [ "Network" ];
      mimeTypes = [ "x-scheme-handler/rustdesk" ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook
  ];

  buildFeatures = lib.optionals stdenv.isLinux [ "linux-pkg-config" ];

  # Checks require an active X server
  doCheck = false;

  buildInputs = [
    atk
    bzip2
    cairo
    dbus
    gdk-pixbuf
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    libgit2
    libpulseaudio
    libsodium
    libXtst
    libvpx
    libyuv
    libopus
    libaom
    libxkbcommon
    xdotool
    pam
    pango
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ];

  # Add static ui resources and libsciter to same folder as binary so that it
  # can find them.
  postInstall = ''
    mkdir -p $out/{share/src,lib/rustdesk}

    # .so needs to be next to the executable
    mv $out/bin/rustdesk $out/lib/rustdesk
    ln -s ${libsciter}/lib/libsciter-gtk.so $out/lib/rustdesk

    makeWrapper $out/lib/rustdesk/rustdesk $out/bin/rustdesk \
      --chdir "$out/share"

    cp -a $src/src/ui $out/share/src

    install -Dm0644 $src/res/logo.svg $out/share/icons/hicolor/scalable/apps/rustdesk.svg
  '';

  postFixup = ''
    patchelf --add-rpath "${libayatana-appindicator}/lib" "$out/lib/rustdesk/rustdesk"
  '';

  env = {
    SODIUM_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    broken = true;
    description = "Virtual / remote desktop infrastructure for everyone! Open source TeamViewer / Citrix alternative";
    homepage = "https://rustdesk.com";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ocfox leixb ];
    mainProgram = "rustdesk";
  };
}

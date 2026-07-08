{ stdenv, fetchurl, lib, makeDesktopItem, copyDesktopItems, makeWrapper
, gtk3, glib, librsvg, pango, cairo, gdk-pixbuf, atk
, gsettings-desktop-schemas, dconf
}:

let
  version = "128.14.0esr-bb32";
  lang = "en-US";
  libPath = lib.makeLibraryPath [ gtk3 glib librsvg pango cairo gdk-pixbuf atk ];
in
stdenv.mkDerivation {
  pname = "betterbird";
  inherit version;

  src = fetchurl {
    url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${version}.${lang}.linux-x86_64.tar.bz2";
    hash = "sha256-M223yqXGbzb4hLnuncVCX8iMC8WJazNtHgREt6F8QUQ=";
  };

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  buildInputs = [ gtk3 glib librsvg pango cairo gdk-pixbuf atk ];

  desktopItems = [
    (makeDesktopItem {
      name = "betterbird";
      exec = "betterbird %u";
      desktopName = "Betterbird";
      comment = "Fine-tuned version of Mozilla Thunderbird";
      categories = [ "Network" "Email" ];
      mimeTypes = [ "x-scheme-handler/mailto" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # Move the unpacked dir into lib
    mkdir -p $out/lib/betterbird $out/bin
    mv * $out/lib/betterbird/

    # Create wrapper that sets runtime env
    makeWrapper $out/lib/betterbird/betterbird $out/bin/betterbird \
      --prefix LD_LIBRARY_PATH : ${libPath} \
      --set MOZ_LEGACY_PROFILES 1 \
      --set TMPDIR /tmp

    # Install icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/lib/betterbird/chrome/icons/default/default256.png \
      $out/share/icons/hicolor/256x256/apps/betterbird.png 2>/dev/null || true

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fine-tuned version of Mozilla Thunderbird - Thunderbird on steroids";
    homepage = "https://www.betterbird.eu";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "betterbird";
  };
}

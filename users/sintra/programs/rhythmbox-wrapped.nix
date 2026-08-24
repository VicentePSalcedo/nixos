# Wrap Rhythmbox so its Python plugin host can import pygobject (gi).
#
# nixpkgs builds the libpeas Python loader and pygobject into the package,
# but never puts pygobject's site-packages on PYTHONPATH, so every Python
# plugin (python-console included) dies with "No module named 'gi'" at
# runtime. Prepend pygobject's site-packages to PYTHONPATH; the inner
# wrapGAppsHook3 ELF wrapper keeps GI_TYPELIB_PATH etc. intact.
{ pkgs }:

pkgs.runCommandLocal "rhythmbox-wrapped" {
  nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.rhythmbox}/bin/rhythmbox $out/bin/rhythmbox \
    --prefix PYTHONPATH : "${pkgs.python3.pkgs.pygobject3}/${pkgs.python3.sitePackages}"
''

# Wrap Rhythmbox so its Python plugin host can import pygobject (gi).
#
# nixpkgs builds the libpeas Python loader and pygobject into the package,
# but never puts pygobject's site-packages on PYTHONPATH, so every Python
# plugin (python-console included) dies with "No module named 'gi'" at
# runtime.
#
# symlinkJoin preserves the full package (desktop entry, icons, schemas,
# plugins, typelibs); only bin/rhythmbox is replaced with a wrapper that
# prepends pygobject's site-packages to PYTHONPATH. The inner ELF wrapper
# (wrapGAppsHook3) keeps GI_TYPELIB_PATH etc. intact.
{ pkgs }:

pkgs.symlinkJoin {
  name = "rhythmbox-wrapped";
  paths = [ pkgs.rhythmbox ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    rm $out/bin/rhythmbox
    makeWrapper ${pkgs.rhythmbox}/bin/rhythmbox $out/bin/rhythmbox \
      --prefix PYTHONPATH : "${pkgs.python3.pkgs.pygobject3}/${pkgs.python3.sitePackages}"
  '';
}

{ pkgs, ... }:

{
  programs.beets = {
    enable = true;
    package = pkgs.beets;
    settings = {
      directory = "/home/sintra/Music/Library";
      library = "/home/sintra/Music/Library/musiclibrary.db";
      ignore = [ ".*" "*~" "System Volume Information" "lost+found" "Library" ];
      plugins = "scrub chroma lastgenre duplicates spotify inline";
      threaded = false;
      
      item_fields = {
        main_artist = ''
          import re
          artist_str = albumartist or artist
          # Split only by feat, ft, and commas (case-insensitive) to avoid over-splitting duos
          m = re.split(r'\s+(?:feat\.?|ft\.?)\s+|,\s+', artist_str, flags=re.IGNORECASE)
          return m[0].strip().strip('_?').strip()
        '';
      };

      lastgenre = {
        source = "track";
        canonical = true;
      };

      spotify = {
        mode = "place";
        data_source_mismatch_penalty = 0.5;
      };

      match = {
        strong_rec_thresh = 0.25;
        medium_rec_thresh = 0.50;
        sources = [ "spotify" "chroma" "musicbrainz" ];
      };

      import = {
        move = true;
        write = true;
        copy = false;
        incremental = true;
        timid = false;
        duplicate_action = "remove";
      };

      paths = {
        "comp" = "Compilations/$album%aunique{}/$track - $title";
        "singleton comp:true" = "Compilations/$album%aunique{}/$track - $title";
        "singleton" = "%if{album,$main_artist/$album%aunique{}/$track - $title,Non-Album/$main_artist - $title}";
        "default" = "$main_artist/$album%aunique{}/$track - $title";
      };
    };
  };
}

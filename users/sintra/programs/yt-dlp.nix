{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yt-dlp
    ffmpeg # required for -x audio extraction + thumbnail embedding
  ];

  home.file.".config/yt-dlp/config".text = ''
    # yt-dlp config - managed by home-manager
    # All downloads land in the beets staging folder

    # Output: flat, beets-friendly "Artist - Title" names (artist falls back to uploader).
    # QUOTED: config parser splits on whitespace, so spaces in the template must be quoted.
    -o "/home/sintra/Music/Stagging/%(artist,uploader)s - %(title)s.%(ext)s"

    # Extract audio-only; opus matches the library format.
    # YouTube audio is already opus, so no re-encoding happens - just container handling.
    -x
    --audio-format opus
    --audio-quality 0

    # Dedup: video-ID archive -> never re-download what we already grabbed
    --download-archive /home/sintra/.config/yt-dlp/archive.txt
    --no-overwrites

    # Single video by default; pass --yes-playlist for full album playlists
    --no-playlist

    # Embed tags + cover art so files are self-describing for the beets import
    --embed-metadata
    --embed-thumbnail

    # Cookies from Chrome (logged-in YouTube): fixes "HTTP Error 403: Forbidden"
    # rate-limiting that hits anonymous sessions after ~1 download.
    --cookies-from-browser chrome

    # Resilience
    --retries 10
    --fragment-retries 10
    --ignore-errors
  '';
}

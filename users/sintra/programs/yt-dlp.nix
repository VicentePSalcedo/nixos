{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yt-dlp
    ffmpeg # required for -x audio extraction + thumbnail embedding
  ];

  home.file.".config/yt-dlp/config".text = ''
    # yt-dlp config - managed by home-manager
    # All downloads land in the beets staging folder

    # Output: flat, beets-friendly "Artist - Title" names (artist falls back to uploader)
    -o /home/sintra/Music/Stagging/%(artist,uploader)s - %(title)s.%(ext)s

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

    # Resilience
    --retries 5
    --fragment-retries 5
    --ignore-errors
  '';
}

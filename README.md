# YouTube Music FLAC Downloader & Rockbox Album Art Fixer

This script lets you:
1. Download audio from **YouTube Music** directly as **FLAC** with embedded thumbnails.
2. Automatically **crop and resize the embedded album art to a 500x500 square**, ensuring full compatibility with **Rockbox** devices.

## ✅ Features
- Downloads music in **FLAC format** with embedded album art and metadata.
- Crops the album art to a perfect square centered on the image.
- Resizes cover art to **500x500px** to meet Rockbox's image display requirements.
- Supports downloading into a subfolder named after the playlist/video or the current directory.

## 🛠️ Requirements
Ensure the following tools are installed on your system:
- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp)
- [`metaflac`](https://xiph.org/flac/documentation_tools_metaflac.html) (from the FLAC tools package)
- [`ImageMagick`](https://imagemagick.org/) (`magick` command, version 7+)

## 🚀 Usage

Make the script executable:

```bash
chmod +x ytmusic_flac_rockbox.sh
```

Then run it:

```bash
./ytmusic_flac_rockbox.sh
```

### 🖥️ Prompt Flow

1. **Enter the base directory** where downloads should be saved (defaults to the script's directory).
2. **Enter a YouTube Music playlist URL or search query.**
3. **Choose whether to create a folder named after the playlist/video.**
4. **Optionally use a `cookies.txt` file for downloads requiring login.**

The script:

* Downloads the audio as FLAC with metadata and thumbnails.
* Automatically processes all FLAC files:

  * Crops the embedded album art to a square.
  * Resizes it to 500x500.
  * Re-embeds the updated image back into the FLAC file.

## 🎵 Why?

**Rockbox**, a popular open-source firmware for MP3 players, displays album art better when:

* It's a square image.
* It's resized to a standard dimension (500x500 is a safe choice).

This script ensures that any music downloaded from YouTube Music is fully optimized for **Rockbox playback and display**.

## ⚠️ Notes

* The script forces downloads to FLAC only.
* If you don't create a subfolder, only FLAC files in the specified base directory will be processed for album art.

---

Enjoy seamless Rockbox music browsing with properly embedded album art!

#!/bin/bash

# ----------- YT Music Download Section -----------

# Prompt for base directory
read -p "Enter the full path to the directory where you want to save the downloads (Press Enter to use the script's directory): " baseDir
[ -z "$baseDir" ] && baseDir="$(dirname "$(realpath "$0")")"
[ ! -d "$baseDir" ] && mkdir -p "$baseDir"

# Playlist URL or search query
read -p "Enter YouTube Music playlist URL or search query: " url

# Ask if subfolder should be created
read -p "Do you want to create a folder named after the playlist/video? (Y/N): " makeSubfolder

# Force audio format to FLAC
audioFormat="flac"
echo "Audio format is set to FLAC."

# Ask about cookies
read -p "Do you want to use a cookies.txt file? (Y/N): " useCookies
if [[ "$useCookies" =~ ^[Yy] ]]; then
    read -p "Enter the full path to your cookies.txt file: " cookiesPath
    cookiesArg="--cookies \"$cookiesPath\""
else
    cookiesArg=""
fi

# Get playlist/video title
if [[ "$makeSubfolder" =~ ^[Yy] ]]; then
    echo "Fetching playlist/video title from yt-dlp..."
    title=$(yt-dlp $cookiesArg --flat-playlist --print "%(playlist_title)s" "$url" 2>/dev/null | head -n 1)
    [ -z "$title" ] && title=$(yt-dlp $cookiesArg --print "%(title)s" "$url" 2>/dev/null | head -n 1)
    [ -z "$title" ] && title="Untitled"
    folderName=$(echo "$title" | tr -d '\\/:*?"<>|')
    outputFolder="$baseDir/$folderName"
    mkdir -p "$outputFolder"
else
    outputFolder="$baseDir"
fi

outputTemplate="${outputFolder}/%(artist)s - %(title)s.%(ext)s"

# Run yt-dlp
eval yt-dlp \
    --extract-audio \
    --audio-format "$audioFormat" \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    --sleep-interval 5 \
    --max-sleep-interval 5 \
    $cookiesArg \
    -o "\"$outputTemplate\"" \
    "\"$url\""

echo "YouTube Music download completed."

# ----------- FLAC Cover Cropping Section -----------

echo "Starting FLAC cover cropping and embedding..."

if [[ "$makeSubfolder" =~ ^[Yy] ]]; then
    searchPath="$outputFolder"
else
    searchPath="$baseDir"
fi

find "$searchPath" -maxdepth 1 -type f -iname "*.flac" | while read -r flac; do
    dir=$(dirname "$flac")
    filename=$(basename "$flac" .flac)
    cover="$dir/${filename}_cover.jpg"
    square_cover="$dir/${filename}_cover_square.jpg"

    # Extract cover art
    metaflac --export-picture-to="$cover" "$flac"

    if [ ! -f "$cover" ]; then
        echo "No cover art in $flac, skipping."
        continue
    fi

    # Crop to square and resize to 500x500
    magick "$cover" -gravity center -crop \
        "$(magick identify -format '%[fx:min(w,h)]x%[fx:min(w,h)]' "$cover")+0+0" \
        +repage -resize 500x500 "$square_cover"

    # Remove old picture and embed new cover
    metaflac --remove --block-type=PICTURE "$flac"
    metaflac --import-picture-from="$square_cover" "$flac"

    echo "Cropped, resized to 500x500, and re-embedded cover for: $flac"

    # Clean up
    rm "$cover" "$square_cover"
done

echo "All FLAC covers processed."

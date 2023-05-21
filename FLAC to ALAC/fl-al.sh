#!/bin/bash
set -e # exit immediately on error
set -u # error if a variable is misspelled

for x in *.flac
#	Check for sample rates above 48kHz
	do if [[ $(ffprobe -v error -select_streams a -show_streams -of default=noprint_wrappers=1 "$x" | \
		grep -Po '(?<=^sample_rate=)\w*$') -gt 48000 ]]; then
#   Set sample rate to 48kHz, leave original bit depth	
			ffmpeg6 -i "$x" -c:v copy -c:a alac -ar 48000 -hide_banner "$x".m4a
#	Otherwise leave original sample rate and bit depth
		else
			ffmpeg6 -i "$x" -c:v copy -c:a alac -hide_banner "$x".m4a
		fi
done

#	Move to Apple music watch folder
for x in *.m4a
	do mv "$x" "/volume1/music/Music/Automatically Add to Music/"
done
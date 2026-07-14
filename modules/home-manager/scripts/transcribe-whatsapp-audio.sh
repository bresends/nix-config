#!/usr/bin/env bash
set -euo pipefail

downloads_dir="${HOME}/Downloads"
credentials_file="${XDG_CONFIG_HOME:-${HOME}/.config}/secrets/groq-api-key"
groq_endpoint="https://api.groq.com/openai/v1/audio/transcriptions"
groq_model="whisper-large-v3-turbo"

notify_error() {
    notify-send --urgency=critical "Audio transcription" "$1"
}

if [[ ! -f "$credentials_file" ]]; then
    notify_error "Credential not found at ${credentials_file}."
    exit 1
fi

if [[ ! -r "$credentials_file" ]]; then
    notify_error "The Groq credential cannot be read."
    exit 1
fi

credentials_mode=$(stat --format='%a' "$credentials_file")
if (( (8#$credentials_mode & 8#077) != 0 )); then
    notify_error "The credential is exposed. Run: chmod 600 ${credentials_file}"
    exit 1
fi

groq_api_key=$(<"$credentials_file")
if [[ -z "$groq_api_key" ]]; then
    notify_error "The Groq credential file is empty."
    exit 1
fi

if [[ "$groq_api_key" =~ [[:space:]] ]]; then
    notify_error "The Groq credential must contain only the key, without spaces or extra lines."
    exit 1
fi

if [[ ! -d "$downloads_dir" ]]; then
    notify_error "The ${downloads_dir} directory does not exist."
    exit 1
fi

mapfile -d '' audio_files < <(
    find "$downloads_dir" -type f -iname '*.ogg' -print0 | sort -z
)

if (( ${#audio_files[@]} == 0 )); then
    notify_error "No OGG files found in Downloads."
    exit 0
fi

declare -A file_by_label=()
menu_entries=()

for audio_file in "${audio_files[@]}"; do
    label="${audio_file#"${downloads_dir}/"}"
    file_by_label["$label"]="$audio_file"
    menu_entries+=("$label")
done

selected=$(
    printf '%s\n' "${menu_entries[@]}" |
        vicinae dmenu --placeholder "Select a WhatsApp audio file"
) || exit 0

[[ -n "$selected" ]] || exit 0
audio_file="${file_by_label[$selected]:-}"

if [[ -z "$audio_file" || ! -f "$audio_file" ]]; then
    notify_error "The selected file was not found."
    exit 1
fi

output_file="${audio_file%.*}.txt"

if [[ -e "$output_file" ]]; then
    notify_error "The file $(basename "$output_file") already exists. Nothing was changed."
    exit 1
fi

mp3_file=$(mktemp --suffix=.mp3)
response_file=$(mktemp)

cleanup() {
    rm -f "$mp3_file" "$response_file"
}
trap cleanup EXIT

if ! ffmpeg -nostdin -loglevel error -y -i "$audio_file" -vn -codec:a libmp3lame "$mp3_file"; then
    notify_error "The audio could not be converted to MP3."
    exit 1
fi

if ! curl --silent --show-error --fail-with-body \
    --request POST "$groq_endpoint" \
    --header "Authorization: Bearer ${groq_api_key}" \
    --form "file=@${mp3_file};type=audio/mpeg" \
    --form "model=${groq_model}" \
    --form "language=pt" \
    --form "prompt=The audio is in Brazilian Portuguese (pt-BR)." \
    --form "response_format=text" \
    --output "$response_file"; then
    notify_error "Groq could not transcribe the audio. The original file was preserved."
    exit 1
fi

if [[ ! -s "$response_file" ]]; then
    notify_error "Groq returned an empty transcription. The original file was preserved."
    exit 1
fi

mv -- "$response_file" "$output_file"
rm -- "$audio_file" "$mp3_file"
trap - EXIT

if wl-copy < "$output_file"; then
    notify-send "Transcription complete" "Text saved to $(basename "$output_file") and copied to the clipboard."
else
    notify-send --urgency=critical "Transcription complete" \
        "Text saved to $(basename "$output_file"), but it could not be copied to the clipboard."
fi

# Video to Subtitles with Whisper (Colab)

Turn your videos into **SRT subtitle files** for free, using OpenAI's Whisper speech-to-text model running on Google Colab. This repository gives you two simple tools:

- A **Colab notebook** that transcribes your audio into clean, properly formatted subtitles.
- A **Windows helper script** that converts your videos to audio, prepares them for upload, and restores the original file names afterward.

No coding experience required — just follow the steps below.

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/M-d3bug/colab-whisper/blob/main/transcribe_colab.ipynb)


---

## What this tool does

The workflow has three stages:

1. **Prepare** — On your Windows PC, the helper script converts your video files into MP3 audio and gives them simple names (like `video_1.mp3`) so they upload cleanly to Colab. It remembers the original names.
2. **Transcribe** — You open the notebook in Google Colab (free, runs in your browser), upload the MP3s, and Whisper writes subtitle (`.srt`) files for each one.
3. **Restore** — Back on your PC, the helper script renames the subtitle files back to their original video names, so everything matches up.

The result: a neatly named `.srt` subtitle file for every video you started with.

---

## What you'll need

- A **Google account** (to use Google Colab — it's free).
- A **Windows PC** for the preparation steps.
- **FFmpeg** installed on Windows (the helper script uses it to convert videos to MP3).
  - Easiest way: download from <https://ffmpeg.org/download.html>, or install with a package manager such as `winget install ffmpeg`.
- Your **video files** (`.mp4`, `.avi`, `.mov`, `.webm`, or `.mkv`).

---

## Step 1 — Prepare your videos (Windows)

1. Download `prepare_videos.cmd` from this repository and save it somewhere convenient (for example, your Desktop).
2. **Double-click** `prepare_videos.cmd` to run it. A menu appears.
3. Press **1** then **Enter** — this creates a folder structure next to the script:
   ```
   main/
     1.default/      <- put your original videos here
        mp3/         <- converted audio appears here
     2.upload/       <- renamed MP3s ready to upload
     3.ready/        <- where finished subtitles go
   ```
4. Copy your video files into **`main\1.default`**.
5. In the script menu, press **2** then **Enter** — your videos are converted to MP3 inside `main\1.default\mp3`.
6. In the script menu, press **3** then **Enter** — the MP3s are copied to **`main\2.upload`** with simple names (`video_1.mp3`, `video_2.mp3`, …) and the original names are saved automatically.

You are now ready to upload the files from `main\2.upload`.

---

## Step 2 — Transcribe in Colab

1. Click the **"Open in Colab"** badge at the top of this page. (If you haven't replaced the placeholder link yet, open `transcribe_colab.ipynb` from this repository and upload it to your own Colab.)
2. In Colab, go to **Runtime → Change runtime type** and set **Hardware accelerator** to **GPU** (recommended for speed).
3. Click **Runtime → Run all** (or run each cell top-to-bottom with the play button).
   - The first cell installs Whisper and FFmpeg and creates an `audio_files` folder.
4. When prompted, use the **file browser** on the left of Colab to upload the MP3s from your `main\2.upload` folder into the `audio_files` directory.
5. Run the remaining cells. Whisper transcribes each file (in English, using the fast `turbo` model) and produces `.srt` subtitle files in a `transcripts` folder.
6. The final cell creates **`transcripts.zip`**. Click it in the file browser to **download** it to your PC.

---

## Step 3 — Restore original file names (Windows)

1. Extract `transcripts.zip` and copy its contents (the `video_N.srt` files) into **`main\3.ready`**.
2. Run `prepare_videos.cmd` again and press **4** then **Enter**.
3. The script reads the saved names and renames each `video_N.srt` back to its original video name. Your subtitles now match your source videos exactly.

---

## Folder layout

```
main/
  1.default/        Original videos go here
    mp3/            Videos converted to MP3
  2.upload/         Renamed MP3s to upload to Colab
  3.ready/          Finished subtitles land here (before name restore)
  original_names.log  Hidden record of original file names
```

---

## Files in this repository

| File | What it is |
|------|------------|
| `transcribe_colab.ipynb` | The Google Colab notebook that runs Whisper and produces SRT subtitles. |
| `prepare_videos.cmd` | A Windows helper script to convert videos to MP3, prepare them for upload, and restore subtitle file names. |
| `README.md` | This file. |

---

## Troubleshooting

- **"No MP3 files found" in Colab** — Make sure you uploaded the files from `main\2.upload` into the `audio_files` folder in Colab's file browser, then re-run the cell.
- **`ffmpeg` is not recognized** (Windows) — FFmpeg isn't installed or isn't on your PATH. Install it and reopen the command prompt.
- **Colab ran out of time or memory** — Colab sessions are temporary. Re-run the notebook, or transcribe fewer files at once.
- **Subtitle names didn't restore** — Confirm the `video_N.srt` files are inside `main\3.ready` and that `original_names.log` still exists in `main`.

---

## License & credits

- Speech recognition powered by [OpenAI Whisper](https://github.com/openai/whisper).
- Audio conversion uses [FFmpeg](https://ffmpeg.org/).
- This project is provided as-is for personal and educational use. Add a license file (e.g. MIT) if you plan to share it widely.

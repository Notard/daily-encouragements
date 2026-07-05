# Daily Encouragements

Codex creates a fresh encouragement line and a calm morning image here each day.

- Automation: `Daily Fresh Encouragement`
- Run time: every day at 08:00 Asia/Seoul
- Output layout: `outputs/YYYY-MM-DD/`

Each dated folder contains:

- `line.txt`: a short, plain encouragement written for that day
- `image.png`: a bright, playful picture-book image with a small character and integrated hand-lettered Korean text
- `metadata.json`: creation details and the image prompt

The automation checks `history.json` before writing, so the new line, character scene, and visual direction do not repeat earlier days.

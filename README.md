# 🤖 AI Chatbot — Gemini-Powered Streaming Chatbot

A lightweight, production-ready AI chatbot built with **FastAPI** (Python) and **vanilla HTML/Tailwind CSS**, powered by the **Google Gemini API** with real-time streaming responses.

---

## ✨ Features

- ⚡ **Real-time streaming** — responses stream token-by-token via `StreamingResponse`
- 🧠 **Google Gemini 2.5 Flash** — fast, intelligent AI responses
- 📝 **Markdown rendering** — code blocks, tables, lists, and inline formatting
- 💻 **Syntax highlighting** — via Highlight.js (`github-dark` theme)
- 📱 **Mobile-responsive** — Tailwind CSS adaptive layout
- 🚨 **Error handling** — network failure banners, API key validation, 60s timeout
- 🧹 **Clear history** — one-click chat reset
- 🚀 **Render.com ready** — includes `render.yaml` deployment blueprint

---

## 🗂️ Project Structure

```
ChatBot/
├── main.py            # FastAPI server — routes & streaming endpoint
├── agent.py           # Gemini AI client — async streaming logic
├── requirements.txt   # Python dependencies
├── render.yaml        # Render.com deployment blueprint
├── setup.sh           # One-command local setup & launch script
├── .env.example       # Environment variable template (safe to commit)
├── .gitignore
└── static/
    └── index.html     # Chat UI (Tailwind CSS + Marked.js + Highlight.js)
```

---

## 🚀 Quick Start (Local)

### Prerequisites
- Python 3.10+
- Git
- A [Gemini API key](https://aistudio.google.com/app/apikey) (free)

### 1 — Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/ChatBot.git
cd ChatBot
```

### 2 — Add your API key

```bash
cp .env.example .env
# Open .env and replace the placeholder with your real API key
```

### 3 — Run the setup script (recommended)

```bash
chmod +x setup.sh
bash setup.sh
```

The script will:
- Create and activate a Python virtual environment
- Install all dependencies
- Validate your API key
- Start the local dev server at `http://localhost:8000`

### Or run manually

```bash
python3 -m venv venv
source venv/bin/activate       # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

Then open **http://localhost:8000** in your browser.

---

## ⚙️ Environment Variables

Copy `.env.example` to `.env` and fill in your values:

| Variable | Required | Description |
|---|---|---|
| `GEMINI_API_KEY` | ✅ Yes | Your Google Gemini API key |
| `PORT` | ❌ No | Server port (default: `8000`, auto-set on Render) |

> ⚠️ **Never commit your `.env` file.** It is listed in `.gitignore`.

---

## 🌐 Deploy to Render

1. Push this repository to GitHub.
2. Go to [render.com](https://render.com) → **New Web Service** → connect your repo.
3. Render auto-detects `render.yaml` and pre-fills the build and start commands.
4. In the **Environment** tab, add `GEMINI_API_KEY` with your real key.
5. Click **Deploy**.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | [FastAPI](https://fastapi.tiangolo.com/) + [Uvicorn](https://www.uvicorn.org/) |
| AI Model | [Google Gemini 2.5 Flash](https://deepmind.google/technologies/gemini/) via `google-genai` |
| Frontend | Vanilla HTML5 + [Tailwind CSS](https://tailwindcss.com/) CDN |
| Markdown | [Marked.js](https://marked.js.org/) |
| Syntax Highlighting | [Highlight.js](https://highlightjs.org/) |
| Deployment | [Render.com](https://render.com) |

---

## 📡 API Reference

### `POST /api/chat`

Streams an AI response for the given user message.

**Request body:**
```json
{ "message": "Explain async/await in Python" }
```

**Response:** `text/plain` stream — chunks of the AI response as they are generated.

**Errors:**
- Missing API key → streams an error message
- Gemini API failure → streams an error message with details

### `GET /`

Serves the chat UI (`static/index.html`).

---

## 📄 License

MIT — see [LICENSE](LICENSE) for details.

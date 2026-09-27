"""
agent.py — Gemini AI client for the AI Chatbot.

Uses the google-genai async SDK to stream responses token-by-token.
The GEMINI_API_KEY is read from the environment (via .env locally,
or injected directly by Render in production).
"""

import os
from collections.abc import AsyncGenerator

from dotenv import load_dotenv
from google import genai

load_dotenv()

# Model to use for generation — change here to switch models globally
GEMINI_MODEL = "gemini-2.5-flash"


def _get_client() -> genai.Client:
    """
    Build and return an authenticated Gemini client.

    Raises:
        ValueError: If GEMINI_API_KEY is missing from the environment.
    """
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise ValueError(
            "GEMINI_API_KEY is not set. "
            "Add it to your .env file (local) or Render environment variables (production)."
        )
    return genai.Client(api_key=api_key)


async def stream_response(prompt: str) -> AsyncGenerator[str, None]:
    """
    Stream a Gemini response for the given prompt.

    Yields chunks of text as they arrive from the model.
    On error, yields a descriptive error string and stops.

    Args:
        prompt: The user's message.

    Yields:
        str: Incremental text chunks from the model.
    """
    try:
        client = _get_client()
    except ValueError as exc:
        yield f"⚠️ Configuration error: {exc}"
        return

    try:
        response = await client.aio.models.generate_content_stream(
            model=GEMINI_MODEL,
            contents=prompt,
        )
        async for chunk in response:
            if chunk.text:
                yield chunk.text

    except Exception as exc:  # noqa: BLE001
        yield f"\n\n⚠️ Error communicating with Gemini: {exc}"

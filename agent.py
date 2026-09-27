import os
from google import genai
from dotenv import load_dotenv

load_dotenv()

def get_client():
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("GEMINI_API_KEY environment variable is not set")
    return genai.Client(api_key=api_key)

async def stream_response(prompt: str):
    try:
        client = get_client()
    except ValueError as e:
        yield f"Error: {str(e)}"
        return

    try:
        # Using the async client to generate content stream
        response = await client.aio.models.generate_content_stream(
            model='gemini-2.5-flash',
            contents=prompt,
        )
        async for chunk in response:
            if chunk.text:
                yield chunk.text
    except Exception as e:
        yield f"\n[Error connecting to Gemini: {str(e)}]"

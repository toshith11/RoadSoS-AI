import google.generativeai as genai
import os

from dotenv import load_dotenv

load_dotenv()

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel("models/gemini-2.0-flash")


def analyze_emergency(description, detected_objects):

    try:

        prompt = f"""
        You are an emergency accident analysis AI.

        Analyze this accident carefully.

        Description:
        {description}

        Detected Objects:
        {detected_objects}

        Return ONLY in this format:

        Severity: Minor/Moderate/Critical

        Services Needed:
        - Ambulance
        - Police
        - Fire Rescue
        - Nearby Hospital
        - Trauma Center

        Short Reason:
        one-line explanation
        """

        response = model.generate_content(prompt)

        return response.text

    except Exception:

        return """
Severity: Critical

Services Needed:
- Ambulance
- Police
- Trauma Center

Short Reason:
AI quota exceeded. Using fallback emergency prediction system.
"""
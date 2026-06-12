# RoadSoS-AI

## AI-Powered Road Accident Detection and Emergency Response System

### Project Overview

RoadSoS-AI is an intelligent emergency response platform designed to reduce response time during road accidents by automatically analyzing accident videos, assessing severity, identifying required emergency services, and notifying the appropriate authorities.

The system enables citizens to report accidents through a mobile application while leveraging Artificial Intelligence to classify incidents and recommend emergency actions.

---

## Problem Statement

Road accidents often suffer from delayed emergency response due to:

* Lack of immediate reporting.
* Inaccurate information provided by witnesses.
* Delays in identifying the required emergency services.
* Difficulty in locating nearby emergency responders.

RoadSoS-AI addresses these challenges through automated incident analysis and intelligent emergency service recommendation.

---

## Objectives

* Enable citizens to report road accidents easily.
* Analyze accident videos using AI.
* Determine accident severity automatically.
* Recommend appropriate emergency services.
* Notify nearby emergency responders.
* Maintain incident history and citizen contribution records.
* Improve overall emergency response efficiency.

---

## Key Features

### 1. Accident Reporting

Users can:

* Record or upload accident videos.
* Provide accident description.
* Enter number of injured victims.
* Submit GPS location automatically.

---

### 2. AI-Based Incident Analysis

The AI Engine performs:

* Video frame extraction.
* Accident classification.
* Severity assessment.
* Incident categorization.

Examples:

* Minor Vehicle Accident
* Major Vehicle Accident
* Vehicle on Fire
* Road Obstruction

---

### 3. Emergency Service Recommendation

Based on severity and incident type, the system recommends:

* Hospital / Ambulance
* Police
* Fire Station
* Trauma Center

---

### 4. SOS Emergency Request

Citizens can directly request:

* Ambulance
* Police Assistance
* Fire Rescue
* Trauma Support

The system:

* Finds nearest service.
* Calculates estimated arrival time (ETA).
* Creates emergency request records.

---

### 5. Incident History

Users can view:

* Incident ID
* Date & Time
* Severity
* Status
* Required Services
* Description

---

### 6. Citizen Profile & Rewards

The system tracks:

* Total reports submitted
* Verified reports
* Citizen points
* Achievement badges
* Community reporting level

---

## System Architecture

Citizen Mobile App

↓

FastAPI Backend Server

↓

AI Engine

↓

Emergency Recommendation Engine

↓

SQLite Database

↓

Emergency Services

---

## Technology Stack

### Frontend

* Flutter
* Dart

### Backend

* FastAPI
* Uvicorn
* Python

### AI Engine

* OpenCV
* TensorFlow / Deep Learning Model
* NumPy

### Database

* SQLite

### Location Services

* GPS Coordinates
* OpenStreetMap APIs

---

## API Modules

### Accident Reporting

POST /processIncident

Processes accident videos and returns:

* Severity
* Required Services
* Victim Count

---

### SOS Request

POST /sos

Returns:

* Success Status
* Assigned Service
* ETA
* Message

---

### Incident History

GET /incidentHistory

Returns all previous incidents.

---

### Citizen Profile

GET /citizenProfile

Returns:

* Points
* Reports
* Verified Reports
* Badges
* User Level

---

### Latest Incident

GET /latestIncident

Returns latest incident information.

---

## Database Tables

### incidents

Stores:

* Incident ID
* Timestamp
* Severity
* Status
* Description
* Required Services
* Reporter Details

### sos_requests

Stores:

* Phone Number
* Service Type
* ETA
* Assigned Service
* Timestamp

---

## Assumptions

* Users have internet connectivity.
* GPS location is available.
* Accident videos are clear enough for AI analysis.
* Emergency service datasets contain valid location information.
* Victim count is entered manually by the user.

---

## Installation & Setup

### Clone Repository

git clone <repository-link>

cd RoadSoS-AI

---

### Install Backend Dependencies

pip install -r requirements.txt

---

### Start Backend

uvicorn main:app --host 0.0.0.0 --port 8000 --reload

---

### Start AI Engine

python ai_engine.py

---

### Run Flutter Application

flutter pub get

flutter run

---

## Future Enhancements

* Real-time emergency dispatch integration.
* Live ambulance tracking.
* Cloud database support.
* AI-based victim detection.
* Multi-language support.
* Government emergency network integration.

---

## Team Contribution

### Backend Development

* FastAPI APIs
* Database Integration
* Emergency Service Modules

### AI Development

* Video Processing
* Incident Classification
* Severity Analysis

### Frontend Development

* Flutter Mobile Application
* User Interface
* API Integration

---

## Conclusion

RoadSoS-AI demonstrates how Artificial Intelligence, Mobile Computing, and Emergency Service Automation can be combined to improve road safety and significantly reduce emergency response time. The platform empowers citizens to become active participants in public safety while enabling faster and more accurate emergency assistance.


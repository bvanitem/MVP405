# MVP405 - Warehouse Management Web Application

## Overview
MVP405 is a web application designed to manage warehouse operations, including addresses, persons, employees, warehouses, depots, vendors, products, shipments, and more. The application uses a Flask backend with a SQLite database for data storage, hosted on Render, and a static HTML frontend hosted on GitHub Pages. This project serves as a Minimum Viable Product (MVP) for a warehouse management system, demonstrating CRUD (Create, Read, Update, Delete) functionality and API integration.

## Features
- **User Management**: Manage persons and employees with associated addresses.
- **Warehouse Operations**: Track warehouses, depots, vendors, and products.
- **Shipment Tracking**: Monitor shipments between vendors, warehouses, and depots.
- **Database Integration**: Uses SQLite for persistent storage with SQL scripts for setup and data population.
- **Frontend/Backend Separation**: Static HTML frontend on GitHub Pages communicates with a Flask backend on Render via RESTful APIs.

## Project Structure
```
MVP405/
├── MVP_App/
│   ├── static/           # CSS and other static files
│   └── templates/        # HTML templates for the Flask backend
├── app.py               # Main Flask application file
├── setup_db.py          # Script to set up and populate the SQLite database
├── setupDB.db          # SQLite database file
├── setupDB.sql          # SQL script to create database tables
├── populateData.sql     # SQL script to populate the database with initial data
├── Procfile             # Configuration for Render deployment
├── requirements.txt     # Python dependencies
└── README.md            # This file
```

## Prerequisites
- **Python 3.11+** (or 3.12, depending on your environment)
- **Git** for version control
- **Render** account for backend deployment
- **GitHub** account for frontend hosting on GitHub Pages

## Installation and Setup

### Local Development
1. **Clone the Repository**
   ```bash
   git clone <your-repo-url>
   cd MVP405
   ```

2. **Install Dependencies**
   Install the required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

3. **Set Up the Database**
   Run the script to create and populate the SQLite database:
   ```bash
   python setup_db.py
   ```
   This will generate `setupDB.db` using `setupDB.sql` and `populateData.sql`.

4. **Run the Flask Application Locally**
   Start the Flask development server:
   ```bash
   python MVP_App/app.py
   ```
   Open your browser and navigate to [http://127.0.0.1:5000/](http://127.0.0.1:5000/) to view the application.

### Testing with Gunicorn (Optional, for Linux/WSL)
To test locally with Gunicorn (as used on Render), ensure you’re in a Unix-like environment (e.g., WSL):
```bash
gunicorn MVP_App.app:app
```
Access the app at [http://127.0.0.1:8000/](http://127.0.0.1:8000/).

## Usage
- **Homepage**: View a list of persons at `/` (e.g., [http://127.0.0.1:5000/](http://127.0.0.1:5000/)).
- **Person Details**: View details of a specific person at `/person/<person_id>` (e.g., [http://127.0.0.1:5000/person/1](http://127.0.0.1:5000/person/1)).
- **Login**: Access the login page at `/login`.
- **Add Person**: Use the form at `/person/add` to add a new person.
- **API**: Fetch person data via `/api/persons` (returns JSON).

## Deployment

### Backend (Flask on Render)
1. **Push to GitHub**: Commit and push your code to your GitHub repository:
   ```bash
   git add .
   git commit -m "Deploy to Render"
   git push origin main
   ```

2. **Deploy on Render**:
   - Create a new Web Service on Render.
   - Connect your GitHub repository.
   - Set the runtime to “Python.”
   - Use the following configuration:
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `gunicorn MVP_App.app:app`
     - **Root Directory**: `/MVP405` (or `/` if deploying from the root).
   - Add any environment variables (e.g., `FLASK_ENV=production`).
   - Deploy the service. Your backend will be available at `https://your-app-name.onrender.com`.

### Frontend (HTML on GitHub Pages)
1. **Prepare Static Files**:
   Copy the HTML files from `MVP_App/templates/` and the `MVP_App/static/` directory to a new `frontend/` directory. Remove Flask-specific templating (e.g., `{{ url_for(...) }}`, `{% for ... %}`) and replace with static content or JavaScript API calls to your Render backend.

2. **Push to GitHub**:
   Commit the `frontend/` directory to your GitHub repository or create a new repository.

3. **Enable GitHub Pages**:
   Enable GitHub Pages in your repository settings, setting the source to the main branch (or the branch containing `frontend/`).

   Your frontend will be available at `https://your-username.github.io/your-repo-name/`.




## Acknowledgments
Thanks to the Flask, SQLite, Render, and GitHub Pages communities for their tools and documentation. Thanks to OpenAI for generating this readme.md file.
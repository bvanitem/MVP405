# MVP405 - Warehouse Management Web Application

## Overview
MVP405 is a web application designed to manage warehouse operations, including addresses, persons, employees, warehouses, depots, vendors, products, shipments, inventory, and trucks. The application features a Flask backend with a SQLite database for data storage, hosted on Render, and a static HTML frontend also hosted on Render, both deployed from GitHub. This project serves as a Minimum Viable Product (MVP) for a warehouse management system, demonstrating CRUD (Create, Read, Update, Delete) functionality, API integration, and role-based access control (admin and user roles).

## Features
- **User Management**: Manage persons and employees with associated addresses.
- **Warehouse Operations**: Track warehouses, depots, vendors, and products.
- **Shipment Tracking**: Monitor shipments between vendors, warehouses, and depots, including truck assignments.
- **Inventory Management**: Track product quantities in warehouses, update inventory levels, and monitor last updates.
- **Truck Management**: Manage trucks, assign drivers (employees), track status (e.g., Available, In Transit, Maintenance), and assign trucks to shipments.
- **Authentication & Authorization**: Login system with role-based access—admins can update data, while regular users have read-only access.
- **Database Integration**: Uses SQLite for persistent storage with SQL scripts for setup and data population.
- **Frontend/Backend Separation**: Static HTML frontend and Flask backend, both hosted on Render, with communication via RESTful APIs.

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
├── Procfile             # Configuration for Render deployment (backend)
├── requirements.txt     # Python dependencies
└── README.md            # This file
```

## Prerequisites
- **Python 3.11+** (or 3.12, depending on your environment)
- **Git** for version control
- **Render** account for both frontend and backend deployment
- **GitHub** account for hosting and deploying from GitHub repositories

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
   Open your browser and navigate to [http://127.0.0.1:5000/](http://127.0.0.1:5000/) to access the login page.

### Testing with Gunicorn (Optional, for Linux/WSL)
To test locally with Gunicorn (as used on Render), ensure you’re in a Unix-like environment (e.g., WSL):
```bash
gunicorn MVP_App.app:app
```
Access the app at [http://127.0.0.1:8000/](http://127.0.0.1:8000/).

## Usage
- **Login**: Access the login page at `/` or [http://127.0.0.1:5000/](http://127.0.0.1:5000/) (redirects to `/login` for unauthenticated users). Default credentials:
  - Admin: username: `admin`, password: `admin123` (full access)
  - Regular User: username: `jane_smith`, password: `user123` (read-only access)
- **Dashboard**: After login, view the dashboard at `/dashboard` to access inventory, trucks, shipments, and persons.
- **Inventory**: View and manage inventory at `/inventory` (admin-only updates via `/inventory/add`).
- **Trucks**: View and manage trucks at `/trucks` (admin-only updates via `/truck/add` and `/truck/assign/<shipment_id>`).
- **Shipments**: View shipments and update status at `/shipments` (admin-only updates via `/shipment/<shipment_id>/update_status`).
- **Persons**: View person details at `/person/<person_id>` (admin-only adds via `/person/add`).
- **API**: Fetch data via `/api/persons`, `/api/inventory`, `/api/trucks`, and `/api/shipments` (read-only for all users).

## Deployment

### Backend (Flask on Render)
1. **Push to GitHub**: Commit and push your code to your GitHub repository:
   ```bash
   git add .
   git commit -m "Deploy to Render"
   git push origin main
   ```

2. **Deploy on Render**:
   - Create a new Web Service on Render for the backend.
   - Connect your GitHub repository.
   - Set the runtime to “Python.”
   - Use the following configuration:
     - **Build Command**: `pip install -r requirements.txt`
     - **Start Command**: `gunicorn MVP_App.app:app`
     - **Root Directory**: `/MVP405` (or `/` if deploying from the root)
   - Add any environment variables (e.g., `FLASK_ENV=production`, `SECRET_KEY=your-secret-key-here` for security).
   - Deploy the service. Your backend will be available at `https://your-backend-name.onrender.com`.

### Frontend (Static HTML on Render)
1. **Prepare Static Files**:
   Copy the HTML files from `MVP_App/templates/` and the `MVP_App/static/` directory to a new `frontend/` directory in your project. Remove Flask-specific templating (e.g., `{{ url_for(...) }}`, `{% for ... %}`) and replace with static content or JavaScript API calls to your Render backend (e.g., fetch data from `https://your-backend-name.onrender.com/api/...`).

   Ensure `style.css` is included in `frontend/static/` or linked appropriately.

2. **Push to GitHub**:
   Commit the `frontend/` directory to your GitHub repository or create a new repository for the frontend.

3. **Deploy the frontend on Render as a Static Site**:
   - Create a new Static Site on Render.
   - Connect your GitHub repository (or the frontend repository).
   - Set the root directory to `/frontend` (or the directory containing your static files).
   - Use a build command if needed (e.g., none for static HTML/CSS, or `npm run build` if using a frontend framework).
   - Deploy the service. Your frontend will be available at `https://your-frontend-name.onrender.com`.


### Acknowledgments
   Thanks to the Flask, SQLite, Render, and GitHub communities for their tools and documentation. This readme was generated with the assistance of OpenAi/Grok.
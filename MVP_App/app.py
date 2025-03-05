# app.py
from flask import Flask, render_template, request, redirect, url_for, jsonify
import sqlite3
from os import path

app = Flask(__name__)

# Database configuration
DB_NAME = "setupDB.db"

def get_db_connection():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row  # Allows accessing columns by name
    return conn

# Home route to display a list of entities (e.g., Persons)
@app.route('/')
def index():
    conn = get_db_connection()
    persons = conn.execute('SELECT * FROM Person').fetchall()
    conn.close()
    return render_template('index.html', persons=persons)

# Route to show a login page (optional, depending on your needs)
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        # In a real app, use hashed passwords and a users table
        if username == 'admin' and password == 'admin':  # Example; replace with database check
            return redirect(url_for('index'))
        return render_template('login.html', error='Invalid credentials')
    return render_template('login.html')

# Route to view a specific person's details
@app.route('/person/<int:person_id>')
def person_detail(person_id):
    conn = get_db_connection()
    person = conn.execute('SELECT * FROM Person WHERE PersonID = ?', (person_id,)).fetchone()
    address = conn.execute('SELECT * FROM Address WHERE AddressID = ?', (person['AddressID'],)).fetchone()
    conn.close()
    if person and address:
        return render_template('person_detail.html', person=person, address=address)
    return "Person not found", 404

# Route to add a new person (example of CREATE)
@app.route('/person/add', methods=['GET', 'POST'])
def add_person():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        address_id = request.form['address_id']  # Assume address_id is provided
        
        conn = get_db_connection()
        conn.execute('INSERT INTO Person (AddressID, FirstName, LastName) VALUES (?, ?, ?)',
                     (address_id, first_name, last_name))
        conn.commit()
        conn.close()
        return redirect(url_for('index'))
    conn = get_db_connection()
    addresses = conn.execute('SELECT * FROM Address').fetchall()
    conn.close()
    return render_template('add_person.html', addresses=addresses)

# API endpoint for JSON data (optional, for frontend integration)
@app.route('/api/persons')
def api_persons():
    conn = get_db_connection()
    persons = conn.execute('SELECT * FROM Person').fetchall()
    conn.close()
    return jsonify([dict(person) for person in persons])

if __name__ == '__main__':
    app.run(debug=True)
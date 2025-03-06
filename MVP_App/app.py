from flask import Flask, render_template, request, redirect, url_for, jsonify, abort
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
import sqlite3
from os import path
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'  # Replace with a secure secret key in production

# Configure template and static folder paths
app.template_folder = 'templates'
app.static_folder = 'static'

# Database configuration
DB_NAME = "setupDB.db"

# Flask-Login setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'  # Redirect unauthenticated users to /login

# User class for Flask-Login
class User(UserMixin):
    def __init__(self, user_id, username, role):
        self.id = user_id
        self.username = username
        self.role = role

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    user = conn.execute('SELECT UserID, Username, Role FROM Users WHERE UserID = ?', (user_id,)).fetchone()
    conn.close()
    if user:
        return User(user['UserID'], user['Username'], user['Role'])
    return None

def get_db_connection():
    try:
        conn = sqlite3.connect(DB_NAME)
        conn.row_factory = sqlite3.Row
        return conn
    except sqlite3.Error as e:
        app.logger.error(f"Database connection error: {e}")
        abort(500, description="Database connection failed")

# Route for the root URL (redirect to login for unauthenticated users)
@app.route('/')
def root():
    return redirect(url_for('login'))

# Route for the login page (now the default landing page for unauthenticated users)
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        conn = get_db_connection()
        user = conn.execute('SELECT UserID, Username, Password, Role FROM Users WHERE Username = ?', (username,)).fetchone()
        conn.close()

        if user and password == user['Password']:  # Plain text password comparison
            user_obj = User(user['UserID'], user['Username'], user['Role'])
            login_user(user_obj)
            return redirect(url_for('dashboard'))
        return render_template('login.html', error='Invalid credentials')

    return render_template('login.html')

# Logout route
@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

# Dashboard route (replaces index as the starting page after login)
@app.route('/dashboard')
@login_required
def dashboard():
    conn = get_db_connection()
    warehouses = conn.execute('SELECT * FROM Warehouse').fetchall()
    conn.close()
    return render_template('dashboard.html', warehouses=warehouses, user=current_user)

# Route to view a specific person's details (read-only for users, editable for admin)
@app.route('/person/<int:person_id>')
@login_required
def person_detail(person_id):
    conn = get_db_connection()
    person = conn.execute('SELECT * FROM Person WHERE PersonID = ?', (person_id,)).fetchone()
    address = conn.execute('SELECT * FROM Address WHERE AddressID = ?', (person['AddressID'],)).fetchone()
    conn.close()
    if person and address:
        return render_template('person_detail.html', person=person, address=address, user=current_user)
    return "Person not found", 404

# Route to add/edit a person (admin-only)
@app.route('/person/add', methods=['GET', 'POST'])
@login_required
def add_person():
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    addresses = conn.execute('SELECT * FROM Address').fetchall()
    conn.close()

    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        address_id = request.form['address_id']
        
        conn = get_db_connection()
        conn.execute('INSERT INTO Person (AddressID, FirstName, LastName) VALUES (?, ?, ?)',
                     (address_id, first_name, last_name))
        conn.commit()
        conn.close()
        return redirect(url_for('dashboard'))

    return render_template('add_person.html', addresses=addresses, user=current_user)

# Route to view inventory (read-only for users, editable for admin)
@app.route('/inventory')
@login_required
def inventory():
    conn = get_db_connection()
    inventory = conn.execute('''
        SELECT i.InventoryID, w.Name AS Warehouse, p.Name AS Product, i.Quantity, i.LastUpdated 
        FROM Inventory i 
        JOIN Warehouse w ON i.WarehouseID = w.WarehouseID 
        JOIN Product p ON i.ProductID = p.ProductID
    ''').fetchall()
    conn.close()
    return render_template('inventory.html', inventory=inventory, user=current_user)

# Route to add/update inventory (admin-only)
@app.route('/inventory/add', methods=['GET', 'POST'])
@login_required
def add_inventory():
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    warehouses = conn.execute('SELECT * FROM Warehouse').fetchall()
    products = conn.execute('SELECT * FROM Product').fetchall()
    conn.close()

    if request.method == 'POST':
        warehouse_id = request.form['warehouse_id']
        product_id = request.form['product_id']
        quantity = request.form['quantity']

        conn = get_db_connection()
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        existing = conn.execute('SELECT * FROM Inventory WHERE WarehouseID = ? AND ProductID = ?', 
                               (warehouse_id, product_id)).fetchone()
        if existing:
            conn.execute('UPDATE Inventory SET Quantity = ?, LastUpdated = ? WHERE WarehouseID = ? AND ProductID = ?',
                        (quantity, current_time, warehouse_id, product_id))
        else:
            conn.execute('INSERT INTO Inventory (WarehouseID, ProductID, Quantity, LastUpdated) VALUES (?, ?, ?, ?)',
                        (warehouse_id, product_id, quantity, current_time))
        conn.commit()
        conn.close()
        return redirect(url_for('inventory'))

    return render_template('add_inventory.html', warehouses=warehouses, products=products, user=current_user)

# Route to view trucks (read-only for users, editable for admin)
@app.route('/trucks')
@login_required
def trucks():
    conn = get_db_connection()
    trucks = conn.execute('''
        SELECT t.TruckID, t.LicensePlate, 
               p.FirstName || " " || p.LastName AS Driver, 
               t.Status, t.Capacity, t.LastMaintenance 
        FROM Truck t 
        LEFT JOIN Employee e ON t.DriverID = e.EmployeeID
        LEFT JOIN Person p ON e.PersonID = p.PersonID
    ''').fetchall()
    conn.close()
    return render_template('trucks.html', trucks=trucks, user=current_user)

# Route to add/update truck (admin-only)
@app.route('/truck/add', methods=['GET', 'POST'])
@login_required
def add_truck():
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    employees = conn.execute('SELECT * FROM Employee').fetchall()
    conn.close()

    if request.method == 'POST':
        license_plate = request.form['license_plate']
        driver_id = request.form['driver_id'] or None  # Allow no driver
        status = request.form['status']
        capacity = request.form['capacity']

        conn = get_db_connection()
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        existing = conn.execute('SELECT * FROM Truck WHERE LicensePlate = ?', (license_plate,)).fetchone()
        if existing:
            conn.execute('UPDATE Truck SET DriverID = ?, Status = ?, Capacity = ?, LastMaintenance = ? WHERE LicensePlate = ?',
                        (driver_id, status, capacity, current_time, license_plate))
        else:
            conn.execute('INSERT INTO Truck (LicensePlate, DriverID, Status, Capacity, LastMaintenance) VALUES (?, ?, ?, ?, ?)',
                        (license_plate, driver_id, status, capacity, current_time))
        conn.commit()
        conn.close()
        return redirect(url_for('trucks'))

    return render_template('add_truck.html', employees=employees, user=current_user)

# Route to assign truck to shipment (admin-only)
@app.route('/truck/assign/<int:shipment_id>', methods=['GET', 'POST'])
@login_required
def assign_truck(shipment_id):
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    trucks = conn.execute('SELECT * FROM Truck WHERE Status = "Available"').fetchall()
    shipment = conn.execute('SELECT * FROM Shipment WHERE ShipmentID = ?', (shipment_id,)).fetchone()
    conn.close()

    if not shipment:
        abort(404, description="Shipment not found")

    if request.method == 'POST':
        truck_id = request.form['truck_id']

        conn = get_db_connection()
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        # Update Shipment with TruckID
        conn.execute('UPDATE Shipment SET TruckID = ? WHERE ShipmentID = ?', (truck_id, shipment_id))
        # Update Truck status and create assignment
        conn.execute('UPDATE Truck SET Status = "In Transit" WHERE TruckID = ?', (truck_id,))
        conn.execute('INSERT INTO TruckAssignment (TruckID, ShipmentID, AssignmentDate) VALUES (?, ?, ?)',
                    (truck_id, shipment_id, current_time))
        conn.commit()
        conn.close()
        return redirect(url_for('shipments'))

    return render_template('assign_truck.html', trucks=trucks, shipment=shipment, user=current_user)

# Route to view shipments with trucks (read-only for users, editable for admin)
@app.route('/shipments')
@login_required
def shipments():
    conn = get_db_connection()
    shipments = conn.execute('''
        SELECT s.ShipmentID, s.OriginType, s.OriginID, s.DestinationType, s.DestinationID, s.ShipmentDate, 
               s.ArrivalDate, s.Status, t.LicensePlate AS Truck
        FROM Shipment s 
        LEFT JOIN Truck t ON s.TruckID = t.TruckID
    ''').fetchall()
    conn.close()
    return render_template('shipments.html', shipments=shipments, user=current_user)

# Route to update shipment status (admin-only)
@app.route('/shipment/<int:shipment_id>/update_status', methods=['GET', 'POST'])
@login_required
def update_shipment_status(shipment_id):
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    shipment = conn.execute('SELECT * FROM Shipment WHERE ShipmentID = ?', (shipment_id,)).fetchone()
    conn.close()

    if not shipment:
        abort(404, description="Shipment not found")

    if request.method == 'POST':
        status = request.form['status']
        if status not in ['Pending', 'In Transit', 'Delivered']:
            return "Invalid status", 400

        conn = get_db_connection()
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        if status == 'Delivered' and shipment['ArrivalDate'] is None:
            conn.execute('UPDATE Shipment SET Status = ?, ArrivalDate = ? WHERE ShipmentID = ?',
                        (status, current_time, shipment_id))
        else:
            conn.execute('UPDATE Shipment SET Status = ? WHERE ShipmentID = ?',
                        (status, shipment_id))
        conn.commit()
        conn.close()

        # Update truck status if shipment is delivered
        if status == 'Delivered':
            truck_id = shipment['TruckID']
            if truck_id:
                conn = get_db_connection()
                conn.execute('UPDATE Truck SET Status = "Available" WHERE TruckID = ?', (truck_id,))
                conn.execute('UPDATE TruckAssignment SET ReturnDate = ? WHERE ShipmentID = ? AND ReturnDate IS NULL',
                            (current_time, shipment_id))
                conn.commit()
                conn.close()

        return redirect(url_for('shipments'))

    return render_template('update_shipment_status.html', shipment=shipment, user=current_user)

# Route to view orders (read-only for all users)
@app.route('/orders')
@login_required
def orders():
    conn = get_db_connection()
    orders = conn.execute('''
        SELECT o.OrderID, o.OrderDate, o.Status, p.FirstName || " " || p.LastName AS Customer, w.Name AS Warehouse
        FROM Orders o
        JOIN Person p ON o.PersonID = p.PersonID
        JOIN Warehouse w ON o.WarehouseID = w.WarehouseID
    ''').fetchall()
    conn.close()
    return render_template('order.html', orders=orders, user=current_user)

# Route to view products for a specific order (read-only)
@app.route('/order/<int:order_id>/products')
@login_required
def view_order_products(order_id):
    conn = get_db_connection()
    order = conn.execute('SELECT * FROM Orders WHERE OrderID = ?', (order_id,)).fetchone()
    order_products = conn.execute('''
        SELECT op.*, p.Name AS ProductName
        FROM OrderProducts op
        JOIN Product p ON op.ProductID = p.ProductID
        WHERE op.OrderID = ?
    ''', (order_id,)).fetchall()
    conn.close()
    if order:
        return render_template('order_products.html', order=order, order_products=order_products, user=current_user)
    abort(404, description="Order not found")

# Route to add a new order (admin-only)
@app.route('/order/add', methods=['GET', 'POST'])
@login_required
def add_order():
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    persons = conn.execute('SELECT * FROM Person').fetchall()
    warehouses = conn.execute('SELECT * FROM Warehouse').fetchall()
    conn.close()

    if request.method == 'POST':
        person_id = request.form['person_id']
        warehouse_id = request.form['warehouse_id']
        current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        conn = get_db_connection()
        conn.execute('INSERT INTO Orders (PersonID, WarehouseID, OrderDate, Status) VALUES (?, ?, ?, ?)',
                     (person_id, warehouse_id, current_time, 'Pending'))
        conn.commit()
        conn.close()
        return redirect(url_for('orders'))

    return render_template('add_order.html', persons=persons, warehouses=warehouses, user=current_user)

# Route to add a product to an order (admin-only)
@app.route('/order/<int:order_id>/add_product', methods=['GET', 'POST'])
@login_required
def add_order_product(order_id):
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    order = conn.execute('SELECT * FROM Orders WHERE OrderID = ?', (order_id,)).fetchone()
    products = conn.execute('SELECT * FROM Product').fetchall()
    conn.close()

    if not order:
        abort(404, description="Order not found")

    if request.method == 'POST':
        product_id = request.form['product_id']
        quantity = request.form['quantity']
        price = request.form['price']

        conn = get_db_connection()
        existing = conn.execute('SELECT * FROM OrderProducts WHERE OrderID = ? AND ProductID = ?',
                               (order_id, product_id)).fetchone()
        if existing:
            conn.execute('UPDATE OrderProducts SET Quantity = ?, Price = ? WHERE OrderID = ? AND ProductID = ?',
                        (quantity, price, order_id, product_id))
        else:
            conn.execute('INSERT INTO OrderProducts (OrderID, ProductID, Quantity, Price) VALUES (?, ?, ?, ?)',
                        (order_id, product_id, quantity, price))
        conn.commit()
        conn.close()
        return redirect(url_for('view_order_products', order_id=order_id))

    return render_template('add_order_product.html', order=order, products=products, user=current_user)

# Route to update order status (admin-only)
@app.route('/order/<int:order_id>/update_status', methods=['GET', 'POST'])
@login_required
def update_order_status(order_id):
    if current_user.role != 'admin':
        abort(403, description="Access denied. Admin privileges required.")
    
    conn = get_db_connection()
    order = conn.execute('SELECT * FROM Orders WHERE OrderID = ?', (order_id,)).fetchone()
    conn.close()

    if not order:
        abort(404, description="Order not found")

    if request.method == 'POST':
        status = request.form['status']
        if status not in ['Pending', 'Processing', 'Completed']:
            return "Invalid status", 400

        conn = get_db_connection()
        conn.execute('UPDATE Orders SET Status = ? WHERE OrderID = ?', (status, order_id))
        conn.commit()
        conn.close()
        return redirect(url_for('orders'))

    return render_template('update_order_status.html', order=order, user=current_user)

# API endpoints (read-only for all users)
@app.route('/api/persons')
@login_required
def api_persons():
    conn = get_db_connection()
    persons = conn.execute('SELECT * FROM Person').fetchall()
    conn.close()
    return jsonify([dict(person) for person in persons])

@app.route('/api/inventory')
@login_required
def api_inventory():
    conn = get_db_connection()
    inventory = conn.execute('''
        SELECT i.InventoryID, w.Name AS Warehouse, p.Name AS Product, i.Quantity, i.LastUpdated 
        FROM Inventory i 
        JOIN Warehouse w ON i.WarehouseID = w.WarehouseID 
        JOIN Product p ON i.ProductID = p.ProductID
    ''').fetchall()
    conn.close()
    return jsonify([dict(item) for item in inventory])

@app.route('/api/trucks')
@login_required
def api_trucks():
    conn = get_db_connection()
    trucks = conn.execute('''
        SELECT t.TruckID, t.LicensePlate, 
               p.FirstName || " " || p.LastName AS Driver, 
               t.Status, t.Capacity, t.LastMaintenance 
        FROM Truck t 
        LEFT JOIN Employee e ON t.DriverID = e.EmployeeID
        LEFT JOIN Person p ON e.PersonID = p.PersonID
    ''').fetchall()
    conn.close()
    return jsonify([dict(truck) for truck in trucks])

@app.route('/api/shipments')
@login_required
def api_shipments():
    conn = get_db_connection()
    shipments = conn.execute('''
        SELECT s.ShipmentID, s.OriginType, s.OriginID, s.DestinationType, s.DestinationID, s.ShipmentDate, 
               s.ArrivalDate, s.Status, t.LicensePlate AS Truck
        FROM Shipment s 
        LEFT JOIN Truck t ON s.TruckID = t.TruckID
    ''').fetchall()
    conn.close()
    return jsonify([dict(shipment) for shipment in shipments])

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return render_template('404.html', error=error, user=current_user if hasattr(current_user, 'is_authenticated') and current_user.is_authenticated else None), 404

@app.errorhandler(500)
def internal_server_error(error):
    return render_template('500.html', error=error, user=current_user if hasattr(current_user, 'is_authenticated') and current_user.is_authenticated else None), 500

@app.errorhandler(403)
def forbidden(error):
    return render_template('403.html', error=error, user=current_user if hasattr(current_user, 'is_authenticated') and current_user.is_authenticated else None), 403

if __name__ == '__main__':
    app.run(debug=True)
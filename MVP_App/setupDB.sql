-- setupDB.sql for SQLite

CREATE TABLE Address (
    AddressID INTEGER PRIMARY KEY AUTOINCREMENT,
    Street TEXT,
    City TEXT,
    State TEXT,
    Zip INTEGER
);

CREATE TABLE Person (
    PersonID INTEGER PRIMARY KEY AUTOINCREMENT,
    AddressID INTEGER,
    FirstName TEXT,
    LastName TEXT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Employee (
    EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT,
    PersonID INTEGER,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE Warehouse (
    WarehouseID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT,
    EmployeeID INTEGER,
    AddressID INTEGER,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Depot (
    DepotID INTEGER PRIMARY KEY AUTOINCREMENT,
    AddressID INTEGER,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Vendor (
    VendorID INTEGER PRIMARY KEY AUTOINCREMENT,
    AddressID INTEGER,
    Name TEXT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

CREATE TABLE Product (
    ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT,
    Expiration TEXT,  -- Use TEXT for dates (e.g., 'YYYY-MM-DD')
    ReceivedDate TEXT,  -- Use TEXT for datetimes (e.g., 'YYYY-MM-DD HH:MM:SS')
    VendorID INTEGER,
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);

CREATE TABLE VendorProducts (
    VendorID INTEGER,
    ProductID INTEGER,
    PRIMARY KEY (VendorID, ProductID),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Shipment (
    ShipmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    OriginType TEXT,  -- Use TEXT instead of ENUM (e.g., 'Vendor', 'Warehouse', 'Depot')
    OriginID INTEGER,
    DestinationType TEXT,  -- Use TEXT instead of ENUM (e.g., 'Warehouse', 'Depot')
    DestinationID INTEGER,
    ShipmentDate TEXT,  -- Use TEXT for datetime (e.g., 'YYYY-MM-DD HH:MM:SS')
    ArrivalDate TEXT,  -- Use TEXT for datetime
    Status TEXT,  -- Use TEXT instead of ENUM (e.g., 'Pending', 'In Transit', 'Delivered')
    TruckID INTEGER,  -- New field to track which truck is used for the shipment
    FOREIGN KEY (TruckID) REFERENCES Truck(TruckID)
);

CREATE TABLE ShipmentDetails (
    ShipmentID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    PRIMARY KEY (ShipmentID, ProductID),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- New Table: Inventory to track product quantities in warehouses
CREATE TABLE Inventory (
    InventoryID INTEGER PRIMARY KEY AUTOINCREMENT,
    WarehouseID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER DEFAULT 0,
    LastUpdated TEXT,  -- Use TEXT for datetime (e.g., 'YYYY-MM-DD HH:MM:SS')
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- New Table: Truck to track trucks and their status
CREATE TABLE Truck (
    TruckID INTEGER PRIMARY KEY AUTOINCREMENT,
    LicensePlate TEXT UNIQUE,
    DriverID INTEGER,  -- Reference to Employee
    Status TEXT,  -- e.g., 'Available', 'In Transit', 'Maintenance'
    Capacity INTEGER,  -- Maximum weight or volume capacity (in units)
    LastMaintenance TEXT,  -- Use TEXT for datetime (e.g., 'YYYY-MM-DD HH:MM:SS')
    FOREIGN KEY (DriverID) REFERENCES Employee(EmployeeID)
);

-- New Table: TruckAssignment to track truck assignments to shipments
CREATE TABLE TruckAssignment (
    AssignmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    TruckID INTEGER,
    ShipmentID INTEGER,
    AssignmentDate TEXT,  -- Use TEXT for datetime (e.g., 'YYYY-MM-DD HH:MM:SS')
    ReturnDate TEXT,  -- Use TEXT for datetime (optional, for tracking return)
    FOREIGN KEY (TruckID) REFERENCES Truck(TruckID),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID)
);

-- New Table: Users for authentication
CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Username TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,  -- Now stores plain text passwords
    Role TEXT NOT NULL CHECK(Role IN ('admin', 'user')) DEFAULT 'user'  -- Role for access control
);
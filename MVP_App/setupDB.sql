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
    Status TEXT  -- Use TEXT instead of ENUM (e.g., 'Pending', 'In Transit', 'Delivered')
    -- Complex CHECK constraints with subqueries are not supported in SQLite
    -- You can enforce these in your application logic or use simpler CHECKs if needed
);

CREATE TABLE ShipmentDetails (
    ShipmentID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    PRIMARY KEY (ShipmentID, ProductID),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
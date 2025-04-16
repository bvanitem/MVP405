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
    Expiration TEXT,
    ReceivedDate TEXT,
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
    OriginType TEXT,
    OriginID INTEGER,
    DestinationType TEXT,
    DestinationID INTEGER,
    ShipmentDate TEXT,
    ArrivalDate TEXT,
    Status TEXT,
    TruckID INTEGER,
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

CREATE TABLE Inventory (
    InventoryID INTEGER PRIMARY KEY AUTOINCREMENT,
    WarehouseID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER DEFAULT 0,
    LastUpdated TEXT,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Truck (
    TruckID INTEGER PRIMARY KEY AUTOINCREMENT,
    LicensePlate TEXT UNIQUE,
    DriverID INTEGER,
    Status TEXT,
    Capacity INTEGER,
    LastMaintenance TEXT,
    FOREIGN KEY (DriverID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE TruckAssignment (
    AssignmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    TruckID INTEGER,
    ShipmentID INTEGER,
    AssignmentDate TEXT,
    ReturnDate TEXT,
    FOREIGN KEY (TruckID) REFERENCES Truck(TruckID),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID)
);

CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    Username TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    Role TEXT NOT NULL CHECK(Role IN ('admin', 'user')) DEFAULT 'user'
);

CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
    PersonID INTEGER,
    WarehouseID INTEGER,
    OrderDate TEXT,
    Status TEXT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);

CREATE TABLE OrderProducts (
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    Price REAL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
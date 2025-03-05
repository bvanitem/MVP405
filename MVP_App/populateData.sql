-- Insert Addresses
INSERT INTO Address (Street, City, State, Zip) VALUES 
('123 Main St', 'New York', 'NY', 10001),
('456 Elm St', 'Los Angeles', 'CA', 90001),
('789 Oak St', 'Chicago', 'IL', 60601),
('321 Pine St', 'Houston', 'TX', 77001),
('654 Maple St', 'Miami', 'FL', 33101);

-- Insert Persons
INSERT INTO Person (AddressID, FirstName, LastName) VALUES  -- Changed 'Address' to 'AddressID'
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Johnson'),
(4, 'Bob', 'Williams'),
(5, 'Charlie', 'Brown');

-- Insert Employees
INSERT INTO Employee (PersonID) VALUES 
(1),
(2),
(3);

-- Insert Warehouses
INSERT INTO Warehouse (Name, EmployeeID, AddressID) VALUES  -- Changed 'Employee' to 'EmployeeID' and 'Address' to 'AddressID'
('NY Warehouse', 1, 1),
('LA Warehouse', 2, 2),
('Chicago Warehouse', 3, 3);

-- Insert Depots
INSERT INTO Depot (AddressID) VALUES  -- Changed 'Address' to 'AddressID'
(4),
(5);

-- Insert Vendors
INSERT INTO Vendor (AddressID, Name) VALUES  -- Changed 'Address' to 'AddressID'
(1, 'Best Supplies'),
(2, 'Quality Goods'),
(3, 'Wholesale Direct');

-- Insert Products
INSERT INTO Product (Name, Expiration, ReceivedDate, VendorID) VALUES  -- Changed 'Vendor' to 'VendorID'
('Product A', '2025-12-31', '2024-02-01 10:00:00', 1),
('Product B', '2026-06-30', '2024-02-02 11:30:00', 2),
('Product C', '2024-09-15', '2024-02-03 14:00:00', 3);

-- Insert VendorProducts (linking Vendors and Products)
INSERT INTO VendorProducts (VendorID, ProductID) VALUES  -- Changed 'Vendor' to 'VendorID' and 'Product' to 'ProductID'
(1, 1),
(2, 2),
(3, 3);

-- Insert Shipments
INSERT INTO Shipment (OriginType, OriginID, DestinationType, DestinationID, ShipmentDate, ArrivalDate, Status) VALUES 
('Vendor', 1, 'Warehouse', 1, '2024-02-10 08:00:00', '2024-02-12 10:00:00', 'Delivered'),
('Warehouse', 2, 'Depot', 4, '2024-02-11 09:00:00', '2024-02-13 12:00:00', 'In Transit');

-- Insert ShipmentDetails (associating shipments with products)
INSERT INTO ShipmentDetails (ShipmentID, ProductID, Quantity) VALUES 
(1, 1, 100),
(2, 2, 50),
(3, 3, 75);  -- Corrected to match ProductID 3 for the third shipment
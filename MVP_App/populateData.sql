-- Insert Addresses
INSERT INTO Address (Street, City, State, Zip) VALUES 
('123 Main St', 'New York', 'NY', 10001),
('456 Elm Ave', 'Los Angeles', 'CA', 90001),
('789 Oak Rd', 'Chicago', 'IL', 60601),
('321 Pine Blvd', 'Houston', 'TX', 77001),
('654 Maple Dr', 'Miami', 'FL', 33101),
('987 Cedar Ln', 'Seattle', 'WA', 98101),
('147 Birch St', 'Atlanta', 'GA', 30301),
('258 Willow Way', 'Denver', 'CO', 80201),
('369 Spruce Ave', 'Boston', 'MA', 02101),
('741 Poplar Rd', 'Phoenix', 'AZ', 85001),
('852 Sycamore St', 'San Francisco', 'CA', 94105),
('963 Magnolia Blvd', 'Dallas', 'TX', 75201),
('174 Chestnut Ave', 'Portland', 'OR', 97201),
('285 Laurel Ln', 'Minneapolis', 'MN', 55401),
('396 Redwood Dr', 'Charlotte', 'NC', 28201);

-- Insert Persons
INSERT INTO Person (AddressID, FirstName, LastName) VALUES 
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith'),
(3, 'Alice', 'Johnson'),
(4, 'Bob', 'Williams'),
(5, 'Charlie', 'Brown'),
(6, 'Emily', 'Davis'),
(7, 'Michael', 'Wilson'),
(8, 'Sarah', 'Taylor'),
(9, 'David', 'Anderson'),
(10, 'Lisa', 'Martinez'),
(11, 'Robert', 'Thompson'),
(12, 'Mary', 'Garcia'),
(13, 'James', 'Lee'),
(14, 'Patricia', 'Clark'),
(15, 'William', 'Walker');

-- Insert Employees
INSERT INTO Employee (PersonID) VALUES 
(1),  -- John Doe
(2),  -- Jane Smith
(3),  -- Alice Johnson
(4),  -- Bob Williams
(6),  -- Emily Davis
(7),  -- Michael Wilson
(9),  -- David Anderson
(11); -- Robert Thompson

-- Insert Warehouses
INSERT INTO Warehouse (Name, EmployeeID, AddressID) VALUES 
('Walmart Distribution Center - NY', 1, 1),  -- John Doe manages NY
('Costco Regional Warehouse - LA', 2, 2),    -- Jane Smith manages LA
('Amazon Fulfillment Center - Chicago', 3, 3),  -- Alice Johnson manages Chicago
('Target Logistics Hub - Houston', 4, 4),    -- Bob Williams manages Houston
('Home Depot Supply Center - Seattle', 6, 6),  -- Emily Davis manages Seattle
('Lowe’s Distribution Hub - Atlanta', 7, 7),  -- Michael Wilson manages Atlanta
('FedEx Supply Chain - Denver', 9, 8),       -- David Anderson manages Denver
('UPS Logistics Center - Boston', 11, 9);    -- Robert Thompson manages Boston

-- Insert Depots
INSERT INTO Depot (AddressID) VALUES 
(10),  -- Phoenix
(12),  -- Dallas
(13),  -- Portland
(14),  -- Minneapolis
(15);  -- Charlotte

-- Insert Vendors
INSERT INTO Vendor (AddressID, Name) VALUES 
(1, 'Walmart Suppliers Inc.'),
(2, 'Costco Wholesale Vendors'),
(3, 'Amazon Logistics Partners'),
(4, 'Target Merchandise Suppliers'),
(5, 'Home Depot Procurement'),
(6, 'Lowe’s Supply Network'),
(7, 'FedEx Supply Solutions'),
(8, 'UPS Logistics Providers'),
(9, 'Sysco Food Services'),
(10, 'Best Buy Distribution');

-- Insert Products
INSERT INTO Product (Name, Expiration, ReceivedDate, VendorID) VALUES 
('Walmart Branded T-Shirt', '2025-12-31', '2024-02-01 10:00:00', 1),
('Costco Organic Coffee', '2026-06-30', '2024-02-02 11:30:00', 2),
('Amazon Electronics - Smart Speaker', '2024-09-15', '2024-02-03 14:00:00', 3),
('Target Kitchenware - Blender', '2025-11-15', '2024-02-04 09:00:00', 4),
('Home Depot Power Tools - Drill', '2025-08-20', '2024-02-05 13:00:00', 5),
('Lowe’s Gardening Supplies - Shovel', '2025-10-10', '2024-02-06 15:00:00', 6),
('FedEx Packaging Materials', '2026-03-15', '2024-02-07 10:30:00', 7),
('UPS Shipping Labels', '2025-07-01', '2024-02-08 12:00:00', 8),
('Sysco Frozen Pizza', '2025-06-15', '2024-02-09 14:00:00', 9),
('Best Buy Electronics - Laptop', '2025-09-30', '2024-02-10 11:00:00', 10),
('Walmart Household Cleaner', '2025-05-20', '2024-02-11 09:00:00', 1),
('Costco Bulk Paper Towels', '2026-04-10', '2024-02-12 13:00:00', 2),
('Amazon Books - Bestseller', '2025-08-01', '2024-02-13 16:00:00', 3),
('Target Toys - Action Figure', '2025-12-01', '2024-02-14 10:00:00', 4),
('Home Depot Paint - Interior', '2025-07-15', '2024-02-15 15:00:00', 5);

-- Insert VendorProducts (linking Vendors and Products)
INSERT INTO VendorProducts (VendorID, ProductID) VALUES 
(1, 1), (1, 11),  -- Walmart products
(2, 2), (2, 12),  -- Costco products
(3, 3), (3, 13),  -- Amazon products
(4, 4), (4, 14),  -- Target products
(5, 5), (5, 15),  -- Home Depot products
(6, 6),           -- Lowe’s products
(7, 7),           -- FedEx products
(8, 8),           -- UPS products
(9, 9),           -- Sysco products
(10, 10);         -- Best Buy products

-- Insert Shipments
INSERT INTO Shipment (OriginType, OriginID, DestinationType, DestinationID, ShipmentDate, ArrivalDate, Status, TruckID) VALUES 
('Vendor', 1, 'Warehouse', 1, '2024-02-10 08:00:00', '2024-02-12 10:00:00', 'Delivered', 1),  -- Walmart to NY Warehouse
('Vendor', 2, 'Warehouse', 2, '2024-02-11 09:00:00', '2024-02-13 12:00:00', 'In Transit', 2),  -- Costco to LA Warehouse
('Warehouse', 3, 'Depot', 10, '2024-02-14 07:00:00', '2024-02-16 11:00:00', 'Delivered', 3),  -- Amazon Chicago to Phoenix Depot
('Vendor', 4, 'Warehouse', 4, '2024-02-15 08:30:00', NULL, 'In Transit', 4),  -- Target to Houston Warehouse
('Vendor', 5, 'Warehouse', 5, '2024-02-16 09:15:00', '2024-02-18 14:00:00', 'Delivered', 1),  -- Home Depot to Seattle Warehouse
('Warehouse', 6, 'Depot', 12, '2024-02-17 10:00:00', NULL, 'In Transit', 2),  -- Lowe’s Atlanta to Dallas Depot
('Vendor', 7, 'Warehouse', 7, '2024-02-18 11:30:00', '2024-02-20 13:00:00', 'Delivered', 3),  -- FedEx to Denver Warehouse
('Vendor', 8, 'Warehouse', 8, '2024-02-19 12:00:00', NULL, 'Pending', 4),  -- UPS to Boston Warehouse
('Vendor', 9, 'Depot', 13, '2024-02-20 13:45:00', '2024-02-22 15:00:00', 'Delivered', 1),  -- Sysco to Portland Depot
('Vendor', 10, 'Warehouse', 3, '2024-02-21 14:30:00', NULL, 'In Transit', 2);  -- Best Buy to Chicago Warehouse

-- Insert ShipmentDetails (associating shipments with products)
INSERT INTO ShipmentDetails (ShipmentID, ProductID, Quantity) VALUES 
(1, 1, 500),  -- Walmart T-Shirts to NY
(1, 11, 300), -- Walmart Cleaners to NY
(2, 2, 200),  -- Costco Coffee to LA
(2, 12, 150), -- Costco Paper Towels to LA
(3, 3, 100),  -- Amazon Smart Speaker to Phoenix
(3, 13, 75),  -- Amazon Books to Phoenix
(4, 4, 250),  -- Target Blender to Houston
(4, 14, 200), -- Target Toys to Houston
(5, 5, 150),  -- Home Depot Drill to Seattle
(5, 15, 120), -- Home Depot Paint to Seattle
(6, 6, 180),  -- Lowe’s Shovel to Dallas
(7, 7, 300),  -- FedEx Packaging to Denver
(8, 8, 400),  -- UPS Labels to Boston
(9, 9, 350),  -- Sysco Pizza to Portland
(10, 10, 90); -- Best Buy Laptop to Chicago

-- Insert Inventory (sample data for products in warehouses)
INSERT INTO Inventory (WarehouseID, ProductID, Quantity, LastUpdated) VALUES 
(1, 1, 500, '2025-03-05 12:00:00'),  -- Walmart T-Shirts in NY Warehouse
(1, 11, 300, '2025-03-05 12:00:00'), -- Walmart Cleaners in NY Warehouse
(2, 2, 200, '2025-03-05 12:00:00'),  -- Costco Coffee in LA Warehouse
(2, 12, 150, '2025-03-05 12:00:00'), -- Costco Paper Towels in LA Warehouse
(3, 3, 100, '2025-03-05 12:00:00'),  -- Amazon Smart Speaker in Chicago Warehouse
(3, 13, 75, '2025-03-05 12:00:00'),  -- Amazon Books in Chicago Warehouse
(4, 4, 250, '2025-03-05 12:00:00'),  -- Target Blender in Houston Warehouse
(4, 14, 200, '2025-03-05 12:00:00'), -- Target Toys in Houston Warehouse
(5, 5, 150, '2025-03-05 12:00:00'),  -- Home Depot Drill in Seattle Warehouse
(5, 15, 120, '2025-03-05 12:00:00'), -- Home Depot Paint in Seattle Warehouse
(6, 6, 180, '2025-03-05 12:00:00'),  -- Lowe’s Shovel in Atlanta Warehouse
(7, 7, 300, '2025-03-05 12:00:00'),  -- FedEx Packaging in Denver Warehouse
(8, 8, 400, '2025-03-05 12:00:00'),  -- UPS Labels in Boston Warehouse
(3, 10, 90, '2025-03-05 12:00:00');  -- Best Buy Laptop in Chicago Warehouse

-- Insert Trucks
INSERT INTO Truck (LicensePlate, DriverID, Status, Capacity, LastMaintenance) VALUES 
('ABC123', 1, 'Available', 20000, '2025-01-01 09:00:00'),  -- John Doe’s truck
('XYZ789', 2, 'In Transit', 25000, '2025-02-01 10:00:00'),  -- Jane Smith’s truck
('DEF456', 3, 'Available', 18000, '2025-01-15 08:00:00'),  -- Alice Johnson’s truck
('GHI789', 4, 'Maintenance', 22000, '2025-02-20 14:00:00'),  -- Bob Williams’s truck
('JKL012', 6, 'Available', 23000, '2025-02-10 11:00:00'),  -- Emily Davis’s truck
('MNO345', 7, 'In Transit', 21000, '2025-03-01 09:30:00'),  -- Michael Wilson’s truck
('PQR678', 9, 'Maintenance', 19000, '2025-02-25 13:00:00'),  -- David Anderson’s truck
('STU901', 11, 'Available', 24000, '2025-01-20 10:00:00');  -- Robert Thompson’s truck

-- Insert TruckAssignments
INSERT INTO TruckAssignment (TruckID, ShipmentID, AssignmentDate, ReturnDate) VALUES 
(1, 1, '2025-03-01 08:00:00', '2025-03-03 10:00:00'),  -- Truck 1 for Shipment 1
(2, 2, '2025-03-02 09:00:00', NULL),  -- Truck 2 for Shipment 2
(3, 3, '2025-03-04 07:00:00', '2025-03-06 11:00:00'),  -- Truck 3 for Shipment 3
(4, 4, '2025-03-05 08:30:00', NULL),  -- Truck 4 for Shipment 4
(1, 5, '2025-03-06 09:15:00', '2025-03-08 14:00:00'),  -- Truck 1 for Shipment 5
(2, 6, '2025-03-07 10:00:00', NULL),  -- Truck 2 for Shipment 6
(3, 7, '2025-03-08 11:30:00', '2025-03-10 13:00:00'),  -- Truck 3 for Shipment 7
(4, 8, '2025-03-09 12:00:00', NULL),  -- Truck 4 for Shipment 8
(1, 9, '2025-03-10 13:45:00', '2025-03-12 15:00:00'),  -- Truck 1 for Shipment 9
(2, 10, '2025-03-11 14:30:00', NULL);  -- Truck 2 for Shipment 10

-- Insert Addresses, Persons, Employees, Warehouses, Depots, Vendors, Products, VendorProducts, Shipments, ShipmentDetails, Inventory, Trucks, and TruckAssignments (as in your expanded version)

-- Insert Users (with plain text passwords)
INSERT INTO Users (Username, Password, Role) VALUES 
('admin', 'admin123', 'admin'),  -- Admin user
('jane_smith', 'user123', 'user'),  -- Regular user (Jane Smith)
('alice_johnson', 'user456', 'user'),  -- Regular user (Alice Johnson)
('bob_williams', 'user789', 'user');  -- Regular user (Bob Williams)
-- -- 1. SUPPLIERS
-- CREATE TABLE Suppliers (
--     supplier_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--     supplier_name    VARCHAR2(100) NOT NULL,
--     contact_person   VARCHAR2(100),
--     email            VARCHAR2(100),
--     location         VARCHAR2(100)
-- );

-- -- 2. PARTS
-- CREATE TABLE Parts (
--     part_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--     part_name     VARCHAR2(100) NOT NULL,
--     supplier_id   NUMBER,
--     stock_quantity NUMBER DEFAULT 0,
--     unit_price    NUMBER(10, 2),
--     CONSTRAINT fk_parts_supplier FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
-- );

-- -- 3. ENGINE
-- CREATE TABLE Engine (
--     engine_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--     engine_type     VARCHAR2(50) NOT NULL,
--     horsepower      NUMBER,
--     fuel_type       VARCHAR2(50),
--     production_cost NUMBER(10, 2)
-- );

-- -- 4. ASSEMBLY_LINES
-- CREATE TABLE Assembly_Lines (
--     assembly_line_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--     line_name            VARCHAR2(100) NOT NULL,
--     location             VARCHAR2(100),
--     shift                VARCHAR2(20),
--     max_output_per_day   NUMBER
-- );

-- -- 5. EMPLOYEES
-- CREATE TABLE Employees (
--     employee_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--     name              VARCHAR2(100) NOT NULL,
--     position          VARCHAR2(50),
--     assembly_line_id  NUMBER,
--     hire_date         DATE,
--     salary            NUMBER(10, 2),
--     CONSTRAINT fk_employee_line FOREIGN KEY (assembly_line_id) REFERENCES Assembly_Lines(assembly_line_id)
-- );

-- -- 6. CARS
-- CREATE TABLE Cars (
--     car_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--     model_name        VARCHAR2(100) NOT NULL,
--     production_year   NUMBER(4),
--     engine_id         NUMBER,
--     assembly_line_id  NUMBER,
--     status            VARCHAR2(50),
--     CONSTRAINT fk_car_engine FOREIGN KEY (engine_id) REFERENCES Engine(engine_id),
--     CONSTRAINT fk_car_line FOREIGN KEY (assembly_line_id) REFERENCES Assembly_Lines(assembly_line_id)
-- );



-- -- Suppliers
-- INSERT INTO Suppliers (supplier_name, contact_person, email, location) VALUES
-- ('Global Motors Ltd', 'Ali Karimov', 'ali.k@globalmotors.com', 'Germany'),
-- ('Turbo Supplies Inc.', 'John Reed', 'john.reed@turbo.com', 'USA'),
-- ('EcoParts Co', 'Maria Ivanova', 'maria@ecoparts.ru', 'Russia'),
-- ('MegaAuto Components', 'Elif Kaya', 'elif.k@megaauto.com', 'Turkey'),
-- ('FastFix Inc.', 'Tom Nguyen', 'tom@fastfix.vn', 'Vietnam'),
-- ('Precision Parts', 'Ravi Mehta', 'ravi@precision.in', 'India'),
-- ('Z-Speed Corp', 'Chen Wang', 'chen.w@zspeed.cn', 'China');

-- -- Parts
-- INSERT INTO Parts (part_name, supplier_id, stock_quantity, unit_price) VALUES
-- ('Brake Pad', 1, 500, 25.50),
-- ('Oil Filter', 2, 300, 15.75),
-- ('Spark Plug', 3, 600, 8.90),
-- ('Battery', 4, 200, 75.00),
-- ('Alternator', 5, 100, 120.40),
-- ('Fuel Pump', 6, 150, 55.30),
-- ('Radiator', 7, 90, 130.00);

-- -- Engine
-- INSERT INTO Engine (engine_type, horsepower, fuel_type, production_cost) VALUES
-- ('V6', 250, 'Petrol', 4500.00),
-- ('V8', 400, 'Petrol', 6200.00),
-- ('I4', 180, 'Diesel', 3000.00),
-- ('Electric', 200, 'Electric', 7500.00),
-- ('Hybrid', 220, 'Hybrid', 6800.00),
-- ('V6 Turbo', 300, 'Petrol', 5200.00),
-- ('I3', 130, 'Diesel', 2500.00);

-- -- Assembly_Lines
-- INSERT INTO Assembly_Lines (line_name, location, shift, max_output_per_day) VALUES
-- ('Line A', 'Plant 1 - Baku', 'Day', 20),
-- ('Line B', 'Plant 1 - Baku', 'Night', 18),
-- ('Line C', 'Plant 2 - Ganja', 'Day', 22),
-- ('Line D', 'Plant 2 - Ganja', 'Night', 20),
-- ('Line E', 'Plant 3 - Sumqayit', 'Day', 25),
-- ('Line F', 'Plant 3 - Sumqayit', 'Night', 15),
-- ('Line G', 'Plant 4 - Mingachevir', 'Day', 30);

-- -- Employees
-- INSERT INTO Employees (name, position, assembly_line_id, hire_date, salary) VALUES
-- ('Orkhan Aliyev', 'Technician', 1, DATE '2020-05-10', 1200.00),
-- ('Leyla Mammadova', 'Engineer', 2, DATE '2019-03-18', 2000.00),
-- ('Javid Rasulov', 'Supervisor', 3, DATE '2021-11-01', 1800.00),
-- ('Aysel Rahimova', 'Assembler', 4, DATE '2022-07-07', 1100.00),
-- ('Kamran Huseynov', 'Quality Inspector', 5, DATE '2020-09-25', 1500.00),
-- ('Nigar Guliyeva', 'Assembler', 6, DATE '2023-01-12', 1050.00),
-- ('Murad Asgarov', 'Technician', 7, DATE '2021-04-14', 1250.00);

-- -- Cars
-- INSERT INTO Cars (model_name, production_year, engine_id, assembly_line_id, status) VALUES
-- ('AZ-Coupe 2023', 2023, 1, 1, 'Completed'),
-- ('AZ-SUV X', 2023, 2, 2, 'In Production'),
-- ('EcoRun E', 2024, 4, 3, 'Completed'),
-- ('Speedster Z', 2023, 6, 4, 'In Production'),
-- ('HybridDrive H1', 2024, 5, 5, 'Completed'),
-- ('DieselMax D3', 2022, 3, 6, 'Completed'),
-- ('MiniDrive I3', 2024, 7, 7, 'In Production');

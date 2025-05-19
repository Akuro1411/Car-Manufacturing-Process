-- 1. SUPPLIERS
CREATE TABLE Suppliers (
    supplier_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_name    VARCHAR2(100) NOT NULL,
    contact_person   VARCHAR2(100),
    email            VARCHAR2(100),
    location         VARCHAR2(100)
);

-- 2. PARTS
CREATE TABLE Parts (
    part_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    part_name     VARCHAR2(100) NOT NULL,
    supplier_id   NUMBER,
    stock_quantity NUMBER DEFAULT 0,
    unit_price    NUMBER(10, 2),
    CONSTRAINT fk_parts_supplier FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- 3. ENGINE
CREATE TABLE Engine (
    engine_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    engine_type     VARCHAR2(50) NOT NULL,
    horsepower      NUMBER,
    fuel_type       VARCHAR2(50),
    production_cost NUMBER(10, 2)
);

-- 4. ASSEMBLY_LINES
CREATE TABLE Assembly_Lines (
    assembly_line_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    line_name            VARCHAR2(100) NOT NULL,
    location             VARCHAR2(100),
    shift                VARCHAR2(20),
    max_output_per_day   NUMBER
);

-- 5. EMPLOYEES
CREATE TABLE Employees (
    employee_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name              VARCHAR2(100) NOT NULL,
    position          VARCHAR2(50),
    assembly_line_id  NUMBER,
    hire_date         DATE,
    salary            NUMBER(10, 2),
    CONSTRAINT fk_employee_line FOREIGN KEY (assembly_line_id) REFERENCES Assembly_Lines(assembly_line_id)
);

-- 6. CARS
CREATE TABLE Cars (
    car_id            NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_name        VARCHAR2(100) NOT NULL,
    production_year   NUMBER(4),
    engine_id         NUMBER,
    assembly_line_id  NUMBER,
    status            VARCHAR2(50),
    CONSTRAINT fk_car_engine FOREIGN KEY (engine_id) REFERENCES Engine(engine_id),
    CONSTRAINT fk_car_line FOREIGN KEY (assembly_line_id) REFERENCES Assembly_Lines(assembly_line_id)
);



-- Suppliers
INSERT INTO Suppliers (supplier_name, contact_person, email, location) VALUES
('Global Motors Ltd', 'Ali Karimov', 'ali.k@globalmotors.com', 'Germany'),
('Turbo Supplies Inc.', 'John Reed', 'john.reed@turbo.com', 'USA'),
('EcoParts Co', 'Maria Ivanova', 'maria@ecoparts.ru', 'Russia'),
('MegaAuto Components', 'Elif Kaya', 'elif.k@megaauto.com', 'Turkey'),
('FastFix Inc.', 'Tom Nguyen', 'tom@fastfix.vn', 'Vietnam'),
('Precision Parts', 'Ravi Mehta', 'ravi@precision.in', 'India'),
('Z-Speed Corp', 'Chen Wang', 'chen.w@zspeed.cn', 'China');

-- Parts
INSERT INTO Parts (part_name, supplier_id, stock_quantity, unit_price) VALUES
('Brake Pad', 1, 500, 25.50),
('Oil Filter', 2, 300, 15.75),
('Spark Plug', 3, 600, 8.90),
('Battery', 4, 200, 75.00),
('Alternator', 5, 100, 120.40),
('Fuel Pump', 6, 150, 55.30),
('Radiator', 7, 90, 130.00);

-- Engine
INSERT INTO Engine (engine_type, horsepower, fuel_type, production_cost) VALUES
('V6', 250, 'Petrol', 4500.00),
('V8', 400, 'Petrol', 6200.00),
('I4', 180, 'Diesel', 3000.00),
('Electric', 200, 'Electric', 7500.00),
('Hybrid', 220, 'Hybrid', 6800.00),
('V6 Turbo', 300, 'Petrol', 5200.00),
('I3', 130, 'Diesel', 2500.00);

-- Assembly_Lines
INSERT INTO Assembly_Lines (line_name, location, shift, max_output_per_day) VALUES
('Line A', 'Plant 1 - Baku', 'Day', 20),
('Line B', 'Plant 1 - Baku', 'Night', 18),
('Line C', 'Plant 2 - Ganja', 'Day', 22),
('Line D', 'Plant 2 - Ganja', 'Night', 20),
('Line E', 'Plant 3 - Sumqayit', 'Day', 25),
('Line F', 'Plant 3 - Sumqayit', 'Night', 15),
('Line G', 'Plant 4 - Mingachevir', 'Day', 30);

-- Employees
INSERT INTO Employees (name, position, assembly_line_id, hire_date, salary) VALUES
('Orkhan Aliyev', 'Technician', 1, DATE '2020-05-10', 1200.00),
('Leyla Mammadova', 'Engineer', 2, DATE '2019-03-18', 2000.00),
('Javid Rasulov', 'Supervisor', 3, DATE '2021-11-01', 1800.00),
('Aysel Rahimova', 'Assembler', 4, DATE '2022-07-07', 1100.00),
('Kamran Huseynov', 'Quality Inspector', 5, DATE '2020-09-25', 1500.00),
('Nigar Guliyeva', 'Assembler', 6, DATE '2023-01-12', 1050.00),
('Murad Asgarov', 'Technician', 7, DATE '2021-04-14', 1250.00);

-- Cars
INSERT INTO Cars (model_name, production_year, engine_id, assembly_line_id, status) VALUES
('AZ-Coupe 2023', 2023, 1, 1, 'Completed'),
('AZ-SUV X', 2023, 2, 2, 'In Production'),
('EcoRun E', 2024, 4, 3, 'Completed'),
('Speedster Z', 2023, 6, 4, 'In Production'),
('HybridDrive H1', 2024, 5, 5, 'Completed'),
('DieselMax D3', 2022, 3, 6, 'Completed'),
('MiniDrive I3', 2024, 7, 7, 'In Production');

-- Suppliers functions and procedures

-- Procedure: Add a New Supplier
CREATE OR REPLACE PROCEDURE add_supplier_with_validation (
    p_supplier_name   IN VARCHAR2,
    p_contact_person  IN VARCHAR2,
    p_email           IN VARCHAR2,
    p_location        IN VARCHAR2
) AS
BEGIN
    IF INSTR(p_email, '@') = 0 OR INSTR(p_email, '.') = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid email format: ' || p_email);
        RETURN;
    END IF;

    INSERT INTO Suppliers (supplier_name, contact_person, email, location)
    VALUES (p_supplier_name, p_contact_person, p_email, p_location);

    DBMS_OUTPUT.PUT_LINE('Supplier "' || p_supplier_name || '" added successfully.');
END;

-- Procedure: If Supplier Doesn't Supply Any Parts, Delete Them
CREATE OR REPLACE PROCEDURE delete_supplier_if_unused (
    p_supplier_id IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    v_count := get_part_count_for_supplier(p_supplier_id);

    IF v_count = 0 THEN
        DELETE FROM Suppliers WHERE supplier_id = p_supplier_id;
        DBMS_OUTPUT.PUT_LINE('Supplier ' || p_supplier_id || ' deleted (no parts supplied).');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Supplier ' || p_supplier_id || ' supplies ' || v_count || ' parts. Not deleted.');
    END IF;
END;



-- Function: Get Total Value of Parts Supplied by a Supplier
CREATE OR REPLACE FUNCTION get_supplier_inventory_value (
    p_supplier_id IN NUMBER
) RETURN NUMBER IS
    v_total_value NUMBER;
BEGIN
    SELECT SUM(stock_quantity * unit_price)
    INTO v_total_value
    FROM Parts
    WHERE supplier_id = p_supplier_id;

    RETURN NVL(v_total_value, 0);
END;
select supplier_id, GET_SUPPLIER_INVENTORY_VALUE(supplier_id) from suppliers;


-- Parts functions and procedurs
--  Updating stock
CREATE OR REPLACE PROCEDURE update_stock (
    p_part_id IN NUMBER,
    p_quantity_change IN NUMBER
) AS
BEGIN
    UPDATE Parts
    SET stock_quantity = stock_quantity + p_quantity_change
    WHERE part_id = p_part_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No part found with given ID.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Stock updated successfully.');
    END IF;
END;



BEGIN
    update_stock(1, -50);  -- Reduces stock of part_id 1 by 50
END;



-- Get stock value
CREATE OR REPLACE FUNCTION get_stock_value (
    p_part_id IN NUMBER
) RETURN NUMBER IS
    v_value NUMBER;
BEGIN
    SELECT stock_quantity * unit_price
    INTO v_value
    FROM Parts
    WHERE part_id = p_part_id;

    RETURN v_value;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;


DECLARE
    v_total_value NUMBER;
BEGIN
    v_total_value := get_stock_value(1);
    DBMS_OUTPUT.PUT_LINE('Total stock value: ' || v_total_value);
END;


-- Engine functions and procedurs
-- Function for learning engine utilization rate
CREATE OR REPLACE FUNCTION get_engine_type_utilization_rate(
    p_engine_type IN VARCHAR2,
    p_year_filter IN NUMBER DEFAULT NULL
)
RETURN NUMBER
IS
    v_total_cars     NUMBER := 0;
    v_type_uses      NUMBER := 0;
BEGIN

    IF p_year_filter IS NOT NULL THEN

        SELECT COUNT(*) 
          INTO v_total_cars
          FROM Cars
         WHERE engine_id IS NOT NULL
           AND production_year = p_year_filter;


        SELECT COUNT(*) 
          INTO v_type_uses
          FROM Cars c
          JOIN Engine e 
            ON c.engine_id = e.engine_id
         WHERE LOWER(e.engine_type) = LOWER(p_engine_type)
           AND c.production_year = p_year_filter;
    ELSE

        SELECT COUNT(*) 
          INTO v_total_cars
          FROM Cars
         WHERE engine_id IS NOT NULL;

        SELECT COUNT(*) 
          INTO v_type_uses
          FROM Cars c
          JOIN Engine e 
            ON c.engine_id = e.engine_id
         WHERE LOWER(e.engine_type) = LOWER(p_engine_type);
    END IF;

    IF v_total_cars = 0 THEN
        RETURN 0;
    END IF;

    RETURN ROUND((v_type_uses / v_total_cars) * 100, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN NULL;
END;


SELECT  c.car_id, c.model_name, e.engine_type, get_engine_type_utilization_rate(e.engine_type) AS type_usage_pct
FROM Cars c JOIN Engine e ON c.engine_id = e.engine_id;


-- Learning average cost of cars based on their fuel type
CREATE OR REPLACE FUNCTION get_average_cost_by_fuel_type(
    p_fuel_type engine.fuel_type%type
)
RETURN NUMBER
IS
    v_avg_cost NUMBER;
BEGIN
    SELECT AVG(production_cost)
    INTO v_avg_cost
    FROM Engine
    WHERE LOWER(fuel_type) = LOWER(p_fuel_type);

    RETURN ROUND(v_avg_cost, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;

select GET_AVERAGE_COST_BY_FUEL_TYPE('Diesel') from dual;


-- Procedure for reporting engine usage
CREATE OR REPLACE PROCEDURE report_engine_usage
IS
    CURSOR cur_engine_usage IS
        SELECT 
            e.engine_id,
            e.engine_type,
            e.production_cost,
            NVL(COUNT(c.car_id), 0) AS usage_count
        FROM Engine e
        LEFT JOIN Cars c
            ON e.engine_id = c.engine_id
        GROUP BY 
            e.engine_id, 
            e.engine_type, 
            e.production_cost
        ORDER BY usage_count DESC;
BEGIN
    FOR rec IN cur_engine_usage LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Engine ID: ' || rec.engine_id ||
            ' | Type: ' || rec.engine_type ||
            ' | Cost: ' || TO_CHAR(rec.production_cost) ||
            ' | Cars Used: ' || rec.usage_count
        );
    END LOOP;
END;

BEGIN
    report_engine_usage;
END;


-- Assembly lines






-- Employees functions and procedurs
CREATE OR REPLACE PROCEDURE add_employee(
    p_name IN VARCHAR2,
    p_position IN VARCHAR2,
    p_assembly_line_id IN NUMBER,
    p_hire_date IN DATE,
    p_salary IN NUMBER
) AS
BEGIN
    INSERT INTO Employees (name, position, assembly_line_id, hire_date, salary)
    VALUES (p_name, p_position, p_assembly_line_id, p_hire_date, p_salary);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error adding employee: ' || SQLERRM);
END add_employee;
/


CREATE OR REPLACE FUNCTION get_avg_salary_by_position(
    p_position IN VARCHAR2
) RETURN NUMBER AS
    v_avg_salary NUMBER;
BEGIN
    SELECT AVG(salary) INTO v_avg_salary
    FROM Employees
    WHERE position = p_position;
    
    RETURN NVL(v_avg_salary, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END get_avg_salary_by_position;
/


CREATE OR REPLACE FUNCTION get_highest_paid_employee(
    p_position IN VARCHAR2
) RETURN VARCHAR2 AS
    v_employee_name VARCHAR2(100);
BEGIN
    SELECT name INTO v_employee_name
    FROM Employees
    WHERE position = p_position
    AND salary = (SELECT MAX(salary) FROM Employees WHERE position = p_position)
    AND ROWNUM = 1;
    
    RETURN v_employee_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No employees found for position: ' || p_position;
END get_highest_paid_employee;
/

select GET_HIGHEST_PAID_EMPLOYEE('Engineer') from dual;


-- Cars functions and procedurs
CREATE OR REPLACE FUNCTION CalculateCarAge(p_car_id NUMBER)
RETURN NUMBER
AS
    v_year NUMBER;
BEGIN
    SELECT production_year INTO v_year FROM Cars WHERE car_id = p_car_id;
    RETURN EXTRACT(YEAR FROM SYSDATE) - v_year;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;


CREATE OR REPLACE PROCEDURE UpdateCarStatus(p_car_id NUMBER, p_new_status VARCHAR2)
AS
BEGIN
    UPDATE Cars
    SET status = p_new_status
    WHERE car_id = p_car_id;
    
    COMMIT;
END;

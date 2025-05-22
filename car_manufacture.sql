-- 1. suppliers
create table suppliers (
    supplier_id      number generated always as identity primary key,
    supplier_name    varchar2(100) not null,
    contact_person   varchar2(100),
    email            varchar2(100),
    location         varchar2(100)
);

-- 2. parts
create table parts (
    part_id       number generated always as identity primary key,
    part_name     varchar2(100) not null,
    supplier_id   number,
    stock_quantity number default 0,
    unit_price    number(10, 2),
    constraint fk_parts_supplier foreign key (supplier_id) references suppliers(supplier_id)
);

-- 3. engine
create table engine (
    engine_id       number generated always as identity primary key,
    engine_type     varchar2(50) not null,
    horsepower      number,
    fuel_type       varchar2(50),
    production_cost number(10, 2)
);

-- 4. assembly_lines
create table assembly_lines (
    assembly_line_id     number generated always as identity primary key,
    line_name            varchar2(100) not null,
    location             varchar2(100),
    shift                varchar2(20),
    max_output_per_day   number
);

-- 5. employees
create table employees (
    employee_id       number generated always as identity primary key,
    name              varchar2(100) not null,
    position          varchar2(50),
    assembly_line_id  number,
    hire_date         date,
    salary            number(10, 2),
    constraint fk_employee_line foreign key (assembly_line_id) references assembly_lines(assembly_line_id)
);

-- 6. cars
create table cars (
    car_id            number generated always as identity primary key,
    model_name        varchar2(100) not null,
    production_year   number(4),
    engine_id         number,
    assembly_line_id  number,
    status            varchar2(50),
    constraint fk_car_engine foreign key (engine_id) references engine(engine_id),
    constraint fk_car_line foreign key (assembly_line_id) references assembly_lines(assembly_line_id)
);



-- suppliers
insert into suppliers (supplier_name, contact_person, email, location) values
('global motors ltd', 'ali karimov', 'ali.k@globalmotors.com', 'germany'),
('turbo supplies inc.', 'john reed', 'john.reed@turbo.com', 'usa'),
('ecoparts co', 'maria ivanova', 'maria@ecoparts.ru', 'russia'),
('megaauto components', 'elif kaya', 'elif.k@megaauto.com', 'turkey'),
('fastfix inc.', 'tom nguyen', 'tom@fastfix.vn', 'vietnam'),
('precision parts', 'ravi mehta', 'ravi@precision.in', 'india'),
('z-speed corp', 'chen wang', 'chen.w@zspeed.cn', 'china');

-- parts
insert into parts (part_name, supplier_id, stock_quantity, unit_price) values
('brake pad', 1, 500, 25.50),
('oil filter', 2, 300, 15.75),
('spark plug', 3, 600, 8.90),
('battery', 4, 200, 75.00),
('alternator', 5, 100, 120.40),
('fuel pump', 6, 150, 55.30),
('radiator', 7, 90, 130.00);

-- engine
insert into engine (engine_type, horsepower, fuel_type, production_cost) values
('v6', 250, 'petrol', 4500.00),
('v8', 400, 'petrol', 6200.00),
('i4', 180, 'diesel', 3000.00),
('electric', 200, 'electric', 7500.00),
('hybrid', 220, 'hybrid', 6800.00),
('v6 turbo', 300, 'petrol', 5200.00),
('i3', 130, 'diesel', 2500.00);

-- assembly_lines
insert into assembly_lines (line_name, location, shift, max_output_per_day) values
('line a', 'plant 1 - baku', 'day', 20),
('line b', 'plant 1 - baku', 'night', 18),
('line c', 'plant 2 - ganja', 'day', 22),
('line d', 'plant 2 - ganja', 'night', 20),
('line e', 'plant 3 - sumqayit', 'day', 25),
('line f', 'plant 3 - sumqayit', 'night', 15),
('line g', 'plant 4 - mingachevir', 'day', 30);

-- employees
insert into employees (name, position, assembly_line_id, hire_date, salary) values
('orkhan aliyev', 'technician', 1, date '2020-05-10', 1200.00),
('leyla mammadova', 'engineer', 2, date '2019-03-18', 2000.00),
('javid rasulov', 'supervisor', 3, date '2021-11-01', 1800.00),
('aysel rahimova', 'assembler', 4, date '2022-07-07', 1100.00),
('kamran huseynov', 'quality inspector', 5, date '2020-09-25', 1500.00),
('nigar guliyeva', 'assembler', 6, date '2023-01-12', 1050.00),
('murad asgarov', 'technician', 7, date '2021-04-14', 1250.00);

-- cars
insert into cars (model_name, production_year, engine_id, assembly_line_id, status) values
('az-coupe 2023', 2023, 1, 1, 'completed'),
('az-suv x', 2023, 2, 2, 'in production'),
('ecorun e', 2024, 4, 3, 'completed'),
('speedster z', 2023, 6, 4, 'in production'),
('hybriddrive h1', 2024, 5, 5, 'completed'),
('dieselmax d3', 2022, 3, 6, 'completed'),
('minidrive i3', 2024, 7, 7, 'in production');

-- Suppliers functions and procedures

-- Adding a New Supplier
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

-- Getting Supplier Summary
CREATE OR REPLACE PROCEDURE Get_Supplier_Summary(p_supplier_id IN NUMBER) IS
    v_supplier_name Suppliers.supplier_name%TYPE;
    v_total_parts   NUMBER;
    v_total_value   NUMBER;
BEGIN
    SELECT supplier_name INTO v_supplier_name
    FROM Suppliers
    WHERE supplier_id = p_supplier_id;

    SELECT 
        (SELECT COUNT(*) FROM Parts WHERE supplier_id = p_supplier_id),
        (SELECT NVL(SUM(stock_quantity * unit_price), 0) FROM Parts WHERE supplier_id = p_supplier_id)
    INTO v_total_parts, v_total_value
    FROM dual;

    DBMS_OUTPUT.PUT_LINE('Supplier: ' || v_supplier_name);
    DBMS_OUTPUT.PUT_LINE('Total Parts Supplied: ' || v_total_parts);
    DBMS_OUTPUT.PUT_LINE('Total Stock Value: $' || v_total_value);
END;

-- Getting Supplier's Average Price
CREATE OR REPLACE FUNCTION Get_Supplier_Average_Price(p_supplier_id IN NUMBER)
RETURN NUMBER IS
    v_avg_price NUMBER := 0;
BEGIN
    SELECT NVL(AVG(unit_price), 0)
    INTO v_avg_price
    FROM Parts
    WHERE supplier_id = p_supplier_id;

    RETURN v_avg_price;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;

-- Listing All Suppliers and Their Contact Info
CREATE OR REPLACE PROCEDURE List_Suppliers_Info IS
    CURSOR c_suppliers IS
        SELECT supplier_name, contact_person, email, location
        FROM Suppliers;

    v_supplier c_suppliers%ROWTYPE;
BEGIN
    OPEN c_suppliers;
    LOOP
        FETCH c_suppliers INTO v_supplier;
        EXIT WHEN c_suppliers%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_supplier.supplier_name || 
                             ', Contact: ' || v_supplier.contact_person ||
                             ', Email: ' || v_supplier.email ||
                             ', Location: ' || v_supplier.location);
    END LOOP;
    CLOSE c_suppliers;
END;

-- Parts functions and procedurs
-- Updating stock
create or replace procedure update_stock (
    p_part_id in number,
    p_quantity_change in number
) as
begin
    update parts
    set stock_quantity = stock_quantity + p_quantity_change
    where part_id = p_part_id;

    if sql%rowcount = 0 then
        dbms_output.put_line('no part found with given id.');
    else
        dbms_output.put_line('stock updated successfully.');
    end if;
end;


-- Getting Supplier's total inventory
CREATE OR REPLACE FUNCTION get_stock_value (
    p_part_id IN NUMBER
) RETURN NUMBER IS
    v_value NUMBER;
BEGIN
	SELECT (SELECT stock_quantity FROM Parts WHERE part_id = p_part_id) *
       (SELECT unit_price FROM Parts WHERE part_id = p_part_id)
	INTO v_value
	FROM dual;

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

-- Inventory value of supplier
CREATE OR REPLACE FUNCTION get_supplier_inventory_value (
    p_supplier_id IN NUMBER
) RETURN NUMBER IS
    v_total_value NUMBER;
BEGIN
    SELECT (
        SELECT SUM(stock_quantity * unit_price)
        FROM Parts
        WHERE supplier_id = p_supplier_id
    )
    INTO v_total_value
    FROM dual;

    RETURN NVL(v_total_value, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;

-- Engine functions and procedurs
-- Function for learning engine utilization rate
create or replace function get_engine_type_utilization_rate(
    p_engine_type in varchar2,
    p_year_filter in number default null
)
return number
is
    v_total_cars     number := 0;
    v_type_uses      number := 0;
begin

    if p_year_filter is not null then

        select count(*) 
          into v_total_cars
          from cars
         where engine_id is not null
           and production_year = p_year_filter;


        select count(*) 
          into v_type_uses
          from cars c
          join engine e 
            on c.engine_id = e.engine_id
         where lower(e.engine_type) = lower(p_engine_type)
           and c.production_year = p_year_filter;
    else

        select count(*) 
          into v_total_cars
          from cars
         where engine_id is not null;

        select count(*) 
          into v_type_uses
          from cars c
          join engine e 
            on c.engine_id = e.engine_id
         where lower(e.engine_type) = lower(p_engine_type);
    end if;

    if v_total_cars = 0 then
        return 0;
    end if;

    return round((v_type_uses / v_total_cars) * 100, 2);
exception
    when no_data_found then
        return 0;
    when others then
        return null;
end;


select  c.car_id, c.model_name, e.engine_type, get_engine_type_utilization_rate(e.engine_type) as type_usage_pct
from cars c join engine e on c.engine_id = e.engine_id;


-- Learning average cost of cars based on their fuel type
create or replace function get_average_cost_by_fuel_type(
    p_fuel_type engine.fuel_type%type
)
return number
is
    v_avg_cost number;
begin
    select avg(production_cost)
    into v_avg_cost
    from engine
    where lower(fuel_type) = lower(p_fuel_type);

    return round(v_avg_cost, 2);
exception
    when no_data_found then
        return null;
end;

select get_average_cost_by_fuel_type('diesel') from dual;


-- Procedure for reporting engine usage
create or replace procedure report_engine_usage
is
    cursor cur_engine_usage is
        select 
            e.engine_id,
            e.engine_type,
            e.production_cost,
            nvl(count(c.car_id), 0) as usage_count
        from engine e
        left join cars c
            on e.engine_id = c.engine_id
        group by 
            e.engine_id, 
            e.engine_type, 
            e.production_cost
        order by usage_count desc;
begin
    for rec in cur_engine_usage loop
        dbms_output.put_line(
            'engine id: ' || rec.engine_id ||
            ' | type: ' || rec.engine_type ||
            ' | cost: ' || to_char(rec.production_cost) ||
            ' | cars used: ' || rec.usage_count
        );
    end loop;
end;

begin
    report_engine_usage;
end;


-- Assembly lines functions and procedurs
CREATE OR REPLACE PROCEDURE Assign_Employee_To_Line (
    p_employee_id       IN NUMBER,
    p_assembly_line_id  IN NUMBER
) AS
    v_count_line    NUMBER;
    v_count_emp     NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count_line
    FROM Assembly_Lines
    WHERE assembly_line_id = p_assembly_line_id;

    IF v_count_line = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Assembly line not found.');
    END IF;

    SELECT COUNT(*) INTO v_count_emp
    FROM Employees
    WHERE employee_id = p_employee_id;

    IF v_count_emp = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee not found.');
    END IF;

    UPDATE Employees
    SET assembly_line_id = p_assembly_line_id
    WHERE employee_id = p_employee_id;

    DBMS_OUTPUT.PUT_LINE('Employee assigned to assembly line successfully.');
END;


CREATE OR REPLACE FUNCTION Get_Daily_Car_Production_Capacity (
    p_line_id IN NUMBER DEFAULT NULL
) RETURN NUMBER IS
    v_total_capacity NUMBER;
BEGIN
    IF p_line_id IS NOT NULL THEN
        SELECT max_output_per_day INTO v_total_capacity
        FROM Assembly_Lines
        WHERE assembly_line_id = p_line_id;
    ELSE
        SELECT SUM(max_output_per_day) INTO v_total_capacity
        FROM Assembly_Lines;
    END IF;

    RETURN v_total_capacity;
END;


CREATE OR REPLACE PROCEDURE Report_Line_Production_Status (
    p_line_id IN NUMBER
) AS
BEGIN
    FOR r IN (
        SELECT status, COUNT(*) AS total
        FROM Cars
        WHERE assembly_line_id = p_line_id
        GROUP BY status
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Status: ' || r.status || ' - Count: ' || r.total);
    END LOOP;
END;



-- Employees functions and procedurs
create or replace procedure add_employee(
    p_name in varchar2,
    p_position in varchar2,
    p_assembly_line_id in number,
    p_hire_date in date,
    p_salary in number
) as
begin
    insert into employees (name, position, assembly_line_id, hire_date, salary)
    values (p_name, p_position, p_assembly_line_id, p_hire_date, p_salary);
    commit;
    dbms_output.put_line('employee added successfully.');
exception
    when others then
        rollback;
        dbms_output.put_line('error adding employee: ' || sqlerrm);
end add_employee;



create or replace function get_avg_salary_by_position(
    p_position in varchar2
) return number as
    v_avg_salary number;
begin
    select avg(salary) into v_avg_salary
    from employees
    where position = p_position;
    
    return nvl(v_avg_salary, 0);
exception
    when no_data_found then
        return 0;
end get_avg_salary_by_position;



CREATE OR REPLACE FUNCTION get_highest_paid_employee(
    p_position IN VARCHAR2
) RETURN VARCHAR2 AS
    v_employee_name VARCHAR2(100);
BEGIN
    SELECT name INTO v_employee_name
    FROM Employees
    WHERE position = p_position
    AND salary = (
        SELECT MAX(salary) 
        FROM Employees 
        WHERE position = p_position
    )
    AND ROWNUM = 1;
    
    RETURN v_employee_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No employees found for position: ' || p_position;
END get_highest_paid_employee;


select get_highest_paid_employee('engineer') from dual;


-- Cars functions and procedurs
CREATE OR REPLACE FUNCTION get_completed_car_count_by_year(p_year NUMBER)
RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM cars
    WHERE production_year = p_year
      AND status = 'completed';

    RETURN v_count;
END;


CREATE OR REPLACE FUNCTION get_latest_model_by_line(p_line_id NUMBER)
RETURN VARCHAR2 IS
    v_model_name VARCHAR2(100);
BEGIN
    SELECT model_name
    INTO v_model_name
    FROM cars
    WHERE assembly_line_id = p_line_id
      AND production_year = (
          SELECT MAX(production_year)
          FROM cars
          WHERE assembly_line_id = p_line_id
      )
    FETCH FIRST 1 ROWS ONLY;

    RETURN v_model_name;
END;


CREATE OR REPLACE PROCEDURE updatecarstatus(
    p_car_id      NUMBER,
    p_new_status  VARCHAR2
) AS
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_exists
    FROM cars
    WHERE car_id = p_car_id;

    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Car with ID ' || p_car_id || ' does not exist.');
    END IF;

    UPDATE cars
    SET status = p_new_status
    WHERE car_id = p_car_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Car status updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

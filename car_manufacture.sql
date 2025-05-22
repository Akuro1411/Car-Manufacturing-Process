-- 1. Suppliers
create table suppliers (
    supplier_id      number generated always as identity primary key,
    supplier_name    varchar2(100) not null,
    contact_person   varchar2(100),
    email            varchar2(100),
    location         varchar2(100)
);

-- 2. Parts
create table parts (
    part_id       number generated always as identity primary key,
    part_name     varchar2(100) not null,
    supplier_id   number,
    stock_quantity number default 0,
    unit_price    number(10, 2),
    constraint fk_parts_supplier foreign key (supplier_id) references suppliers(supplier_id)
);

-- 3. Engine
create table engine (
    engine_id       number generated always as identity primary key,
    engine_type     varchar2(50) not null,
    horsepower      number,
    fuel_type       varchar2(50),
    production_cost number(10, 2)
);

-- 4. Assembly_lines
create table assembly_lines (
    assembly_line_id     number generated always as identity primary key,
    line_name            varchar2(100) not null,
    location             varchar2(100),
    shift                varchar2(20),
    max_output_per_day   number
);

-- 5. Employees
create table employees (
    employee_id       number generated always as identity primary key,
    name              varchar2(100) not null,
    position          varchar2(50),
    assembly_line_id  number,
    hire_date         date,
    salary            number(10, 2),
    constraint fk_employee_line foreign key (assembly_line_id) references assembly_lines(assembly_line_id)
);

-- 6. Cars
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



-- Suppliers
insert into suppliers (supplier_name, contact_person, email, location) values
('global motors ltd', 'ali karimov', 'ali.k@globalmotors.com', 'germany'),
('turbo supplies inc.', 'john reed', 'john.reed@turbo.com', 'usa'),
('ecoparts co', 'maria ivanova', 'maria@ecoparts.ru', 'russia'),
('megaauto components', 'elif kaya', 'elif.k@megaauto.com', 'turkey'),
('fastfix inc.', 'tom nguyen', 'tom@fastfix.vn', 'vietnam'),
('precision parts', 'ravi mehta', 'ravi@precision.in', 'india'),
('z-speed corp', 'chen wang', 'chen.w@zspeed.cn', 'china');

-- Parts
insert into parts (part_name, supplier_id, stock_quantity, unit_price) values
('brake pad', 1, 500, 25.50),
('oil filter', 2, 300, 15.75),
('spark plug', 3, 600, 8.90),
('battery', 4, 200, 75.00),
('alternator', 5, 100, 120.40),
('fuel pump', 6, 150, 55.30),
('radiator', 7, 90, 130.00);

-- Engine
insert into engine (engine_type, horsepower, fuel_type, production_cost) values
('v6', 250, 'petrol', 4500.00),
('v8', 400, 'petrol', 6200.00),
('i4', 180, 'diesel', 3000.00),
('electric', 200, 'electric', 7500.00),
('hybrid', 220, 'hybrid', 6800.00),
('v6 turbo', 300, 'petrol', 5200.00),
('i3', 130, 'diesel', 2500.00);

-- Assembly_lines
insert into assembly_lines (line_name, location, shift, max_output_per_day) values
('line a', 'plant 1 - baku', 'day', 20),
('line b', 'plant 1 - baku', 'night', 18),
('line c', 'plant 2 - ganja', 'day', 22),
('line d', 'plant 2 - ganja', 'night', 20),
('line e', 'plant 3 - sumqayit', 'day', 25),
('line f', 'plant 3 - sumqayit', 'night', 15),
('line g', 'plant 4 - mingachevir', 'day', 30);

-- Employees
insert into employees (name, position, assembly_line_id, hire_date, salary) values
('orkhan aliyev', 'technician', 1, date '2020-05-10', 1200.00),
('leyla mammadova', 'engineer', 2, date '2019-03-18', 2000.00),
('javid rasulov', 'supervisor', 3, date '2021-11-01', 1800.00),
('aysel rahimova', 'assembler', 4, date '2022-07-07', 1100.00),
('kamran huseynov', 'quality inspector', 5, date '2020-09-25', 1500.00),
('nigar guliyeva', 'assembler', 6, date '2023-01-12', 1050.00),
('murad asgarov', 'technician', 7, date '2021-04-14', 1250.00);

-- Cars
insert into cars (model_name, production_year, engine_id, assembly_line_id, status) values
('az-coupe 2023', 2023, 1, 1, 'completed'),
('az-suv x', 2023, 2, 2, 'in production'),
('ecorun e', 2024, 4, 3, 'completed'),
('speedster z', 2023, 6, 4, 'in production'),
('hybriddrive h1', 2024, 5, 5, 'completed'),
('dieselmax d3', 2022, 3, 6, 'completed'),
('minidrive i3', 2024, 7, 7, 'in production');

-- Suppliers functions and procedures

-- Adding a new supplier
create or replace procedure add_supplier_with_validation (
    p_supplier_name   in varchar2,
    p_contact_person  in varchar2,
    p_email           in varchar2,
    p_location        in varchar2
) as
begin
    if instr(p_email, '@') = 0 or instr(p_email, '.') = 0 then
        dbms_output.put_line('invalid email format: ' || p_email);
        return;
    end if;

    insert into suppliers (supplier_name, contact_person, email, location)
    values (p_supplier_name, p_contact_person, p_email, p_location);

    dbms_output.put_line('supplier "' || p_supplier_name || '" added successfully.');
end;

-- Getting supplier summary
create or replace procedure get_supplier_summary(p_supplier_id in number) is
    v_supplier_name suppliers.supplier_name%type;
    v_total_parts   number;
    v_total_value   number;
begin
    select supplier_name into v_supplier_name
    from suppliers
    where supplier_id = p_supplier_id;

    select 
        (select count(*) from parts where supplier_id = p_supplier_id),
        (select nvl(sum(stock_quantity * unit_price), 0) from parts where supplier_id = p_supplier_id)
    into v_total_parts, v_total_value
    from dual;

    dbms_output.put_line('supplier: ' || v_supplier_name);
    dbms_output.put_line('total parts supplied: ' || v_total_parts);
    dbms_output.put_line('total stock value: $' || v_total_value);
end;

-- Getting supplier's average price
create or replace function get_supplier_average_price(p_supplier_id in number)
return number is
    v_avg_price number := 0;
begin
    select nvl(avg(unit_price), 0)
    into v_avg_price
    from parts
    where supplier_id = p_supplier_id;

    return v_avg_price;
exception
    when no_data_found then
        return 0;
end;

-- Listing all suppliers and their contact info
create or replace procedure list_suppliers_info is
    cursor c_suppliers is
        select supplier_name, contact_person, email, location
        from suppliers;

    v_supplier c_suppliers%rowtype;
begin
    open c_suppliers;
    loop
        fetch c_suppliers into v_supplier;
        exit when c_suppliers%notfound;
        dbms_output.put_line('name: ' || v_supplier.supplier_name || 
                             ', contact: ' || v_supplier.contact_person ||
                             ', email: ' || v_supplier.email ||
                             ', location: ' || v_supplier.location);
    end loop;
    close c_suppliers;
end;

-- Parts functions and procedurs

create or replace function get_supplier_inventory_value (
    p_supplier_id in number
) return number is
    v_total_value number;
begin
    select sum(stock_quantity * unit_price)
    into v_total_value
    from parts
    where supplier_id = p_supplier_id;

    return nvl(v_total_value, 0);
exception
    when no_data_found then
      return 0;
end;

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


-- Getting supplier's total inventory
create or replace function get_stock_value (
    p_part_id in number
) return number is
    v_value number;
begin
	select (select stock_quantity from parts where part_id = p_part_id) *
       (select unit_price from parts where part_id = p_part_id)
	into v_value
	from dual;

    return v_value;
exception
    when no_data_found then
        return null;
end;

declare
    v_total_value number;
begin
    v_total_value := get_stock_value(1);
    dbms_output.put_line('total stock value: ' || v_total_value);
end;

-- Inventory value of supplier
create or replace function get_supplier_inventory_value (
    p_supplier_id in number
) return number is
    v_total_value number;
begin
    select sum(stock_quantity * unit_price)
    into v_total_value
    from parts
    where supplier_id = p_supplier_id;

    return nvl(v_total_value, 0);
exception
    when no_data_found then
        return 0;
end;

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
create or replace procedure assign_employee_to_line (
    p_employee_id       in number,
    p_assembly_line_id  in number
) as
    v_count_line    number;
    v_count_emp     number;
begin
    select count(*) into v_count_line
    from assembly_lines
    where assembly_line_id = p_assembly_line_id;

    if v_count_line = 0 then
        raise_application_error(-20001, 'assembly line not found.');
    end if;

    select count(*) into v_count_emp
    from employees
    where employee_id = p_employee_id;

    if v_count_emp = 0 then
        raise_application_error(-20002, 'employee not found.');
    end if;

    update employees
    set assembly_line_id = p_assembly_line_id
    where employee_id = p_employee_id;

    dbms_output.put_line('employee assigned to assembly line successfully.');
end;


create or replace function get_car_production_capacity (
    p_line_id in number default null,
    p_period  in varchar2 default 'day'
) return number is
    v_daily_capacity number;
    v_final_capacity number;
begin

    if p_line_id is not null then
        select max_output_per_day into v_daily_capacity
        from assembly_lines
        where assembly_line_id = p_line_id;
    else
        select sum(max_output_per_day) into v_daily_capacity
        from assembly_lines;
    end if;

   
    case lower(p_period)
        when 'day' then
            v_final_capacity := v_daily_capacity;
        when 'month' then
            v_final_capacity := v_daily_capacity * 30;
        when 'year' then
            v_final_capacity := v_daily_capacity * 365;
        else
            raise_application_error(-20003, 'Invalid period. Use day, month, or year.');
    end case;

    return v_final_capacity;
end;


-- Reports current production status
create or replace procedure report_line_production_status (
    p_line_id in number
) as
begin
    for r in (
        select status, count(*) as total
        from cars
        where assembly_line_id = p_line_id
        group by status
    ) loop
        dbms_output.put_line('status: ' || r.status || ' - count: ' || r.total);
    end loop;
end;



-- Employees functions and procedurs

-- Adding new employee without duplication
create or replace procedure add_employee(
    p_name in varchar2,
    p_position in varchar2,
    p_assembly_line_id in number,
    p_hire_date in date,
    p_salary in number
) as
    v_count number;
begin
    select count(*) into v_count
    from employees
    where name = p_name
      and assembly_line_id = p_assembly_line_id;

    if v_count > 0 then
        dbms_output.put_line('Employee already exists. No action taken.');
    else
        insert into employees (name, position, assembly_line_id, hire_date, salary)
        values (p_name, p_position, p_assembly_line_id, p_hire_date, p_salary);
        dbms_output.put_line('Employee added successfully.');
    end if;
exception
    when others then
        rollback;
        dbms_output.put_line('Error adding employee: ' || sqlerrm);
end;


-- Displays average salary based position
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


-- Displays highest paid employee in order to find maximum salary limit
create or replace function get_highest_paid_employee(
    p_position in varchar2
) return varchar2 as
    v_employee_name varchar2(100);
begin
    select name into v_employee_name
    from employees
    where position = p_position
    and salary = (
        select max(salary) 
        from employees 
        where position = p_position
    )
    and rownum = 1;
    
    return v_employee_name;
exception
    when no_data_found then
        return 'no employees found for position: ' || p_position;
end get_highest_paid_employee;


select get_highest_paid_employee('engineer') from dual;


-- Cars functions and procedurs

-- Calculates total producion amount of car in a year
create or replace function get_completed_car_count_by_year(p_year number)
return number is
    v_count number;
begin
    select count(*) into v_count
    from cars
    where production_year = p_year
      and status = 'completed';

    return v_count;
end;


-- Displays the latest model of given car
create or replace function get_latest_model_by_line(p_line_id number)
return varchar2 is
    v_model_name varchar2(100);
begin
    select model_name
    into v_model_name
    from cars
    where assembly_line_id = p_line_id
      and production_year = (
          select max(production_year)
          from cars
          where assembly_line_id = p_line_id
      )
    fetch first 1 rows only;

    return v_model_name;
end;


-- Updates car status based on its current appearance
create or replace procedure updatecarstatus(
    p_car_id      number,
    p_new_status  varchar2
) as
    v_exists number;
begin
    select count(*)
    into v_exists
    from cars
    where car_id = p_car_id;

    if v_exists = 0 then
        raise_application_error(-20001, 'car with id ' || p_car_id || ' does not exist.');
    end if;

    update cars
    set status = p_new_status
    where car_id = p_car_id;

    commit;

    dbms_output.put_line('car status updated successfully.');
exception
    when others then
        rollback;
        dbms_output.put_line('error: ' || sqlerrm);
end;

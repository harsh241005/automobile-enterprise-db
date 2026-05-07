CREATE TABLE Company (
    company_id INT ,
    company_name VARCHAR2(100) NOT NULL,
    country VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_company PRIMARY KEY (company_id)
);

--No dependencies:
--Company, Colours, Engine, Transmission,
--Body_Style,Supplier, Parts, Plant

create table Colours (
colour_id int ,
colour_name varchar2(50) not null ,
constraint pk_colours primary key (colour_id),
CONSTRAINT uq_colours_name UNIQUE (colour_name)
);

CREATE TABLE Engine (
    engine_id INT,
    engine_type VARCHAR2(50) NOT NULL,
    capacity DECIMAL(4,1) NOT NULL,
    fuel_type VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_engine PRIMARY KEY (engine_id),
    CONSTRAINT chk_engine_fuel CHECK (UPPER(fuel_type) IN ('PETROL','DIESEL','ELECTRIC','HYBRID','CNG'))
);


CREATE TABLE Transmission (
    transmission_id INT,
    transmission_type VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_transmission PRIMARY KEY (transmission_id),
    CONSTRAINT chk_trans_type CHECK (UPPER(transmission_type) IN (
        'MANUAL','AUTOMATIC','SEMI-AUTOMATIC','CVT','DCT','AMT'
    ))
);

CREATE TABLE Bodystyle (
    body_style_id INT,
    style_name VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_bodystyle PRIMARY KEY (body_style_id)
);

CREATE TABLE Supplier (
    supplier_id int ,
    supplier_name varchar2(100) NOT NULL,
    contact varchar2(50) NOT NULL unique,
    address varchar2(200) NOT NULL,
    CONSTRAINT pk_supplier PRIMARY KEY (supplier_id)
); 

CREATE TABLE Parts (
    part_id INT,
    part_name VARCHAR2(100) NOT NULL,
    part_type VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_parts PRIMARY KEY (part_id)
);

CREATE TABLE Plant (
    plant_id INT,
    plant_name VARCHAR2(100) NOT NULL,
    location VARCHAR2(200) NOT NULL,
    CONSTRAINT pk_plant PRIMARY KEY (plant_id)
);

--Round 1 — No dependencies:
--Company, Colours, Engine, Transmission, Body_Style, Supplier, Parts, Plant
--Round 2 — Depend on Round 1:
--Brand, Model, Dealer, Customer, Serializing_Part
--Round 3 — Depend on Round 2:
--Vehicle
--Round 4 — Depend on Round 3:
--Sold_Vehicle
--Round 5 — Junction Tables:
--Model_Colour, Model_Engine, Model_Transmission, Model_BodyStyle, Model_Parts
--Round 6 — Trigger:
--after_sale_insert

create table Brand (
brand_id int ,
brand_name varchar2(100) not null ,
company_id int not null,
constraint pk_brand primary key (brand_id),
constraint fk_brand_comp foreign key (company_id)
references Company(company_id));


create table Model (
model_id int ,
model_name varchar2(100) not null ,
brand_id int not null,
constraint pk_model primary key (model_id),
constraint fk_model_brand foreign key (brand_id)
references Brand (brand_id));
ALTER TABLE Model
ADD body_style_id INT;
ALTER TABLE Model
ADD CONSTRAINT fk_model_bodystyle
FOREIGN KEY (body_style_id)
REFERENCES Bodystyle(body_style_id);
select * from model;

create table dealer (
dealer_id int ,
dealer_name varchar2(100) not null ,
location varchar2(200) not null ,
contact varchar2(50) not null ,
brand_id int not null,
constraint pk_dealer primary key (dealer_id),
constraint fk_dealer_brand foreign key (brand_id)
references Brand (brand_id));

create table customer (
customer_id int ,
customer_name varchar2(100) not null,
address varchar2(200) not null ,
phone varchar2(20) not null ,
gender varchar2(20) not null ,
annual_income decimal(15,2) not null,
constraint pk_customer primary key (customer_id),
constraint check_gender check (upper (gender) in ('MALE','FEMALE','OTHER'))
);

CREATE TABLE Serializing_Part (
    serial_id INT,
    part_id INT NOT NULL,
    supplier_id INT NOT NULL,
    batch_no VARCHAR2(50) NOT NULL,
    manufacture_date DATE NOT NULL,
    CONSTRAINT pk_serializing PRIMARY KEY (serial_id),
    CONSTRAINT fk_serial_part FOREIGN KEY (part_id)
        REFERENCES Parts(part_id),
    CONSTRAINT fk_serial_supplier FOREIGN KEY (supplier_id)
        REFERENCES Supplier(supplier_id),
    CONSTRAINT uq_serial_batch UNIQUE (batch_no)
); 
CREATE TABLE Model_Colour (
    model_id INT NOT NULL,
    colour_id INT NOT NULL,
    CONSTRAINT pk_model_colour PRIMARY KEY (model_id, colour_id),
    CONSTRAINT fk_mc_model FOREIGN KEY (model_id)
        REFERENCES Model(model_id),
    CONSTRAINT fk_mc_colour FOREIGN KEY (colour_id)
        REFERENCES Colours(colour_id)
);

CREATE TABLE Model_Engine (
    model_id INT NOT NULL,
    engine_id INT NOT NULL,
    CONSTRAINT pk_model_engine PRIMARY KEY (model_id, engine_id),
    CONSTRAINT fk_me_model FOREIGN KEY (model_id)
        REFERENCES Model(model_id) ,
    CONSTRAINT fk_me_engine FOREIGN KEY (engine_id)
        REFERENCES Engine(engine_id)
);

CREATE TABLE Model_Transmission (
    model_id INT NOT NULL,
    transmission_id INT NOT NULL,
    CONSTRAINT pk_model_transmission PRIMARY KEY (model_id, transmission_id),
    CONSTRAINT fk_mt_model FOREIGN KEY (model_id)
        REFERENCES Model(model_id) ON DELETE CASCADE,
    CONSTRAINT fk_mt_transmission FOREIGN KEY (transmission_id)
        REFERENCES Transmission(transmission_id) 
);

--Swift ? always Hatchback
--Fortuner - always SUV
--Body style is fixed per MODEL
--not a customer choice like colour,ENIGNE ETC
--body_style_id in Vehicle unnecessary
--Model_BodyStyle junction table — unnecessary
--? body_style_id directly in Model as FK — fixed per model!



CREATE TABLE Model_Parts (
    model_id INT NOT NULL,
    part_id INT NOT NULL,
    CONSTRAINT pk_model_parts PRIMARY KEY (model_id, part_id),
    CONSTRAINT fk_mp_model FOREIGN KEY (model_id)
        REFERENCES Model(model_id) ,
    CONSTRAINT fk_mp_part FOREIGN KEY (part_id)
        REFERENCES Parts(part_id) 
);
CREATE TABLE Vehicle (
    VIN VARCHAR2(17),
    model_id INT NOT NULL,
    colour_id INT NOT NULL,
    engine_id INT NOT NULL,
    transmission_id INT NOT NULL,
    dealer_id INT NOT NULL,
    plant_id INT NOT NULL,
    CONSTRAINT pk_vehicle PRIMARY KEY (VIN),
    CONSTRAINT fk_vehicle_colour FOREIGN KEY (model_id, colour_id)
        REFERENCES Model_Colour(model_id, colour_id),
    CONSTRAINT fk_vehicle_engine FOREIGN KEY (model_id, engine_id)
        REFERENCES Model_Engine(model_id, engine_id),
    CONSTRAINT fk_vehicle_transmission FOREIGN KEY (model_id, transmission_id)
        REFERENCES Model_Transmission(model_id, transmission_id),
    CONSTRAINT fk_vehicle_dealer FOREIGN KEY (dealer_id)
        REFERENCES Dealer(dealer_id),
    CONSTRAINT fk_vehicle_plant FOREIGN KEY (plant_id)
        REFERENCES Plant(plant_id)
);
ALTER TABLE Serializing_Part
ADD VIN VARCHAR2(17);
ALTER TABLE Serializing_Part
ADD CONSTRAINT fk_serial_vin
FOREIGN KEY (VIN)
REFERENCES Vehicle(VIN);


CREATE TABLE Sold_Vehicle (
    sold_id INT,
    VIN VARCHAR2(17) NOT NULL,
    customer_id INT not null,
    sale_date DATE NOT NULL,
    sale_price DECIMAL(15,2) NOT NULL,
    CONSTRAINT pk_sold_vehicle PRIMARY KEY (sold_id),
    CONSTRAINT fk_sv_vin FOREIGN KEY (VIN)
        REFERENCES Vehicle(VIN),
    CONSTRAINT fk_sv_customer FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id) ,
    CONSTRAINT uq_sv_vin UNIQUE (VIN)
);



SELECT 
    COALESCE(co.company_name, 'TOTAL') AS company,
    COALESCE(b.brand_name, 'SUBTOTAL') AS brand,
    COALESCE(m.model_name, 'SUBTOTAL') AS model,
    COUNT(sv.sold_id) AS units_sold,
    SUM(sv.sale_price) AS revenue
FROM Sold_Vehicle sv
JOIN Vehicle v ON sv.VIN = v.VIN
JOIN Model m ON v.model_id = m.model_id
JOIN Brand b ON m.brand_id = b.brand_id
JOIN Company co ON b.company_id = co.company_id
GROUP BY ROLLUP(co.company_name, b.brand_name, m.model_name)
ORDER BY co.company_name, b.brand_name, m.model_name;
 
-- =============================================
-- 1. COMPANY (no FK)
-- =============================================
INSERT INTO Company VALUES (1, 'General Motors', 'USA');
INSERT INTO Company VALUES (2, 'Toyota', 'Japan');
INSERT INTO Company VALUES (3, 'Volkswagen', 'Germany');
INSERT INTO Company VALUES (4, 'Ford', 'USA');
INSERT INTO Company VALUES (5, 'Hyundai', 'South Korea');

-- =============================================
-- 2. COLOURS (no FK)
-- =============================================
INSERT INTO Colours VALUES (1, 'Red');
INSERT INTO Colours VALUES (2, 'Blue');
INSERT INTO Colours VALUES (3, 'White');
INSERT INTO Colours VALUES (4, 'Black');
INSERT INTO Colours VALUES (5, 'Silver');
INSERT INTO Colours VALUES (6, 'Grey');
INSERT INTO Colours VALUES (7, 'Green');
INSERT INTO Colours VALUES (8, 'Brown');

-- =============================================
-- 3. ENGINE (no FK)
-- =============================================
INSERT INTO Engine VALUES (1, 'Inline-4', 1.5, 'Petrol');
INSERT INTO Engine VALUES (2, 'Inline-4', 2.0, 'Petrol');
INSERT INTO Engine VALUES (3, 'V6', 3.5, 'Petrol');
INSERT INTO Engine VALUES (4, 'Inline-4', 2.0, 'Diesel');
INSERT INTO Engine VALUES (5, 'Electric Motor', 0, 'Electric');
INSERT INTO Engine VALUES (6, 'Inline-4', 1.5, 'Hybrid');
INSERT INTO Engine VALUES (7, 'V8', 5.0, 'Petrol');
INSERT INTO Engine VALUES (8, 'Inline-4', 1.2, 'CNG');

-- =============================================
-- 4. TRANSMISSION (no FK)
-- =============================================
INSERT INTO Transmission VALUES (1, 'Manual');
INSERT INTO Transmission VALUES (2, 'Automatic');
INSERT INTO Transmission VALUES (3, 'CVT');
INSERT INTO Transmission VALUES (4, 'DCT');
INSERT INTO Transmission VALUES (5, 'AMT');

-- =============================================
-- 5. BODY_STYLE (no FK)
-- =============================================
INSERT INTO BodyStyle VALUES (1, 'Sedan');
INSERT INTO BodyStyle VALUES (2, 'SUV');
INSERT INTO BodyStyle VALUES (3, 'Hatchback');
INSERT INTO BodyStyle VALUES (4, 'Coupe');
INSERT INTO BodyStyle VALUES (5, 'Truck');
INSERT INTO BodyStyle VALUES (6, 'Wagon');
INSERT INTO BodyStyle VALUES (7, 'Convertible');
INSERT INTO BodyStyle VALUES (8, 'MPV');

-- =============================================
-- 6. SUPPLIER (no FK)
-- =============================================
INSERT INTO Supplier VALUES (1, 'Bosch', '9876543210', 'Stuttgart, Germany');
INSERT INTO Supplier VALUES (2, 'Denso', '8765432109', 'Aichi, Japan');
INSERT INTO Supplier VALUES (3, 'Magna', '7654321098', 'Ontario, Canada');
INSERT INTO Supplier VALUES (4, 'Continental', '6543210987', 'Hanover, Germany');
INSERT INTO Supplier VALUES (5, 'Aisin', '5432109876', 'Aichi, Japan');

-- =============================================
-- 7. PARTS (no FK)
-- =============================================
INSERT INTO Parts VALUES (1, 'Brake Pad', 'Braking System');
INSERT INTO Parts VALUES (2, 'Tyre', 'Wheel System');
INSERT INTO Parts VALUES (3, 'Airbag', 'Safety System');
INSERT INTO Parts VALUES (4, 'Alternator', 'Electrical System');
INSERT INTO Parts VALUES (5, 'Radiator', 'Cooling System');
INSERT INTO Parts VALUES (6, 'Shock Absorber', 'Suspension System');
INSERT INTO Parts VALUES (7, 'Fuel Injector', 'Fuel System');
INSERT INTO Parts VALUES (8, 'Clutch Plate', 'Transmission System');

-- =============================================
-- 8. PLANT (no FK)
-- =============================================
INSERT INTO Plant VALUES (1, 'Plant Alpha', 'Detroit, USA');
INSERT INTO Plant VALUES (2, 'Plant Beta', 'Toyota City, Japan');
INSERT INTO Plant VALUES (3, 'Plant Gamma', 'Wolfsburg, Germany');
INSERT INTO Plant VALUES (4, 'Plant Delta', 'Chennai, India');
INSERT INTO Plant VALUES (5, 'Plant Epsilon', 'Ulsan, South Korea');

-- =============================================
-- 9. BRAND (FK: company_id ? Company)
-- company_id 1=GM, 2=Toyota, 3=VW, 4=Ford, 5=Hyundai ?
-- =============================================
INSERT INTO Brand VALUES (1, 'Chevrolet', 1);
INSERT INTO Brand VALUES (2, 'Cadillac', 1);
INSERT INTO Brand VALUES (3, 'Toyota', 2);
INSERT INTO Brand VALUES (4, 'Lexus', 2);
INSERT INTO Brand VALUES (5, 'Volkswagen', 3);
INSERT INTO Brand VALUES (6, 'Audi', 3);
INSERT INTO Brand VALUES (7, 'Ford', 4);
INSERT INTO Brand VALUES (8, 'Hyundai', 5);

-- =============================================
-- 10. MODEL (FK: brand_id ? Brand, body_style_id ? Body_Style)
-- brand: 1=Chevrolet,2=Cadillac,3=Toyota,4=Lexus,5=VW,6=Audi,7=Ford,8=Hyundai ?
-- body_style: 1=Sedan,2=SUV,3=Hatchback,4=Coupe,5=Truck,6=Wagon,7=Convertible,8=MPV ?
-- =============================================
--ALTER TABLE Model
--ADD body_style_id INT;
--ALTER TABLE Model
--ADD CONSTRAINT fk_model_bodystyle
--FOREIGN KEY (body_style_id)
--REFERENCES Bodystyle(body_style_id);
--select * from model;
INSERT INTO Model VALUES (1, 'Camry', 3, 1);
INSERT INTO Model VALUES (2, 'Fortuner', 3, 2);
INSERT INTO Model VALUES (3, 'Corolla', 3, 1);
INSERT INTO Model VALUES (4, 'Innova', 3, 8);
INSERT INTO Model VALUES (5, 'Silverado', 1, 5);
INSERT INTO Model VALUES (6, 'Malibu', 1, 1);
INSERT INTO Model VALUES (7, 'Escalade', 2, 2);
INSERT INTO Model VALUES (8, 'Golf', 5, 3);
INSERT INTO Model VALUES (9, 'Tiguan', 5, 2);
INSERT INTO Model VALUES (10, 'Mustang', 7, 4);

-- =============================================
-- 11. DEALER (FK: brand_id ? Brand)
-- brand: 1=Chevrolet,2=Cadillac,3=Toyota,4=Lexus,5=VW,6=Audi,7=Ford,8=Hyundai ?
-- =============================================
INSERT INTO Dealer VALUES (1, 'GM World', 'New York, USA', '1112223333', 1);
INSERT INTO Dealer VALUES (2, 'Cadillac Elite', 'Los Angeles, USA', '2223334444', 2);
INSERT INTO Dealer VALUES (3, 'Toyota Hub', 'Chicago, USA', '3334445555', 3);
INSERT INTO Dealer VALUES (4, 'Lexus Lane', 'Houston, USA', '4445556666', 4);
INSERT INTO Dealer VALUES (5, 'VW Center', 'Berlin, Germany', '5556667777', 5);
INSERT INTO Dealer VALUES (6, 'Audi World', 'Munich, Germany', '6667778888', 6);
INSERT INTO Dealer VALUES (7, 'Ford Zone', 'Dallas, USA', '7778889999', 7);
INSERT INTO Dealer VALUES (8, 'Hyundai Hub', 'Seoul, South Korea', '8889990000', 8);

-- =============================================
-- 12. CUSTOMER (no FK)
-- =============================================
INSERT INTO Customer VALUES (1, 'John Smith', '123 Main St New York', '9998887777', 'Male', 75000.00);
INSERT INTO Customer VALUES (2, 'Sarah Johnson', '456 Oak Ave Chicago', '8887776666', 'Female', 92000.00);
INSERT INTO Customer VALUES (3, 'Mike Davis', '789 Pine Rd Houston', '7776665555', 'Male', 55000.00);
INSERT INTO Customer VALUES (4, 'Emily Brown', '321 Elm St Dallas', '6665554444', 'Female', 110000.00);
INSERT INTO Customer VALUES (5, 'Raj Patel', '654 Maple Dr Detroit', '5554443333', 'Male', 68000.00);
INSERT INTO Customer VALUES (6, 'Priya Singh', '987 Cedar Ln Los Angeles', '4443332222', 'Female', 85000.00);
INSERT INTO Customer VALUES (7, 'David Wilson', '147 Birch Blvd Berlin', '3332221111', 'Male', 95000.00);
INSERT INTO Customer VALUES (8, 'Lisa Anderson', '258 Walnut Way Munich', '2221110000', 'Female', 120000.00);
INSERT INTO Customer VALUES (9, 'James Taylor', '369 Spruce St Seoul', '1110009999', 'Male', 72000.00);
INSERT INTO Customer VALUES (10, 'Anna Martinez', '741 Poplar Ave Tokyo', '0009998888', 'Female', 88000.00);

-- =============================================
-- 13. MODEL_COLOUR (FK: model_id ? Model, colour_id ? Colours)
-- Models: 1=Camry,2=Fortuner,3=Corolla,8=Golf,10=Mustang ?
-- Colours: 1=Red,2=Blue,3=White,4=Black,5=Silver,6=Grey,7=Green ?
-- =============================================
-- Camry(1): Red(1), White(3), Black(4), Silver(5)
INSERT INTO Model_Colour VALUES (1, 1);
INSERT INTO Model_Colour VALUES (1, 3);
INSERT INTO Model_Colour VALUES (1, 4);
INSERT INTO Model_Colour VALUES (1, 5);
-- Fortuner(2): White(3), Black(4), Silver(5), Grey(6)
INSERT INTO Model_Colour VALUES (2, 3);
INSERT INTO Model_Colour VALUES (2, 4);
INSERT INTO Model_Colour VALUES (2, 5);
INSERT INTO Model_Colour VALUES (2, 6);
-- Corolla(3): Red(1), Blue(2), White(3), Black(4)
INSERT INTO Model_Colour VALUES (3, 1);
INSERT INTO Model_Colour VALUES (3, 2);
INSERT INTO Model_Colour VALUES (3, 3);
INSERT INTO Model_Colour VALUES (3, 4);
-- Innova(4): White(3), Silver(5), Grey(6), Brown(8)
INSERT INTO Model_Colour VALUES (4, 3);
INSERT INTO Model_Colour VALUES (4, 5);
INSERT INTO Model_Colour VALUES (4, 6);
INSERT INTO Model_Colour VALUES (4, 8);
-- Silverado(5): White(3), Black(4), Red(1), Grey(6)
INSERT INTO Model_Colour VALUES (5, 3);
INSERT INTO Model_Colour VALUES (5, 4);
INSERT INTO Model_Colour VALUES (5, 1);
INSERT INTO Model_Colour VALUES (5, 6);
-- Malibu(6): Red(1), Blue(2), Silver(5), Black(4)
INSERT INTO Model_Colour VALUES (6, 1);
INSERT INTO Model_Colour VALUES (6, 2);
INSERT INTO Model_Colour VALUES (6, 5);
INSERT INTO Model_Colour VALUES (6, 4);
-- Escalade(7): Black(4), White(3), Silver(5), Grey(6)
INSERT INTO Model_Colour VALUES (7, 4);
INSERT INTO Model_Colour VALUES (7, 3);
INSERT INTO Model_Colour VALUES (7, 5);
INSERT INTO Model_Colour VALUES (7, 6);
-- Golf(8): Blue(2), White(3), Grey(6), Green(7)
INSERT INTO Model_Colour VALUES (8, 2);
INSERT INTO Model_Colour VALUES (8, 3);
INSERT INTO Model_Colour VALUES (8, 6);
INSERT INTO Model_Colour VALUES (8, 7);
-- Tiguan(9): White(3), Black(4), Blue(2), Silver(5)
INSERT INTO Model_Colour VALUES (9, 3);
INSERT INTO Model_Colour VALUES (9, 4);
INSERT INTO Model_Colour VALUES (9, 2);
INSERT INTO Model_Colour VALUES (9, 5);
-- Mustang(10): Red(1), Black(4), White(3), Blue(2)
INSERT INTO Model_Colour VALUES (10, 1);
INSERT INTO Model_Colour VALUES (10, 4);
INSERT INTO Model_Colour VALUES (10, 3);
INSERT INTO Model_Colour VALUES (10, 2);

-- =============================================
-- 14. MODEL_ENGINE (FK: model_id ? Model, engine_id ? Engine)
-- Engines: 1=I4 1.5P, 2=I4 2.0P, 3=V6 3.5P, 4=I4 2.0D, 5=Electric
--          6=I4 1.5H, 7=V8 5.0P, 8=I4 1.2CNG ?
-- =============================================
-- Camry(1): I4 1.5P(1), I4 2.0P(2), Hybrid(6)
INSERT INTO Model_Engine VALUES (1, 1);
INSERT INTO Model_Engine VALUES (1, 2);
INSERT INTO Model_Engine VALUES (1, 6);
-- Fortuner(2): Diesel(4), V6(3)
INSERT INTO Model_Engine VALUES (2, 4);
INSERT INTO Model_Engine VALUES (2, 3);
-- Corolla(3): I4 1.5P(1), Hybrid(6)
INSERT INTO Model_Engine VALUES (3, 1);
INSERT INTO Model_Engine VALUES (3, 6);
-- Innova(4): Diesel(4), I4 2.0P(2)
INSERT INTO Model_Engine VALUES (4, 4);
INSERT INTO Model_Engine VALUES (4, 2);
-- Silverado(5): V8(7), V6(3)
INSERT INTO Model_Engine VALUES (5, 7);
INSERT INTO Model_Engine VALUES (5, 3);
-- Malibu(6): I4 1.5P(1), I4 2.0P(2)
INSERT INTO Model_Engine VALUES (6, 1);
INSERT INTO Model_Engine VALUES (6, 2);
-- Escalade(7): V8(7), V6(3)
INSERT INTO Model_Engine VALUES (7, 7);
INSERT INTO Model_Engine VALUES (7, 3);
-- Golf(8): I4 1.5P(1), Diesel(4)
INSERT INTO Model_Engine VALUES (8, 1);
INSERT INTO Model_Engine VALUES (8, 4);
-- Tiguan(9): I4 2.0P(2), Diesel(4)
INSERT INTO Model_Engine VALUES (9, 2);
INSERT INTO Model_Engine VALUES (9, 4);
-- Mustang(10): V8(7)
INSERT INTO Model_Engine VALUES (10, 7);

-- =============================================
-- 15. MODEL_TRANSMISSION (FK: model_id ? Model, transmission_id ? Transmission)
-- Transmissions: 1=Manual, 2=Automatic, 3=CVT, 4=DCT, 5=AMT ?
-- =============================================
-- Camry(1): Automatic(2), CVT(3)
INSERT INTO Model_Transmission VALUES (1, 2);
INSERT INTO Model_Transmission VALUES (1, 3);
-- Fortuner(2): Manual(1), Automatic(2)
INSERT INTO Model_Transmission VALUES (2, 1);
INSERT INTO Model_Transmission VALUES (2, 2);
-- Corolla(3): Manual(1), Automatic(2), CVT(3)
INSERT INTO Model_Transmission VALUES (3, 1);
INSERT INTO Model_Transmission VALUES (3, 2);
INSERT INTO Model_Transmission VALUES (3, 3);
-- Innova(4): Manual(1), Automatic(2)
INSERT INTO Model_Transmission VALUES (4, 1);
INSERT INTO Model_Transmission VALUES (4, 2);
-- Silverado(5): Manual(1), Automatic(2)
INSERT INTO Model_Transmission VALUES (5, 1);
INSERT INTO Model_Transmission VALUES (5, 2);
-- Malibu(6): Automatic(2), CVT(3)
INSERT INTO Model_Transmission VALUES (6, 2);
INSERT INTO Model_Transmission VALUES (6, 3);
-- Escalade(7): Automatic(2)
INSERT INTO Model_Transmission VALUES (7, 2);
-- Golf(8): Manual(1), DCT(4)
INSERT INTO Model_Transmission VALUES (8, 1);
INSERT INTO Model_Transmission VALUES (8, 4);
-- Tiguan(9): Automatic(2), DCT(4)
INSERT INTO Model_Transmission VALUES (9, 2);
INSERT INTO Model_Transmission VALUES (9, 4);
-- Mustang(10): Manual(1), Automatic(2)
INSERT INTO Model_Transmission VALUES (10, 1);
INSERT INTO Model_Transmission VALUES (10, 2);

-- =============================================
-- 16. MODEL_PARTS (FK: model_id ? Model, part_id ? Parts)
-- Parts: 1=Brake Pad,2=Tyre,3=Airbag,4=Alternator
--        5=Radiator,6=Shock Absorber,7=Fuel Injector,8=Clutch Plate ?
-- =============================================
INSERT INTO Model_Parts VALUES (1, 1);
INSERT INTO Model_Parts VALUES (1, 2);
INSERT INTO Model_Parts VALUES (1, 3);
INSERT INTO Model_Parts VALUES (1, 5);
INSERT INTO Model_Parts VALUES (2, 1);
INSERT INTO Model_Parts VALUES (2, 2);
INSERT INTO Model_Parts VALUES (2, 5);
INSERT INTO Model_Parts VALUES (2, 6);
INSERT INTO Model_Parts VALUES (3, 1);
INSERT INTO Model_Parts VALUES (3, 3);
INSERT INTO Model_Parts VALUES (3, 7);
INSERT INTO Model_Parts VALUES (4, 1);
INSERT INTO Model_Parts VALUES (4, 2);
INSERT INTO Model_Parts VALUES (4, 8);
INSERT INTO Model_Parts VALUES (5, 1);
INSERT INTO Model_Parts VALUES (5, 7);
INSERT INTO Model_Parts VALUES (6, 1);
INSERT INTO Model_Parts VALUES (6, 3);
INSERT INTO Model_Parts VALUES (7, 1);
INSERT INTO Model_Parts VALUES (7, 5);
INSERT INTO Model_Parts VALUES (8, 1);
INSERT INTO Model_Parts VALUES (8, 6);
INSERT INTO Model_Parts VALUES (9, 1);
INSERT INTO Model_Parts VALUES (9, 2);
INSERT INTO Model_Parts VALUES (10, 1);
INSERT INTO Model_Parts VALUES (10, 7);

-- =============================================
-- 17. VEHICLE
-- FK checks:
-- (model_id, colour_id) must exist in Model_Colour ?
-- (model_id, engine_id) must exist in Model_Engine ?
-- (model_id, transmission_id) must exist in Model_Transmission ?
-- dealer_id must exist in Dealer ?
-- plant_id must exist in Plant ?
-- FORMAT: VIN, model_id, colour_id, engine_id, transmission_id, dealer_id, plant_id
-- =============================================
-- Camry(1) Red(1) I4 1.5P(1) Automatic(2) Toyota Hub(3) Plant Beta(2)
-- Check: (1,1)?Colour (1,1)?Engine (1,2)?Trans dealer3? plant2?
INSERT INTO Vehicle VALUES ('VIN00000000000001', 1, 1, 1, 2, 3, 2);

-- Camry(1) White(3) I4 2.0P(2) CVT(3) Toyota Hub(3) Plant Beta(2)
-- Check: (1,3)?Colour (1,2)?Engine (1,3)?Trans dealer3? plant2?
INSERT INTO Vehicle VALUES ('VIN00000000000002', 1, 3, 2, 3, 3, 2);

-- Fortuner(2) White(3) Diesel(4) Manual(1) Toyota Hub(3) Plant Beta(2)
-- Check: (2,3)?Colour (2,4)?Engine (2,1)?Trans dealer3? plant2?
INSERT INTO Vehicle VALUES ('VIN00000000000003', 2, 3, 4, 1, 3, 2);

-- Fortuner(2) Black(4) V6(3) Automatic(2) Toyota Hub(3) Plant Beta(2)
-- Check: (2,4)?Colour (2,3)?Engine (2,2)?Trans dealer3? plant2?
INSERT INTO Vehicle VALUES ('VIN00000000000004', 2, 4, 3, 2, 3, 2);

-- Corolla(3) Red(1) I4 1.5P(1) Manual(1) Toyota Hub(3) Plant Delta(4)
-- Check: (3,1)?Colour (3,1)?Engine (3,1)?Trans dealer3? plant4?
INSERT INTO Vehicle VALUES ('VIN00000000000005', 3, 1, 1, 1, 3, 4);

-- Corolla(3) Blue(2) Hybrid(6) CVT(3) Toyota Hub(3) Plant Delta(4)
-- Check: (3,2)?Colour (3,6)?Engine (3,3)?Trans dealer3? plant4?
INSERT INTO Vehicle VALUES ('VIN00000000000006', 3, 2, 6, 3, 3, 4);

-- Golf(8) Blue(2) I4 1.5P(1) Manual(1) VW Center(5) Plant Gamma(3)
-- Check: (8,2)?Colour (8,1)?Engine (8,1)?Trans dealer5? plant3?
INSERT INTO Vehicle VALUES ('VIN00000000000007', 8, 2, 1, 1, 5, 3);

-- Golf(8) Grey(6) Diesel(4) DCT(4) VW Center(5) Plant Gamma(3)
-- Check: (8,6)?Colour (8,4)?Engine (8,4)?Trans dealer5? plant3?
INSERT INTO Vehicle VALUES ('VIN00000000000008', 8, 6, 4, 4, 5, 3);

-- Mustang(10) Red(1) V8(7) Manual(1) Ford Zone(7) Plant Alpha(1)
-- Check: (10,1)?Colour (10,7)?Engine (10,1)?Trans dealer7? plant1?
INSERT INTO Vehicle VALUES ('VIN00000000000009', 10, 1, 7, 1, 7, 1);

-- Mustang(10) Black(4) V8(7) Automatic(2) Ford Zone(7) Plant Alpha(1)
-- Check: (10,4)?Colour (10,7)?Engine (10,2)?Trans dealer7? plant1?
INSERT INTO Vehicle VALUES ('VIN00000000000010', 10, 4, 7, 2, 7, 1);

-- =============================================
-- 18. SERIALIZING_PART
-- FK: part_id?Parts, supplier_id?Supplier, VIN?Vehicle ?
-- FORMAT: serial_id, part_id, supplier_id, VIN, batch_no, manufacture_date
-- =============================================
--ALTER TABLE Serializing_Part
--ADD VIN VARCHAR2(17);
--ALTER TABLE Serializing_Part
--ADD CONSTRAINT fk_serial_vin
--FOREIGN KEY (VIN)
--REFERENCES Vehicle(VIN);
INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (1, 1, 1, 'BATCH-BP-001', TO_DATE('2024-01-10','YYYY-MM-DD'), 'VIN00000000000001');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (2, 2, 2, 'BATCH-TY-001', TO_DATE('2024-01-10','YYYY-MM-DD'), 'VIN00000000000001');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (3, 3, 1, 'BATCH-AB-001', TO_DATE('2024-01-15','YYYY-MM-DD'), 'VIN00000000000002');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (4, 1, 3, 'BATCH-BP-002', TO_DATE('2024-02-01','YYYY-MM-DD'), 'VIN00000000000003');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (5, 5, 2, 'BATCH-RD-001', TO_DATE('2024-02-10','YYYY-MM-DD'), 'VIN00000000000004');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (6, 6, 4, 'BATCH-SA-001', TO_DATE('2024-02-15','YYYY-MM-DD'), 'VIN00000000000005');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (7, 7, 5, 'BATCH-FI-001', TO_DATE('2024-03-01','YYYY-MM-DD'), 'VIN00000000000006');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (8, 3, 1, 'BATCH-AB-002', TO_DATE('2024-03-10','YYYY-MM-DD'), 'VIN00000000000007');

INSERT INTO Serializing_Part 
(serial_id, part_id, supplier_id, batch_no, manufacture_date, VIN)
VALUES (9, 1, 2, 'BATCH-BP-003', TO_DATE('2024-03-15','YYYY-MM-DD'), 'VIN00000000000008');INSERT INTO Serializing_Part VALUES (10, 7, 3, 'VIN00000000000009', 'BATCH-FI-002', TO_DATE('2024-04-01', 'YYYY-MM-DD'));
select * from serializing_part;
-- =============================================
-- 19. SOLD_VEHICLE
-- FK: VIN?Vehicle, customer_id?Customer ?
-- VIN must be UNIQUE (one vehicle sold only once) ?
-- FORMAT: sold_id, VIN, customer_id, sale_date, sale_price
-- =============================================
INSERT INTO Sold_Vehicle VALUES (1, 'VIN00000000000001', 1, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 25000.00);
INSERT INTO Sold_Vehicle VALUES (2, 'VIN00000000000003', 2, TO_DATE('2024-03-15', 'YYYY-MM-DD'), 45000.00);
INSERT INTO Sold_Vehicle VALUES (3, 'VIN00000000000005', 3, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 18000.00);
INSERT INTO Sold_Vehicle VALUES (4, 'VIN00000000000007', 4, TO_DATE('2024-04-20', 'YYYY-MM-DD'), 22000.00);
INSERT INTO Sold_Vehicle VALUES (5, 'VIN00000000000009', 5, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 55000.00);

COMMIT;
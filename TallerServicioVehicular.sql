-- ====================================================================
-- CREACIÓN DE BASE DE DATOS: TallerServicioVehicular
-- ====================================================================
CREATE DATABASE TallerServicioVehicular;
GO

USE TallerServicioVehicular;
GO

-- 1. TABLA EMPLEADO
CREATE TABLE EMPLEADO (
    empleado_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL,
    cargo VARCHAR(50) NOT NULL
);
GO

-- 2. TABLA USUARIO (Login)
CREATE TABLE USUARIO (
    usuario_id INT IDENTITY(1,1) PRIMARY KEY,
    empleado_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- Idealmente hasheada en el backend
    rol VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Usuario_Empleado FOREIGN KEY (empleado_id) REFERENCES EMPLEADO(empleado_id)
);
GO

-- 3. TABLA CLIENTE
CREATE TABLE CLIENTE (
    cliente_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono_movil VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    fecha_registro DATE DEFAULT GETDATE()
);
GO


-- 4. TABLA VEHICULO (Relacionada con el Cliente)
CREATE TABLE VEHICULO (
    vehiculo_id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    patente VARCHAR(20) UNIQUE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    nro_chasis VARCHAR(50),
    nro_motor VARCHAR(50),
    CONSTRAINT FK_Vehiculo_Cliente FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id)
);
GO

-- 5. TABLA SERVICIO (Orden general de ingreso)
CREATE TABLE SERVICIO (
    servicio_id INT IDENTITY(1,1) PRIMARY KEY,
    vehiculo_id INT NOT NULL,
    fecha_servicios DATE DEFAULT GETDATE(),
    odometro INT NOT NULL,
    descripcion_general TEXT NOT NULL,
    costo_total DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT FK_Servicio_Vehiculo FOREIGN KEY (vehiculo_id) REFERENCES VEHICULO(vehiculo_id)
);
GO



-- 6. TABLA DIAGNOSTICO
CREATE TABLE DIAGNOSTICO (
    diagnostico_id INT IDENTITY(1,1) PRIMARY KEY,
    servicio_id INT NOT NULL,
    fecha_diagnostico DATE DEFAULT GETDATE(),
    detalle_falla TEXT NOT NULL,
    estado_general_vehiculo VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Diagnostico_Servicio FOREIGN KEY (servicio_id) REFERENCES SERVICIO(servicio_id)
);
GO


-- 7. TABLA REPARACION (Asignada al Empleado/Técnico)
CREATE TABLE REPARACION (
    reparacion_id INT IDENTITY(1,1) PRIMARY KEY,
    servicio_id INT NOT NULL,
    empleado_id INT NOT NULL, -- Técnico encargado
    fecha_reparacion DATE DEFAULT GETDATE(),
    tipo_reparacion VARCHAR(100) NOT NULL,
    observaciones_tecnico TEXT,
    costo_mano_obra DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Reparacion_Servicio FOREIGN KEY (servicio_id) REFERENCES SERVICIO(servicio_id),
    CONSTRAINT FK_Reparacion_Empleado FOREIGN KEY (empleado_id) REFERENCES EMPLEADO(empleado_id)
);
GO



-- 8. TABLA PIEZA (Inventario de repuestos)
CREATE TABLE PIEZA (
    pieza_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_pieza VARCHAR(100) NOT NULL,
    descripcion_pieza TEXT,
    codigo_fabrica VARCHAR(50) UNIQUE NOT NULL,
    precio_costo DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL
);
GO




-- 9. TABLA DETALLE_PIEZAS (Relación muchos a muchos entre Reparación y Pieza)
CREATE TABLE DETALLE_PIEZAS (
    detalle_id INT IDENTITY(1,1) PRIMARY KEY,
    reparacion_id INT NOT NULL,
    pieza_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Detalle_Reparacion FOREIGN KEY (reparacion_id) REFERENCES REPARACION(reparacion_id),
    CONSTRAINT FK_Detalle_Pieza FOREIGN KEY (pieza_id) REFERENCES PIEZA(pieza_id)
);
GO



select * from DETALLE_PIEZAS




-- 1. EMPLEADOS (5 registros con tus datos exactos)
INSERT INTO EMPLEADO (nombre, direccion, telefono, sueldo, cargo) VALUES
('Wilfredo Antonio Gonzalez Valle', 'San Salvador, El Salvador', '7111-2222', 1500.00, 'Director General'),
('Hector Abel Tejada Ayala', 'La Libertad, El Salvador', '7222-3333', 1100.00, 'Supervisor De Mecanica'),
('Jefferson Benjamin Merino Palacios', 'San Salvador, El Salvador', '7333-4444', 850.00, 'Mecanico'),
('Carlos Emanuel Reyes Maldonado', 'Soyapango, El Salvador', '7444-5555', 850.00, 'Mecanico'),
('Daniela De Los Angeles Alvarez Alas', 'Santa Tecla, El Salvador', '7555-6666', 700.00, 'Recepcionista');
GO

-- 2. USUARIOS / LOGIN (5 registros vinculados a cada empleado)
INSERT INTO USUARIO (empleado_id, username, password, rol) VALUES
(1, 'wgonzalez', 'Admin2026*', 'Administrador'),
(2, 'htejada', 'Super2026#', 'Supervisor'),
(3, 'jmerino', 'Mecanico3$', 'Mecanico'),
(4, 'creyes', 'Mecanico4$', 'Mecanico'),
(5, 'dalvarez', 'Recepcion26', 'Recepcionista');
GO

-- 3. CLIENTES (10 registros)
INSERT INTO CLIENTE (nombre, apellido, telefono_movil, email) VALUES
('Juan', 'Perez', '7000-1111', 'juan.perez@gmail.com'),
('Maria', 'Gomez', '7000-2222', 'maria.gomez@yahoo.com'),
('Carlos', 'Lopez', '7000-3333', 'carlos.lopez@outlook.com'),
('Ana', 'Martinez', '7000-4444', 'ana.martinez@gmail.com'),
('Luis', 'Hernandez', '7000-5555', 'luis.h@gmail.com'),
('Sofia', 'Ramirez', '7000-6666', 'sofia.r@hotmail.com'),
('Jorge', 'Torres', '7000-7777', 'jorge.t@gmail.com'),
('Lucia', 'Flores', '7000-8888', 'lucia.f@yahoo.com'),
('Miguel', 'Castillo', '7000-9999', 'miguel.c@gmail.com'),
('Elena', 'Vargas', '7001-0000', 'elena.v@outlook.com');
GO

-- 4. VEHICULOS (10 registros)
INSERT INTO VEHICULO (cliente_id, patente, marca, modelo, anio, nro_chasis, nro_motor) VALUES
(1, 'P-123456', 'Toyota', 'Corolla', 2018, 'CHS123456789', 'MOT987654321'),
(2, 'P-654321', 'Honda', 'Civic', 2020, 'CHS987654321', 'MOT123456789'),
(3, 'P-789012', 'Nissan', 'Sentra', 2017, 'CHS456789123', 'MOT321654987'),
(4, 'P-345678', 'Mazda', '3', 2019, 'CHS789123456', 'MOT654987321'),
(5, 'P-901234', 'Hyundai', 'Elantra', 2021, 'CHS321654987', 'MOT789123456'),
(6, 'P-112233', 'Kia', 'Rio', 2016, 'CHS111222333', 'MOT333222111'),
(7, 'P-445566', 'Ford', 'Escape', 2018, 'CHS444555666', 'MOT666555444'),
(8, 'P-778899', 'Chevrolet', 'Cruze', 2019, 'CHS777888999', 'MOT999888777'),
(9, 'P-990011', 'Volkswagen', 'Jetta', 2020, 'CHS000111222', 'MOT222111000'),
(10, 'P-556677', 'Subaru', 'Impreza', 2022, 'CHS555666777', 'MOT777666555');
GO

-- 5. SERVICIOS (10 registros)
INSERT INTO SERVICIO (vehiculo_id, odometro, descripcion_general, costo_total) VALUES
(1, 45000, 'Mantenimiento general y cambio de frenos', 150.00),
(2, 32000, 'Revision por ruido extraño en motor', 80.00),
(3, 78000, 'Cambio de aceite y filtro de aire', 45.00),
(4, 15000, 'Revision de sistema electrico', 60.00),
(5, 50000, 'Cambio de kit de embrague', 250.00),
(6, 62000, 'Reparacion de suspencion delantera', 180.00),
(7, 41000, 'Cambio de bujias y cables', 90.00),
(8, 89000, 'Revision de sistema de enfriamiento', 110.00),
(9, 23000, 'Mantenimiento preventivo de 20 mil km', 100.00),
(10, 12000, 'Revision de frenos traseros', 75.00);
GO

-- 6. DIAGNOSTICOS (10 registros)
INSERT INTO DIAGNOSTICO (servicio_id, detalle_falla, estado_general_vehiculo) VALUES
(1, 'Desgaste severo en pastillas de freno delanteras', 'Regular'),
(2, 'Fuga menor de aceite en empaque de tapa de valvulas', 'Bueno'),
(3, 'Filtro de aire obstruido por acumulacion de polvo', 'Bueno'),
(4, 'Falso contacto en arnes de luces principales', 'Regular'),
(5, 'Disco de embrague quemado por uso', 'Malo'),
(6, 'Amortiguadores delanteros con fuga de aceite', 'Regular'),
(7, 'Bujias carbonizadas generando jaloneos', 'Regular'),
(8, 'Termostato trabado provocando calentamiento', 'Malo'),
(9, 'Desgaste normal, requiere solo fluidos nuevos', 'Excelente'),
(10, 'Cintas de freno traseras al 20 por ciento de vida', 'Regular');
GO

-- 7. REPARACIONES (10 registros vinculados a los empleados/mecánicos)
INSERT INTO REPARACION (servicio_id, empleado_id, tipo_reparacion, observaciones_tecnico, costo_mano_obra) VALUES
(1, 3, 'Cambio de Frenos', 'Se reemplazaron pastillas y se rectificaron discos', 50.00),
(2, 4, 'Sellado de Motor', 'Cambio de empaque y limpieza de area', 40.00),
(3, 3, 'Mantenimiento Basico', 'Sustitucion de aceite sintetico y filtros', 20.00),
(4, 4, 'Reparacion Electrica', 'Se soldo cableado dañado y se aisló', 35.00),
(5, 3, 'Cambio de Embriague', 'Sustitucion completa del kit de clutch', 120.00),
(6, 4, 'Cambio de Suspension', 'Instalacion de amortiguadores nuevos', 90.00),
(7, 3, 'Sintonizacion', 'Cambio de bujias de iridio', 30.00),
(8, 4, 'Sistema de Enfriamiento', 'Cambio de termostato y refrigerante', 45.00),
(9, 3, 'Servicio General', 'Inspeccion de puntos clave de seguridad', 40.00),
(10, 4, 'Frenos Traseros', 'Reemplazo de zapatas y ajuste de freno de mano', 35.00);
GO

-- 8. PIEZAS (10 registros)
INSERT INTO PIEZA (nombre_pieza, descripcion_pieza, codigo_fabrica, precio_costo, stock_actual) VALUES
('Pastillas de Freno', 'Juego de pastillas delanteras ceramicas', 'PST-001', 35.00, 15),
('Aceite Sintetico 5W30', 'Galon de aceite para motor de alta gama', 'ACE-002', 25.00, 30),
('Filtro de Aire', 'Filtro de aire de alta durabilidad', 'FLT-003', 12.00, 20),
('Kit de Embrague', 'Disco, plato y collarin', 'CLT-004', 110.00, 5),
('Amortiguador Delantero', 'Amortiguador hidraulico por unidad', 'AMR-005', 45.00, 8),
('Bujias de Iridio', 'Paquete de 4 bujias de alto rendimiento', 'BUJ-006', 20.00, 25),
('Termostato', 'Valvula de control de temperatura', 'TRM-007', 18.00, 12),
('Liquido de Frenos', 'Botella de liquido DOT 4', 'LQF-008', 8.00, 40),
('Empaque de Valvulas', 'Junta de hule resistente a altas temperaturas', 'EMP-009', 15.00, 10),
('Zapatas de Freno', 'Juego de balatas traseras', 'ZPT-010', 22.00, 14);
GO

-- 9. DETALLE_PIEZAS (10 registros cruzando reparaciones y piezas)
INSERT INTO DETALLE_PIEZAS (reparacion_id, pieza_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 45.00),
(2, 9, 1, 20.00),
(3, 2, 1, 35.00),
(4, 8, 1, 12.00),
(5, 4, 1, 130.00),
(6, 5, 2, 55.00),
(7, 6, 1, 25.00),
(8, 7, 1, 22.00),
(9, 3, 1, 15.00),
(10, 10, 1, 28.00);
GO
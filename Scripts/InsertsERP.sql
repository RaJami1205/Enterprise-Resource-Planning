-- Inserts para la tabla Departamento
INSERT INTO Departamento (departamento_id, nombre) VALUES (1, 'Recursos Humanos');
INSERT INTO Departamento (departamento_id, nombre) VALUES (2, 'Finanzas');
INSERT INTO Departamento (departamento_id, nombre) VALUES (3, 'Tecnología de la Información');
INSERT INTO Departamento (departamento_id, nombre) VALUES (4, 'Ventas');
INSERT INTO Departamento (departamento_id, nombre) VALUES (5, 'Marketing');
INSERT INTO Departamento (departamento_id, nombre) VALUES (6, 'Producción');
INSERT INTO Departamento (departamento_id, nombre) VALUES (7, 'Investigación y Desarrollo');
INSERT INTO Departamento (departamento_id, nombre) VALUES (8, 'Logística');
INSERT INTO Departamento (departamento_id, nombre) VALUES (9, 'Compras');
INSERT INTO Departamento (departamento_id, nombre) VALUES (10, 'Atención al Cliente');
INSERT INTO Departamento (departamento_id, nombre) VALUES (11, 'Calidad');
INSERT INTO Departamento (departamento_id, nombre) VALUES (12, 'Legal');
INSERT INTO Departamento (departamento_id, nombre) VALUES (13, 'Relaciones Públicas');
INSERT INTO Departamento (departamento_id, nombre) VALUES (14, 'Soporte Técnico');
INSERT INTO Departamento (departamento_id, nombre) VALUES (15, 'Seguridad');
INSERT INTO Departamento (departamento_id, nombre) VALUES (16, 'Mantenimiento');
INSERT INTO Departamento (departamento_id, nombre) VALUES (17, 'Operaciones');
INSERT INTO Departamento (departamento_id, nombre) VALUES (18, 'Gestión Ambiental');
INSERT INTO Departamento (departamento_id, nombre) VALUES (19, 'Innovación');
INSERT INTO Departamento (departamento_id, nombre) VALUES (20, 'Desarrollo Organizacional');

-- Inserts para la tabla Puesto
INSERT INTO Puesto (puesto_id, puesto) VALUES (1, 'Gerente General');
INSERT INTO Puesto (puesto_id, puesto) VALUES (2, 'Analista Financiero');
INSERT INTO Puesto (puesto_id, puesto) VALUES (3, 'Ingeniero de Software');
INSERT INTO Puesto (puesto_id, puesto) VALUES (4, 'Vendedor');
INSERT INTO Puesto (puesto_id, puesto) VALUES (5, 'Diseñador Gráfico');
INSERT INTO Puesto (puesto_id, puesto) VALUES (6, 'Operador de Producción');
INSERT INTO Puesto (puesto_id, puesto) VALUES (7, 'Jefe de Logística');
INSERT INTO Puesto (puesto_id, puesto) VALUES (8, 'Comprador Senior');
INSERT INTO Puesto (puesto_id, puesto) VALUES (9, 'Asistente de Atención al Cliente');
INSERT INTO Puesto (puesto_id, puesto) VALUES (10, 'Investigador Científico');
INSERT INTO Puesto (puesto_id, puesto) VALUES (11, 'Administrador de Redes');
INSERT INTO Puesto (puesto_id, puesto) VALUES (12, 'Abogado Corporativo');
INSERT INTO Puesto (puesto_id, puesto) VALUES (13, 'Consultor de Marketing');
INSERT INTO Puesto (puesto_id, puesto) VALUES (14, 'Jefe de Producción');
INSERT INTO Puesto (puesto_id, puesto) VALUES (15, 'Especialista en Recursos Humanos');
INSERT INTO Puesto (puesto_id, puesto) VALUES (16, 'Coordinador de Mantenimiento');
INSERT INTO Puesto (puesto_id, puesto) VALUES (17, 'Analista de Datos');
INSERT INTO Puesto (puesto_id, puesto) VALUES (18, 'Ingeniero de Control de Calidad');
INSERT INTO Puesto (puesto_id, puesto) VALUES (19, 'Auditor Interno');
INSERT INTO Puesto (puesto_id, puesto) VALUES (20, 'Gerente de Innovación');

INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (1, 'Pendiente');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (2, 'Pagada');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (3, 'Cancelada');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (4, 'En proceso');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (5, 'Reembolsada');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (6, 'Parcialmente pagada');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (7, 'Vencida');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (8, 'En disputa');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (9, 'Aprobada');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (10, 'Rechazada');
INSERT INTO EstadoFactura (estadofactura_id, nombre) VALUES (11, 'Anulada');



-- Inserts para la tabla Familia
INSERT INTO Familia (codigo, nombre, activo, descripcion) 
VALUES 
(1, 'Electrónica', 'Activo', 'Dispositivos electrónicos'),
(2, 'Muebles', 'Activo', 'Mobiliario para el hogar y la oficina'),
(3, 'Alimentos', 'Activo', 'Productos alimenticios procesados'),
(4, 'Ropa', 'Activo', 'Vestimenta para todas las edades'),
(5, 'Juguetes', 'Activo', 'Juguetes educativos para niños'),
(6, 'Herramientas', 'Activo', 'Herramientas para uso doméstico e industrial'),
(7, 'Deportes', 'Activo', 'Equipos deportivos y accesorios'),
(8, 'Libros', 'Activo', 'Libros de todas las categorías'),
(9, 'Accesorios', 'Activo', 'Accesorios y complementos de moda'),
(10, 'Jardinería', 'Activo', 'Herramientas y accesorios para jardinería'),
(11, 'Electrodomésticos', 'Activo', 'Electrodomésticos para el hogar'),
(12, 'Oficina', 'Activo', 'Artículos de oficina y papelería'),
(13, 'Belleza', 'Activo', 'Productos de belleza y cuidado personal'),
(14, 'Salud', 'Activo', 'Equipos médicos y productos de salud'),
(15, 'Limpieza', 'Activo', 'Productos de limpieza para el hogar y la oficina'),
(16, 'Automóviles', 'Activo', 'Accesorios y repuestos para automóviles'),
(17, 'Bebés', 'Activo', 'Productos para el cuidado de bebés'),
(18, 'Mascotas', 'Activo', 'Productos y alimentos para mascotas'),
(19, 'Joyería', 'Activo', 'Joyería y relojería'),
(20, 'Música', 'Activo', 'Instrumentos musicales y accesorios'),
(21, 'Cine', 'Activo', 'Accesorios para entretenimiento y cine en casa'),
(22, 'Videojuegos', 'Activo', 'Consolas y juegos de video'),
(23, 'Cocina', 'Activo', 'Utensilios y accesorios de cocina'),
(24, 'Iluminación', 'Activo', 'Lámparas y sistemas de iluminación'),
(25, 'Pintura', 'Activo', 'Pinturas y accesorios para decoración');

-- Inserts para la tabla Articulo
INSERT INTO Articulo (codigo, nombre, cantidad, activo, descripcion, peso, costo, precio_estandar, codigo_familia) 
VALUES 
(1, 'Laptop', 50, 'Activo', 'Laptop de 15 pulgadas', 2.5, 800.00, 1200.00, 1),
(2, 'Sofá', 20, 'Activo', 'Sofá de cuero de 3 plazas', 35.0, 400.00, 700.00, 2),
(3, 'Televisor', 30, 'Activo', 'Televisor 4K de 50 pulgadas', 15.0, 300.00, 500.00, 1),
(4, 'Mesa de comedor', 15, 'Activo', 'Mesa de comedor de madera', 45.0, 200.00, 400.00, 2),
(5, 'Camiseta', 100, 'Activo', 'Camiseta de algodón', 0.2, 5.00, 15.00, 4),
(6, 'Taladro', 60, 'Activo', 'Taladro eléctrico', 4.5, 50.00, 90.00, 6),
(7, 'Bicicleta', 25, 'Activo', 'Bicicleta de montaña', 12.0, 150.00, 300.00, 7),
(8, 'Libro de ciencia ficción', 80, 'Activo', 'Novela de ciencia ficción', 0.5, 10.00, 20.00, 8),
(9, 'Bolso', 40, 'Activo', 'Bolso de cuero', 1.5, 50.00, 120.00, 9),
(10, 'Sierra eléctrica', 20, 'Activo', 'Sierra eléctrica para madera', 7.0, 100.00, 200.00, 6),
(11, 'Auriculares', 70, 'Activo', 'Auriculares inalámbricos', 0.3, 30.00, 60.00, 1),
(12, 'Zapatos deportivos', 55, 'Activo', 'Zapatos deportivos de hombre', 0.8, 25.00, 50.00, 4),
(13, 'Tablet', 40, 'Activo', 'Tablet de 10 pulgadas', 1.0, 250.00, 450.00, 1),
(14, 'Cama', 10, 'Activo', 'Cama king size de madera', 80.0, 300.00, 600.00, 2),
(15, 'Chaqueta', 90, 'Activo', 'Chaqueta impermeable', 0.7, 40.00, 90.00, 4),
(16, 'Taladro industrial', 35, 'Activo', 'Taladro industrial de alto rendimiento', 5.5, 100.00, 200.00, 6),
(17, 'Balón de fútbol', 120, 'Activo', 'Balón de fútbol oficial', 0.4, 20.00, 50.00, 7),
(18, 'Novela de romance', 85, 'Activo', 'Novela de romance contemporáneo', 0.6, 8.00, 15.00, 8),
(19, 'Gafas de sol', 65, 'Activo', 'Gafas de sol polarizadas', 0.2, 15.00, 40.00, 9),
(20, 'Martillo', 75, 'Activo', 'Martillo de acero', 1.2, 10.00, 25.00, 6),
(21, 'Cámara digital', 15, 'Activo', 'Cámara digital de 20MP', 0.6, 400.00, 650.00, 1),
(22, 'Silla de oficina', 30, 'Activo', 'Silla de oficina ergonómica', 10.0, 100.00, 180.00, 2),
(23, 'Pelota de tenis', 150, 'Activo', 'Pelota de tenis profesional', 0.1, 2.00, 5.00, 7),
(24, 'Mochila', 60, 'Activo', 'Mochila resistente al agua', 1.0, 25.00, 60.00, 9),
(25, 'Llave inglesa', 45, 'Activo', 'Llave inglesa ajustable', 1.5, 15.00, 35.00, 6);

-- Inserts para la tabla Bodega
INSERT INTO Bodega (codigo_bodega, numero, ubicacion, capacidad, espacio_cubico)
VALUES 
(1, 1001, 'San José', 500, 1000.00),
(2, 1002, 'Alajuela', 300, 600.00),
(3, 1003, 'Cartago', 400, 800.00),
(4, 1004, 'Heredia', 600, 1200.00),
(5, 1005, 'Puntarenas', 200, 400.00),
(6, 1006, 'Guanacaste', 350, 700.00),
(7, 1007, 'Limón', 450, 900.00),
(8, 1008, 'Perez Zeledón', 250, 500.00),
(9, 1009, 'San Carlos', 300, 600.00),
(10, 1010, 'Nicoya', 400, 800.00);

--Insert para la tabla BodegaFamilia
INSERT INTO BodegaFamilia (codigo_bodega, codigo_familia)
VALUES 
(1, 1),
(1, 3),
(2, 2),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 1),
(6, 4),
(7, 2),
(7, 5),
(8, 3),
(8, 6),
(9, 7),
(9, 9),
(10, 8),
(10, 10),
(5, 1),
(3, 2),
(7, 3),
(2, 6),
(1, 7);

-- Inserts en la tabla Zona
INSERT INTO Zona (zona_id, nombre)
VALUES 
(1, 'San José'),
(2, 'Alajuela'),
(3, 'Cartago'),
(4, 'Heredia'),
(5, 'Guanacaste'),
(6, 'Puntarenas'),
(7, 'Limón'),
(8, 'Perez Zeledón'),
(9, 'San Carlos'),
(10, 'Nicoya'),
(11, 'Liberia'),
(12, 'Santa Cruz'),
(13, 'Quepos'),
(14, 'Jaco'),
(15, 'Atenas'),
(16, 'Grecia'),
(17, 'Orotina'),
(18, 'Puriscal'),
(19, 'Guápiles'),
(20, 'Turrialba'),
(21, 'Escazú'),
(22, 'San Ramón'),
(23, 'Cañas'),
(24, 'Upala'),
(25, 'Tilarán');

-- Inserts en la tabla Sector
INSERT INTO Sector (sector_id, nombre)
VALUES 
(1, 'Tecnología'),
(2, 'Finanzas'),
(3, 'Construcción'),
(4, 'Agricultura'),
(5, 'Manufactura'),
(6, 'Comercio'),
(7, 'Turismo'),
(8, 'Educación'),
(9, 'Salud'),
(10, 'Transporte'),
(11, 'Telecomunicaciones'),
(12, 'Minería'),
(13, 'Energía'),
(14, 'Industria Alimentaria'),
(15, 'Bienes Raíces'),
(16, 'Consultoría'),
(17, 'Entretenimiento'),
(18, 'Deportes'),
(19, 'Seguros'),
(20, 'Marketing'),
(21, 'Logística'),
(22, 'Investigación'),
(23, 'Seguridad'),
(24, 'Automotriz'),
(25, 'Ingeniería');

-- Inserts en la tabla Cliente
INSERT INTO Cliente (cedula_juridica, nombre, correo, telefono, celular, fax, zona, sector)
VALUES 
(101001, 'Empresa Alpha', 'alpha@empresa.com', 22221111, 88881111, '22221111', 1, 1),
(101002, 'Constructora Beta', 'beta@constructora.com', 22221222, 88881222, '22221222', 2, 3),
(101003, 'Agroindustrias Gamma', 'gamma@agro.com', 22221333, 88881333, '22221333', 3, 4),
(101004, 'Comercio Delta', 'delta@comercio.com', 22221444, 88881444, '22221444', 4, 6),
(101005, 'Turismo Epsilon', 'epsilon@turismo.com', 22221555, 88881555, '22221555', 5, 7),
(101006, 'Educación Zeta', 'zeta@educacion.com', 22221666, 88881666, '22221666', 6, 8),
(101007, 'Salud Eta', 'eta@salud.com', 22221777, 88881777, '22221777', 7, 9),
(101008, 'Telecomunicaciones Theta', 'theta@telecom.com', 22221888, 88881888, '22221888', 8, 11),
(101009, 'Transporte Iota', 'iota@transporte.com', 22221999, 88881999, '22221999', 9, 10),
(101010, 'Finanzas Kappa', 'kappa@finanzas.com', 22222000, 88882000, '22222000', 10, 2),
(101011, 'Industria Alimentaria Lambda', 'lambda@alimentos.com', 22222111, 88882111, '22222111', 11, 14),
(101012, 'Consultoría Mu', 'mu@consultoria.com', 22222222, 88882222, '22222222', 12, 16),
(101013, 'Entretenimiento Nu', 'nu@entretenimiento.com', 22222333, 88882333, '22222333', 13, 17),
(101014, 'Deportes Xi', 'xi@deportes.com', 22222444, 88882444, '22222444', 14, 18),
(101015, 'Bienes Raíces Omicron', 'omicron@bienesraices.com', 22222555, 88882555, '22222555', 15, 15),
(101016, 'Ingeniería Pi', 'pi@ingenieria.com', 22222666, 88882666, '22222666', 16, 25),
(101017, 'Logística Rho', 'rho@logistica.com', 22222777, 88882777, '22222777', 17, 21),
(101018, 'Minería Sigma', 'sigma@mineria.com', 22222888, 88882888, '22222888', 18, 12),
(101019, 'Seguridad Tau', 'tau@seguridad.com', 22222999, 88882999, '22222999', 19, 23),
(101020, 'Consultoría Marketing Upsilon', 'upsilon@marketing.com', 22223000, 88883000, '22223000', 20, 20),
(101021, 'Automotriz Phi', 'phi@automotriz.com', 22223111, 88883111, '22223111', 21, 24),
(101022, 'Investigación Chi', 'chi@investigacion.com', 22223222, 88883222, '22223222', 22, 22),
(101023, 'Seguros Psi', 'psi@seguros.com', 22223333, 88883333, '22223333', 23, 19),
(101024, 'Compañía Energética Omega', 'omega@energia.com', 22223444, 88883444, '22223444', 24, 13),
(101025, 'Tecnología Delta', 'delta@tecnologia.com', 22223555, 88883555, '22223555', 25, 1);


-- Inserts en la tabla TipoCaso
INSERT INTO TipoCaso (tipocaso_id, nombre)
VALUES 
(1, 'Soporte Técnico'),
(2, 'Reclamo de Factura'),
(3, 'Consultoría'),
(4, 'Devolución de Producto'),
(5, 'Garantía'),
(6, 'Incidencia'),
(7, 'Reembolso'),
(8, 'Solicitud de Información'),
(9, 'Asesoría Técnica'),
(10, 'Reparación de Producto'),
(11, 'Queja'),
(12, 'Cancelación de Servicio'),
(13, 'Solicitud de Cotización'),
(14, 'Revisión de Servicio'),
(15, 'Reclamo de Pago'),
(16, 'Actualización de Datos'),
(17, 'Error de Facturación'),
(18, 'Solicitud de Cambios en el Servicio'),
(19, 'Problema con Entrega'),
(20, 'Incumplimiento de Términos');

-- Inserts en la EstadoCaso
INSERT INTO EstadoCaso (estado_id, nombre)
VALUES 
(1, 'Abierto'),
(2, 'En Proceso'),
(3, 'Cerrado'),
(4, 'Pendiente de Respuesta'),
(5, 'Resuelto'),
(6, 'Escalado'),
(7, 'Cancelado'),
(8, 'En Espera de Cliente'),
(9, 'Asignado'),
(10, 'Revisado'),
(11, 'En Espera de Aprobación'),
(12, 'Reabierto'),
(13, 'Investigación en Proceso'),
(14, 'Aprobado'),
(15, 'Denegado'),
(16, 'Cerrado con Incidente'),
(17, 'Pendiente de Tercero'),
(18, 'En Revisión de Calidad'),
(19, 'Cerrado Satisfactoriamente'),
(20, 'No Resuelto');

-- Inserts en la tabla PrioridadCaso
INSERT INTO PrioridadCaso (prioridad_id, nombre)
VALUES 
(1, 'Baja'),
(2, 'Media'),
(3, 'Alta'),
(4, 'Urgente'),
(5, 'Crítica'),
(6, 'Baja Prioridad'),
(7, 'Prioridad Media'),
(8, 'Alta Prioridad'),
(9, 'Urgente - Escalado'),
(10, 'Prioridad Inmediata'),
(11, 'Sin Urgencia'),
(12, 'Moderada'),
(13, 'Prioridad Alta'),
(14, 'Atención Urgente'),
(15, 'Alta Crítica'),
(16, 'Prioridad Baja'),
(17, 'Media-Alta'),
(18, 'Crítica - Prioridad Máxima'),
(19, 'Media - Escalado'),
(20, 'Baja - Sin Escalado');

INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (1, 'Pendiente');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (2, 'Aprobada');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (3, 'Rechazada');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (4, 'En revisión');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (5, 'Cancelada');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (6, 'Vencida');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (7, 'En negociación');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (8, 'Aceptada con cambios');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (9, 'En espera de aprobación');
INSERT INTO EstadoCotizacion (estadocotizacion_id, nombre) VALUES (10, 'Completada');

INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (1, 'Productos');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (2, 'Servicios');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (3, 'Propuesta Comercial');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (4, 'Licitación Pública');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (5, 'Consultoría');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (6, 'Soporte Técnico');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (7, 'Mantenimiento');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (8, 'Capacitación');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (9, 'Proyecto Especial');
INSERT INTO TipoCotizacion (tipocotizacion_id, nombre) VALUES (10, 'Subcontratación');


-- Inserts en la tabla Empleado
INSERT INTO Empleado (cedula, nombre, apellido1, apellido2, fecha_nacimiento, genero, residencia, fecha_ingreso, departamento, permiso_vendedor, numero_telefono, salario_actual, puesto)
VALUES 
(12345678, 'Carlos', 'Pérez', 'González', '1990-05-12', 'Masculino', 'San José', '2020-01-15', 1, 'Con permiso', 22223333, 1500.00, 1),
(23456789, 'Ana', 'Gómez', 'Ramírez', '1985-08-25', 'Femenino', 'Alajuela', '2019-03-10', 2, 'Sin permiso', 22224444, 1600.00, 2),
(34567890, 'Luis', 'Ramírez', 'Martínez', '1982-11-30', 'Masculino', 'Cartago', '2018-05-22', 3, 'Con permiso', 22225555, 1700.00, 3),
(45678901, 'María', 'Fernández', 'Soto', '1992-02-14', 'Femenino', 'Heredia', '2021-07-01', 4, 'Con permiso', 22226666, 1800.00, 4),
(56789012, 'Jorge', 'Valverde', 'Rojas', '1989-12-10', 'Masculino', 'Guanacaste', '2017-09-15', 5, 'Sin permiso', 22227777, 1750.00, 5),
(67890123, 'Elena', 'Rojas', 'Castro', '1987-06-18', 'Femenino', 'Limón', '2016-04-20', 6, 'Con permiso', 22228888, 1650.00, 6),
(78901234, 'David', 'Hernández', 'Zúñiga', '1991-09-05', 'Masculino', 'Puntarenas', '2015-12-01', 7, 'Con permiso', 22229999, 1600.00, 7),
(89012345, 'Laura', 'Mora', 'Pacheco', '1986-03-22', 'Femenino', 'San Carlos', '2014-06-30', 8, 'Sin permiso', 22220000, 1550.00, 8),
(90123456, 'José', 'Vargas', 'Rodríguez', '1993-07-10', 'Masculino', 'Nicoya', '2013-08-25', 9, 'Con permiso', 22221111, 1450.00, 9),
(11223344, 'Patricia', 'Quesada', 'Molina', '1984-10-15', 'Femenino', 'Santa Cruz', '2012-11-19', 10, 'Sin permiso', 22222222, 1400.00, 10);

-- Inserts en la tabla Factura
INSERT INTO Factura (num_facturacion, telefono_local, cedula_juridica, nombre_local, fecha, estado, cedula_vendedor)
VALUES 
(2001, 22223333, 101001, 'Empresa A', '2024-01-05', 1, 12345678), -- Factura para Caso 1
(2002, 22224444, 101002, 'Empresa B', '2024-01-06', 2, 23456789), -- Factura para Caso 2
(2003, 22225555, 101003, 'Empresa C', '2024-01-07', 3, 34567890), -- Factura para Caso 3
(2004, 22226666, 101004, 'Empresa D', '2024-01-08', 1, 45678901), -- Factura para Caso 4
(2005, 22227777, 101005, 'Empresa G', '2024-01-09', 1, 78901234), -- Factura para Caso 7
(2006, 22228888, 101006, 'Empresa F', '2024-01-10', 2, 67890123), -- Factura para Caso 6
(2007, 22229999, 101007, 'Empresa H', '2024-01-11', 3, 89012345), -- Factura para Caso 8
(2008, 22221111, 101008, 'Empresa I', '2024-01-12', 1, 90123456), -- Factura para Caso 9
(2009, 22222222, 101009, 'Empresa J', '2024-01-13', 4, 11223344), -- Factura para Caso 10
(2010, 22230000, 101010, 'Empresa K', '2024-02-01', 1, 12345678),
(2011, 22231111, 101011, 'Empresa L', '2024-02-05', 2, 23456789),
(2012, 22232222, 101012, 'Empresa M', '2024-02-10', 1, 34567890),
(2013, 22233333, 101013, 'Empresa N', '2024-02-15', 3, 45678901),
(2014, 22234444, 101014, 'Empresa O', '2024-03-01', 1, 78901234);


INSERT INTO FacturaArticulo (num_facturacion, codigo_articulo, cantidad, monto)
VALUES
(2001, 1, 5, 500.00), -- Artículo 1 en Factura 2001
(2001, 2, 3, 450.00), -- Artículo 2 en Factura 2001
(2002, 3, 8, 1200.00), -- Artículo 3 en Factura 2002
(2003, 4, 10, 1500.00), -- Artículo 4 en Factura 2003
(2003, 5, 2, 600.00), -- Artículo 5 en Factura 2003
(2004, 6, 4, 600.00), -- Artículo 6 en Factura 2004
(2005, 7, 7, 1575.00), -- Artículo 7 en Factura 2005
(2006, 8, 6, 1500.00), -- Artículo 8 en Factura 2006
(2007, 9, 2, 500.00), -- Artículo 9 en Factura 2007
(2008, 10, 3, 750.00), -- Artículo 10 en Factura 2008
(2010, 11, 5, 550.00), -- Artículo 11 en Factura 2010
(2010, 12, 3, 450.00), -- Artículo 12 en Factura 2010
(2011, 13, 8, 1200.00), -- Artículo 13 en Factura 2011
(2012, 14, 10, 1600.00), -- Artículo 14 en Factura 2012
(2013, 15, 2, 800.00), -- Artículo 15 en Factura 2013
(2014, 16, 7, 1750.00), -- Artículo 16 en Factura 2014
(2014, 17, 4, 800.00); -- Artículo 17 en Factura 2014


-- Inserts en la tabla Cotizacion
INSERT INTO Cotizacion (num_cotizacion, orden_compra, tipo, descripcion, zona, sector, estado, monto_total, mes_cierre, cedula_vendedor, fecha_inicio, fecha_cierre, probabilidad, razon_negacion, cedula_cliente)
VALUES 
(1001, 'OC-1234', 1, 'Cotización de soporte técnico', 1, 1, 1, 5000.00, 1, 12345678, '2024-01-01', '2024-01-31', 80.00, '', 101001), -- Cotización para Caso 1
(1002, 'OC-2345', 2, 'Reclamo de factura técnica', 2, 2, 2, 1500.00, 2, 23456789, '2024-02-01', '2024-02-28', 60.00, '', 101002), -- Cotización para Caso 2
(1003, 'OC-3456', 3, 'Cotización de devolución de producto', 3, 3, 3, 3000.00, 3, 34567890, '2024-03-01', '2024-03-31', 90.00, '', 101003), -- Cotización para Caso 3
(1004, 'OC-4567', 4, 'Reclamo de devolución', 4, 4, 4, 4500.00, 4, 45678901, '2024-04-01', '2024-04-30', 75.00, '', 101004), -- Cotización para Caso 4
(1005, 'OC-5678', 5, 'Cotización de asesoría técnica', 5, 5, 1, 2500.00, 5, 90123456, '2024-05-01', '2024-05-31', 85.00, '', 101008), -- Cotización para Caso 9
(1006, 'OC-6789', 6, 'Cotización para instalación de equipo', 1, 6, 2, 6000.00, 2, 12345678, '2024-02-01', '2024-02-28', 90.00, '', 101010),
(1007, 'OC-7890', 7, 'Cotización para soporte extendido', 2, 7, 1, 4000.00, 3, 23456789, '2024-03-01', '2024-03-31', 85.00, '', 101011),
(1008, 'OC-8901', 8, 'Cotización para asesoría técnica', 3, 8, 3, 5000.00, 4, 34567890, '2024-04-01', '2024-04-30', 70.00, '', 101012),
(1009, 'OC-9012', 9, 'Cotización para revisión de servicios', 4, 9, 2, 3000.00, 5, 45678901, '2024-05-01', '2024-05-31', 75.00, '', 101013),
(1010, 'OC-0123', 10, 'Cotización para optimización de procesos', 5, 10, 1, 7000.00, 6, 78901234, '2024-06-01', '2024-06-30', 95.00, '', 101014);


INSERT INTO CotizacionArticulo (codigo_articulo, num_cotizacion, cantidad, monto)
VALUES
(1, 1001, 10, 1000.00), -- Artículo 1 en Cotización 1001
(2, 1001, 5, 1500.00), -- Artículo 2 en Cotización 1001
(3, 1002, 8, 1200.00), -- Artículo 3 en Cotización 1002
(4, 1003, 12, 1800.00), -- Artículo 4 en Cotización 1003
(5, 1003, 7, 2100.00), -- Artículo 5 en Cotización 1003
(6, 1004, 15, 2250.00), -- Artículo 6 en Cotización 1004
(7, 1004, 6, 2250.00), -- Artículo 7 en Cotización 1004
(8, 1005, 3, 750.00), -- Artículo 8 en Cotización 1005
(9, 1005, 4, 1000.00), -- Artículo 9 en Cotización 1005
(1, 1005, 2, 750.00), -- Artículo 10 en Cotización 1005
(11, 1006, 12, 3600.00), -- Artículo 11 en Cotización 1006
(2, 1006, 8, 2400.00), -- Artículo 12 en Cotización 1006
(13, 1007, 10, 4000.00), -- Artículo 13 en Cotización 1007
(4, 1008, 6, 3000.00), -- Artículo 14 en Cotización 1008
(1, 1008, 4, 2000.00), -- Artículo 15 en Cotización 1008
(2, 1009, 5, 1500.00), -- Artículo 16 en Cotización 1009
(7, 1010, 7, 4900.00); -- Artículo 17 en Cotización 1010


-- Inserts en la tabla Logueo_Usuario
INSERT INTO Logueo_Usuario (usuario, contrasenna, cedula_empleado)
VALUES 
('carlos.perez', HASHBYTES('SHA2_256', 'password123'), 12345678),
('ana.gomez', HASHBYTES('SHA2_256', 'password456'), 23456789),
('luis.ramirez', HASHBYTES('SHA2_256', 'password789'), 34567890),
('maria.fernandez', HASHBYTES('SHA2_256', 'password101'), 45678901),
('jorge.valverde', HASHBYTES('SHA2_256', 'password202'), 56789012),
('elena.rojas', HASHBYTES('SHA2_256', 'password303'), 67890123),
('david.hernandez', HASHBYTES('SHA2_256', 'password404'), 78901234),
('laura.mora', HASHBYTES('SHA2_256', 'password505'), 89012345),
('jose.vargas', HASHBYTES('SHA2_256', 'password606'), 90123456),
('patricia.quesada', HASHBYTES('SHA2_256', 'password707'), 11223344),
('admin', HASHBYTES('SHA2_256', 'admin'), 12345678);


INSERT INTO Caso (codigo, nombre_cuenta, nombre_contacto, asunto, direccion, descripcion, estado, tipo, prioridad, cedula_propietario, origen_cotizacion, origen_factura)
VALUES
(1, 'Cuenta A', 'Juan Pérez', 'Soporte Técnico requerido', 'Calle 1, San José', 'Problema con el servidor principal.', 1, 1, 3, 12345678, 1001, NULL),
(2, 'Cuenta B', 'María Gómez', 'Reclamo de Factura', 'Avenida Central, Alajuela', 'Factura incorrecta en el monto total.', 2, 2, 2, 23456789, NULL, 2002),
(3, 'Cuenta C', 'Carlos Ramírez', 'Devolución de Producto', 'Barrio El Carmen, Cartago', 'Producto defectuoso recibido.', 3, 4, 4, 34567890, 1003, NULL),
(4, 'Cuenta D', 'Ana Fernández', 'Garantía solicitada', 'Urbanización La Paz, Heredia', 'Reclamo de garantía por falla técnica.', 4, 5, 1, 45678901, NULL, 2004),
(5, 'Cuenta E', 'Jorge Valverde', 'Incidencia técnica', 'Zona Norte, Guanacaste', 'Problema con el sistema eléctrico.', 5, 6, 5, 56789012, NULL, 2005),
(6, 'Cuenta F', 'Elena Rojas', 'Reembolso solicitado', 'Calle Principal, Limón', 'Reembolso por producto devuelto.', 6, 7, 3, 67890123, 1003, NULL),
(7, 'Cuenta G', 'David Hernández', 'Asesoría Técnica', 'Calle Secundaria, Puntarenas', 'Asesoría técnica requerida.', 1, 9, 2, 78901234, 1001, NULL),
(8, 'Cuenta H', 'Laura Mora', 'Solicitud de Información', 'Avenida Central, San Carlos', 'Consulta sobre nuevos productos.', 2, 8, 4, 89012345, NULL, 2007),
(9, 'Cuenta I', 'José Vargas', 'Problema con Entrega', 'Zona Rural, Nicoya', 'Entrega retrasada de productos.', 3, 19, 1, 90123456, NULL, 2008),
(10, 'Cuenta J', 'Patricia Quesada', 'Incumplimiento de Términos', 'Calle del Comercio, Santa Cruz', 'Condiciones no respetadas.', 4, 20, 5, 11223344, NULL, 2009);

INSERT INTO TareaCaso (codigo_tarea, codigo_caso, fecha, descripcion, cedula_usuario)
VALUES
(2, 1, '2024-01-10', 'Diagnóstico inicial del problema.', 12345678),
(1, 2, '2024-01-12', 'Revisión de la factura reclamada.', 23456789),
(8, 3, '2024-01-15', 'Inspección del producto defectuoso.', 34567890),
(5, 4, '2024-01-18', 'Confirmación de cobertura de garantía.', 45678901),
(3, 5, '2024-01-20', 'Investigación de incidencia técnica.', 56789012),
(11, 6, '2024-01-22', 'Procesamiento del reembolso solicitado.', 67890123),
(9, 7, '2024-01-25', 'Preparación para la asesoría técnica.', 78901234),
(7, 8, '2024-01-28', 'Envío de información solicitada.', 89012345),
(12, 9, '2024-01-30', 'Seguimiento del retraso en entrega.', 90123456),
(10, 10, '2024-02-01', 'Investigación de términos incumplidos.', 11223344);

-- Insert de Entradas

INSERT INTO Entrada (codigo_entrada, fecha_hora, codigo_bodega, cedula_administrador)
VALUES
(1, '2024-11-01 08:30:00', 1, 12345678),
(2, '2024-11-01 09:00:00', 2, 23456789),
(3, '2024-11-01 09:30:00', 3, 34567890),
(4, '2024-11-01 10:00:00', 4, 45678901),
(5, '2024-11-01 10:30:00', 5, 56789012),
(6, '2024-11-01 11:00:00', 6, 67890123),
(7, '2024-11-01 11:30:00', 7, 78901234),
(8, '2024-11-01 12:00:00', 8, 89012345),
(9, '2024-11-01 12:30:00', 9, 90123456),
(10, '2024-11-01 13:00:00', 10, 11223344);

-- Insert de Movimientos

INSERT INTO Movimiento (codigo_movimiento, fecha_hora, cedula_administrador, codigo_bodega_origen, codigo_bodega_destino)
VALUES
(1, '2024-11-02 08:30:00', 12345678, 1, 2),
(2, '2024-11-02 09:00:00', 23456789, 2, 3),
(3, '2024-11-02 09:30:00', 34567890, 3, 4),
(4, '2024-11-02 10:00:00', 45678901, 4, 5),
(5, '2024-11-02 10:30:00', 56789012, 5, 6),
(6, '2024-11-02 11:00:00', 67890123, 6, 7),
(7, '2024-11-02 11:30:00', 78901234, 7, 8),
(8, '2024-11-02 12:00:00', 89012345, 8, 9),
(9, '2024-11-02 12:30:00', 90123456, 9, 10),
(10, '2024-11-02 13:00:00', 11223344, 10, 1);

-- Inserts de Salidas

INSERT INTO Salida (fecha_hora, cedula_vendedor, codigo_bodega, factura)
VALUES
('2024-11-03 08:30:00', 12345678, 1, 2001),
('2024-11-03 09:00:00', 23456789, 2, 2002),
('2024-11-03 09:30:00', 34567890, 3, 2003),
('2024-11-03 10:00:00', 45678901, 4, 2004),
('2024-11-03 10:30:00', 56789012, 5, 2005),
('2024-11-03 11:00:00', 67890123, 6, 2006),
('2024-11-03 11:30:00', 78901234, 7, 2007),
('2024-11-03 12:00:00', 89012345, 8, 2008),
('2024-11-03 12:30:00', 90123456, 9, 2009),

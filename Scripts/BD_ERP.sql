if not exists (select[name] from sys.databases where [name]=N'ERP')
begin
	create database ERP
end;

use master;
go

use ERP;
go

-----------MODULO USUARIO------------
/* Tabla para almacenar información de los empleados */
CREATE TABLE Empleado (
    cedula INT PRIMARY KEY NOT NULL, /* Identificador único del empleado */
    nombre VARCHAR(25) NOT NULL, /* Nombre del empleado */
    apellido1 VARCHAR(25) NOT NULL, /* Primer apellido del empleado */
    apellido2 VARCHAR(25) NOT NULL, /* Segundo apellido del empleado */
    fecha_nacimiento DATE NOT NULL, /* Fecha de nacimiento del empleado */
    genero VARCHAR(50) NOT NULL, /* Género del empleado (Masculino, Femenino, Otro) */
	edad INT NOT NULL, /* Edad del empleado (entre 18 y 80 años) */
	fecha_ingreso DATE NOT NULL, /* Fecha en que ingresó a la empresa */
    departamento VARCHAR(25) NOT NULL, /* Departamento al que pertenece el empleado */
    permiso_vendedor VARCHAR(20) NOT NULL, /* Permiso de vendedor (Con permiso, Sin permiso) */
    numero_telefono INT NOT NULL, /* Número de teléfono del empleado */
    salario_actual DECIMAL(10,2) NOT NULL, /* Salario actual del empleado */
	puesto VARCHAR(40) NOT NULL, /* Puesto que ocupa el empleado */
	CONSTRAINT chk_genero CHECK (genero IN ('Masculino', 'Femenino', 'Otro')), /* Restricción para validar el género */
	CONSTRAINT chk_permisos_vendedor CHECK (permiso_vendedor IN ('Con permiso', 'Sin permiso')), /* Validación para permisos de vendedor */
	CONSTRAINT chk_edad CHECK (edad BETWEEN 18 AND 80) /* Validación de edad entre 18 y 80 años */
);

/* Tabla para gestionar los roles de los empleados */
CREATE TABLE Rol (
    rol VARCHAR(15) NOT NULL, /* Rol del empleado (Edición, Visualización, Reportería) */
    cedula_empleado INT NOT NULL, /* Cédula del empleado relacionado */
    PRIMARY KEY (rol,cedula_empleado), /* Llave primaria compuesta por rol y cédula */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave foránea a la tabla Empleado */
	CONSTRAINT chk_rol CHECK (rol IN ('Edición', 'Visualización', 'Reportería')) /* Validación de los roles permitidos */
);

/* Tabla para registrar el historial de salarios de los empleados */
CREATE TABLE HistoricoSalario (
    nombre_puesto INT NOT NULL, /* Nombre del puesto en el historial */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio del puesto */
    fecha_fin DATE NOT NULL, /* Fecha de fin del puesto */
    departamento VARCHAR(25) NOT NULL, /* Departamento del empleado */
    monto INT NOT NULL, /* Salario en ese periodo */
    cedula_empleado INT NOT NULL, /* Cédula del empleado */
    PRIMARY KEY (nombre_puesto,fecha_inicio,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula) /* Llave foránea a Empleado */
);

/* Tabla para registrar el historial de puestos de los empleados */
CREATE TABLE HistoricoPuesto (
    nombre_puesto INT NOT NULL, /* Nombre del puesto en el historial */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio en el puesto */
    fecha_fin DATE NOT NULL, /* Fecha de fin en el puesto */
    departamento VARCHAR(25) NOT NULL, /* Departamento del empleado */
    cedula_empleado INT NOT NULL, /* Cédula del empleado */
	PRIMARY KEY (nombre_puesto,fecha_inicio,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula) /* Llave foránea a Empleado */
);

/* Tabla para almacenar los pagos de salarios mensuales de los empleados */
CREATE TABLE Salario (
	anno INT NOT NULL, /* Año del pago */
	mes INT NOT NULL, /* Mes del pago (1-12) */
    pago DECIMAL(10,2) NOT NULL, /* Monto del pago */
	cantidad_horas INT NOT NULL, /* Cantidad de horas trabajadas */
	cedula_empleado INT NOT NULL, /* Cédula del empleado */
	PRIMARY KEY (pago,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
	CONSTRAINT chk_anno CHECK (anno > 1980), /* Validación del año */
	CONSTRAINT chk_mes CHECK (mes BETWEEN 1 AND 12) /* Validación del mes */
);

-----------MODULO INVENTARIO------------
/* Tabla para almacenar las familias de productos en el inventario */
CREATE TABLE Familia (
    codigo INT PRIMARY KEY, /* Código único de la familia */
    nombre VARCHAR(25) NOT NULL, /* Nombre de la familia */
    descripcion VARCHAR(255) NOT NULL /* Descripción de la familia */
);

/* Tabla para almacenar los artículos en el inventario */
CREATE TABLE Articulo (
    codigo INT PRIMARY KEY, /* Código único del artículo */
    nombre VARCHAR(25) NOT NULL, /* Nombre del artículo */
    cantidad INT NOT NULL, /* Cantidad en inventario */
	activo VARCHAR(50) NOT NULL, /* Estado del artículo (Activo/Inactivo) */
    descripcion VARCHAR(255) NOT NULL, /* Descripción del artículo */
    peso DECIMAL(10,2) NOT NULL, /* Peso del artículo */
	costo DECIMAL(10,2) NOT NULL, /* Costo del artículo */
    precio_estandar DECIMAL(10,2) NOT NULL, /* Precio estándar del artículo */
    codigo_familia INT NOT NULL, /* Código de la familia a la que pertenece el artículo */
    FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo) /* Llave foránea a la tabla Familia */
);

/* Tabla para almacenar información sobre las bodegas */
CREATE TABLE Bodega (
    codigo_bodega INT PRIMARY KEY, /* Código único de la bodega */
    numero INT NOT NULL, /* Número de identificación de la bodega */
    ubicacion VARCHAR(25) NOT NULL, /* Ubicación de la bodega */
    capacidad INT NOT NULL, /* Capacidad total de la bodega */
	espacio_cubico DECIMAL(10,2) /* Espacio cúbico disponible en la bodega */
);

/* Tabla que asocia familias de productos a bodegas */
CREATE TABLE BodegaFamilia (
	codigo_bodega INT NOT NULL, /* Código de la bodega */
	codigo_familia INT NOT NULL, /* Código de la familia */
	PRIMARY KEY (codigo_bodega,codigo_familia), /* Llave primaria compuesta */
	FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega), /* Llave foránea a Bodega */
	FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo) /* Llave foránea a Familia */
);

/* Tabla que asocia artículos a bodegas y registra su cantidad en cada bodega */
CREATE TABLE BodegaArticulo (
	codigo_bodega INT NOT NULL, /* Código de la bodega */
	codigo_articulo INT NOT NULL, /* Código del artículo */
	cantidad INT NOT NULL, /* Cantidad de artículos en la bodega */
	PRIMARY KEY (codigo_bodega,codigo_articulo), /* Llave primaria compuesta */
	FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega), /* Llave foránea a Bodega */
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

/* Tabla para registrar las entradas de productos en una bodega */
CREATE TABLE Entrada (
    fecha_hora DATETIME NOT NULL, /* Fecha y hora de la entrada */
    cantidad INT NOT NULL, /* Cantidad de productos ingresados */
    precio DECIMAL(10,2) NOT NULL, /* Precio total de la entrada */
    codigo_bodega INT NOT NULL, /* Código de la bodega donde ingresan los productos */
    cedula_administrador INT NOT NULL, /* Cédula del administrador responsable */
	PRIMARY KEY(fecha_hora,cedula_administrador,codigo_bodega), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega) /* Llave foránea a Bodega */
);

/* Tabla para registrar los artículos que ingresan en una entrada específica */
CREATE TABLE EntradaArticulo (
    fecha_hora_entrada DATETIME NOT NULL, /* Fecha y hora de la entrada */
	codigo_bodega INT NOT NULL, /* Código de la bodega */
    cedula_administrador INT NOT NULL, /* Cédula del administrador */
	codigo_articulo INT NOT NULL, /* Código del artículo ingresado */
	PRIMARY KEY(fecha_hora_entrada,cedula_administrador,codigo_bodega,codigo_articulo), /* Llave primaria compuesta */
    FOREIGN KEY(fecha_hora_entrada,cedula_administrador,codigo_bodega) REFERENCES Entrada(fecha_hora,cedula_administrador,codigo_bodega), /* Llave foránea a Entrada */
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

/* Tabla para registrar movimientos de artículos entre bodegas */
CREATE TABLE Movimiento (
    fecha_hora DATETIME NOT NULL, /* Fecha y hora del movimiento */
    cantidad INT NOT NULL, /* Cantidad movida */
    cedula_administrador INT NOT NULL, /* Cédula del administrador */
    codigo_bodega_origen INT NOT NULL, /* Bodega de origen */
    codigo_bodega_destino INT NOT NULL, /* Bodega de destino */
	PRIMARY KEY(fecha_hora,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (codigo_bodega_origen) REFERENCES Bodega(codigo_bodega), /* Llave foránea a Bodega de origen */
    FOREIGN KEY (codigo_bodega_destino) REFERENCES Bodega(codigo_bodega) /* Llave foránea a Bodega de destino */
);

/* Tabla para registrar los artículos movidos entre bodegas en un movimiento específico */
CREATE TABLE MovimientoArticulo (
    fecha_hora_movimiento DATETIME NOT NULL, /* Fecha y hora del movimiento */
    cedula_administrador INT NOT NULL, /* Cédula del administrador */
    codigo_bodega_origen INT NOT NULL, /* Bodega de origen */
    codigo_bodega_destino INT NOT NULL, /* Bodega de destino */
	codigo_articulo INT NOT NULL, /* Código del artículo */
	PRIMARY KEY(fecha_hora_movimiento,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino,codigo_articulo), /* Llave primaria compuesta */
    FOREIGN KEY (fecha_hora_movimiento,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino) REFERENCES Movimiento(fecha_hora,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino), /* Llave foránea a Movimiento */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

/* Tabla para registrar las salidas de productos de una bodega */
CREATE TABLE Salida (
	fecha_hora DATETIME NOT NULL, /* Fecha y hora de la salida */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor */
    codigo_bodega INT NOT NULL, /* Código de la bodega de salida */
    PRIMARY KEY (fecha_hora,cedula_vendedor, codigo_bodega), /* Llave primaria compuesta */
	FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega) /* Llave foránea a Bodega */
);

/* Tabla para registrar los artículos que salen de una bodega en una salida específica */
CREATE TABLE SalidaArticulo (
	fecha_hora_salida DATETIME NOT NULL, /* Fecha y hora de la salida */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor */
    codigo_bodega INT NOT NULL, /* Código de la bodega de salida */
    codigo_articulo INT NOT NULL, /* Código del artículo */
    PRIMARY KEY (codigo_articulo, fecha_hora_salida,cedula_vendedor, codigo_bodega), /* Llave primaria compuesta */
    FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo), /* Llave foránea a Artículo */
    FOREIGN KEY (fecha_hora_salida,cedula_vendedor, codigo_bodega) REFERENCES Salida(fecha_hora,cedula_vendedor, codigo_bodega) /* Llave foránea a Salida */
);

-----------MODULO CLIENTE------------
/* Tabla para gestionar la información de los clientes */
CREATE TABLE Cliente (
    cedula INT PRIMARY KEY, /* Cédula del cliente */
    nombre VARCHAR(255) NOT NULL, /* Nombre del cliente */
    apellido1 VARCHAR(255) NOT NULL, /* Primer apellido del cliente */
    apellido2 VARCHAR(255) NOT NULL, /* Segundo apellido del cliente */
    correo VARCHAR(255) NOT NULL, /* Correo electrónico del cliente */
	telefono INT NOT NULL, /* Teléfono del cliente */
	celular INT NOT NULL, /* Celular del cliente */
	fax VARCHAR(50) NOT NULL, /* Fax del cliente */
    zona VARCHAR(50) NOT NULL, /* Zona geográfica del cliente */
    sector VARCHAR(50) NOT NULL /* Sector del cliente */
);

-----------MODULO COTIZACION------------
/* Tabla para gestionar las cotizaciones realizadas a los clientes */
CREATE TABLE Cotizacion (
    num_cotizacion INT PRIMARY KEY, /* Número único de la cotización */
	orden_compra VARCHAR(50) NOT NULL, /* Orden de compra asociada */
	tipo VARCHAR(30) NOT NULL, /* Tipo de cotización */
	descripcion VARCHAR(255) NOT NULL, /* Descripción de la cotización */
	zona VARCHAR(50) NOT NULL, /* Zona de la cotización */
    sector VARCHAR(50) NOT NULL, /* Sector de la cotización */
	estado VARCHAR(10) NOT NULL, /* Estado de la cotización (abierta, aprobada, denegada) */
	monto_total DECIMAL(10, 2) NOT NULL, /* Monto total de la cotización */
	mes_cierre INT NOT NULL, /* Mes estimado de cierre de la cotización */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor encargado */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio de la cotización */
    fecha_cierre DATE NOT NULL, /* Fecha de cierre de la cotización */
    probabilidad DECIMAL(5, 2) NOT NULL, /* Probabilidad de éxito de la cotización */
	razon_negacion VARCHAR(255) NOT NULL, /* Razón de negación si corresponde */
	cedula_cliente INT NOT NULL, /* Cédula del cliente */
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
	FOREIGN KEY (cedula_cliente) REFERENCES Cliente(cedula), /* Llave foránea a Cliente */
	CONSTRAINT chk_mes_cierre CHECK (mes_cierre BETWEEN 1 AND 12), /* Validación del mes de cierre */
    CONSTRAINT chk_estado CHECK (estado IN ('abierta', 'aprobada', 'denegada')), /* Validación del estado de la cotización */
	CONSTRAINT chk_probabilidad CHECK (probabilidad >= 1.00 AND probabilidad <= 100.00) /* Validación de probabilidad de éxito */
);

/* Tabla para gestionar las tareas relacionadas con las cotizaciones */
CREATE TABLE TareaCotizacion (
	codigo_tarea INT NOT NULL, /* Código único de la tarea */
	descripcion VARCHAR(255) NOT NULL, /* Descripción de la tarea */
    num_cotizacion INT NOT NULL, /* Número de la cotización asociada */
	PRIMARY KEY (codigo_tarea, num_cotizacion), /* Llave primaria compuesta */
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion) /* Llave foránea a Cotización */
);

/* Tabla que asocia artículos con cotizaciones */
CREATE TABLE CotizacionArticulo (
	codigo_articulo INT NOT NULL, /* Código del artículo */
    num_cotizacion INT NOT NULL, /* Número de la cotización */
	cantidad INT NOT NULL, /* Cantidad del artículo en la cotización */
	monto DECIMAL(10,2) NOT NULL, /* Monto correspondiente */
	PRIMARY KEY (codigo_articulo, num_cotizacion), /* Llave primaria compuesta */
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion), /* Llave foránea a Cotización */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

-----------MODULO FACTURACION------------
/* Tabla para gestionar las facturas emitidas */
CREATE TABLE Factura (
    num_facturacion INT PRIMARY KEY, /* Número único de la factura */
    telefono_local INT NOT NULL, /* Teléfono del local */
    cedula_juridica INT NOT NULL, /* Cédula jurídica del cliente */
    nombre_local VARCHAR(200) NOT NULL, /* Nombre del local del cliente */
	fecha DATE NOT NULL, /* Fecha de emisión de la factura */
    estado VARCHAR(60) NOT NULL, /* Estado de la factura (pagada, pendiente, etc.) */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor */
    cedula_cliente INT NOT NULL, /* Cédula del cliente */
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (cedula_cliente) REFERENCES Cliente(cedula) /* Llave foránea a Cliente */
);

/* Tabla que asocia artículos con facturas */
CREATE TABLE FacturaArticulo (
    num_facturacion INT NOT NULL, /* Número de la factura */
    codigo_articulo INT NOT NULL, /* Código del artículo */
	cantidad INT NOT NULL, /* Cantidad de articulos*/
	monto DECIMAL(10,2) NOT NULL, /*Monto del articulo*/
    FOREIGN KEY (num_facturacion) REFERENCES Factura(num_facturacion), /* Llave foránea a Factura */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

-----------MODULO REGISTRO DE CASOS------------
/* Tabla para registrar casos relacionados con cotizaciones o facturas */
CREATE TABLE Caso (
    codigo INT PRIMARY KEY, /* Código único del caso */
	nombre_cuenta VARCHAR(255) NOT NULL, /* Nombre de la cuenta asociada */
	nombre_contacto VARCHAR(60) NOT NULL, /* Nombre del contacto relacionado */
	asunto VARCHAR(255) NOT NULL, /* Asunto del caso */
	direccion VARCHAR(255) NOT NULL, /* Dirección relacionada al caso */
	descripcion VARCHAR(255) NOT NULL, /* Descripción del caso */
	estado VARCHAR(60) NOT NULL, /* Estado del caso */
	tipo VARCHAR(30) NOT NULL, /* Tipo del caso (soporte, reclamo, etc.) */
	prioridad VARCHAR(20) NOT NULL, /* Prioridad del caso */
	cedula_propietario INT NOT NULL, /* Cédula del propietario del caso */
	origen_cotizacion INT, /* Referencia a la cotización de origen, si aplica */
    origen_factura INT, /* Referencia a la factura de origen, si aplica */

	FOREIGN KEY (cedula_propietario) REFERENCES Empleado(cedula),
    FOREIGN KEY (origen_cotizacion) REFERENCES Cotizacion(num_cotizacion), /* Llave foránea a Cotización */
    FOREIGN KEY (origen_factura) REFERENCES Factura(num_facturacion), /* Llave foránea a Factura */
    CONSTRAINT chk_origen CHECK ((origen_cotizacion IS NOT NULL AND origen_factura IS NULL) OR (origen_cotizacion IS NULL AND origen_factura IS NOT NULL)) /* Validación para evitar referencias simultáneas a cotización y factura */
);

/* Tabla para registrar las tareas asociadas a los casos */
CREATE TABLE TareaCaso (
	codigo_tarea INT PRIMARY KEY, /*Código de la tarea*/
	codigo_caso INT NOT NULL, /* Código del caso asociado */
	fecha DATE NOT NULL, /* Fecha de la tarea */
	descripcion VARCHAR(255) NOT NULL, /* Descripción de la tarea */
	cedula_usuario INT NOT NULL, /* Cédula del usuario asignado */
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo), /* Llave foránea a Caso */
	FOREIGN KEY (cedula_usuario) REFERENCES Empleado(cedula) /* Llave foránea a Empleado */
);

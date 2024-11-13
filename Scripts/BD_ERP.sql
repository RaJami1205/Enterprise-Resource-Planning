if not exists (select[name] from sys.databases where [name]=N'ERP')
begin
	create database ERP
end;

use master;
go

use ERP;
go

-----------MODULO USUARIO------------

CREATE TABLE Accion (
	accion_id INT PRIMARY KEY,
	accion VARCHAR(100) NOT NULL,
	rol VARCHAR(15) NOT NULL,
);

/* Tabla para gestionar los roles de los empleados */
CREATE TABLE Rol (
	rol_id INT PRIMARY KEY,
    rol VARCHAR(15) NOT NULL, /* Rol del empleado (Edición, Visualización, Reportería) */
	CONSTRAINT chk_rol CHECK (rol IN ('Edición', 'Visualización', 'Reportería')) /* Validación de los roles permitidos */
);

CREATE TABLE AccionRol (
	accion_id INT NOT NULL,
	rol_id INT NOT NULL,
	FOREIGN KEY (accion_id) REFERENCES Accion(accion_id),
	FOREIGN KEY (rol_id) REFERENCES Rol(rol_id)
);

/* Tabla para registrar los departamentos */
CREATE TABLE Departamento (
	departamento_id INT PRIMARY KEY NOT NULL,
	nombre varchar(200) NOT NULL,
);

CREATE TABLE Puesto (
	puesto_id INT PRIMARY KEY,
	puesto VARCHAR(200) NOT NULL,
);

/* Tabla para almacenar información de los empleados */
CREATE TABLE Empleado (
    cedula INT PRIMARY KEY NOT NULL, /* Identificador único del empleado */
    nombre VARCHAR(25) NOT NULL, /* Nombre del empleado */
    apellido1 VARCHAR(25) NOT NULL, /* Primer apellido del empleado */
    apellido2 VARCHAR(25) NOT NULL, /* Segundo apellido del empleado */
    fecha_nacimiento DATE NOT NULL, /* Fecha de nacimiento del empleado */
    genero VARCHAR(50) NOT NULL, /* Género del empleado (Masculino, Femenino, Otro) */
	residencia VARCHAR(80) NOT NULL, /* Lugar en el que reside*/
	fecha_ingreso DATE NOT NULL, /* Fecha en que ingresó a la empresa */
    departamento INT NOT NULL, /* Departamento al que pertenece el empleado */
    permiso_vendedor VARCHAR(20) NOT NULL, /* Permiso de vendedor (Con permiso, Sin permiso) */
    numero_telefono INT NOT NULL, /* Número de teléfono del empleado */
    salario_actual FLOAT NOT NULL, /* Salario actual del empleado */
	puesto INT NOT NULL, /* Puesto que ocupa el empleado */
	CONSTRAINT chk_genero CHECK (genero IN ('Masculino', 'Femenino', 'Otro')), /* Restricción para validar el género */
	CONSTRAINT chk_permisos_vendedor CHECK (permiso_vendedor IN ('Con permiso', 'Sin permiso')), /* Validación para permisos de vendedor */
	FOREIGN KEY (departamento) REFERENCES Departamento(departamento_id),
	FOREIGN KEY (puesto) REFERENCES Puesto(puesto_id),
);

/* Tabla para almacenar los usuarios del sistema */
CREATE TABLE Logueo_Usuario (
	usuario VARCHAR(75) NOT NULL,
	contrasenna VARBINARY(64) NOT NULL,
	cedula_empleado INT NOT NULL,

	FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula)
);

CREATE TABLE EmpleadoRol (
	rol INT NOT NULL ,
	cedula_empleado INT NOT NULL,
	FOREIGN KEY (rol) REFERENCES Rol(rol_id),
	FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula)
);

/* Tabla para registrar el historial de salarios de los empleados */
CREATE TABLE HistoricoSalario (
	HistoricoSalario_id INT NOT NULL,
    puesto INT NOT NULL, /* Nombre del puesto en el historial */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio del puesto */
    fecha_fin DATE NOT NULL, /* Fecha de fin del puesto */
    departamento INT NOT NULL, /* Departamento del empleado */
    monto FLOAT NOT NULL, /* Salario en ese periodo */
    cedula_empleado INT NOT NULL, /* Cédula del empleado */
    PRIMARY KEY (HistoricoSalario_id,puesto,fecha_inicio,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
	FOREIGN KEY (puesto) REFERENCES Puesto(puesto_id), /* Llave foránea a Puesto */
	FOREIGN KEY (departamento) REFERENCES Departamento(departamento_id) /* Llave foránea a Departamento */
);

/* Tabla para registrar el historial de puestos de los empleados */
CREATE TABLE HistoricoPuesto (
	HistoricoPuesto_id INT NOT NULL,
    puesto INT NOT NULL, /* Nombre del puesto en el historial */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio en el puesto */
    fecha_fin DATE NOT NULL, /* Fecha de fin en el puesto */
    departamento INT NOT NULL, /* Departamento del empleado */
    cedula_empleado INT NOT NULL, /* Cédula del empleado */
	PRIMARY KEY (HistoricoPuesto_id,puesto,fecha_inicio,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
	FOREIGN KEY (puesto) REFERENCES Puesto(puesto_id), /* Llave foránea a Puesto */
	FOREIGN KEY (departamento) REFERENCES Departamento(departamento_id) /* Llave foránea a Departamento */
);

/* Tabla para almacenar los pagos de salarios mensuales de los empleados */
CREATE TABLE SalarioMensual (
	anno INT NOT NULL, /* Año del pago */
	mes INT NOT NULL, /* Mes del pago (1-12) */
    pago FLOAT NOT NULL, /* Monto del pago */
	cantidad_horas INT NOT NULL, /* Cantidad de horas trabajadas */
	cedula_empleado INT NOT NULL, /* Cédula del empleado */
	PRIMARY KEY (anno,mes,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
	CONSTRAINT chk_anno CHECK (anno > 1980), /* Validación del año */
	CONSTRAINT chk_mes CHECK (mes BETWEEN 1 AND 12) /* Validación del mes */
);

-----------TABLAS GENERALES------------
/* Tabla para gestionar las zonas geográficas */
CREATE TABLE Zona (
	zona_id INT PRIMARY KEY,
	nombre varchar(75) NOT NULL
);

/* Tabla para gestionar los sectores industriales */
CREATE TABLE Sector (
	sector_id INT PRIMARY KEY,
	nombre varchar(75) NOT NULL
);

-----------MODULO CLIENTE------------
/* Tabla para gestionar la información de los clientes */
CREATE TABLE Cliente (
    cedula_juridica INT PRIMARY KEY, /* Cédula Juridica del cliente */
    nombre VARCHAR(255) NOT NULL, /* Nombre del cliente */
	correo VARCHAR(200) NOT NULL, /*Correo del cliente*/
	telefono INT NOT NULL, /* Teléfono del cliente */
	celular INT NOT NULL, /* Celular del cliente */
	fax VARCHAR(50) NOT NULL, /* Fax del cliente */
    zona INT NOT NULL, /* Zona geográfica del cliente */
    sector INT NOT NULL /* Sector del cliente */
	FOREIGN KEY (zona) REFERENCES Zona(zona_id),
	FOREIGN KEY (sector) REFERENCES Sector(sector_id)
);


-----------MODULO INVENTARIO------------
/* Tabla para almacenar las familias de productos en el inventario */
CREATE TABLE Familia (
    codigo INT PRIMARY KEY, /* Código único de la familia */
    nombre VARCHAR(25) NOT NULL, /* Nombre de la familia */
	activo VARCHAR(25) NOT NULL, /*Nombre del activo*/
    descripcion VARCHAR(255) NOT NULL /* Descripción de la familia */
);

/* Tabla para almacenar los artículos en el inventario */
CREATE TABLE Articulo (
    codigo INT PRIMARY KEY, /* Código único del artículo */
    nombre VARCHAR(25) NOT NULL, /* Nombre del artículo */
    cantidad INT NOT NULL, /* Cantidad en inventario */
	activo VARCHAR(50) NOT NULL, /* Estado del artículo (Activo/Inactivo) */
    descripcion VARCHAR(255) NOT NULL, /* Descripción del artículo */
    peso FLOAT NOT NULL, /* Peso del artículo */
	costo FLOAT NOT NULL, /* Costo del artículo */
    precio_estandar FLOAT NOT NULL, /* Precio estándar del artículo */
    codigo_familia INT NOT NULL, /* Código de la familia a la que pertenece el artículo */
    FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo) /* Llave foránea a la tabla Familia */
);

/* Tabla para almacenar información sobre las bodegas */
CREATE TABLE Bodega (
    codigo_bodega INT PRIMARY KEY, /* Código único de la bodega */
    numero INT NOT NULL, /* Número de identificación de la bodega */
    ubicacion VARCHAR(25) NOT NULL, /* Ubicación de la bodega */
    capacidad INT NOT NULL, /* Capacidad total de la bodega */
	espacio_cubico FLOAT /* Espacio cúbico disponible en la bodega */
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
	codigo_entrada INT PRIMARY KEY NOT NULL, /* Codigo de entrada llave primaria */
    fecha_hora DATETIME NOT NULL, /* Fecha y hora de la entrada */
    codigo_bodega INT NOT NULL, /* Código de la bodega donde ingresan los productos */
    cedula_administrador INT NOT NULL, /* Cédula del administrador responsable */
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega) /* Llave foránea a Bodega */
);

/* Tabla para registrar los artículos que ingresan en una entrada específica */
CREATE TABLE EntradaArticulo (
	codigo_entrada INT NOT NULL, /* codigo de entrada */
    fecha_hora_entrada DATETIME NOT NULL, /* Fecha y hora de la entrada */
	codigo_bodega INT NOT NULL, /* Código de la bodega */
    cedula_administrador INT NOT NULL, /* Cédula del administrador */
	codigo_articulo INT NOT NULL, /* Código del artículo ingresado */
	cantidad INT NOT NULL, /* Cantidad de productos ingresados */
    FOREIGN KEY(codigo_entrada) REFERENCES Entrada(codigo_entrada), /* Llave foránea a Entrada */
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

/* Tabla para registrar movimientos de artículos entre bodegas */
CREATE TABLE Movimiento (
	codigo_movimiento INT PRIMARY KEY NOT NULL, /*Código de movimiento llave primaria*/
    fecha_hora DATETIME NOT NULL, /* Fecha y hora del movimiento */
    cedula_administrador INT NOT NULL, /* Cédula del administrador */
    codigo_bodega_origen INT NOT NULL, /* Bodega de origen */
    codigo_bodega_destino INT NOT NULL, /* Bodega de destino */
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (codigo_bodega_origen) REFERENCES Bodega(codigo_bodega), /* Llave foránea a Bodega de origen */
    FOREIGN KEY (codigo_bodega_destino) REFERENCES Bodega(codigo_bodega) /* Llave foránea a Bodega de destino */
);

/* Tabla para registrar los artículos movidos entre bodegas en un movimiento específico */
CREATE TABLE MovimientoArticulo (
	codigo_movimiento INT NOT NULL, /*Código de movimiento llave primaria*/
    fecha_hora_movimiento DATETIME NOT NULL, /* Fecha y hora del movimiento */
    cedula_administrador INT NOT NULL, /* Cédula del administrador */
    codigo_bodega_origen INT NOT NULL, /* Bodega de origen */
    codigo_bodega_destino INT NOT NULL, /* Bodega de destino */
	codigo_articulo INT NOT NULL, /* Código del artículo */
	cantidad INT NOT NULL, /* Cantidad movida */
	FOREIGN KEY (codigo_movimiento) REFERENCES Movimiento(codigo_movimiento), /*Llave foránea a Movimiento*/
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

-----------MODULO COTIZACION------------
/* Tabla para gestionar los estados de cotización */
CREATE TABLE EstadoCotizacion (
	estadocotizacion_id INT PRIMARY KEY NOT NULL,
	nombre varchar(75)
);

/* Tabla para gestionar los tipos de cotizaciones */
CREATE TABLE TipoCotizacion (
	tipocotizacion_id INT PRIMARY KEY NOT NULL,
	nombre varchar(75)
);

/* Tabla para gestionar las cotizaciones realizadas a los clientes */
CREATE TABLE Cotizacion (
    num_cotizacion INT PRIMARY KEY, /* Número único de la cotización */
	orden_compra VARCHAR(50) NOT NULL, /* Orden de compra asociada */
	tipo INT NOT NULL, /* Tipo de cotización */
	descripcion VARCHAR(255) NOT NULL, /* Descripción de la cotización */
	zona INT NOT NULL, /* Zona de la cotización */
    sector INT NOT NULL, /* Sector de la cotización */
	estado INT NOT NULL, /* Estado de la cotización (abierta, aprobada, denegada) */
	monto_total FLOAT NOT NULL, /* Monto total de la cotización */
	mes_cierre INT NOT NULL, /* Mes estimado de cierre de la cotización */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor encargado */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio de la cotización */
    fecha_cierre DATE NOT NULL, /* Fecha de cierre de la cotización */
    probabilidad FLOAT NOT NULL, /* Probabilidad de éxito de la cotización */
	razon_negacion VARCHAR(255) NOT NULL, /* Razón de negación si corresponde */
	cedula_cliente INT NOT NULL, /* Cédula del cliente */
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
	FOREIGN KEY (cedula_cliente) REFERENCES Cliente(cedula_juridica), /* Llave foránea a Cliente */
	CONSTRAINT chk_mes_cierre CHECK (mes_cierre BETWEEN 1 AND 12), /* Validación del mes de cierre */
	CONSTRAINT chk_probabilidad CHECK (probabilidad >= 1.00 AND probabilidad <= 100.00), /* Validación de probabilidad de éxito */
	FOREIGN KEY (zona) REFERENCES Zona(zona_id),
	FOREIGN KEY (sector) REFERENCES Sector(sector_id),
	FOREIGN KEY (estado) REFERENCES EstadoCotizacion(estadocotizacion_id),
	FOREIGN KEY (tipo) REFERENCES TipoCotizacion(tipocotizacion_id)
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
	monto FLOAT NOT NULL, /* Monto correspondiente */
	PRIMARY KEY (codigo_articulo, num_cotizacion), /* Llave primaria compuesta */
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion), /* Llave foránea a Cotización */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

-----------MODULO FACTURACION------------
/* Tabla para gestionar los estados de factura */
CREATE TABLE EstadoFactura (
	estadofactura_id INT PRIMARY KEY NOT NULL,
	nombre varchar(75)
);

/* Tabla para gestionar las facturas emitidas */
CREATE TABLE Factura (
    num_facturacion INT PRIMARY KEY, /* Número único de la factura */
    telefono_local INT NOT NULL, /* Teléfono del local */
    cedula_juridica INT NOT NULL, /* Cédula jurídica del cliente */
    nombre_local VARCHAR(200) NOT NULL, /* Nombre del local del cliente */
	fecha DATE NOT NULL, /* Fecha de emisión de la factura */
    estado INT NOT NULL, /* Estado de la factura (pagada, pendiente, etc.) */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor */
	num_cotizacion INT,
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion),
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (cedula_juridica) REFERENCES Cliente(cedula_juridica), /* Llave foránea a Cliente */
	FOREIGN KEY (estado) REFERENCES EstadoFactura(estadofactura_id) /* Llave foránea a Cliente */
);-----------------------------------------------------------------------------------------------------------------------------------------------Agregue num cotizacion

/* Tabla que asocia artículos con facturas */
CREATE TABLE FacturaArticulo (
    num_facturacion INT NOT NULL, /* Número de la factura */
    codigo_articulo INT NOT NULL, /* Código del artículo */
	cantidad INT NOT NULL, /* Cantidad de articulos*/
	monto FLOAT NOT NULL, /*Monto del articulo*/
    FOREIGN KEY (num_facturacion) REFERENCES Factura(num_facturacion), /* Llave foránea a Factura */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave foránea a Artículo */
);

/* Tabla para registrar las salidas de productos de una bodega */
CREATE TABLE Salida (
	fecha_hora DATETIME NOT NULL, /* Fecha y hora de la salida */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor */
    codigo_bodega INT NOT NULL, /* Código de la bodega de salida */
	factura INT NOT NULL,
    PRIMARY KEY (fecha_hora,cedula_vendedor, codigo_bodega), /* Llave primaria compuesta */
	FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave foránea a Empleado */
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega), /* Llave foránea a Bodega */
	FOREIGN KEY (factura) REFERENCES Factura(num_facturacion) /* Llave foránea a Bodega */
);

/* Tabla para registrar los artículos que salen de una bodega en una salida específica */
CREATE TABLE SalidaArticulo (
	fecha_hora_salida DATETIME NOT NULL, /* Fecha y hora de la salida */
    cedula_vendedor INT NOT NULL, /* Cédula del vendedor */
    codigo_bodega INT NOT NULL, /* Código de la bodega de salida */
    codigo_articulo INT NOT NULL, /* Código del artículo */
	cantidad INT NOT NULL, /* Cantidad de articulos fuera de la bodega*/
    PRIMARY KEY (codigo_articulo, fecha_hora_salida,cedula_vendedor, codigo_bodega), /* Llave primaria compuesta */
    FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo), /* Llave foránea a Artículo */
    FOREIGN KEY (fecha_hora_salida,cedula_vendedor, codigo_bodega) REFERENCES Salida(fecha_hora,cedula_vendedor, codigo_bodega) /* Llave foránea a Salida */
);
-----------MODULO REGISTRO DE CASOS------------
/* Tabla para gestionar los tipos de cotizaciones */
CREATE TABLE TipoCaso (
	tipocaso_id INT PRIMARY KEY,
	nombre varchar(75) NOT NULL
);

/* Tabla para gestionar los tipos de cotizaciones */
CREATE TABLE EstadoCaso (
	estado_id INT PRIMARY KEY,
	nombre varchar(75) NOT NULL
);

CREATE TABLE PrioridadCaso (
	prioridad_id INT PRIMARY KEY,
	nombre varchar(75) NOT NULL
);

/* Tabla para registrar casos relacionados con cotizaciones o facturas */
CREATE TABLE Caso (
    codigo INT PRIMARY KEY, /* Código único del caso */
	nombre_cuenta VARCHAR(255) NOT NULL, /* Nombre de la cuenta asociada */
	nombre_contacto VARCHAR(60) NOT NULL, /* Nombre del contacto relacionado */
	asunto VARCHAR(255) NOT NULL, /* Asunto del caso */
	direccion VARCHAR(255) NOT NULL, /* Dirección relacionada al caso */
	descripcion VARCHAR(255) NOT NULL, /* Descripción del caso */
	estado INT NOT NULL, /* Estado del caso */
	tipo INT NOT NULL, /* Tipo del caso (soporte, reclamo, etc.) */
	prioridad INT NOT NULL, /* Prioridad del caso */
	cedula_propietario INT NOT NULL, /* Cédula del propietario del caso */
	origen_cotizacion INT, /* Referencia a la cotización de origen, si aplica */
    origen_factura INT, /* Referencia a la factura de origen, si aplica */

	FOREIGN KEY (cedula_propietario) REFERENCES Empleado(cedula),
    FOREIGN KEY (origen_cotizacion) REFERENCES Cotizacion(num_cotizacion), /* Llave foránea a Cotización */
    FOREIGN KEY (origen_factura) REFERENCES Factura(num_facturacion), /* Llave foránea a Factura */
	FOREIGN KEY (tipo) REFERENCES TipoCaso(tipocaso_id), /* Llave foránea a TipoCaso */
	FOREIGN KEY (prioridad) REFERENCES PrioridadCaso(prioridad_id), /* Llave foránea a TipoCaso */
	FOREIGN KEY (estado) REFERENCES EstadoCaso(estado_id), /* Llave foránea a TipoCaso */
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
	FOREIGN KEY (cedula_usuario) REFERENCES Empleado(cedula) /* Llave foránea a Empleado */
);
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
    rol VARCHAR(15) NOT NULL, /* Rol del empleado (Edici�n, Visualizaci�n, Reporter�a) */
	CONSTRAINT chk_rol CHECK (rol IN ('Edici�n', 'Visualizaci�n', 'Reporter�a')) /* Validaci�n de los roles permitidos */
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
	nombre varchar(200)�NOT�NULL,
);

CREATE TABLE Puesto (
	puesto_id INT PRIMARY KEY,
	puesto VARCHAR(200) NOT NULL,
);

/* Tabla para almacenar informaci�n de los empleados */
CREATE TABLE Empleado (
    cedula INT PRIMARY KEY NOT NULL, /* Identificador �nico del empleado */
    nombre VARCHAR(25) NOT NULL, /* Nombre del empleado */
    apellido1 VARCHAR(25) NOT NULL, /* Primer apellido del empleado */
    apellido2 VARCHAR(25) NOT NULL, /* Segundo apellido del empleado */
    fecha_nacimiento DATE NOT NULL, /* Fecha de nacimiento del empleado */
    genero VARCHAR(50) NOT NULL, /* G�nero del empleado (Masculino, Femenino, Otro) */
	residencia VARCHAR(80) NOT NULL, /* Lugar en el que reside*/
	fecha_ingreso DATE NOT NULL, /* Fecha en que ingres� a la empresa */
    departamento INT NOT NULL, /* Departamento al que pertenece el empleado */
    permiso_vendedor VARCHAR(20) NOT NULL, /* Permiso de vendedor (Con permiso, Sin permiso) */
    numero_telefono INT NOT NULL, /* N�mero de tel�fono del empleado */
    salario_actual FLOAT NOT NULL, /* Salario actual del empleado */
	puesto INT NOT NULL, /* Puesto que ocupa el empleado */
	CONSTRAINT chk_genero CHECK (genero IN ('Masculino', 'Femenino', 'Otro')), /* Restricci�n para validar el g�nero */
	CONSTRAINT chk_permisos_vendedor CHECK (permiso_vendedor IN ('Con permiso', 'Sin permiso')), /* Validaci�n para permisos de vendedor */
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
    cedula_empleado INT NOT NULL, /* C�dula del empleado */
    PRIMARY KEY (HistoricoSalario_id,puesto,fecha_inicio,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
	FOREIGN KEY (puesto) REFERENCES Puesto(puesto_id), /* Llave for�nea a Puesto */
	FOREIGN KEY (departamento) REFERENCES Departamento(departamento_id) /* Llave for�nea a Departamento */
);

/* Tabla para registrar el historial de puestos de los empleados */
CREATE TABLE HistoricoPuesto (
	HistoricoPuesto_id INT NOT NULL,
    puesto INT NOT NULL, /* Nombre del puesto en el historial */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio en el puesto */
    fecha_fin DATE NOT NULL, /* Fecha de fin en el puesto */
    departamento INT NOT NULL, /* Departamento del empleado */
    cedula_empleado INT NOT NULL, /* C�dula del empleado */
	PRIMARY KEY (HistoricoPuesto_id,puesto,fecha_inicio,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
	FOREIGN KEY (puesto) REFERENCES Puesto(puesto_id), /* Llave for�nea a Puesto */
	FOREIGN KEY (departamento) REFERENCES Departamento(departamento_id) /* Llave for�nea a Departamento */
);

/* Tabla para almacenar los pagos de salarios mensuales de los empleados */
CREATE TABLE SalarioMensual (
	anno INT NOT NULL, /* A�o del pago */
	mes INT NOT NULL, /* Mes del pago (1-12) */
    pago FLOAT NOT NULL, /* Monto del pago */
	cantidad_horas INT NOT NULL, /* Cantidad de horas trabajadas */
	cedula_empleado INT NOT NULL, /* C�dula del empleado */
	PRIMARY KEY (anno,mes,cedula_empleado), /* Llave primaria compuesta */
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
	CONSTRAINT chk_anno CHECK (anno > 1980), /* Validaci�n del a�o */
	CONSTRAINT chk_mes CHECK (mes BETWEEN 1 AND 12) /* Validaci�n del mes */
);

-----------TABLAS GENERALES------------
/* Tabla para gestionar las zonas geogr�ficas */
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
/* Tabla para gestionar la informaci�n de los clientes */
CREATE TABLE Cliente (
    cedula_juridica INT PRIMARY KEY, /* C�dula Juridica del cliente */
    nombre VARCHAR(255) NOT NULL, /* Nombre del cliente */
	correo VARCHAR(200) NOT NULL, /*Correo del cliente*/
	telefono INT NOT NULL, /* Tel�fono del cliente */
	celular INT NOT NULL, /* Celular del cliente */
	fax VARCHAR(50) NOT NULL, /* Fax del cliente */
    zona INT NOT NULL, /* Zona geogr�fica del cliente */
    sector INT NOT NULL /* Sector del cliente */
	FOREIGN KEY (zona) REFERENCES Zona(zona_id),
	FOREIGN KEY (sector) REFERENCES Sector(sector_id)
);


-----------MODULO INVENTARIO------------
/* Tabla para almacenar las familias de productos en el inventario */
CREATE TABLE Familia (
    codigo INT PRIMARY KEY, /* C�digo �nico de la familia */
    nombre VARCHAR(25) NOT NULL, /* Nombre de la familia */
	activo VARCHAR(25) NOT NULL, /*Nombre del activo*/
    descripcion VARCHAR(255) NOT NULL /* Descripci�n de la familia */
);

/* Tabla para almacenar los art�culos en el inventario */
CREATE TABLE Articulo (
    codigo INT PRIMARY KEY, /* C�digo �nico del art�culo */
    nombre VARCHAR(25) NOT NULL, /* Nombre del art�culo */
    cantidad INT NOT NULL, /* Cantidad en inventario */
	activo VARCHAR(50) NOT NULL, /* Estado del art�culo (Activo/Inactivo) */
    descripcion VARCHAR(255) NOT NULL, /* Descripci�n del art�culo */
    peso FLOAT NOT NULL, /* Peso del art�culo */
	costo FLOAT NOT NULL, /* Costo del art�culo */
    precio_estandar FLOAT NOT NULL, /* Precio est�ndar del art�culo */
    codigo_familia INT NOT NULL, /* C�digo de la familia a la que pertenece el art�culo */
    FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo) /* Llave for�nea a la tabla Familia */
);

/* Tabla para almacenar informaci�n sobre las bodegas */
CREATE TABLE Bodega (
    codigo_bodega INT PRIMARY KEY, /* C�digo �nico de la bodega */
    numero INT NOT NULL, /* N�mero de identificaci�n de la bodega */
    ubicacion VARCHAR(25) NOT NULL, /* Ubicaci�n de la bodega */
    capacidad INT NOT NULL, /* Capacidad total de la bodega */
	espacio_cubico FLOAT /* Espacio c�bico disponible en la bodega */
);

/* Tabla que asocia familias de productos a bodegas */
CREATE TABLE BodegaFamilia (
	codigo_bodega INT NOT NULL, /* C�digo de la bodega */
	codigo_familia INT NOT NULL, /* C�digo de la familia */
	PRIMARY KEY (codigo_bodega,codigo_familia), /* Llave primaria compuesta */
	FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega), /* Llave for�nea a Bodega */
	FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo) /* Llave for�nea a Familia */
);

/* Tabla que asocia art�culos a bodegas y registra su cantidad en cada bodega */
CREATE TABLE BodegaArticulo (
	codigo_bodega INT NOT NULL, /* C�digo de la bodega */
	codigo_articulo INT NOT NULL, /* C�digo del art�culo */
	cantidad INT NOT NULL, /* Cantidad de art�culos en la bodega */
	PRIMARY KEY (codigo_bodega,codigo_articulo), /* Llave primaria compuesta */
	FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega), /* Llave for�nea a Bodega */
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo) /* Llave for�nea a Art�culo */
);

/* Tabla para registrar las entradas de productos en una bodega */
CREATE TABLE Entrada (
	codigo_entrada INT PRIMARY KEY NOT NULL, /* Codigo de entrada llave primaria */
    fecha_hora DATETIME NOT NULL, /* Fecha y hora de la entrada */
    codigo_bodega INT NOT NULL, /* C�digo de la bodega donde ingresan los productos */
    cedula_administrador INT NOT NULL, /* C�dula del administrador responsable */
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega) /* Llave for�nea a Bodega */
);

/* Tabla para registrar los art�culos que ingresan en una entrada espec�fica */
CREATE TABLE EntradaArticulo (
	codigo_entrada INT NOT NULL, /* codigo de entrada */
    fecha_hora_entrada DATETIME NOT NULL, /* Fecha y hora de la entrada */
	codigo_bodega INT NOT NULL, /* C�digo de la bodega */
    cedula_administrador INT NOT NULL, /* C�dula del administrador */
	codigo_articulo INT NOT NULL, /* C�digo del art�culo ingresado */
	cantidad INT NOT NULL, /* Cantidad de productos ingresados */
    FOREIGN KEY(codigo_entrada) REFERENCES Entrada(codigo_entrada), /* Llave for�nea a Entrada */
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo) /* Llave for�nea a Art�culo */
);

/* Tabla para registrar movimientos de art�culos entre bodegas */
CREATE TABLE Movimiento (
	codigo_movimiento INT PRIMARY KEY NOT NULL, /*C�digo de movimiento llave primaria*/
    fecha_hora DATETIME NOT NULL, /* Fecha y hora del movimiento */
    cedula_administrador INT NOT NULL, /* C�dula del administrador */
    codigo_bodega_origen INT NOT NULL, /* Bodega de origen */
    codigo_bodega_destino INT NOT NULL, /* Bodega de destino */
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
    FOREIGN KEY (codigo_bodega_origen) REFERENCES Bodega(codigo_bodega), /* Llave for�nea a Bodega de origen */
    FOREIGN KEY (codigo_bodega_destino) REFERENCES Bodega(codigo_bodega) /* Llave for�nea a Bodega de destino */
);

/* Tabla para registrar los art�culos movidos entre bodegas en un movimiento espec�fico */
CREATE TABLE MovimientoArticulo (
	codigo_movimiento INT NOT NULL, /*C�digo de movimiento llave primaria*/
    fecha_hora_movimiento DATETIME NOT NULL, /* Fecha y hora del movimiento */
    cedula_administrador INT NOT NULL, /* C�dula del administrador */
    codigo_bodega_origen INT NOT NULL, /* Bodega de origen */
    codigo_bodega_destino INT NOT NULL, /* Bodega de destino */
	codigo_articulo INT NOT NULL, /* C�digo del art�culo */
	cantidad INT NOT NULL, /* Cantidad movida */
	FOREIGN KEY (codigo_movimiento) REFERENCES Movimiento(codigo_movimiento), /*Llave for�nea a Movimiento*/
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave for�nea a Art�culo */
);

-----------MODULO COTIZACION------------
/* Tabla para gestionar los estados de cotizaci�n */
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
    num_cotizacion INT PRIMARY KEY, /* N�mero �nico de la cotizaci�n */
	orden_compra VARCHAR(50) NOT NULL, /* Orden de compra asociada */
	tipo INT NOT NULL, /* Tipo de cotizaci�n */
	descripcion VARCHAR(255) NOT NULL, /* Descripci�n de la cotizaci�n */
	zona INT NOT NULL, /* Zona de la cotizaci�n */
    sector INT NOT NULL, /* Sector de la cotizaci�n */
	estado INT NOT NULL, /* Estado de la cotizaci�n (abierta, aprobada, denegada) */
	monto_total FLOAT NOT NULL, /* Monto total de la cotizaci�n */
	mes_cierre INT NOT NULL, /* Mes estimado de cierre de la cotizaci�n */
    cedula_vendedor INT NOT NULL, /* C�dula del vendedor encargado */
    fecha_inicio DATE NOT NULL, /* Fecha de inicio de la cotizaci�n */
    fecha_cierre DATE NOT NULL, /* Fecha de cierre de la cotizaci�n */
    probabilidad FLOAT NOT NULL, /* Probabilidad de �xito de la cotizaci�n */
	razon_negacion VARCHAR(255) NOT NULL, /* Raz�n de negaci�n si corresponde */
	cedula_cliente INT NOT NULL, /* C�dula del cliente */
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
	FOREIGN KEY (cedula_cliente) REFERENCES Cliente(cedula_juridica), /* Llave for�nea a Cliente */
	CONSTRAINT chk_mes_cierre CHECK (mes_cierre BETWEEN 1 AND 12), /* Validaci�n del mes de cierre */
	CONSTRAINT chk_probabilidad CHECK (probabilidad >= 1.00 AND probabilidad <= 100.00), /* Validaci�n de probabilidad de �xito */
	FOREIGN KEY (zona) REFERENCES Zona(zona_id),
	FOREIGN KEY (sector) REFERENCES Sector(sector_id),
	FOREIGN KEY (estado) REFERENCES EstadoCotizacion(estadocotizacion_id),
	FOREIGN KEY (tipo) REFERENCES TipoCotizacion(tipocotizacion_id)
);

/* Tabla para gestionar las tareas relacionadas con las cotizaciones */
CREATE TABLE TareaCotizacion (
	codigo_tarea INT NOT NULL, /* C�digo �nico de la tarea */
	descripcion VARCHAR(255) NOT NULL, /* Descripci�n de la tarea */
    num_cotizacion INT NOT NULL, /* N�mero de la cotizaci�n asociada */
	PRIMARY KEY (codigo_tarea, num_cotizacion), /* Llave primaria compuesta */
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion) /* Llave for�nea a Cotizaci�n */
);

/* Tabla que asocia art�culos con cotizaciones */
CREATE TABLE CotizacionArticulo (
	codigo_articulo INT NOT NULL, /* C�digo del art�culo */
    num_cotizacion INT NOT NULL, /* N�mero de la cotizaci�n */
	cantidad INT NOT NULL, /* Cantidad del art�culo en la cotizaci�n */
	monto FLOAT NOT NULL, /* Monto correspondiente */
	PRIMARY KEY (codigo_articulo, num_cotizacion), /* Llave primaria compuesta */
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion), /* Llave for�nea a Cotizaci�n */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave for�nea a Art�culo */
);

-----------MODULO FACTURACION------------
/* Tabla para gestionar los estados de factura */
CREATE TABLE EstadoFactura (
	estadofactura_id INT PRIMARY KEY NOT NULL,
	nombre varchar(75)
);

/* Tabla para gestionar las facturas emitidas */
CREATE TABLE Factura (
    num_facturacion INT PRIMARY KEY, /* N�mero �nico de la factura */
    telefono_local INT NOT NULL, /* Tel�fono del local */
    cedula_juridica INT NOT NULL, /* C�dula jur�dica del cliente */
    nombre_local VARCHAR(200) NOT NULL, /* Nombre del local del cliente */
	fecha DATE NOT NULL, /* Fecha de emisi�n de la factura */
    estado INT NOT NULL, /* Estado de la factura (pagada, pendiente, etc.) */
    cedula_vendedor INT NOT NULL, /* C�dula del vendedor */
	num_cotizacion INT,
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion),
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
    FOREIGN KEY (cedula_juridica) REFERENCES Cliente(cedula_juridica), /* Llave for�nea a Cliente */
	FOREIGN KEY (estado) REFERENCES EstadoFactura(estadofactura_id) /* Llave for�nea a Cliente */
);-----------------------------------------------------------------------------------------------------------------------------------------------Agregue num cotizacion

/* Tabla que asocia art�culos con facturas */
CREATE TABLE FacturaArticulo (
    num_facturacion INT NOT NULL, /* N�mero de la factura */
    codigo_articulo INT NOT NULL, /* C�digo del art�culo */
	cantidad INT NOT NULL, /* Cantidad de articulos*/
	monto FLOAT NOT NULL, /*Monto del articulo*/
    FOREIGN KEY (num_facturacion) REFERENCES Factura(num_facturacion), /* Llave for�nea a Factura */
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo) /* Llave for�nea a�Art�culo�*/
);

/* Tabla para registrar las salidas de productos de una bodega */
CREATE TABLE Salida (
	fecha_hora DATETIME NOT NULL, /* Fecha y hora de la salida */
    cedula_vendedor INT NOT NULL, /* C�dula del vendedor */
    codigo_bodega INT NOT NULL, /* C�digo de la bodega de salida */
	factura INT NOT NULL,
    PRIMARY KEY (fecha_hora,cedula_vendedor, codigo_bodega), /* Llave primaria compuesta */
	FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula), /* Llave for�nea a Empleado */
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega), /* Llave for�nea a Bodega */
	FOREIGN KEY (factura) REFERENCES Factura(num_facturacion) /* Llave for�nea a Bodega */
);

/* Tabla para registrar los art�culos que salen de una bodega en una salida espec�fica */
CREATE TABLE SalidaArticulo (
	fecha_hora_salida DATETIME NOT NULL, /* Fecha y hora de la salida */
    cedula_vendedor INT NOT NULL, /* C�dula del vendedor */
    codigo_bodega INT NOT NULL, /* C�digo de la bodega de salida */
    codigo_articulo INT NOT NULL, /* C�digo del art�culo */
	cantidad INT NOT NULL, /* Cantidad de articulos fuera de la bodega*/
    PRIMARY KEY (codigo_articulo, fecha_hora_salida,cedula_vendedor, codigo_bodega), /* Llave primaria compuesta */
    FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo), /* Llave for�nea a Art�culo */
    FOREIGN KEY (fecha_hora_salida,cedula_vendedor, codigo_bodega) REFERENCES Salida(fecha_hora,cedula_vendedor, codigo_bodega) /* Llave for�nea a Salida */
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
    codigo INT PRIMARY KEY, /* C�digo �nico del caso */
	nombre_cuenta VARCHAR(255) NOT NULL, /* Nombre de la cuenta asociada */
	nombre_contacto VARCHAR(60) NOT NULL, /* Nombre del contacto relacionado */
	asunto VARCHAR(255) NOT NULL, /* Asunto del caso */
	direccion VARCHAR(255) NOT NULL, /* Direcci�n relacionada al caso */
	descripcion VARCHAR(255) NOT NULL, /* Descripci�n del caso */
	estado INT NOT NULL, /* Estado del caso */
	tipo INT NOT NULL, /* Tipo del caso (soporte, reclamo, etc.) */
	prioridad INT NOT NULL, /* Prioridad del caso */
	cedula_propietario INT NOT NULL, /* C�dula del propietario del caso */
	origen_cotizacion INT, /* Referencia a la cotizaci�n de origen, si aplica */
    origen_factura INT, /* Referencia a la factura de origen, si aplica */

	FOREIGN KEY (cedula_propietario) REFERENCES Empleado(cedula),
    FOREIGN KEY (origen_cotizacion) REFERENCES Cotizacion(num_cotizacion), /* Llave for�nea a Cotizaci�n */
    FOREIGN KEY (origen_factura) REFERENCES Factura(num_facturacion), /* Llave for�nea a Factura */
	FOREIGN KEY (tipo) REFERENCES TipoCaso(tipocaso_id), /* Llave for�nea a TipoCaso */
	FOREIGN KEY (prioridad) REFERENCES PrioridadCaso(prioridad_id), /* Llave for�nea a TipoCaso */
	FOREIGN KEY (estado) REFERENCES EstadoCaso(estado_id), /* Llave for�nea a TipoCaso */
    CONSTRAINT chk_origen CHECK ((origen_cotizacion IS NOT NULL AND origen_factura IS NULL) OR (origen_cotizacion IS NULL AND origen_factura IS NOT NULL)) /* Validaci�n para evitar referencias simult�neas a cotizaci�n y factura */
);

/* Tabla para registrar las tareas asociadas a los casos */
CREATE TABLE TareaCaso (
	codigo_tarea INT PRIMARY KEY, /*C�digo de la tarea*/
	codigo_caso INT NOT NULL, /* C�digo del caso asociado */
	fecha DATE NOT NULL, /* Fecha de la tarea */
	descripcion VARCHAR(255) NOT NULL, /* Descripci�n de la tarea */
	cedula_usuario INT NOT NULL, /* C�dula del usuario asignado */
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo), /* Llave for�nea a Caso */
	FOREIGN KEY (cedula_usuario) REFERENCES Empleado(cedula) /* Llave for�nea a�Empleado�*/
);
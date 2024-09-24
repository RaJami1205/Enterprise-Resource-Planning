if not exists (select[name] from sys.databases where [name]=N'ERP')
begin
	create database ERP
end;

use master
go

use ERP;
go

-----------MODULO USUARIO------------
CREATE TABLE Empleado (
    cedula INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellido1 VARCHAR(255) NOT NULL,
    apellido2 VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero VARCHAR(50) NOT NULL,
	edad INT NOT NULL,
	fecha_ingreso DATE NOT NULL,
    departamento VARCHAR(25) NOT NULL,
    permiso_vendedor VARCHAR(20) NOT NULL,
    numero_telefono INT NOT NULL,
    salario_actual INT NOT NULL,
	puesto VARCHAR(40) NOT NULL,
	CONSTRAINT chk_genero CHECK (genero IN ('Masculino', 'Femenino', 'Otro')),
	CONSTRAINT chk_permisos_vendedor CHECK (permiso_vendedor IN ('Con permiso', 'Sin permiso')),
	CONSTRAINT chk_edad CHECK (edad BETWEEN 18 AND 80)
);

CREATE TABLE Rol (
    rol VARCHAR(15) NOT NULL,
    cedula_empleado INT NOT NULL,
    PRIMARY KEY (rol,cedula_empleado),
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula),
	CONSTRAINT chk_rol CHECK (rol IN ('Edición', 'Visualización', 'Reportería'))
);


CREATE TABLE HistoricoSalario (
    nombre_puesto INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    departamento VARCHAR(25) NOT NULL,
    monto INT NOT NULL,
    cedula_empleado INT NOT NULL,
    PRIMARY KEY (nombre_puesto,fecha_inicio,cedula_empleado),
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula)
);

CREATE TABLE HistoricoPuesto (
    nombre_puesto INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    departamento VARCHAR(25) NOT NULL,
    cedula_empleado INT NOT NULL,
	PRIMARY KEY (nombre_puesto,fecha_inicio,cedula_empleado),
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula)
);

CREATE TABLE Salario (
	anno INT NOT NULL,
	mes INT NOT NULL,
    pago DECIMAL(10,2) NOT NULL, --El pago calculado
	cantidad_horas INT NOT NULL,
	cedula_empleado INT NOT NULL,
	PRIMARY KEY (pago,cedula_empleado),
    FOREIGN KEY (cedula_empleado) REFERENCES Empleado(cedula),
	CONSTRAINT chk_anno CHECK (anno > 1980),
	CONSTRAINT chk_mes CHECK (mes BETWEEN 1 AND 12)
);

-----------MODULO INVENTARIO------------

CREATE TABLE Familia (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Articulo (
    codigo INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL,
	activo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    peso INT NOT NULL,
	costo INT NOT NULL,
    precio_estandar INT NOT NULL,
    codigo_familia INT NOT NULL,
    FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo)
);

CREATE TABLE Bodega (
    codigo_bodega INT PRIMARY KEY,
    numero INT NOT NULL,
    ubicacion VARCHAR(255) NOT NULL,
    capacidad INT NOT NULL,
	espacio_cubico DECIMAL(10,2),
);

CREATE TABLE BodegaFamilia (
	codigo_bodega INT NOT NULL,
	codigo_familia INT NOT NULL,
	PRIMARY KEY (codigo_bodega,codigo_familia),
	FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega),
	FOREIGN KEY (codigo_familia) REFERENCES Familia(codigo)
);

CREATE TABLE BodegaArticulo (
	codigo_bodega INT NOT NULL,
	codigo_articulo INT NOT NULL,
	cantidad INT NOT NULL,
	PRIMARY KEY (codigo_bodega,codigo_articulo),
	FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega),
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo)
);

CREATE TABLE Entrada (
    fecha_hora DATETIME NOT NULL,
    cantidad INT NOT NULL,
    precio INT NOT NULL,
    codigo_bodega INT NOT NULL,
    cedula_administrador INT NOT NULL,
	PRIMARY KEY(fecha_hora,cedula_administrador,codigo_bodega),
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula),
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega)
);

CREATE TABLE EntradaArticulo (
    fecha_hora_entrada DATETIME NOT NULL,
	codigo_bodega INT NOT NULL,
    cedula_administrador INT NOT NULL,
	codigo_articulo INT NOT NULL,
	cantidad INT NOT NULL,
	PRIMARY KEY(fecha_hora_entrada,cedula_administrador,codigo_bodega,codigo_articulo),
    FOREIGN KEY(fecha_hora_entrada,cedula_administrador,codigo_bodega) REFERENCES Entrada(fecha_hora,cedula_administrador,codigo_bodega),
	FOREIGN KEY(codigo_articulo) REFERENCES Articulo(codigo)
);

CREATE TABLE Movimiento (
    fecha_hora DATETIME NOT NULL,
    cantidad INT NOT NULL,
    cedula_administrador INT NOT NULL,
    codigo_bodega_origen INT NOT NULL,
    codigo_bodega_destino INT NOT NULL,
	PRIMARY KEY(fecha_hora,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino),
    FOREIGN KEY (cedula_administrador) REFERENCES Empleado(cedula),
    FOREIGN KEY (codigo_bodega_origen) REFERENCES Bodega(codigo_bodega),
    FOREIGN KEY (codigo_bodega_destino) REFERENCES Bodega(codigo_bodega)
);

CREATE TABLE MovimientoArticulo (
    fecha_hora_movimiento DATETIME NOT NULL,
    cedula_administrador INT NOT NULL,
    codigo_bodega_origen INT NOT NULL,
    codigo_bodega_destino INT NOT NULL,
	codigo_articulo INT NOT NULL,
	cantidad INT NOT NULL,
	PRIMARY KEY(fecha_hora_movimiento,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino,codigo_articulo),
    FOREIGN KEY (fecha_hora_movimiento,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino) REFERENCES Movimiento(fecha_hora,cedula_administrador,codigo_bodega_origen, codigo_bodega_destino),
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo)
);

CREATE TABLE Salida (
	fecha_hora DATETIME NOT NULL,
    cedula_vendedor INT NOT NULL,
    codigo_bodega INT NOT NULL,
    PRIMARY KEY (fecha_hora,cedula_vendedor, codigo_bodega),
	FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula),
    FOREIGN KEY (codigo_bodega) REFERENCES Bodega(codigo_bodega)
);

CREATE TABLE SalidaArticulo (
	fecha_hora_salida DATETIME NOT NULL,
    cedula_vendedor INT NOT NULL,
    codigo_bodega INT NOT NULL,
    codigo_articulo INT NOT NULL,
    PRIMARY KEY (codigo_articulo, fecha_hora_salida,cedula_vendedor, codigo_bodega),
    FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo),
    FOREIGN KEY (fecha_hora_salida,cedula_vendedor, codigo_bodega) REFERENCES Salida(fecha_hora,cedula_vendedor, codigo_bodega)
);

-----------MODULO CLIENTE------------

CREATE TABLE Cliente (
    cedula INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido1 VARCHAR(255) NOT NULL,
    apellido2 VARCHAR(255) NOT NULL,
    correo VARCHAR(255) NOT NULL,
	telefono INT NOT NULL,
	celular INT NOT NULL,
	fax VARCHAR(50) NOT NULL,
    zona VARCHAR(50) NOT NULL,
    sector VARCHAR(50) NOT NULL
);

-----------MODULO COTIZACION------------

CREATE TABLE Cotizacion (
    num_cotizacion INT PRIMARY KEY,
	orden_compra VARCHAR(50) NOT NULL,
	tipo VARCHAR(30) NOT NULL,
	descripcion VARCHAR(255) NOT NULL,
	zona VARCHAR(50) NOT NULL,
    sector VARCHAR(50) NOT NULL,
	estado VARCHAR(10) NOT NULL,
	monto_total DECIMAL(10, 2) NOT NULL,
	mes_cierre INT NOT NULL,
    cedula_vendedor INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_cierre DATE NOT NULL,
    probabilidad DECIMAL(5, 2) NOT NULL,
	razon_negacion VARCHAR(255) NOT NULL,
	cedula_cliente INT NOT NULL,
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula),
	FOREIGN KEY (cedula_cliente) REFERENCES Cliente(cedula),
	CONSTRAINT chk_mes_cierre CHECK (mes_cierre BETWEEN 1 AND 12),
    CONSTRAINT chk_estado CHECK (estado IN ('abierta', 'aprobada', 'denegada')),
	CONSTRAINT chk_probabilidad CHECK (probabilidad >= 1.00 AND probabilidad <= 100.00)
);

CREATE TABLE TareaCotizacion (
	codigo_tarea INT NOT NULL,
	descripcion VARCHAR(255) NOT NULL,
    num_cotizacion INT NOT NULL,
	PRIMARY KEY (codigo_tarea, num_cotizacion),
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion)
);

CREATE TABLE CotizacionArticulo (
	codigo_articulo INT NOT NULL,
    num_cotizacion INT NOT NULL,
	cantidad INT NOT NULL,
	monto DECIMAL(10,2) NOT NULL,
	PRIMARY KEY (codigo_articulo, num_cotizacion),
	FOREIGN KEY (num_cotizacion) REFERENCES Cotizacion(num_cotizacion),
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo)
);

-----------MODULO FACTURACION------------

CREATE TABLE Factura (
    num_facturacion INT PRIMARY KEY,
    telefono_local INT NOT NULL,
    cedula_juridica INT NOT NULL,
    nombre_local VARCHAR(200) NOT NULL,
	fecha DATE NOT NULL,
    estado VARCHAR(60) NOT NULL,
    cedula_vendedor INT NOT NULL,
    cedula_cliente INT NOT NULL,
    FOREIGN KEY (cedula_vendedor) REFERENCES Empleado(cedula),
    FOREIGN KEY (cedula_cliente) REFERENCES Cliente(cedula)
);

CREATE TABLE FacturaArticulo (
    num_facturacion INT NOT NULL,
    codigo_articulo INT NOT NULL,
    FOREIGN KEY (num_facturacion) REFERENCES Factura(num_facturacion),
	FOREIGN KEY (codigo_articulo) REFERENCES Articulo(codigo)
);

-----------MODULO REGISTRO DE CASOS------------

CREATE TABLE Caso (
    codigo INT PRIMARY KEY,
	nombre_cuenta VARCHAR(255) NOT NULL,
	nombre_contacto VARCHAR(60) NOT NULL,
	asunto VARCHAR(255) NOT NULL,
	direccion VARCHAR(255) NOT NULL,
	descripcion VARCHAR(255) NOT NULL,
	estado VARCHAR(60) NOT NULL,
	tipo VARCHAR(30) NOT NULL,
	prioridad VARCHAR(20) NOT NULL,
	cedula_propietario INT NOT NULL,
	origen_cotizacion INT,
    origen_factura INT,

    FOREIGN KEY (origen_cotizacion) REFERENCES Cotizacion(num_cotizacion),
    FOREIGN KEY (origen_factura) REFERENCES Factura(num_facturacion),
    CONSTRAINT chk_origen CHECK ((origen_cotizacion IS NOT NULL AND origen_factura IS NULL) OR (origen_cotizacion IS NULL AND origen_factura IS NOT NULL))
);

CREATE TABLE TareaCaso (
	codigo_caso INT NOT NULL,
	fecha DATE NOT NULL,
	descripcion VARCHAR(255) NOT NULL,
	cedula_usuario INT NOT NULL,
	FOREIGN KEY (codigo_caso) REFERENCES Caso(codigo),
	FOREIGN KEY (cedula_usuario) REFERENCES Empleado(cedula),
);
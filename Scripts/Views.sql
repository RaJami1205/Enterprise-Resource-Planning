
-- Vistas Cotizacion

CREATE VIEW VistaCotizacion AS
SELECT 
    c.num_cotizacion,
    c.orden_compra,
    c.descripcion,
    c.monto_total,
    c.mes_cierre,
    c.probabilidad,
	c.fecha_inicio,
	c.fecha_cierre,
	c.razon_negacion,
    c.cedula_vendedor,
	c.cedula_cliente,
    z.nombre AS zona,
    s.nombre AS sector,
    ec.nombre AS estado,
    tc.nombre AS tipo
FROM 
    Cotizacion c
INNER JOIN 
    Zona z ON c.zona = z.zona_id
INNER JOIN 
    Sector s ON c.sector = s.sector_id
INNER JOIN 
    EstadoCotizacion ec ON c.estado = ec.estadocotizacion_id
INNER JOIN 
    TipoCotizacion tc ON c.tipo = tc.tipocotizacion_id
go

-- Vista articulo cotizacion

CREATE VIEW VistaArticuloCotizacion AS
SELECT 
    a.codigo AS codigo_articulo,
    a.nombre AS nombre_articulo,
    a.cantidad AS cantidad_inventario,
    a.activo AS estado_articulo,
    a.descripcion AS descripcion_articulo,
    a.peso AS peso_articulo,
    a.costo AS costo_articulo,
    a.precio_estandar AS precio_articulo,
    ca.num_cotizacion AS numero_cotizacion,
    ca.cantidad AS cantidad_cotizada,
    ca.monto AS monto_cotizacion
FROM 
    Articulo a
JOIN 
    CotizacionArticulo ca ON a.codigo = ca.codigo_articulo;
go

CREATE VIEW VistaFacturaDetalle AS
SELECT 
    f.num_facturacion,
    f.telefono_local,
    f.cedula_juridica,
    f.nombre_local,
    f.fecha,
    ef.nombre AS estado_factura, -- Mostrar el nombre del estado en lugar del ID
    f.cedula_vendedor,
    f.num_cotizacion
FROM 
    Factura f
JOIN 
    EstadoFactura ef ON f.estado = ef.estadofactura_id; -- Relación con la tabla EstadoFactura para obtener el nombre del estado
go


CREATE VIEW VistaFacturaArticulo AS
SELECT 
    f.num_facturacion AS numero_factura,
    f.telefono_local AS telefono_local,
    f.nombre_local AS nombre_local,
    f.fecha AS fecha_factura,
    ef.nombre AS estado_factura,
    f.cedula_vendedor AS cedula_vendedor,
    f.cedula_juridica AS cedula_cliente,
    fa.codigo_articulo AS codigo_articulo,
    a.nombre AS nombre_articulo,
    a.descripcion AS descripcion_articulo,
    fa.cantidad AS cantidad_facturada,
    fa.monto AS monto_articulo,
    a.precio_estandar AS precio_estandar
FROM 
    Factura f
JOIN 
    FacturaArticulo fa ON f.num_facturacion = fa.num_facturacion
JOIN 
    Articulo a ON fa.codigo_articulo = a.codigo
JOIN 
    EstadoFactura ef ON f.estado = ef.estadofactura_id;
go

/*Vista para el listado de los empleados*/
CREATE VIEW Vista_Empleado_Completa AS
SELECT 
    e.cedula AS Cedula, 
    e.nombre AS Nombre, 
    e.apellido1 AS Apellido_1, 
    e.apellido2 AS Apellido_2,
	dbo.CalcularEdad(e.fecha_nacimiento) as Edad,
    e.genero AS Genero, 
    e.residencia AS Residencia, 
    e.fecha_ingreso AS Fecha_Ingreso, 
    d.nombre AS Departamento,
    e.permiso_vendedor AS Vendedor, 
    e.numero_telefono AS Telefono, 
    e.salario_actual AS Salario, 
    p.puesto AS Puesto
FROM 
    Empleado e
INNER JOIN 
    Departamento d ON e.departamento = d.departamento_id
INNER JOIN 
    Puesto p ON e.puesto = p.puesto_id;
GO

/*Vista para el listado de Artículos*/
CREATE VIEW ArticuloBodega AS
SELECT 
    A.codigo AS codigo_articulo,
    A.nombre AS nombre_articulo,
    A.descripcion AS descripcion_articulo,
    B.codigo_bodega AS codigo_bodega,
    B.ubicacion AS ubicacion_bodega,
    BA.cantidad AS cantidad_en_bodega
FROM 
    Articulo A
JOIN 
    BodegaArticulo BA ON A.codigo = BA.codigo_articulo
JOIN 
    Bodega B ON BA.codigo_bodega = B.codigo_bodega;
GO

/*Vista para el histórico de salarios*/
CREATE VIEW VistaHistorialSalario AS
SELECT
	hs.HistoricoSalario_id as ID_historico,
	e.cedula AS Cedula,
    e.nombre AS Nombre,
    e.apellido1 AS PrimerApellido,
    e.apellido2 AS SegundoApellido,
    p.puesto AS Puesto,
    d.nombre AS Departamento,
    hs.monto AS Monto,
    hs.fecha_inicio AS FechaInicio,
    hs.fecha_fin AS FechaFin
FROM 
    Empleado e
JOIN 
    HistoricoSalario hs ON e.cedula = hs.cedula_empleado
JOIN 
    Puesto p ON hs.puesto = p.puesto_id
JOIN 
    Departamento d ON hs.departamento = d.departamento_id;
GO

/*Vista para el histórico de puestos*/
CREATE VIEW VistaHistorialPuesto AS
SELECT
	hp.HistoricoPuesto_id as ID_historico,
	e.cedula AS Cedula,
    e.nombre AS Nombre,
    e.apellido1 AS PrimerApellido,
    e.apellido2 AS SegundoApellido,
    p.puesto AS Puesto,
    d.nombre AS Departamento,
    hp.fecha_inicio AS FechaInicio,
    hp.fecha_fin AS FechaFin
FROM 
    Empleado e
JOIN 
    HistoricoPuesto hp ON e.cedula = hp.cedula_empleado
JOIN 
    Puesto p ON hp.puesto = p.puesto_id
JOIN 
    Departamento d ON hp.departamento = d.departamento_id;
GO

/*Vista para el listado de entradas*/
CREATE VIEW VistaEntradas AS
SELECT 
	e.cedula AS Cedula,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS administrador, -- Concatenación del nombre completo
    en.fecha_hora AS fecha,
    a.nombre AS articulo,
    ea.cantidad AS cantidad_ingresada,
    b.ubicacion AS ubicacion_bodega
FROM 
    Entrada en
JOIN 
    Empleado e ON en.cedula_administrador = e.cedula
JOIN 
    EntradaArticulo ea ON en.codigo_entrada = ea.codigo_entrada
JOIN 
    Articulo a ON ea.codigo_articulo = a.codigo
JOIN 
    Bodega b ON en.codigo_bodega = b.codigo_bodega;
GO

CREATE VIEW VistaPlanillaMensual AS
SELECT 
    anno AS Año,
    mes AS Mes,
    COUNT(DISTINCT cedula_empleado) AS Cantidad_Salarios,
    SUM(pago) AS Total_Pago
FROM 
    SalarioMensual
GROUP BY 
    anno, mes
GO


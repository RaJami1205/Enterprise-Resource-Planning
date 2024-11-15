-- Reportes

-- Planilla

CREATE FUNCTION ObtenerMontosPlanillaRangoFechas (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        CONCAT(anno, '-', FORMAT(mes, '00')) AS AñoMes, -- Formato Año-Mes
        SUM(pago) AS MontoTotal
    FROM 
        SalarioMensual
    WHERE 
        CONCAT(anno, '-', FORMAT(mes, '00')) BETWEEN FORMAT(@FechaInicio, 'yyyy-MM') AND FORMAT(@FechaFin, 'yyyy-MM')
    GROUP BY 
        anno, mes
);
GO


CREATE FUNCTION ObtenerMontosPorDepartamentoMes (
    @Mes INT, 
    @Anno INT
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        d.nombre AS Departamento,
        SUM(sm.pago) AS MontoTotal
    FROM 
        SalarioMensual sm
    INNER JOIN 
        Empleado e ON sm.cedula_empleado = e.cedula
    INNER JOIN 
        Departamento d ON e.departamento = d.departamento_id
    WHERE 
        sm.mes = @Mes AND sm.anno = @Anno
    GROUP BY 
        d.nombre
);
GO


-- Cotizacion

CREATE FUNCTION ObtenerTop10ProductosMasCotizados (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        p.nombre AS Producto,
        COUNT(c.num_cotizacion) AS CantidadCotizaciones
    FROM 
        Cotizacion c
    INNER JOIN 
        CotizacionArticulo ca ON c.num_cotizacion = ca.num_cotizacion
    INNER JOIN 
        Articulo p ON ca.codigo_articulo = p.codigo
    WHERE 
        c.fecha_inicio BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        p.nombre
);
GO


-- Facturacion

CREATE FUNCTION ObtenerVentasPorSector (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        s.nombre AS Sector,
        SUM(fa.monto * fa.cantidad) AS MontoTotal
    FROM 
        Factura f
    INNER JOIN 
        FacturaArticulo fa ON f.num_facturacion = fa.num_facturacion
    INNER JOIN 
        Cliente c ON f.cedula_juridica = c.cedula_juridica
    INNER JOIN 
        Sector s ON c.sector = s.sector_id
    WHERE 
        f.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        s.nombre
);
GO

CREATE FUNCTION ObtenerVentasPorZona (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        z.nombre AS Zona,
        SUM(fa.monto * fa.cantidad) AS MontoTotal
    FROM 
        Factura f
    INNER JOIN 
        FacturaArticulo fa ON f.num_facturacion = fa.num_facturacion
    INNER JOIN 
        Cliente c ON f.cedula_juridica = c.cedula_juridica
    INNER JOIN 
        Zona z ON c.zona = z.zona_id
    WHERE 
        f.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        z.nombre
);
GO

-- Cotizacion y Ventas por Departamento

CREATE FUNCTION ObtenerCotizacionesPorDepartamento (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        d.nombre AS Departamento,
		COUNT(c.num_cotizacion) AS CantidadCotizaciones,
        SUM(ca.monto * ca.cantidad) AS MontoTotal
    FROM 
        Cotizacion c
    INNER JOIN 
        CotizacionArticulo ca ON c.num_cotizacion = ca.num_cotizacion
    INNER JOIN 
        Empleado e ON c.cedula_vendedor = e.cedula
    INNER JOIN 
        Departamento d ON e.departamento = d.departamento_id
	WHERE 
        c.fecha_inicio BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        d.nombre
);
GO

CREATE FUNCTION ObtenerVentasPorDepartamento (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        d.nombre AS Departamento,
		COUNT(f.num_facturacion) AS CantidadVentas,
        SUM(fa.monto * fa.cantidad) AS MontoTotal
    FROM 
        Factura f
    INNER JOIN 
        FacturaArticulo fa ON f.num_facturacion = fa.num_facturacion
    INNER JOIN 
        Empleado e ON f.cedula_vendedor = e.cedula
    INNER JOIN 
        Departamento d ON e.departamento = d.departamento_id
    WHERE 
        f.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        d.nombre
);
GO

CREATE FUNCTION ObtenerVentasPorDepartamentoPorcentual (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        d.nombre AS Departamento,
        COUNT(f.cedula_juridica) AS CantidadTotal
    FROM 
        Factura f
    INNER JOIN 
        FacturaArticulo fa ON f.num_facturacion = fa.num_facturacion
    INNER JOIN 
        Empleado e ON f.cedula_vendedor = e.cedula
    INNER JOIN 
        Departamento d ON e.departamento = d.departamento_id
    WHERE 
        f.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        d.nombre
);
GO


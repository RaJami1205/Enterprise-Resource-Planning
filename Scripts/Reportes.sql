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



-- Cotizacion y Ventas

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

CREATE FUNCTION ObtenerVentasPorMesAno ()
RETURNS TABLE
AS
RETURN (
    SELECT 
        YEAR(f.fecha) AS Anio,
        MONTH(f.fecha) AS Mes,
        COUNT(f.num_facturacion) AS CantidadVentas
    FROM 
        Factura f
    GROUP BY 
        YEAR(f.fecha), MONTH(f.fecha)
    ORDER BY 
        YEAR(f.fecha), MONTH(f.fecha)
);
GO

CREATE FUNCTION ObtenerCotizacionesPorMesAno ()
RETURNS TABLE
AS
RETURN (
    SELECT 
        YEAR(c.fecha_inicio) AS Anio,
        MONTH(c.fecha_inicio) AS Mes,
        COUNT(c.num_cotizacion) AS CantidadCotizaciones
    FROM 
        Cotizacion c
    GROUP BY 
        YEAR(c.fecha_inicio), MONTH(c.fecha_inicio)
    ORDER BY 
        YEAR(c.fecha_inicio), MONTH(c.fecha_inicio)
);
GO


-- Cantidad de movimientos por bodega

CREATE FUNCTION PorcentajeMovimientosBodegas()
RETURNS TABLE
AS
RETURN (
    WITH Totales AS (
        SELECT
            COUNT(DISTINCT E.codigo_entrada) AS total_entradas, -- Total global de entradas
            COUNT(DISTINCT S.fecha_hora) AS total_salidas,      -- Total global de salidas
            COUNT(M.codigo_movimiento) AS total_movimientos -- Total global de movimientos
        FROM
            Bodega B
        LEFT JOIN 
            Entrada E ON B.codigo_bodega = E.codigo_bodega
        LEFT JOIN 
            Salida S ON B.codigo_bodega = S.codigo_bodega
        LEFT JOIN 
            Movimiento M ON B.codigo_bodega = M.codigo_bodega_origen
                        OR B.codigo_bodega = M.codigo_bodega_destino
    )
    SELECT 
        B.ubicacion,
        ROUND(CAST(COUNT(DISTINCT S.fecha_hora) AS FLOAT) / T.total_salidas * 100, 2) AS porcentaje_salidas,
        ROUND(CAST(COUNT(DISTINCT E.codigo_entrada) AS FLOAT) / T.total_entradas * 100, 2) AS porcentaje_entradas,
        ROUND(CAST(COUNT(DISTINCT M.codigo_movimiento) AS FLOAT) / T.total_movimientos * 100, 2) AS porcentaje_movimientos
    FROM
        Bodega B
    LEFT JOIN 
        Entrada E ON B.codigo_bodega = E.codigo_bodega
    LEFT JOIN 
        Salida S ON B.codigo_bodega = S.codigo_bodega
    LEFT JOIN 
        Movimiento M ON B.codigo_bodega = M.codigo_bodega_origen
                    OR B.codigo_bodega = M.codigo_bodega_destino
    CROSS JOIN
        Totales T -- Utilizamos los totales calculados en el CTE
    GROUP BY
        B.codigo_bodega, B.ubicacion, T.total_entradas, T.total_salidas, T.total_movimientos
);
GO

-- Bodegas con artículos más Transados

CREATE FUNCTION ObtenerTopBodegasTransados()
RETURNS TABLE
AS
RETURN
    SELECT 
        B.ubicacion, 
        COUNT(DISTINCT E.codigo_entrada) AS total_entradas, 
        COUNT(DISTINCT S.fecha_hora) AS total_salidas, 
        COUNT(M.codigo_movimiento) AS total_movimientos,
        (COUNT(DISTINCT E.codigo_entrada) + COUNT(DISTINCT S.fecha_hora) + COUNT(M.codigo_movimiento)) AS total_eventos
    FROM 
        Bodega B
    LEFT JOIN 
        Entrada E ON B.codigo_bodega = E.codigo_bodega
    LEFT JOIN 
        Salida S ON B.codigo_bodega = S.codigo_bodega
    LEFT JOIN 
        Movimiento M ON B.codigo_bodega = M.codigo_bodega_origen OR B.codigo_bodega = M.codigo_bodega_destino
    GROUP BY 
        B.codigo_bodega, B.ubicacion
GO

-- Monto total vendido por Familias de Artículos

CREATE FUNCTION ObtenerMontoTotalVendidoPorFamilia()
RETURNS TABLE
AS
RETURN
    SELECT 
        F.nombre AS familia, 
        CAST(SUM(FA.monto) AS FLOAT) AS monto_total_vendido
    FROM 
        FacturaArticulo FA
    JOIN 
        Articulo A ON FA.codigo_articulo = A.codigo
    JOIN 
        Familia F ON A.codigo_familia = F.codigo
    GROUP BY 
        F.codigo, F.nombre
GO

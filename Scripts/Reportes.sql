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
    SELECT TOP 10
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
	ORDER BY CantidadCotizaciones DESC
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

CREATE VIEW ObtenerVentasPorMesAno
AS
(
    SELECT 
        YEAR(f.fecha) AS Anio,
        MONTH(f.fecha) AS Mes,
        COUNT(f.num_facturacion) AS CantidadVentas
    FROM 
        Factura f
    GROUP BY 
        YEAR(f.fecha), MONTH(f.fecha)
);
GO

CREATE VIEW ObtenerCotizacionesPorMesAno
AS
(
    SELECT 
        YEAR(c.fecha_inicio) AS Anio,
        MONTH(c.fecha_inicio) AS Mes,
        COUNT(c.num_cotizacion) AS CantidadCotizaciones
    FROM 
        Cotizacion c
    GROUP BY 
        YEAR(c.fecha_inicio), MONTH(c.fecha_inicio)
);
GO

-- Clientes

CREATE FUNCTION ObtenerTopClientesVentas (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT TOP 10
        c.nombre AS Cliente,
        SUM(fa.monto * fa.cantidad) AS MontoTotal
    FROM 
        Factura f
    INNER JOIN 
        FacturaArticulo fa ON f.num_facturacion = fa.num_facturacion
    INNER JOIN 
        Cliente c ON f.cedula_juridica = c.cedula_juridica
    WHERE 
        f.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        c.nombre
	ORDER BY MontoTotal DESC
);
GO

CREATE FUNCTION ObtenerClientesVentasPorZona (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        z.nombre AS Zona,
        COUNT(c.cedula_juridica) AS CantidadClientes,
        SUM(fa.monto * fa.cantidad) AS MontoVentas
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



-- Cantidad de movimientos por bodega

CREATE FUNCTION PorcentajeMovimientosBodegas(
	@FechaInicio DATE,
    @FechaFin DATE
)
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

	WHERE 
    (@FechaInicio IS NULL OR E.fecha_hora >= @FechaInicio OR S.fecha_hora >= @FechaInicio OR M.fecha_hora >= @FechaInicio) AND
    (@FechaFin IS NULL OR E.fecha_hora <= @FechaFin OR S.fecha_hora <= @FechaFin OR M.fecha_hora <= @FechaFin) 

    GROUP BY
        B.codigo_bodega, B.ubicacion, T.total_entradas, T.total_salidas, T.total_movimientos
);
GO


-- Bodegas con artículos más Transados

CREATE FUNCTION ObtenerTopBodegasTransados(
	@FechaInicio DATE,
    @FechaFin DATE
)
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

	WHERE 
    (@FechaInicio IS NULL OR E.fecha_hora >= @FechaInicio OR S.fecha_hora >= @FechaInicio OR M.fecha_hora >= @FechaInicio) AND
    (@FechaFin IS NULL OR E.fecha_hora <= @FechaFin OR S.fecha_hora <= @FechaFin OR M.fecha_hora <= @FechaFin) 

    GROUP BY 
        B.codigo_bodega, B.ubicacion
GO

-- Monto total vendido por Familias de Artículos

CREATE FUNCTION ObtenerMontoTotalVendidoPorFamilia(
	@FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN
    SELECT 
        F.nombre AS familia, 
        CAST(SUM(FA.monto) AS FLOAT) AS monto_total_vendido
    FROM 
        FacturaArticulo FA
    JOIN 
        Factura FT ON FA.num_facturacion = FT.num_facturacion -- Vincular Factura para obtener las fechas
    JOIN 
        Articulo A ON FA.codigo_articulo = A.codigo
    JOIN 
        Familia F ON A.codigo_familia = F.codigo
    WHERE 
        FT.fecha BETWEEN @FechaInicio AND @FechaFin -- Filtrar por las fechas proporcionadas
    GROUP BY 
        F.codigo, F.nombre;
GO

--Casos

CREATE FUNCTION ObtenerCasosPorCotizacion (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        CONCAT(YEAR(c.fecha_inicio), '-', FORMAT(MONTH(c.fecha_inicio), '00')) AS AñoMes,
        COUNT(*) AS CantidadCasos
    FROM 
        Caso ca
	INNER JOIN Cotizacion c on ca.origen_cotizacion=c.num_cotizacion
    WHERE 
        ca.origen_cotizacion IS NOT NULL 
        AND c.fecha_inicio BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        YEAR(c.fecha_inicio), MONTH(c.fecha_inicio)
)
GO

CREATE FUNCTION ObtenerCasosPorFactura (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        CONCAT(YEAR(f.fecha), '-', FORMAT(MONTH(f.fecha), '00')) AS AñoMes,
        COUNT(c.codigo) AS CantidadCasos
    FROM 
        Caso c
	INNER JOIN Factura f on f.num_facturacion=c.origen_factura
    WHERE 
        c.origen_factura IS NOT NULL 
        AND f.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        YEAR(f.fecha), MONTH(f.fecha)
)
GO

CREATE FUNCTION ObtenerTareasSinCerrar (
    @FechaInicio DATE,
    @FechaFin DATE
)
RETURNS TABLE
AS
RETURN (
    SELECT TOP 15
        tc.codigo_tarea,
        c.nombre_cuenta AS NombreCuenta,
        tc.fecha AS FechaTarea,
        c.estado AS EstadoCaso
    FROM 
        TareaCaso tc
    INNER JOIN 
        Caso c ON tc.codigo_caso = c.codigo
    WHERE 
        c.estado NOT IN (3, 5, 19) -- Estados cerrados o resueltos
        AND tc.fecha BETWEEN @FechaInicio AND @FechaFin

);


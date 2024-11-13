/* Procedimientos almacenados del ERP*/

-----------MODULO DE USUARIOS------------
/*Empleado*/

/*Procedimiento para Insertar Empleados*/
CREATE PROCEDURE InsertarEmpleado
    @cedula INT,
    @nombre VARCHAR(25),
    @apellido1 VARCHAR(25),
    @apellido2 VARCHAR(25),
    @fecha_nacimiento DATE,
    @genero VARCHAR(50),
    @residencia VARCHAR(80),
    @fecha_ingreso DATE,
    @departamento INT,
    @permiso_vendedor VARCHAR(20),
    @numero_telefono INT,
    @salario_actual DECIMAL(10,2),
    @puesto INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos una transacci�n
        BEGIN TRANSACTION;

        -- Insertamos el nuevo empleado en la tabla Empleado
        INSERT INTO Empleado (cedula, nombre, apellido1, apellido2, fecha_nacimiento, genero, residencia, fecha_ingreso, departamento, permiso_vendedor, numero_telefono, salario_actual, puesto)
        VALUES (@cedula, @nombre, @apellido1, @apellido2, @fecha_nacimiento, @genero, @residencia, @fecha_ingreso, @departamento, @permiso_vendedor, @numero_telefono, @salario_actual, @puesto);

        -- Si la inserci�n fue exitosa, confirmamos la transacci�n
        COMMIT TRANSACTION;

        -- Devolvemos un mensaje de �xito en el par�metro de salida
        SET @ErrorMsg = 'Empleado insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Modificar Empleados*/
CREATE PROCEDURE ModificarEmpleado
    @cedula INT,
    @nombre VARCHAR(25),
    @apellido1 VARCHAR(25),
    @apellido2 VARCHAR(25),
    @fecha_nacimiento DATE,
    @genero VARCHAR(50),
    @residencia VARCHAR(80),
    @fecha_ingreso DATE,
    @departamento INT,
    @permiso_vendedor VARCHAR(20),
    @numero_telefono INT,
    @salario_actual DECIMAL(10,2),
    @puesto INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos una transacci�n
        BEGIN TRANSACTION;

        -- Actualizamos los datos del empleado en la tabla Empleado
        UPDATE Empleado
        SET nombre = @nombre,
            apellido1 = @apellido1,
            apellido2 = @apellido2,
            fecha_nacimiento = @fecha_nacimiento,
            genero = @genero,
            residencia = @residencia,
            fecha_ingreso = @fecha_ingreso,
            departamento = @departamento,
            permiso_vendedor = @permiso_vendedor,
            numero_telefono = @numero_telefono,
            salario_actual = @salario_actual,
            puesto = @puesto
        WHERE cedula = @cedula;

        -- Si la actualizaci�n fue exitosa, confirmamos la transacci�n
        COMMIT TRANSACTION;

        -- Devolvemos un mensaje de �xito en el par�metro de salida
        SET @ErrorMsg = 'Empleado actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Eliminar Empleados*/
CREATE PROCEDURE EliminarEmpleado
    @cedula INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos una transacci�n
        BEGIN TRANSACTION;

        -- Verificamos si el empleado existe
        IF EXISTS (SELECT 1 FROM Empleado WHERE cedula = @cedula)
        BEGIN
            -- Eliminamos el empleado
            DELETE FROM Empleado WHERE cedula = @cedula;

            -- Confirmamos la transacci�n
            COMMIT TRANSACTION;

            -- Devolvemos un mensaje de �xito
            SET @ErrorMsg = 'Empleado eliminado exitosamente.';
        END
        ELSE
        BEGIN
            -- Si el empleado no existe, deshacemos la transacci�n
            ROLLBACK TRANSACTION;

            -- Devolvemos un mensaje de error
            SET @ErrorMsg = 'Empleado no encontrado.';
        END
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Hist�rico de Salarios*/

/*Procedimiento para Insertar Hist�ricos de Salarios*/
CREATE PROCEDURE InsertarHistoricoSalario
	@id INT,
    @puesto INT,
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @departamento INT,
    @monto INT,
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos el hist�rico del salario
        INSERT INTO HistoricoSalario (HistoricoSalario_id, puesto, fecha_inicio, fecha_fin, departamento, monto, cedula_empleado)
        VALUES (@id, @puesto, @fecha_inicio, @fecha_fin, @departamento, @monto, @cedula_empleado);

        -- Confirmamos la transacci�n
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Hist�rico de salario insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Modificar Hist�ricos de Salarios*/
CREATE PROCEDURE ModificarHistoricoSalario
    @id INT, -- ID del registro a modificar
    @puesto INT,
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @departamento INT,
    @monto DECIMAL(10, 2),
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Actualizamos el hist�rico del salario
        UPDATE HistoricoSalario
        SET puesto = @puesto,
            fecha_inicio = @fecha_inicio,
            fecha_fin = @fecha_fin,
            departamento = @departamento,
            monto = @monto,
            cedula_empleado = @cedula_empleado
        WHERE HistoricoSalario_id = @id;

        -- Confirmamos la transacci�n
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Hist�rico de salario modificado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Eliminar Hist�ricos de Salarios*/
CREATE PROCEDURE EliminarHistoricoSalario
    @puesto INT,
    @fecha_inicio DATE,
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Eliminamos el registro del hist�rico del salario
        DELETE FROM HistoricoSalario 
        WHERE puesto = @puesto 
          AND fecha_inicio = @fecha_inicio 
          AND cedula_empleado = @cedula_empleado;

        -- Confirmamos la transacci�n si la eliminaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Historial de salario eliminado correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Hist�rico de Puestos*/

/*Procedimiento para Insertar Hist�ricos de Puestos*/
CREATE PROCEDURE InsertarHistoricoPuesto
	@id INT,
    @puesto INT,
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @departamento VARCHAR(25),
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos el hist�rico de puesto
        INSERT INTO HistoricoPuesto (HistoricoPuesto_id, puesto, fecha_inicio, fecha_fin, departamento, cedula_empleado)
        VALUES (@id, @puesto, @fecha_inicio, @fecha_fin, @departamento, @cedula_empleado);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Hist�rico de puesto insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Modificar Hist�ricos de Puestos*/
CREATE PROCEDURE ModificarHistoricoPuesto
	@id INT,
    @puesto INT,
    @fecha_inicio DATE,
    @cedula_empleado INT,
    @fecha_fin DATE,
    @departamento VARCHAR(25),
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Realizamos la actualizaci�n en el hist�rico de puesto
        UPDATE HistoricoPuesto
        SET puesto = @puesto,
            departamento = @departamento,
			fecha_inicio = @fecha_inicio,
			fecha_fin = @fecha_fin,
			cedula_empleado = @cedula_empleado
		WHERE HistoricoPuesto_id = @id;
			

        -- Confirmamos la transacci�n si la actualizaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Hist�rico de puesto modificado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Eliminar Hist�ricos de Puestos*/
CREATE PROCEDURE EliminarHistoricoPuesto
    @puesto INT,
    @fecha_inicio DATE,
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Realizamos la eliminaci�n del hist�rico de puesto
        DELETE FROM HistoricoPuesto 
        WHERE puesto = @puesto 
          AND fecha_inicio = @fecha_inicio 
          AND cedula_empleado = @cedula_empleado;

        -- Confirmamos la transacci�n si la eliminaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Hist�rico de puesto eliminado correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para insertar sesiones de usuario*/
CREATE PROCEDURE InsertarLogueoUsuario
    @usuario VARCHAR(75),
    @contrasenna_hash VARCHAR(64),
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    -- Establecer un valor inicial para el mensaje de error
    SET @ErrorMsg = '';

    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Validar si el usuario ya existe
        IF EXISTS (SELECT 1 FROM Logueo_Usuario WHERE usuario = @usuario)
        BEGIN
            SET @ErrorMsg = 'Error: El nombre de usuario ya existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar si el empleado ya tiene un registro en Logueo_Usuario
        IF EXISTS (SELECT 1 FROM Logueo_Usuario WHERE cedula_empleado = @cedula_empleado)
        BEGIN
            SET @ErrorMsg = 'Error: El empleado ya tiene un usuario asignado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el nuevo usuario en la tabla Logueo_Usuario
        INSERT INTO Logueo_Usuario (usuario, contrasenna, cedula_empleado)
        VALUES (@usuario, HASHBYTES('SHA2_256', @contrasenna_hash), @cedula_empleado);

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Usuario insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Deshacer la transacci�n en caso de error
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


-----------MODULO DE INVENTARIO------------
/*Entrada*/

/*Procedimiento para Insertar Entradas*/
CREATE PROCEDURE InsertarEntrada
	@codigo_entrada INT,
    @fecha_hora DATETIME,
    @codigo_bodega INT,
    @cedula_administrador INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos la entrada en la tabla Entrada
        INSERT INTO Entrada (codigo_entrada, fecha_hora, codigo_bodega, cedula_administrador)
        VALUES (@codigo_entrada, @fecha_hora, @codigo_bodega, @cedula_administrador);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Entrada insertada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Procedimiento para Insertar Art�culos por Entrada*/
CREATE PROCEDURE InsertarEntradaArticulo
	@codigo_entrada INT,
    @fecha_hora_entrada DATETIME,
    @codigo_bodega INT,
    @cedula_administrador INT,
    @codigo_articulo INT,
    @cantidad INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos la entrada de art�culo en la tabla EntradaArticulo
        INSERT INTO EntradaArticulo (codigo_entrada, fecha_hora_entrada, codigo_bodega, cedula_administrador, codigo_articulo, cantidad)
        VALUES (@codigo_entrada, @fecha_hora_entrada, @codigo_bodega, @cedula_administrador, @codigo_articulo, @cantidad);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Entrada de art�culo insertada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


/*Procedimiento para Insertar Art�culos por Movimiento*/
CREATE PROCEDURE InsertarMovimientoArticulo
	@codigo_movimiento INT,
    @fecha_hora_movimiento DATETIME,
    @cedula_administrador INT,
    @codigo_bodega_origen INT,
    @codigo_bodega_destino INT,
    @codigo_articulo INT,
    @cantidad INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos el movimiento de art�culo en la tabla MovimientoArticulo
        INSERT INTO MovimientoArticulo (codigo_movimiento, fecha_hora_movimiento, cedula_administrador, codigo_bodega_origen, codigo_bodega_destino, codigo_articulo, cantidad)
        VALUES (@codigo_movimiento ,@fecha_hora_movimiento, @cedula_administrador, @codigo_bodega_origen, @codigo_bodega_destino, @codigo_articulo, @cantidad);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Movimiento de art�culo insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Salidas*/

/*Procedimiento para Insertar Salidas*/
CREATE PROCEDURE InsertarSalida
    @cedula_vendedor INT,
    @codigo_bodega INT,
    @factura INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Insertar en la tabla Salida
        INSERT INTO Salida (fecha_hora, cedula_vendedor, codigo_bodega, factura)
        VALUES (GETDATE(), @cedula_vendedor, @codigo_bodega, @factura);

        -- Confirmar la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Salida registrada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error y asignarlo al par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


/*Procedimiento para Insertar Art�culos por Salida*/
CREATE PROCEDURE InsertarSalidaArticulo
    @fecha_hora_salida DATETIME,
    @cedula_vendedor INT,
    @codigo_bodega INT,
    @codigo_articulo INT,
    @cantidad INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos la salida del art�culo en la tabla SalidaArticulo
        INSERT INTO SalidaArticulo (fecha_hora_salida, cedula_vendedor, codigo_bodega, codigo_articulo, cantidad)
        VALUES (@fecha_hora_salida, @cedula_vendedor, @codigo_bodega, @codigo_articulo, @cantidad);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Salida de art�culo registrada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE ModificarCantidadBodega
    @codigo_bodega INT,
	@codigo_articulo INT,
    @nueva_cantidad INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Actualizamos solo la columna "capacidad" de la bodega espec�fica
        UPDATE BodegaArticulo
        SET cantidad = @nueva_cantidad
        WHERE codigo_bodega = @codigo_bodega AND codigo_articulo = @codigo_articulo;

        -- Confirmamos la transacci�n si la actualizaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Capacidad de la bodega modificada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END�CATCH
END;
GO



/*Bodega*/

/* Procedimiento para Modificar la Capacidad de la Bodega */
CREATE PROCEDURE ModificarCapacidadBodega
    @codigo_bodega INT,
    @nueva_capacidad INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Actualizamos solo la columna "capacidad" de la bodega espec�fica
        UPDATE Bodega
        SET capacidad = @nueva_capacidad
        WHERE codigo_bodega = @codigo_bodega;

        -- Confirmamos la transacci�n si la actualizaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Capacidad de la bodega modificada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/* Procedimiento para Modificar la Cantidad de art�culos de la Bodega */
CREATE PROCEDURE InsertarBodegaArticulo
	@codigo_articulo INT,
    @codigo_bodega INT,
    @cantidad INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos EL art�culo y su cantidad en la tabla BodegaArticulo
        INSERT INTO BodegaArticulo (codigo_bodega, codigo_articulo, cantidad) 
		VALUES (@codigo_bodega, @codigo_articulo, @cantidad);

        -- Confirmamos la transacci�n si la actualizaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Art�culo ingresado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE InsertarMovimiento
	@codigo_movimiento INT,
    @fecha_hora DATETIME,
    @cedula_administrador INT,
    @codigo_bodega_origen INT,
    @codigo_bodega_destino INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos el movimiento en la tabla Movimiento
        INSERT INTO Movimiento (codigo_movimiento, fecha_hora, cedula_administrador, codigo_bodega_origen, codigo_bodega_destino)
        VALUES (@codigo_movimiento, @fecha_hora, @cedula_administrador, @codigo_bodega_origen, @codigo_bodega_destino);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Movimiento insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

-----------MODULO DE COTIZACI�N------------

/*Cotizaci�n*/

CREATE PROCEDURE InsertarCotizacion
    @num_cotizacion INT,
    @orden_compra VARCHAR(50),
    @tipo VARCHAR(75),
    @descripcion VARCHAR(255),
    @zona VARCHAR(75),
    @sector VARCHAR(75),
    @estado VARCHAR(75),
    @monto_total FLOAT,
    @mes_cierre INT,
    @cedula_vendedor INT,
    @fecha_inicio DATE,
    @fecha_cierre DATE,
    @probabilidad FLOAT,
    @razon_negacion VARCHAR(255),
    @cedula_cliente INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Variables para almacenar los IDs correspondientes
        DECLARE @zona_id INT, @sector_id INT, @estado_id INT, @tipo_id INT;

        -- Obtener el ID de la Zona
        SELECT @zona_id = zona_id 
        FROM Zona 
        WHERE nombre = @zona;

        -- Verificar si el ID fue encontrado
        IF @zona IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Zona no v�lida.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID del Sector
        SELECT @sector_id = sector_id 
        FROM Sector 
        WHERE nombre = @sector;

        -- Verificar si el ID fue encontrado
        IF @sector IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Sector no v�lido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID del Estado
        SELECT @estado_id = estadocotizacion_id 
        FROM EstadoCotizacion 
        WHERE nombre = @estado;

        -- Verificar si el ID fue encontrado
        IF @estado IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Estado de cotizaci�n no v�lido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID del Tipo de Cotizaci�n
        SELECT @tipo_id = tipocotizacion_id 
        FROM TipoCotizacion 
        WHERE nombre = @tipo;

        -- Verificar si el ID fue encontrado
        IF @tipo IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Tipo de cotizaci�n no v�lido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar la cotizaci�n en la tabla Cotizacion
        INSERT INTO Cotizacion (num_cotizacion, orden_compra, tipo, descripcion, zona, sector, estado, monto_total, mes_cierre, cedula_vendedor, fecha_inicio, fecha_cierre, probabilidad, razon_negacion, cedula_cliente)
        VALUES (@num_cotizacion, @orden_compra, @tipo_id, @descripcion, @zona_id, @sector_id, @estado_id, @monto_total, @mes_cierre, @cedula_vendedor, @fecha_inicio, @fecha_cierre, @probabilidad, @razon_negacion, @cedula_cliente);

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Cotizaci�n registrada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error y asignarlo al par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE ModificarCotizacion
    @num_cotizacion INT,
    @orden_compra VARCHAR(50),
    @tipo VARCHAR(75),
    @descripcion VARCHAR(255),
    @zona VARCHAR(75),
    @sector VARCHAR(75),
    @estado VARCHAR(75),
    @monto_total FLOAT,
    @mes_cierre INT,
    @cedula_vendedor INT,
    @fecha_inicio DATE,
    @fecha_cierre DATE,
    @probabilidad FLOAT,
    @razon_negacion VARCHAR(255),
    @cedula_cliente INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Variables para almacenar los IDs correspondientes
        DECLARE @zona_id INT, @sector_id INT, @estado_id INT, @tipo_id INT;

        -- Obtener el ID de la Zona
        SELECT @zona_id = zona_id 
        FROM Zona 
        WHERE nombre = @zona;

        IF @zona_id IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Zona no v�lida.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID del Sector
        SELECT @sector_id = sector_id 
        FROM Sector 
        WHERE nombre = @sector;

        IF @sector_id IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Sector no v�lido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID del Estado de Cotizaci�n
        SELECT @estado_id = estadocotizacion_id 
        FROM EstadoCotizacion 
        WHERE nombre = @estado;

        IF @estado_id IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Estado de cotizaci�n no v�lido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Obtener el ID del Tipo de Cotizaci�n
        SELECT @tipo_id = tipocotizacion_id 
        FROM TipoCotizacion 
        WHERE nombre = @tipo;

        IF @tipo_id IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: Tipo de cotizaci�n no v�lido.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar la cotizaci�n en la tabla Cotizacion
        UPDATE Cotizacion
        SET orden_compra = @orden_compra,
            tipo = @tipo_id,
            descripcion = @descripcion,
            zona = @zona_id,
            sector = @sector_id,
            estado = @estado_id,
            monto_total = @monto_total,
            mes_cierre = @mes_cierre,
            cedula_vendedor = @cedula_vendedor,
            fecha_inicio = @fecha_inicio,
            fecha_cierre = @fecha_cierre,
            probabilidad = @probabilidad,
            razon_negacion = @razon_negacion,
            cedula_cliente = @cedula_cliente
        WHERE num_cotizacion = @num_cotizacion;

        -- Verificar si se realiz� alguna actualizaci�n
        IF @@ROWCOUNT = 0
        BEGIN
            SET @ErrorMsg = 'No se encontr� una cotizaci�n con el n�mero proporcionado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Cotizaci�n modificada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error y asignarlo al par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


/*Procedimiento para Eliminar Cotizaciones*/
CREATE PROCEDURE EliminarCotizacion
    @num_cotizacion INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Verificar si la cotizaci�n existe antes de eliminarla
        IF NOT EXISTS (SELECT 1 FROM Cotizacion WHERE num_cotizacion = @num_cotizacion)
        BEGIN
            SET @ErrorMsg = 'No se encontr� una cotizaci�n con el n�mero proporcionado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar la cotizaci�n
        DELETE FROM Cotizacion 
        WHERE num_cotizacion = @num_cotizacion;

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Cotizaci�n eliminada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error y asignarlo al par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


/*Cotizaci�nArt�culo*/

/*Procedimiento para Insertar Art�culos por Cotizaci�n*/
CREATE PROCEDURE InsertarArticuloCotizacion
    @codigo_articulo INT,
    @num_cotizacion INT,
    @cantidad INT,
    @monto DECIMAL(10, 2),
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Insertamos el art�culo en la cotizaci�n
        INSERT INTO CotizacionArticulo (codigo_articulo, num_cotizacion, cantidad, monto)
        VALUES (@codigo_articulo, @num_cotizacion, @cantidad, @monto);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Art�culo insertado exitosamente en la cotizaci�n.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el mensaje de error y lo asignamos al par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*TareCotizaci�n*/

/*Procedimiento para Insertar Tareas por Cotizaci�n*/
CREATE PROCEDURE InsertarTareaCotizacion
    @codigo_tarea INT,
    @descripcion VARCHAR(255),
    @num_cotizacion INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Verificar que exista la cotizaci�n a la que se asocia la tarea
        IF NOT EXISTS (SELECT 1 FROM Cotizacion WHERE num_cotizacion = @num_cotizacion)
        BEGIN
            SET @ErrorMsg = 'Error: La cotizaci�n asociada no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar la tarea en la tabla TareaCotizacion
        INSERT INTO TareaCotizacion (codigo_tarea, descripcion, num_cotizacion)
        VALUES (@codigo_tarea, @descripcion, @num_cotizacion);

        -- Confirmar la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Tarea insertada exitosamente en la cotizaci�n.';
    END TRY
    BEGIN CATCH
        -- Deshacer la transacci�n en caso de error
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


/*Procedimiento para Eliminar Tareas por Cotizaci�n*/
CREATE PROCEDURE EliminarTareaCotizacion
    @codigo_tarea INT,
    @num_cotizacion INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Verificar que la tarea exista en la cotizaci�n especificada
        IF NOT EXISTS (SELECT 1 FROM TareaCotizacion WHERE codigo_tarea = @codigo_tarea AND num_cotizacion = @num_cotizacion)
        BEGIN
            SET @ErrorMsg = 'Error: La tarea especificada no existe para la cotizaci�n dada.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Eliminar la tarea de la cotizaci�n
        DELETE FROM TareaCotizacion
        WHERE codigo_tarea = @codigo_tarea AND num_cotizacion = @num_cotizacion;

        -- Confirmar la transacci�n si la eliminaci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Tarea eliminada exitosamente de la cotizaci�n.';
    END TRY
    BEGIN CATCH
        -- Deshacer la transacci�n en caso de error
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO


-----------MODULO DE PLANILLA------------

 /*Salario Mensual*/

 /*Procedimiento para Insertar Salarios Mensuales*/
 CREATE PROCEDURE InsertarSalarioMensual
    @anno INT,
    @mes INT,
    @pago FLOAT,
    @cantidad_horas INT,
    @cedula_empleado INT,
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        -- Iniciamos la transacci�n
        BEGIN TRANSACTION;

        -- Realizamos la inserci�n del salario mensual
        INSERT INTO SalarioMensual (anno, mes, pago, cantidad_horas, cedula_empleado)
        VALUES (@anno, @mes, dbo.CalcularPlanillaMensual(@pago,@cantidad_horas), @cantidad_horas, @cedula_empleado);

        -- Confirmamos la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Salario mensual insertado exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacemos la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturamos el error y lo retornamos en el par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

/*Facturacion*/

CREATE PROCEDURE InsertarFactura
    @num_facturacion INT,
    @telefono_local INT,
    @cedula_juridica INT,
    @nombre_local VARCHAR(200),
    @fecha DATE,
    @estado VARCHAR(75), -- Mantener como VARCHAR para recibir el nombre
    @cedula_vendedor INT,
    @num_cotizacion INT = NULL, -- Par�metro opcional
    @ErrorMsg NVARCHAR(255) OUTPUT -- Par�metro de salida para el mensaje de error
AS
BEGIN
    BEGIN TRY
        DECLARE @estado_id INT; -- Variable para el ID de estado

        -- Iniciar la transacci�n
        BEGIN TRANSACTION;

        -- Obtener el estadofactura_id correspondiente al nombre
        SELECT @estado_id = estadofactura_id
        FROM EstadoFactura
        WHERE nombre = @estado;

        -- Validar que el estado exista en EstadoFactura
        IF @estado_id IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: El estado proporcionado no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que el vendedor exista en Empleado
        IF NOT EXISTS (SELECT 1 FROM Empleado WHERE cedula = @cedula_vendedor)
        BEGIN
            SET @ErrorMsg = 'Error: El vendedor proporcionado no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que el cliente exista en Cliente
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE cedula_juridica = @cedula_juridica)
        BEGIN
            SET @ErrorMsg = 'Error: El cliente proporcionado no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que la cotizaci�n exista en Cotizacion, si se proporciona
        IF @num_cotizacion IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cotizacion WHERE num_cotizacion = @num_cotizacion)
        BEGIN
            SET @ErrorMsg = 'Error: La cotizaci�n proporcionada no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar la factura en la tabla Factura
        INSERT INTO Factura (num_facturacion, telefono_local, cedula_juridica, nombre_local, fecha, estado, cedula_vendedor, num_cotizacion)
        VALUES (@num_facturacion, @telefono_local, @cedula_juridica, @nombre_local, @fecha, @estado_id, @cedula_vendedor, @num_cotizacion);

        -- Confirmar la transacci�n si la inserci�n fue exitosa
        COMMIT TRANSACTION;

        -- Mensaje de �xito
        SET @ErrorMsg = 'Factura registrada exitosamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, deshacer la transacci�n
        ROLLBACK TRANSACTION;

        -- Capturar el mensaje de error y asignarlo al par�metro de salida
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE AnularFactura
    @num_facturacion INT,
    @ErrorMsg NVARCHAR(255) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Asumiendo que tienes un estado espec�fico para "anulada"
        DECLARE @estado_anulada INT;

        -- Obtener el estado correspondiente a "anulada"
        SELECT @estado_anulada = estadofactura_id FROM EstadoFactura WHERE nombre = 'anulada';

        IF @estado_anulada IS NULL
        BEGIN
            SET @ErrorMsg = 'Error: El estado "anulada" no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualizar el estado de la factura a "anulada"
        UPDATE Factura
        SET estado = @estado_anulada
        WHERE num_facturacion = @num_facturacion;

        -- Verificar que se haya encontrado la factura
        IF @@ROWCOUNT = 0
        BEGIN
            SET @ErrorMsg = 'Error: No se encontr� la factura con el n�mero proporcionado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        COMMIT TRANSACTION;
        SET @ErrorMsg = 'Factura anulada exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE InsertarArticuloFactura
    @num_factura INT,
    @codigo_articulo INT,
    @cantidad INT,
    @monto DECIMAL(10, 2),
    @ErrorMsg NVARCHAR(255) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar existencia de factura
        IF NOT EXISTS (SELECT 1 FROM Factura WHERE num_facturacion = @num_factura)
        BEGIN
            SET @ErrorMsg = 'Error: La factura proporcionada no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar existencia de art�culo
        IF NOT EXISTS (SELECT 1 FROM Articulo WHERE codigo = @codigo_articulo)
        BEGIN
            SET @ErrorMsg = 'Error: El art�culo proporcionado no existe.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el art�culo en la factura
        INSERT INTO FacturaArticulo (num_facturacion, codigo_articulo, cantidad, monto)
        VALUES (@num_factura, @codigo_articulo, @cantidad, @monto);

        COMMIT TRANSACTION;
        SET @ErrorMsg = 'Art�culo agregado a la factura exitosamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @ErrorMsg = ERROR_MESSAGE();
    END CATCH
END
GO

CREATE PROCEDURE ObtenerSalariosMensuales
    @A�o INT,
    @Mes INT
AS
BEGIN
    SELECT 
        cedula_empleado AS CedulaEmpleado,
        cantidad_horas AS CantidadHoras,
        pago AS Pago
    FROM 
        SalarioMensual
    WHERE 
        anno = @A�o AND mes = @Mes;
END;
GO

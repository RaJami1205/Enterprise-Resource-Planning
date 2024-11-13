
-- Funciones para base de datos ERP

/*Calcular edad de empleado*/

CREATE FUNCTION CalcularEdad (@fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE())
    
    -- Ajustar la edad si no ha pasado su cumpleaños este año
    IF (DATEADD(YEAR, @edad, @fecha_nacimiento) > GETDATE())
        SET @edad = @edad - 1
    
    RETURN @edad
END
GO

/*Calcular salario de Planilla*/
CREATE FUNCTION CalcularPlanillaMensual (
    @salario_actual FLOAT,
    @cantidad_horas INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @pago_mensual FLOAT
    DECLARE @horas_minimas INT = 200
    DECLARE @tasa_excedente FLOAT = 1.5
    DECLARE @pago_hora FLOAT
    DECLARE @excedente INT

    -- Calcular el pago por hora basado en el salario actual y las 200 horas mínimas
    SET @pago_hora = @salario_actual / @horas_minimas

    -- Si las horas trabajadas son iguales o menores a 200, se paga el salario completo
    IF @cantidad_horas <= @horas_minimas
        SET @pago_mensual = @salario_actual
    ELSE
    BEGIN
        -- Calcular el excedente de horas
        SET @excedente = @cantidad_horas - @horas_minimas

        -- Pago mensual es el salario completo más el pago por el excedente de horas a 1.5
        SET @pago_mensual = @salario_actual + (@pago_hora * @excedente * @tasa_excedente)
    END

    RETURN @pago_mensual
END
GO


-- Verificar usuario
CREATE FUNCTION VerificarUsuario(
    @usuario VARCHAR(75),
    @contrasenna VARCHAR(75)
)
RETURNS BIT
AS
BEGIN
    DECLARE @existe BIT;

    -- Verificar si el usuario y el hash de la contraseña ingresada coinciden con los registros
    IF EXISTS (
        SELECT 1
        FROM Logueo_Usuario
        WHERE usuario = @usuario
        AND contrasenna = HASHBYTES('SHA2_256', @contrasenna) -- Genera el hash para comparar
    )
    BEGIN
        SET @existe = 1;  -- Usuario encontrado
    END
    ELSE
    BEGIN
        SET @existe = 0;  -- Usuario no encontrado
    END

    RETURN @existe;
END;

CREATE PROCEDURE practica1.PR6
AS
BEGIN
    -- Manejo de errores TryCatch
    BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRANSACTION;
        
        -- Declarar variables
        DECLARE @NumFilas INT;
        DECLARE @CurrentRow INT;
        DECLARE @ErrorMessage NVARCHAR(MAX) = '';

        -- Inicializar variables para tabla USUARIOS
        SET @NumFilas = (SELECT COUNT(*) FROM practica1.Usuarios);
        SET @CurrentRow = 1;

        -- Recorrer las filas de la tabla
        WHILE @CurrentRow <= @NumFilas
        BEGIN
            -- Validar tipos de dato para cada campo
            DECLARE @Firstname VARCHAR(MAX);
            DECLARE @Lastname VARCHAR(MAX);
            
            -- Obtener valores de la fila actual
            SELECT @Firstname = Firstname, @Lastname = Lastname
            FROM (
                SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
                FROM practica1.Usuarios
            ) AS TempTable
            WHERE RowNum = @CurrentRow;

            -- Validar si el nombre solo contiene letras
            IF @Firstname LIKE '%[^a-zA-Z]%'
            BEGIN
                SET @ErrorMessage = @ErrorMessage + 'Error en tabla Usuarios, Fila ' + CAST(@CurrentRow AS NVARCHAR(10)) + ': El nombre debería de contener solo letras.' + CHAR(13);
            END;
            -- Validar si el apellido solo contiene letras
            IF @Lastname LIKE '%[^a-zA-Z]%'
            BEGIN
                SET @ErrorMessage = @ErrorMessage + 'Error en tabla Usuarios, Fila ' + CAST(@CurrentRow AS NVARCHAR(10)) + ': El apellido debería de contener solo letras.' + CHAR(13);
            END;

            -- Incrementar contador de fila actual
            SET @CurrentRow = @CurrentRow + 1;
        END;

        -- Inicializar variables para tabla USUARIOS
        SET @NumFilas = (SELECT COUNT(*) FROM practica1.Course);
        SET @CurrentRow = 1;

        -- Recorrer las filas de la tabla
        WHILE @CurrentRow <= @NumFilas
        BEGIN
            -- Validar tipos de dato para cada campo
            DECLARE @Name VARCHAR(MAX);
            DECLARE @CreditsRequired INT;
            
            -- Obtener valores de la fila actual
            SELECT @Name = Name, @CreditsRequired = CreditsRequired
            FROM (
                SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
                FROM practica1.Course
            ) AS TempTable
            WHERE RowNum = @CurrentRow;

            -- Validar si el nombre solo contiene letras
            IF @Name LIKE '%[^a-zA-Z]%'
            BEGIN
                SET @ErrorMessage = @ErrorMessage + 'Error en tabla Course, Fila ' + CAST(@CurrentRow AS NVARCHAR(10)) + ': El nombre del curso debería de contener solo letras.' + CHAR(13);
            END;
            -- Validar si el apellido solo contiene letras
            IF ISNUMERIC(@CreditsRequired) = 0 AND @CreditsRequired <= 0
            BEGIN
                SET @ErrorMessage = @ErrorMessage + 'Error en tabla Course, Fila ' + CAST(@CurrentRow AS NVARCHAR(10)) + ': Los créditos deberían de ser números y positivos.' + CHAR(13);
            END;

            -- Incrementar contador de fila actual
            SET @CurrentRow = @CurrentRow + 1;
        END;

        -- Mostrar mensajes de error si es necesario
        IF @ErrorMessage <> ''
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT @ErrorMessage AS Error;
        END
        ELSE
        BEGIN
            COMMIT TRANSACTION;
            SELECT 'Se ha verificado la tabla Usuarios con éxito' AS Mensaje;
        END;

    END TRY
    BEGIN CATCH
        -- Si ocurre algún error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Mandar mensaje de error
        SELECT 'Hubo un error al verificar los datos.' AS Error;
    END CATCH;
END;
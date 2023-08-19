CREATE PROCEDURE practica1.PR5
    @Name VARCHAR(150),
    @CreditsRequired INT
AS
BEGIN
    -- Manejo de errores TryCatch
    BEGIN TRY       
        -- Iniciar la transacción
        BEGIN TRANSACTION; 
            -- Validar Name: Solamente letras
            IF @Name NOT LIKE '%[^a-zA-Z]%'
            BEGIN
                -- Verificamos que @CreditsRequired sea numérico y mayor a 0
                IF ISNUMERIC(@CreditsRequired) = 1 AND @CreditsRequired > 0
                BEGIN
                    -- insertamos el curso
                    INSERT INTO practica1.Course (Name, CreditsRequired) VALUES (@Name, @CreditsRequired);
                    -- Confirmar la transacción si todo fue exitoso
                    COMMIT TRANSACTION;
                    -- Mandamos mensaje de confirmación 
                    SELECT 'Se ha ingresado el curso con éxito.' AS Mensaje;
                END
                ELSE
                BEGIN
                    -- Si @CreditsRequired no es válido, deshacer la transacción y mostrar mensaje de error
                    ROLLBACK TRANSACTION;
                    SELECT 'Error: Los créditos del curso deben de ser numérico y mayor a 0.' AS Error;
                END;
            END
            ELSE
            BEGIN
                -- Si Name no es válido, deshacer la transacción y mostrar mensaje de error
                ROLLBACK TRANSACTION;
                SELECT 'Error: El nombre del curso debe contener solamente letras.' AS Error;
            END;
    END TRY
    BEGIN CATCH
        -- Si ocurre algún error, deshacer la transacción
        ROLLBACK TRANSACTION;
        -- Mandar mensaje de error
        SELECT 'Error: Ha habido un error al crear el curso.' AS Error;
    END CATCH;
END;
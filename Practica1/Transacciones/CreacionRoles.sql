-- Creción de Roles: Permite crear los roles para estudiantes.
DROP PROCEDURE IF EXISTS practica1.PR4;

CREATE PROCEDURE practica1.PR4 ( @roleName NVARCHAR(MAX) ) AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            IF @roleName NOT LIKE '%[^a-zA-Z]%'
            BEGIN
                IF EXISTS (SELECT 1 FROM Roles r WHERE r.RoleName = @roleName)
                    BEGIN
                        ROLLBACK TRANSACTION;
                        SELECT 'El rol que se intenta crear ya existe.' AS ERROR;
                        INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Creación de rol fallida, el rol que se intenta crear ya existe.');
                    END;
                ELSE
                    BEGIN
                        INSERT INTO ROLES (Id, RoleName) VALUES (NEWID(), UPPER(@roleName));
                        COMMIT TRANSACTION;
                        SELECT CONCAT('Rol ', UPPER(@roleName), ' creado correctamente.') AS MENSAJE;
                    END;
            END;
            ELSE
            BEGIN
                ROLLBACK TRANSACTION;
                SELECT 'El nombre del rol debe contener únicamente letras.' AS ERROR;
                INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Creación de rol fallida, el nombre de rol debe contener únicamente letras.');
            END;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Ha ocurrido un error, no fue posible crear el rol.' AS ERROR;
        INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Creación de rol fallida.');
    END CATCH;
END;
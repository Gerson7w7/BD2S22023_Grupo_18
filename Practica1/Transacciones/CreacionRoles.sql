-- Creción de Roles: Permite crear los roles para estudiantes.
DROP PROCEDURE IF EXISTS practica1.PR4;

CREATE PROCEDURE practica1.PR4 ( @roleName NVARCHAR(MAX) ) AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            IF EXISTS (SELECT 1 FROM Roles r WHERE r.RoleName = @roleName)
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT 'El rol que se intenta crear ya existe.' AS ERROR;
                END;
            ELSE
                BEGIN
                    IF (@roleName = 'Student' OR @roleName = 'Tutor')
                        BEGIN
                            INSERT INTO ROLES (Id, RoleName) VALUES (NEWID(), UPPER(@roleName));
                            COMMIT TRANSACTION;
                            SELECT 'Rol creado correctamente.' AS MENSAJE;
                        END;
                    ELSE
                        BEGIN
                            ROLLBACK TRANSACTION;
                            SELECT CONCAT('No es posible crear el rol "', @roleName,
                                '", los roles válidos son: "Student" y "Tutor".') AS ERROR;
                        END;
                END;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Ha ocurrido un error, no fue posible crear el rol.' AS ERROR;
    END CATCH;
END;
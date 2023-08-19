-- Creción de Roles: Permite crear los roles para estudiantes.
DROP PROCEDURE IF EXISTS practica1.PR4;

CREATE PROCEDURE practica1.PR4 ( @roleName NVARCHAR(MAX))
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Roles r WHERE r.RoleName = @roleName)
        SELECT 'El rol que se intenta crear ya existe.' AS ERROR;
    ELSE
        IF (@roleName = 'Student' OR @roleName = 'Tutor')
            BEGIN
                INSERT INTO ROLES (Id, RoleName)
                    VALUES (NEWID(), @roleName)
                SELECT 'Rol creado correctamente.' AS MENSAJE;
            END
        ELSE
            SELECT CONCAT('No es posible crear el rol "', @roleName, '", los roles validos son: "Student" y "Tutor".') AS ERROR;
END;
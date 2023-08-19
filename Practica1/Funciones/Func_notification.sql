-- Func_notification_usuarios: Retorna las notificaciones que hayan sido enviadas a un usuario.
DROP FUNCTION IF EXISTS practica1.F3;

CREATE FUNCTION practica1.F3 ( @id uniqueidentifier ) RETURNS TABLE
AS
RETURN (
    SELECT * FROM Notification WHERE UserId = @id
);
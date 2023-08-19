CREATE FUNCTION practica1.F5(@Id uniqueidentifier)
RETURNS TABLE 
AS 
RETURN (
    SELECT u.Firstname, u.Lastname, u.Email, u.DateOfBirth, ps.Credits, r.RoleName
    FROM practica1.Usuarios u  
    INNER JOIN practica1.ProfileStudent ps ON u.Id = ps.UserId 
    INNER JOIN practica1.Roles r on ps.UserId = r.Id
    WHERE u.Id = @Id
)
CREATE TRIGGER Trigger12
ON practica1.Roles 
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RoleName AS VARCHAR(MAX);
    SET @RoleName = CONVERT(VARCHAR(MAX), (SELECT RoleName FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un rol: ' + @RoleName;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger13
ON practica1.Course
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @CodCourse AS INT;
    SET @CodCourse = CONVERT(INT, (SELECT CodCourse FROM INSERTED));

    DECLARE @Name AS VARCHAR(MAX);
    SET @Name = CONVERT(VARCHAR(MAX), (SELECT Name FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un curso con id: ' + @CodCourse + ', y nombre: ' + @Name;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger14
ON practica1.Usuarios
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @Firstname AS VARCHAR(MAX);
    SET @Firstname = CONVERT(VARCHAR(MAX), (SELECT Firstname FROM INSERTED));

    DECLARE @Lastname AS VARCHAR(MAX);
    SET @Lastname = CONVERT(VARCHAR(MAX), (SELECT Lastname FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un usuario con nombre: ' + @Firstname + ' ' + @Lastname;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger15
ON practica1.CourseAssignment
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @StudentId AS uniqueidentifier;
    SET @StudentId = CONVERT(uniqueidentifier, (SELECT StudentId FROM INSERTED));

    DECLARE @CourseCodCourse AS int;
    SET @CourseCodCourse = CONVERT(int, (SELECT CourseCodCourse FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado una asignación de curso al estudiante: ' + CAST(@StudentId AS VARCHAR(36)) + ', al curso: ' + @CourseCodCourse;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger16
ON practica1.CourseTutor
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @TutorId AS uniqueidentifier;
    SET @TutorId = CONVERT(uniqueidentifier, (SELECT TutorId FROM INSERTED));

    DECLARE @CourseCodCourse AS int;
    SET @CourseCodCourse = CONVERT(int, (SELECT CourseCodCourse FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado una asignación de tutor al curso: ' + @CourseCodCourse + ', el tutor será: ' + CAST(@TutorId AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger17
ON practica1.Notification
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM INSERTED));

    DECLARE @Message AS VARCHAR(MAX);
    SET @Message = CONVERT(VARCHAR(MAX), (SELECT Message FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado una notificación al usuario: ' + CAST(@UserId AS VARCHAR(36)) + ', con el siguiente mensaje: ' + @Message;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger18
ON practica1.ProfileStudent
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM INSERTED));

    DECLARE @Credits AS int;
    SET @Credits = CONVERT(int, (SELECT Credits FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un perfil de usuario al estudiante: ' + CAST(@UserId AS VARCHAR(36)) + ', con: ' + @Credits + ' créditos';

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger19
ON practica1.TFA
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM INSERTED));

    DECLARE @Status AS bit;
    SET @Status = CONVERT(bit, (SELECT Status FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un TFA al usuario: ' + CAST(@UserId AS VARCHAR(36)) + ', con estatus: ' +  CAST(@Status AS VARCHAR(2));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger20
ON practica1.TutorProfile
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM INSERTED));

    DECLARE @TutorCode AS VARCHAR(MAX);
    SET @TutorCode = CONVERT(VARCHAR(MAX), (SELECT TutorCode FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un perfil de tutor: ' + CAST(@UserId AS VARCHAR(36)) + ', con id de tutor: ' + @TutorCode;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger21
ON practica1.UsuarioRole
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RoleId AS uniqueidentifier;
    SET @RoleId = CONVERT(uniqueidentifier, (SELECT RoleId FROM INSERTED));

    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un rol de usuario: ' + CAST(@RoleId AS VARCHAR(36)) + ', al usuario: ' + CAST(@UserId AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger22
ON practica1.UsuarioRole
AFTER UPDATE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RoleId AS uniqueidentifier;
    SET @RoleId = CONVERT(uniqueidentifier, (SELECT RoleId FROM INSERTED));

    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM INSERTED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha actualizado un rol de usuario: ' + CAST(@RoleId AS VARCHAR(36)) + ', al usuario: ' + CAST(@UserId AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
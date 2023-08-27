CREATE TRIGGER Trigger23
ON practica1.Roles 
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RoleName AS VARCHAR(MAX);
    SET @RoleName = CONVERT(VARCHAR(MAX), (SELECT RoleName FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un rol: ' + @RoleName;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger24
ON practica1.Course
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @CodCourse AS INT;
    SET @CodCourse = CONVERT(INT, (SELECT CodCourse FROM DELETED));

    DECLARE @Name AS VARCHAR(MAX);
    SET @Name = CONVERT(VARCHAR(MAX), (SELECT Name FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un curso con id: ' + CAST(@CodCourse AS VARCHAR(36)) + ', y nombre: ' + @Name;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger25
ON practica1.Usuarios
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @Firstname AS VARCHAR(MAX);
    SET @Firstname = CONVERT(VARCHAR(MAX), (SELECT Firstname FROM DELETED));

    DECLARE @Lastname AS VARCHAR(MAX);
    SET @Lastname = CONVERT(VARCHAR(MAX), (SELECT Lastname FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un usuario con nombre: ' + @Firstname + ' ' + @Lastname;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger26
ON practica1.CourseAssignment
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @StudentId AS uniqueidentifier;
    SET @StudentId = CONVERT(uniqueidentifier, (SELECT StudentId FROM DELETED));

    DECLARE @CourseCodCourse AS int;
    SET @CourseCodCourse = CONVERT(int, (SELECT CourseCodCourse FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado una asignación de curso al estudiante: ' + CAST(@StudentId AS VARCHAR(36)) + ', al curso: ' + CAST(@CourseCodCourse AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger27
ON practica1.CourseTutor
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @TutorId AS uniqueidentifier;
    SET @TutorId = CONVERT(uniqueidentifier, (SELECT TutorId FROM DELETED));

    DECLARE @CourseCodCourse AS int;
    SET @CourseCodCourse = CONVERT(int, (SELECT CourseCodCourse FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado una asignación de tutor al curso: ' + CAST(@CourseCodCourse AS VARCHAR(36)) + ', el tutor será: ' + CAST(@TutorId AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger28
ON practica1.Notification
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM DELETED));

    DECLARE @Message AS VARCHAR(MAX);
    SET @Message = CONVERT(VARCHAR(MAX), (SELECT Message FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado una notificación al usuario: ' + CAST(@UserId AS VARCHAR(36)) + ', con el siguiente mensaje: ' + @Message;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger29
ON practica1.ProfileStudent
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM DELETED));

    DECLARE @Credits AS int;
    SET @Credits = CONVERT(int, (SELECT Credits FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un perfil de usuario al estudiante: ' + CAST(@UserId AS VARCHAR(36)) + ', con: ' + CAST(@Credits AS VARCHAR(36)) + ' créditos';

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger30
ON practica1.TFA
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM DELETED));

    DECLARE @Status AS bit;
    SET @Status = CONVERT(bit, (SELECT Status FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un TFA al usuario: ' + CAST(@UserId AS VARCHAR(36)) + ', con estatus: ' + CAST(@Status AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger31
ON practica1.TutorProfile
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM DELETED));

    DECLARE @TutorCode AS VARCHAR(MAX);
    SET @TutorCode = CONVERT(VARCHAR(MAX), (SELECT TutorCode FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un perfil de tutor: ' + CAST(@UserId AS VARCHAR(36)) + ', con id de tutor: ' + @TutorCode;

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger32
ON practica1.UsuarioRole
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RoleId AS uniqueidentifier;
    SET @RoleId = CONVERT(uniqueidentifier, (SELECT RoleId FROM DELETED));

    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un rol de usuario: ' + CAST(@RoleId AS VARCHAR(36)) + ', al usuario: ' + CAST(@UserId AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
-- =================================================================================
CREATE TRIGGER Trigger33
ON practica1.UsuarioRole
AFTER DELETE 
AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RoleId AS uniqueidentifier;
    SET @RoleId = CONVERT(uniqueidentifier, (SELECT RoleId FROM DELETED));

    DECLARE @UserId AS uniqueidentifier;
    SET @UserId = CONVERT(uniqueidentifier, (SELECT UserId FROM DELETED));

    DECLARE @Mensaje AS VARCHAR(MAX);
    SET @Mensaje = 'Se ha eliminado un rol de usuario: ' + CAST(@RoleId AS VARCHAR(36)) + ', al usuario: ' + CAST(@UserId AS VARCHAR(36));

    INSERT INTO practica1.HistoryLog([Date], Description)
    VALUES (GETDATE(), @Mensaje);
END
GO
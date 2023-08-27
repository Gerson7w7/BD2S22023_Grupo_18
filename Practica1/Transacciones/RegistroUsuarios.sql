USE BD2;
DROP PROCEDURE IF EXISTS [practica1].[PR1];

CREATE PROCEDURE [practica1].[PR1]
    @FirstName NVARCHAR(MAX),
    @LastName NVARCHAR(MAX),
    @Email NVARCHAR(MAX),
    @DateOfBirth DATETIME2,
    @Password NVARCHAR(MAX),
    @Credits INT
AS
BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @RoleId UNIQUEIDENTIFIER;
    DECLARE @TFAStatus BIT = 0; -- Por defecto el TFA esta desactivado


    IF NOT EXISTS (SELECT 1 FROM [practica1].[Usuarios] WHERE [Email] = @Email)
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            INSERT INTO [practica1].[Usuarios] ([Id], [Firstname], [Lastname], [Email], [DateOfBirth], [Password], [LastChanges], [EmailConfirmed])
            VALUES (NEWID(), @FirstName, @LastName, @Email, @DateOfBirth, @Password, GETDATE(), 1); -- EmailConfirmed establecido en 1

            SET @UserId = (SELECT [Id] FROM [practica1].[Usuarios] WHERE [Email] = @Email);
            SET @RoleId = (SELECT [Id] FROM [practica1].[Roles] WHERE [RoleName] = 'Student');

            INSERT INTO [practica1].[UsuarioRole] ([RoleId], [UserId], [IsLatestVersion])
            VALUES (@RoleId, @UserId, 1);

            INSERT INTO [practica1].[ProfileStudent] ([UserId], [Credits])
            VALUES (@UserId, @Credits);

            -- Registrar TFA si está habilitado
            IF @TFAStatus = 1
            BEGIN
                INSERT INTO [practica1].[TFA] ([UserId], [Status], [LastUpdate])
                VALUES (@UserId, 0, GETDATE()); -- Se establece el estado TFA como no activo
            END;

            INSERT INTO [practica1].[Notification] ([UserId], [Message], [Date])
            VALUES (@UserId, '¡Bienvenido a nuestro sistema!', GETDATE());
            print 'Transacción realizada, bienvenido a nuestro sistema'
            INSERT INTO practica1.HistoryLog([Date], Description)
            VALUES (GETDATE(), CONCAT('Se ha registrado un nuevo usuario ', @Email));
            -- Confirmacion de la transaccion
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            print 'Revirtiendo la transacción'
            SELECT 'Error: Revirtiendo la transacción' AS Error;
            ROLLBACK TRANSACTION;
            -- Manejo de errores
        END CATCH;
    END;
END;


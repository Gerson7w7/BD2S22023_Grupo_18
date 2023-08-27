DROP PROCEDURE IF EXISTS practica1.PR3;

CREATE PROCEDURE practica1.PR3 ( @email NVARCHAR(MAX), @codCourse INT ) AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @idUser uniqueidentifier;
        DECLARE @idTutor uniqueidentifier;
        DECLARE @creditosUser INT;
        DECLARE @creditosCurso INT;
        DECLARE @nombreCurso NVARCHAR(MAX);
        DECLARE @repetidos INT;

        SELECT @idUser = Id FROM Usuarios u WHERE u.Email = @email;
        IF (@idUser IS NULL)
            BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'No existe un usuario con el email ingresado.' AS ERROR;
            INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida, no existe un usuario con el email ingresado.');
            END;
        ELSE
            BEGIN
            SELECT @creditosUser = Credits FROM ProfileStudent ps WHERE ps.UserId = @idUser;
            IF (@creditosUser IS NULL)
                BEGIN
                ROLLBACK TRANSACTION;
                SELECT 'El usuario que se intenta asignar no cuenta con un perfil de estudiante.' AS ERROR;
                INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida, el usuario que se intenta asignar no cuenta con un perfil de estudiante.');
                END;
            ELSE
                BEGIN
                SELECT @creditosCurso = CreditsRequired, @nombreCurso = Name FROM Course c WHERE c.CodCourse = @codCourse;
                IF (@creditosCurso IS NULL)
                    BEGIN
                        ROLLBACK TRANSACTION;
                        SELECT 'No existe el curso que se intenta asignar.' AS ERROR;
                        INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida, no existe el curso que se intenta asignar.');
                    END;
                ELSE
                    BEGIN
                    IF (@creditosUser >= @creditosCurso)
                        BEGIN
                        SET @IdTutor = (SELECT TOP 1 TutorId FROM practica1.CourseTutor WHERE CourseCodCourse = @codCourse)
                        IF (@IdTutor IS NULL)
                            BEGIN
                                ROLLBACK TRANSACTION;
                                SELECT 'Asignación fallida, no existe un tutor asignado al curso.' AS ERROR;
                                INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida, el curso no cuenta con un tutor asignado.');
                            END;
                        ELSE
                            BEGIN
                                SET @repetidos = (SELECT COUNT(*) FROM practica1.CourseAssignment WHERE StudentId = @idUser and CourseCodCourse = @codCourse);
                                IF (@repetidos > 0)
                                    BEGIN
                                        ROLLBACK TRANSACTION;
                                        SELECT 'Asignación fallida, el estudiante ya se encuentra asignado al curso.' AS ERROR;
                                        INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida, el estudiante ya se encuentra asignado al curso.');
                                    END;
                                ELSE
                                    BEGIN
                                        -- Asignación
                                        INSERT INTO CourseAssignment (StudentId, CourseCodCourse)
                                            VALUES (@idUser, @codCourse);

                                        -- Notificación estudiante
                                        INSERT INTO Notification (UserId, Message, Date)
                                            VALUES (@idUser, CONCAT('Usted ha sido asignado al curso ', @codCourse, ' - ', @nombreCurso, ' exitosamente.'), GETDATE());

                                        -- Notificación tutor
                                        INSERT INTO Notification (UserId, Message, Date)
                                            -- verificar que exista tutor en 
                                            VALUES ((SELECT TOP 1 TutorId FROM practica1.CourseTutor WHERE CourseCodCourse = @codCourse),
                                                CONCAT('El estudiante con ID de usuario: ', @idUser, ' ha sido asignado al curso ', @codCourse, ' - ', @nombreCurso, ' exitosamente.'), GETDATE());

                                        COMMIT TRANSACTION;
                                        SELECT 'Curso asignado correctamente.' AS MENSAJE;
                                    END;
                            END;
                        END;
                    ELSE
                        BEGIN
                            ROLLBACK TRANSACTION;
                            SELECT 'El estudiante no cumple con la cantidad de créditos necesarios para asignarse al curso.' AS ERROR;
                            INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida, el estudiante no cuenta con los créditos necesarios.');
                        END;
                    END;
                END;
            END;             
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Ha ocurrido un error, no fue posible asignar el curso.' AS ERROR;
        INSERT INTO HistoryLog (Date, Description) VALUES (GETDATE(), 'Asignación de curso fallida.');
    END CATCH;    
END;
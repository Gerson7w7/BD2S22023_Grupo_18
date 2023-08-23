DROP FUNCTION IF EXISTS [practica1].[F1];

CREATE FUNCTION [practica1].[F1]
(
    @CodCourse INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        U.[Id] AS UserId,
        U.[Firstname] AS FirstName,
        U.[Lastname] AS LastName
    FROM
        [practica1].[Usuarios] U
    INNER JOIN
        [practica1].[CourseAssignment] CA ON U.[Id] = CA.[StudentId]
    WHERE
        CA.[CourseCodCourse] = @CodCourse
);

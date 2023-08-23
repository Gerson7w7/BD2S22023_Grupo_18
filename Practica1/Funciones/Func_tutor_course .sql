DROP FUNCTION IF EXISTS [practica1].[F2];

CREATE function F2(@Id INT)
returns table
as
return (
	Select
		C.CodCourse,
		C.Name
	from practica1.TutorProfile TP
	inner join practica1.Usuarios U on TP.UserId = U.Id
	inner join practica1.CourseTutor CT on CT.TutorId = U.Id
	inner join practica1.Course C on C.CodCourse = CT.CourseCodCourse
	where TP.Id = @Id
);
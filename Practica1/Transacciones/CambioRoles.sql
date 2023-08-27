USE BD2
DROP PROCEDURE IF EXISTS [practica1].[PR2];

create procedure [practica1].[PR2]
	@Email nvarchar(max),
	@CodCourse int
as
begin
	begin transaction;

	declare @userId uniqueidentifier;
	declare @found bit = 0;

	select @userId = u.Id, @found = 1 from practica1.Usuarios u where u.Email = @Email;

	if @found = 0 begin
		print 'No existe ningun usuario registrado con ese correo';
		SELECT 'No existe ningun usuario registrado con ese correo' AS Error;
		rollback;
	end
	else begin
		set @found = 0;
		select @found = 1 from practica1.Course c where c.CodCourse = @CodCourse;

		if (@found = 1) begin

			set @found = 0;
			select @found = 1 from practica1.TutorProfile tp where tp.UserId = @userId;

			if @found = 0 begin
				insert into practica1.UsuarioRole (RoleId, UserId, IsLatestVersion)
				values ('2cf8e1cf-3cd6-44f3-8f86-1386b7c17657', @userId, 1);

				insert into practica1.TutorProfile (UserId, TutorCode)
				values (@userId, convert(nvarchar(max), NEWID()));
			end
			insert into practica1.CourseTutor (TutorId, CourseCodCourse)
			values (@userId, @CodCourse);

			insert into practica1.Notification (UserId, Message, [Date])
			values (@userId, 'Se ha registrado como tutor de un nuevo curso', CAST(GETDATE() as Date));

			print 'Se realizo la transaccion de forma exitosa';
			INSERT INTO practica1.HistoryLog([Date], Description)
            VALUES (GETDATE(), CONCAT('Se ha registrado como tutor de un nuevo curso ', @Email));
			commit;
		end
		else
		begin
			print 'El curso que intenta asignar no existe';
			SELECT 'El curso que intenta asignar no existe' AS Error;
			rollback;
		end
	end
end


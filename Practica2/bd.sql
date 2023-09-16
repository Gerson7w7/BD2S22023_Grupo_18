CREATE DATABASE Practica2;

SHOW DATABASES;

USE Practica2;

CREATE TABLE LOG_ACTIVIDAD (
	id_log_actividad INT auto_increment PRIMARY KEY,
    timestampx VARCHAR(100),
    actividad VARCHAR(500),
    PACIENTE_idPaciente INT,
    HABITACION_idHabitacion INT
);

CREATE TABLE HABITACION (
idHabitacion INT auto_increment primary KEY,
Habitacion varchar(50)
);

CREATE TABLE PACIENTE(
	idPaciente INT auto_increment primary key,
    edad int,
    genero varchar(20)
);

CREATE TABLE LOG_HABITACION(
	timestampx varchar(100) PRIMARY KEY,
    statusx VARCHAR(15),
    idHabitacion INT
);

ALTER TABLE LOG_ACTIVIDAD
ADD CONSTRAINT fk_log_actividad_paciente
foreign key (PACIENTE_idPaciente)
REFERENCES PACIENTE(idPaciente)
ON DELETE CASCADE;


ALTER TABLE LOG_ACTIVIDAD
ADD CONSTRAINT fk_habitacion_log_actividad
foreign key (HABITACION_idHabitacion)
REFERENCES HABITACION(idHabitacion)
ON DELETE CASCADE;

ALTER TABLE LOG_HABITACION
ADD CONSTRAINT fk_habitacion_log_habitacion
foreign key (idHabitacion)
REFERENCES HABITACION(idHabitacion)
ON DELETE CASCADE;

GRANT ALTER ANY LOGIN TO sqlserver AS CustomerDbRootRole;

CREATE CREDENTIAL [s3://storage.googleapis.com/sqlserver_proyecto2]
WITH IDENTITY = 'S3 Access Key'
	, SECRET = 'GOOGZXJGTVASPFJOI5FRKH74:EocqVWG9uZ3fKOBFU71aWDVacelk1J7hpCxK/zur' 
AS CustomerDbRootRole;
	
BACKUP DATABASE [Videojuegos]
TO URL = 's3://storage.googleapis.com/sqlserver_proyecto2/full_backup.bak'
WITH compression, stats=1;

-- Backup
BACKUP DATABASE Videojuegos
TO DISK = '/var/opt/mssql/data/full_backup.bak'
WITH INIT;

-- Si no deja eliminar base
USE master;
ALTER DATABASE Videojuegos SET AUTO_CLOSE OFF;
DROP DATABASE Videojuegos;

-- Restaurar backup
RESTORE DATABASE Videojuegos
FROM DISK = '/var/opt/mssql/data/full_backup.bak'
WITH RECOVERY;

-- Crear base nueva
USE master;
CREATE DATABASE Calificacion;
-- Restaurar backup en base nueva
RESTORE DATABASE Calificacion
FROM DISK = '/var/opt/mssql/data/full_backup.bak'
WITH MOVE 'Videojuegos' TO '/var/opt/mssql/data/Calificacion.mdf',
    MOVE 'Videojuegos_Log' TO '/var/opt/mssql/data/Calificacion_Log.ldf',
    REPLACE;

-- truncar bitácora
SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'Videojuegos';
ALTER DATABASE Videojuegos SET RECOVERY FULL;
BACKUP LOG Videojuegos TO DISK = 'NUL';
DBCC SHRINKFILE(N'NombreDeLaBaseDeDatos_log', 1);

-- Collation de la base de datos
SELECT DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS DatabaseCollation;

-- Collation de las tablas y columnas
SELECT TABLE_NAME, COLUMN_NAME, COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'; -- Puedes ajustar el esquema según tu configuración

-- Obtener información sobre la fragmentación de índices
SELECT
    OBJECT_NAME(ind.OBJECT_ID) AS TableName,
    ind.name AS IndexName,
    indexstats.index_type_desc AS IndexType,
    indexstats.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
INNER JOIN sys.indexes ind ON ind.object_id = indexstats.object_id AND ind.index_id = indexstats.index_id
WHERE indexstats.avg_fragmentation_in_percent > 10; -- Ajusta el umbral según tus criterios
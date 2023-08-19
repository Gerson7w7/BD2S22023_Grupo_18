-- Func_logger: Función que retornará la información almacenada en la tabla HistoryLog.
DROP FUNCTION IF EXISTS practica1.F4;

CREATE FUNCTION practica1.F4 () RETURNS TABLE
AS
RETURN (
    SELECT * FROM HistoryLog
);
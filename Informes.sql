/*
 INFORMES
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'informeProgresoCliente')
BEGIN
    DROP PROCEDURE informeProgresoCliente
END
GO
--Creación de un Procedimiento Almacenado que permita visualizar un informe del prgreso del cliente, 
--a través de la cedula del cliente.
CREATE PROCEDURE informeProgresoCliente (@cedulaCliente nvarchar(12))
AS
BEGIN
	/Validacion de datos de entrada de cliente/
	if ((SELECT COUNT (*) FROM Cliente C WHERE C.numeroCedula = @cedulaCliente) = 0)
	BEGIN
		RAISERROR('INGRESE UNA CEDULA VALIDA O VERIFIQUE QUE EL CLIENTE EXISTA', 16,1)
		RETURN
	END

	--Se declaran los argumentos que recibe el procedimiento almacenado
	DECLARE @idCliente AS TINYINT
	DECLARE @nombresCliente AS NVARCHAR(100)
	DECLARE @apellidosClientes AS NVARCHAR(100)
	DECLARE @fechaInicioPlanEntenamiento AS DATE
	DECLARE @idPrimeraCitaMedica AS TINYINT
	DECLARE @alturaInicial AS DECIMAL(3,2)
	DECLARE @pesoInicial AS  DECIMAL(5,2)
	DECLARE @IGCInicial AS DECIMAL (3,1)

	--Se asigna un valor a las variables
	SET @idCliente = (SELECT TOP 1 idCliente FROM Cliente WHERE numeroCedula = @cedulaCliente)
	SET @nombresCliente = (SELECT TOP 1 nombres FROM Cliente WHERE idCliente = @idCliente)
	SET @apellidosClientes = (SELECT TOP 1 apellidos FROM Cliente WHERE idCliente = @idCliente)
	SET @idPrimeraCitaMedica = (SELECT TOP 1 idCita FROM Cita WHERE idCita = @idCliente)
	SET @alturaInicial = (SELECT alturaActual FROM RegistroMedico WHERE idRegistroMedico = (SELECT TOP 1 idRegistroMedico FROM RegistroMedico WHERE idCita = @idPrimeraCitaMedica))
	SET @pesoInicial = (SELECT pesoActual FROM RegistroMedico WHERE idRegistroMedico = (SELECT TOP 1 idRegistroMedico FROM RegistroMedico WHERE idCita = @idPrimeraCitaMedica))
	SET @IGCInicial = (SELECT indiceGrasaCorporal FROM RegistroMedico WHERE idRegistroMedico = (SELECT TOP 1 idRegistroMedico FROM RegistroMedico WHERE idCita = @idPrimeraCitaMedica))

	

	/Se muestra la informacion con la que el cliente llego al gimnasio, es decir la inicial/
	PRINT('*************Life Fitness Gym*************')
	PRINT('Cliente: ' + @nombresCliente + ' ' + @apellidosClientes)
	PRINT('*********Información inicial del cliente sobre su progreso*********')
	PRINT('Altura inicial: ' + CONVERT(NVARCHAR(10), @alturaInicial, 120))
	PRINT('Peso inicial: ' + CONVERT(NVARCHAR(10), @pesoInicial, 120))
	PRINT('Indice de grasa corporal inicial: ' + CONVERT(NVARCHAR(10), @IGCInicial, 120))

	/Se declaran la variables que se van a usar en el cursor/
	DECLARE @idCita SMALLINT, @fechaRegistro DATE, @alturaActual DECIMAL(3,2), @pesoActual DECIMAL(5,2), @indiceGrasaCorporal DECIMAL (3,1), @estadoSalud NVARCHAR(10)
	
	/SE declara y se usa el cursor/
	DECLARE cursorRegistroMedico CURSOR FOR 
		SELECT REG.idCita, REG.fechaRegistro ,REG.alturaActual, REG.pesoActual, REG.indiceGrasaCorporal, REG.estadoSalud
		FROM RegistroMedico REG
		INNER JOIN Cita C ON C.idCita = REG.idCita
		INNER JOIN Cliente Cli ON Cli.idCliente = @idCliente
		ORDER BY REG.idCita

	OPEN cursorRegistroMedico

	FETCH NEXT FROM cursorRegistroMedico INTO @idCita, @fechaRegistro, @alturaActual, @pesoActual, @indiceGrasaCorporal, @estadoSalud

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		PRINT('')
		PRINT('*********Fecha registro: ' + CONVERT(NVARCHAR(10), @fechaRegistro, 120) + ' *********')
		PRINT('Altura a la fecha: ' + CONVERT(NVARCHAR(10), @alturaActual, 120))
		PRINT('Peso a la fecha: ' + CONVERT(NVARCHAR(10), @pesoActual, 120))
		PRINT('Indice de grasa corporal a la fecha: ' + CONVERT(NVARCHAR(10), @indiceGrasaCorporal, 120))
		PRINT('Estado de salud a la fecha: ' + CONVERT(NVARCHAR(10), @estadoSalud, 120))
		PRINT('')
		
		FETCH NEXT FROM cursorRegistroMedico INTO @idCita, @fechaRegistro, @alturaActual, @pesoActual, @indiceGrasaCorporal, @estadoSalud
	END

	CLOSE cursorRegistroMedico
	DEALLOCATE cursorRegistroMedico
END


--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'registrarAsistencia')
BEGIN
    DROP PROCEDURE registrarAsistencia
END
GO
--Creación de un Procedimiento Almacenado que permita registrar la asistencia de un cliente, 
--a través de la cedula del cliente.
CREATE PROCEDURE registrarAsistencia (@cedulaCliente nvarchar(12))
AS
BEGIN
	--Se verifica que eita el cliente
	if ((SELECT COUNT (*) FROM Cliente C WHERE C.numeroCedula = @cedulaCliente) = 0)
	BEGIN
		RAISERROR('INGRESE UNA CEDULA VALIDA O VERIFIQUE QUE EL CLIENTE EXISTA', 16,1)
		ROLLBACK TRANSACTION
	END

	--Se declaran las variables necesarias
	DECLARE @idCliente AS INT

	--Se asigan valor a las variables
	SET @idCliente = (SELECT TOP 1 idCliente FROM Cliente WHERE numeroCedula = @cedulaCliente)

	--Se verifica si el valor del campo es null, si s null entonces se establece la asistencia en 1, sino esta incrementa en 1 con cada llamada al procedure
	IF EXISTS ((SELECT TOP 1 asistencia FROM PlanEntrenamiento WHERE idCliente = @idCliente AND asistencia IS NULL ORDER BY idPlanEntrenamiento DESC) )
		BEGIN
			PRINT('No tenia asistencia')
			UPDATE PlanEntrenamiento 
			SET asistencia = 1
			WHERE  idPlanEntrenamiento = (SELECT TOP 1 idPlanEntrenamiento FROM PlanEntrenamiento WHERE idCliente = @idCliente ORDER BY idPlanEntrenamiento DESC)
			PRINT('Asistencia registrada correctamente')
		END
	ELSE
		BEGIN
			PRINT('Ha estado asisteniendo')
			UPDATE PlanEntrenamiento 
			SET asistencia += 1
			WHERE  idPlanEntrenamiento = (SELECT TOP 1 idPlanEntrenamiento FROM PlanEntrenamiento WHERE idCliente = @idCliente ORDER BY idPlanEntrenamiento DESC)
			PRINT('Asistencia registrada correctamente')
		END
END

--PROYECTO IMPLEMENTADO

/*
El siguiente script fue desarrollado por: David Trujillo, Sebastián Andrade y Jose Miguel Merlo
Fecha de creacion: 08-05-2023 
Última versión: 11-05-2023 

**********************************
-- Verificacion de existencia de la base de datos y creacion de la misma
**********************************
*/
-- Usar master para creación de base.
USE Master
GO

--Crear los inicios de sesión (logins):
--Comprobando la existencia de inicios de sesion
IF EXISTS (SELECT * FROM sys.syslogins WHERE name = 'Administrador')
BEGIN
    DROP LOGIN Administrador;
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE name = 'Cliente')
BEGIN
    DROP LOGIN Cliente;
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE name = 'Entrenador')
BEGIN
    DROP LOGIN Entrenador;
END
    
IF EXISTS (SELECT * FROM sys.syslogins WHERE name = 'PersonalSalud')
BEGIN
    DROP LOGIN PersonalSalud;
END
GO

--Creando los inicios de sesión
CREATE LOGIN Administrador WITH PASSWORD = 'TuContraseñaSegura1';
CREATE LOGIN Cliente WITH PASSWORD = 'TuContraseñaSegura2';
CREATE LOGIN Entrenador WITH PASSWORD = 'TuContraseñaSegura3';
CREATE LOGIN PersonalSalud WITH PASSWORD = 'TuContraseñaSegura4';
GO



-- Verificar si la base de datos Gimnasio ya existe; si existe, eliminarla
IF EXISTS(SELECT name FROM sys.databases WHERE name = 'Gimnasio')
BEGIN
    DROP DATABASE Gimnasio;
END

CREATE DATABASE Gimnasio;
GO


/*********************************************************
USUARIOS
**********************************************************/
-- Crear los usuarios en la base de datos y asociarlos con los inicios de sesión:
-- Comprobar la existencia de los usuarios y borrarlos en caso de ser así
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Administrador')
    DROP USER Administrador;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Cliente')
    DROP USER Cliente;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Entrenador')
    DROP USER Entrenador;

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'PersonalSalud')
    DROP USER PersonalSalud;
GO

-- Creando usuarios
CREATE USER Administrador FOR LOGIN Administrador;
CREATE USER Cliente FOR LOGIN Cliente;
CREATE USER Entrenador FOR LOGIN Entrenador;
CREATE USER PersonalSalud FOR LOGIN PersonalSalud;
GO


--Asignar roles y permisos a los usuarios según sus responsabilidades:
-- Administrador: Otorgar permisos de administración
EXEC sp_addrolemember 'db_owner', 'Administrador';

-- Cliente: Otorgar permisos de lectura y escritura
EXEC sp_addrolemember 'db_datareader', 'Cliente';
EXEC sp_addrolemember 'db_datawriter', 'Cliente';

-- Entrenador: Otorgar permisos de lectura y escritura
EXEC sp_addrolemember 'db_datareader', 'Entrenador';
EXEC sp_addrolemember 'db_datawriter', 'Entrenador';

-- Personal Salud: Otorgar permisos de lectura
EXEC sp_addrolemember 'db_datareader', 'PersonalSalud';
GO



/*
**********************************
-- Verificacion de existencia de reglas y tipos; creacion de las mismas
**********************************
*/

-- Usar la base de datos Gimnasio
USE Gimnasio
GO

-- Validar si existe el tipo de dato correo y crear tipo de dato para correo electrónico
IF EXISTS(SELECT name FROM sys.systypes WHERE name = 'correo')
BEGIN
    DROP TYPE correo;
END

CREATE TYPE correo FROM varchar(320) NOT NULL 
GO

-- Validar si existe el tipo de dato cedulaIdentidad y crear tipo de dato para cedulaIdentidad
IF EXISTS(SELECT name FROM sys.systypes WHERE name = 'cedulaIdentidad')
BEGIN
    DROP TYPE cedulaIdentidad;
END

CREATE TYPE cedulaIdentidad FROM char(10) NOT NULL
GO

-- Validar si existe el tipo de dato celular y crear tipo de dato para celular
IF EXISTS(SELECT name FROM sys.systypes WHERE name = 'celular')
BEGIN
    DROP TYPE celular;
END

CREATE TYPE celular FROM char(10) NOT NULL
GO

--  Validar si existe la regla "cedulaIdentidad_rule" y crear la regla
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'R' AND name = 'cedulaIdentidad_rule')
BEGIN
    DROP RULE cedulaIdentidad_rule;
END
GO

-- Creación de la regla que valide que el tipo de dato cedulaIdentidad siga los parámetros de una cédula de identidad Ecuatoriana
CREATE RULE cedulaIdentidad_rule AS @value LIKE '[2][0-4][0-5][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    OR @value LIKE '[1][0-9][0-5][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    OR @value LIKE '[0][1-9][0-5][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    OR @value LIKE '[3][0][0-5][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    AND SUBSTRING(@value, 3, 1) BETWEEN '0'
    AND '5'
    AND CAST(SUBSTRING(@value, 10, 1) AS INT) = (
        (
            2 * CAST(SUBSTRING(@value, 1, 1) AS INT) + 1 * CAST(SUBSTRING(@value, 2, 1) AS INT) + 2 * CAST(SUBSTRING(@value, 3, 1) AS INT) + 1 * CAST(SUBSTRING(@value, 4, 1) AS INT) + 2 * CAST(SUBSTRING(@value, 5, 1) AS INT) + 1 * CAST(SUBSTRING(@value, 6, 1) AS INT) + 2 * CAST(SUBSTRING(@value, 7, 1) AS INT) + 1 * CAST(SUBSTRING(@value, 8, 1) AS INT) + 2 * CAST(SUBSTRING(@value, 9, 1) AS INT)
        ) % 10
    )
GO

-- Asociar tipo de dato "cedulaIdentidad" con regla "cedulaIdentidad_rule"
EXEC sp_bindrule 'cedulaIdentidad_rule', 'cedulaIdentidad';
GO

--  Validar si existe la regla "correo_rule" y crear la regla
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'R' AND name = 'correo_rule')
BEGIN
    DROP RULE correo_rule;
END
GO

-- Creación de la regla que valide que el tipo de dato correo siga los parámetros requeridos por un email.
CREATE RULE correo_rule
AS
    @Correo LIKE '%@%' AND
    LEN(@Correo) <= 320 AND
    LEN(SUBSTRING(@Correo, 1, CHARINDEX('@', @Correo)-1)) BETWEEN 2 AND 64 AND --LA PARTE ANTES DEL '@' DEBE TENER ENTRE 2 Y 64 CARACTERES
    LEN(SUBSTRING(@Correo, CHARINDEX('@', @Correo)+1, LEN(@Correo)-CHARINDEX('@', @Correo))) BETWEEN 4 AND 255 AND --LA PARTE DESPUES DEL '@' DEBE TENER ENTRE 4 Y 255 CARACTERES
    SUBSTRING(@Correo, 1, 1) LIKE '[a-zA-Z0-9]' AND --VALIDA QUE EL PRIMER CARACTER SIEMPRE SEA UNA LETRA O NUMERO
    SUBSTRING(@Correo, LEN(@Correo), 1) NOT LIKE '[0-9]' AND --VALIDA QUE EL ULTIMO CARACTER NO SEA UN NUMERO
	SUBSTRING(@Correo, LEN(@Correo), 1) NOT LIKE '[-]' AND -- VALIDA QUE EL DOMINIO NO TERMINE CON '-'
	SUBSTRING(@Correo, CHARINDEX('@', @Correo)+1,1) NOT LIKE '[-]' AND -- VALIDA QUE EL DOMINIO NO EMPIECE CON '-'
    NOT (@Correo LIKE '%..%') AND --VALIDA QUE NO HAYAN DOS PUNTOS SEGUIDOS
	NOT (@Correo LIKE '%@%@%') AND  -- VALIDA QUE NO HAYAN DOS ARROBAS
    SUBSTRING(@Correo, CHARINDEX('@', @Correo)+1, LEN(@Correo)-CHARINDEX('@', @Correo)) LIKE '%.[a-zA-Z][a-zA-Z][a-zA-Z]' OR -- VALIDA QUE LA EXTENSION DEL DOMINIO TENGA 4 CARACTERES
    SUBSTRING(@Correo, CHARINDEX('@', @Correo)+1, LEN(@Correo)-CHARINDEX('@', @Correo)) LIKE '%.[a-zA-Z][a-zA-Z]' -- VALIDA QUE LA EXTENSION DEL DOMINIO TENGA 3 CARACTERES 
GO

-- Asociar tipo de dato "correo" con regla "correo_rule"
EXEC sp_bindrule 'correo_rule', 'correo';
GO

--  Validar si existe la regla "celular_rule" y crear la regla
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'R' AND name = 'celular_rule')
BEGIN
    DROP RULE celular_rule;
END
GO

-- Creación de la regla que valide que el tipo de dato celular siga los parámetros de un celular ecuatoriano
CREATE RULE celular_rule AS @value LIKE '[0][9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
   
GO

-- Asociar tipo de dato "celular" con regla "celular_rule"
EXEC sp_bindrule 'celular_rule', 'celular';
GO
/*
*******************************************************
-- Creacion de tablas de la base de datos, no se eliminan las tablas una por una, ya que la validacion de su existencia esta realizada a nivel de la base de datos
*******************************************************
*/
USE Gimnasio
GO

--Creación de la tabla Cliente.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Cliente')
BEGIN
    DROP TABLE Cliente;
END

CREATE TABLE Cliente (
idCliente SMALLINT IDENTITY (1,1),
nombres NVARCHAR(100) NOT NULL,
apellidos NVARCHAR(100) NOT NULL,
numeroCedula cedulaIdentidad NOT NULL,
fechaNacimiento DATE NOT NULL,
direccionDomicilio NVARCHAR(255) NULL,
correoElectronico correo NOT NULL,
numeroCelular celular NULL,
numeroContactoEmergencia celular NULL,
CONSTRAINT PK_Cliente PRIMARY KEY (idCliente),
CONSTRAINT UQ_NumeroCedulaC UNIQUE (numeroCedula),
CONSTRAINT CK_FechaNacimientoC CHECK(FechaNacimiento<GETDATE()),
CONSTRAINT UQ_CorreoElectronicoC UNIQUE (correoElectronico) ,
CONSTRAINT UQ_NumeroCelularC UNIQUE (numeroCelular),
CONSTRAINT CK_nombres CHECK (PATINDEX('%[0-9]%', nombres) = 0),
CONSTRAINT CK_apellidos CHECK (PATINDEX('%[0-9]%', apellidos) = 0)
);


--Creación de la tabla Entrenador.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Entrenador')
BEGIN
    DROP TABLE Entrenador;
END
CREATE TABLE Entrenador (
idEntrenador TINYINT IDENTITY (1,1),
nombres NVARCHAR(100) NOT NULL,
apellidos NVARCHAR(100) NOT NULL,
numeroCedula cedulaIdentidad NOT NULL,
fechaNacimiento DATE NOT NULL,
direccionDomicilio NVARCHAR(255) NULL,
correoElectronico correo NOT NULL,
numeroCelular celular NULL,
aniosExperiencia TINYINT NOT NULL,
fechaIngreso DATE DEFAULT GETDATE(),
fechaSalida DATE NULL,
CONSTRAINT PK_Entrenador PRIMARY KEY (idEntrenador),
CONSTRAINT UQ_NumeroCedulaE UNIQUE (numeroCedula),
CONSTRAINT CK_FechaNacimientoE CHECK((DATEDIFF(YEAR,fechaNacimiento, GETDATE()) -
CASE 
      WHEN DATEADD(YEAR, DATEDIFF(YEAR, fechaNacimiento, GETDATE()), fechaNacimiento) > GETDATE() 
      THEN 1 
      ELSE 0 END>=18)),
CONSTRAINT UQ_CorreoElectronicoE UNIQUE (correoElectronico),
CONSTRAINT UQ_NumeroCelularE UNIQUE (numeroCelular),
CONSTRAINT CK_AniosExperiencia CHECK(AniosExperiencia>=0 AND AniosExperiencia<=30),
CONSTRAINT CK_fechaSalida CHECK (fechaSalida>=fechaIngreso),
CONSTRAINT CK_nombresE CHECK (PATINDEX('%[0-9]%', nombres) = 0),
CONSTRAINT CK_apellidosE CHECK (PATINDEX('%[0-9]%', apellidos) = 0)
);

--Creación de la tabla Plan Entrenamiento.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'PlanEntrenamiento')
BEGIN
    DROP TABLE PlanEntrenamiento;
END
CREATE TABLE PlanEntrenamiento(
idPlanEntrenamiento SMALLINT IDENTITY (1,1),
idCliente SMALLINT NOT NULL,
idEntrenador TINYINT NOT NULL,
nombre VARCHAR(20) NOT NULL,
intensidad VARCHAR(5) NOT NULL,
objetivoPlan NVARCHAR(40) NOT NULL,
fechaInicio DATE NOT NULL,
fechaCambio DATE NULL,
monitoreo CHAR(7) NULL,
asistencia TINYINT NULL,
CONSTRAINT PK_PlanEntrenamiento PRIMARY KEY (idPlanEntrenamiento),
CONSTRAINT FK_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente),
CONSTRAINT FK_Entrenador FOREIGN KEY (idEntrenador) REFERENCES Entrenador (idEntrenador),
CONSTRAINT CK_Intensidad CHECK (intensidad IN ('Alta','Media','Baja')),
CONSTRAINT CK_FechaInicio CHECK (fechaInicio>=GETDATE()),
CONSTRAINT CK_FechaCambio CHECK (fechaCambio>fechaInicio),
CONSTRAINT CK_Monitoreo CHECK (monitoreo IN ('Semanal','Mensual')),
CONSTRAINT UQ_NombreP UNIQUE (nombre),
CONSTRAINT CK_nombre CHECK (PATINDEX('%[0-9]%', nombre) = 0)
);

--Creación de la tabla Rutina.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Rutina')
BEGIN
    DROP TABLE Rutina;
END

CREATE TABLE Rutina (
idRutina SMALLINT IDENTITY (1,1),
idPlanEntrenamiento SMALLINT NOT NULL,
nombreEjercicio NVARCHAR(30) NOT NULL,
descripcionEjercicio NVARCHAR(120) NULL,
grupoMuscular NVARCHAR(20) NOT NULL,
cantidadRepeticiones TINYINT NOT NULL,
tiempoDescanso DECIMAL (3,1) NULL,
cantidadSeries TINYINT NOT NULL,
diaSemana VARCHAR(9) NOT NULL,
caloriasQuemadas DECIMAL (5,1) NOT NULL,
CONSTRAINT PK_Rutina PRIMARY KEY (idRutina),
CONSTRAINT FK_PlanEntrenamiento FOREIGN KEY (idPlanEntrenamiento) REFERENCES PlanEntrenamiento (idPlanEntrenamiento),
CONSTRAINT CK_CantidadRepeticiones CHECK (cantidadRepeticiones>0 AND cantidadRepeticiones<=8),
CONSTRAINT CK_TiempoDescanso CHECK (tiempoDescanso>10),
CONSTRAINT CK_CantidadSeries CHECK (cantidadSeries>0 AND cantidadSeries<=8),
CONSTRAINT CK_DiaSemana CHECK (diaSemana IN ('Lunes', 'Martes','Miercoles', 'Jueves', 'Viernes', 'Sabado')),
CONSTRAINT CK_caloriasQuemadas CHECK (caloriasQuemadas>0),
CONSTRAINT CK_nombreEjercicio CHECK (PATINDEX('%[0-9]%', nombreEjercicio) = 0)
);

--Creación de la tabla PersonalSalud.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'PersonalSalud')
BEGIN
    DROP TABLE PersonalSalud;
END
CREATE TABLE PersonalSalud (
idPersonalSalud TINYINT IDENTITY (1,1),
nombres NVARCHAR(100) NOT NULL,
apellidos NVARCHAR(100) NOT NULL,
numeroCedula cedulaIdentidad NOT NULL,
fechaNacimiento DATE NOT NULL,
correoElectronico correo NOT NULL,
numeroCelular celular NULL,
direccionDomicilio NVARCHAR(255) NULL,
aniosExperiencia TINYINT NOT NULL,
tipo VARCHAR(15) NOT NULL,
especialidad NVARCHAR(55) NOT NULL,
activo BIT NOT NULL DEFAULT 1,
finesSemana BIT NOT NULL DEFAULT 0,
tipoContrato VARCHAR(20) NOT NULL,
CONSTRAINT PK_PersonalSalud PRIMARY KEY (idPersonalSalud),
CONSTRAINT UQ_NumeroCedulaP UNIQUE (numeroCedula),
CONSTRAINT CK_FechaNacimientoP CHECK
(DATEDIFF(YEAR,fechaNacimiento, GETDATE()) -
CASE 
      WHEN DATEADD(YEAR, DATEDIFF(YEAR, fechaNacimiento, GETDATE()), fechaNacimiento) > GETDATE() 
      THEN 1 
      ELSE 0 END>=18),
CONSTRAINT UQ_CorreoElectronicoP UNIQUE (correoElectronico),
CONSTRAINT UQ_NumeroCelularP UNIQUE (numeroCelular),
CONSTRAINT CK_AniosExperienciaP CHECK (aniosExperiencia>=0),
CONSTRAINT CK_Tipo CHECK(tipo IN ('Nutricionista','Doctor')),
CONSTRAINT CK_TipoContrato CHECK(tipoContrato IN ('Tiempo Completo','Medio Tiempo','Ocasional')),
CONSTRAINT CK_nombresP CHECK (PATINDEX('%[0-9]%', nombres) = 0),
CONSTRAINT CK_apellidosP CHECK (PATINDEX('%[0-9]%', apellidos) = 0),
CONSTRAINT CK_especialidad CHECK (PATINDEX('%[0-9]%', especialidad) = 0)
);

--Creación de la tabla Cita.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Cita')
BEGIN
    DROP TABLE Cita;
END
CREATE TABLE Cita (
idCita SMALLINT IDENTITY (1,1),
idPersonalSalud TINYINT NOT  NULL,
idEntrenador TINYINT NULL,
idCliente SMALLINT NULL,
nombre VARCHAR (20) NOT NULL,
fechaCita SMALLDATETIME NOT NULL,
tipo NVARCHAR(20) NOT NULL,
descripcion NVARCHAR (25) NULL,
asistencia BIT NOT NULL DEFAULT 0,
fechaAsistencia SMALLDATETIME NOT NULL,
CONSTRAINT PK_Cita PRIMARY KEY (idCita),
CONSTRAINT FK_PersonalSalud FOREIGN KEY (idPersonalSalud) REFERENCES PersonalSalud (idPersonalSalud),
CONSTRAINT FK_EntrenadorC FOREIGN KEY (idEntrenador) REFERENCES Entrenador (idEntrenador),
CONSTRAINT FK_ClienteC FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente),
CONSTRAINT CK_fechaCita CHECK (fechaCita>=GETDATE()),
CONSTRAINT CK_fechaAsistencia CHECK (fechaAsistencia>=GETDATE()),
CONSTRAINT CK_tipoC CHECK (tipo IN ('Cita médica', 'Cita nutricionista')),
CONSTRAINT UQ_nombre UNIQUE (nombre)
);

--Creación de la tabla RegistroMedico.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'RegistroMedico')
BEGIN
    DROP TABLE RegistroMedico;
END
CREATE TABLE RegistroMedico(
idRegistroMedico SMALLINT IDENTITY (1,1),
idCita SMALLINT NOT NULL,
nombre VARCHAR (20) NOT NULL,
fechaRegistro DATE NOT NULL DEFAULT GETDATE(),
tipoSangre VARCHAR(3) NOT NULL,
estadoSalud NVARCHAR(10) NOT NULL,
pesoActual DECIMAL(5,2) NOT NULL,
alturaActual DECIMAL(3,2) NOT NULL,
indiceGrasaCorporal DECIMAL (3,1) NOT NULL,
lesiones NVARCHAR(120) NULL,
enfermedades NVARCHAR (180) NULL,
somatipo VARCHAR(10) NOT NULL,
operaciones NVARCHAR(120) NULL,
alergias NVARCHAR(100) NULL,
objetivoCliente NVARCHAR(150) NOT NULL,
CONSTRAINT PK_RegistroMedico PRIMARY KEY (idRegistroMedico),
CONSTRAINT FK_Cita FOREIGN KEY (idCita) REFERENCES Cita (idCita),
--CONSTRAINT CK_FechaRegistro CHECK (fechaRegistro>=GETDATE()),
CONSTRAINT CK_TipoSangre CHECK (tipoSangre IN ('O+','O-','A+','A-','B+','B-','AB+','AB-')),
CONSTRAINT CK_EstadoSalud CHECK (estadoSalud IN ('Excelente','Bueno','Crítico')),
CONSTRAINT CK_PesoActual CHECK(pesoActual>0 AND pesoActual<400),
CONSTRAINT CK_alturaActual CHECK (alturaActual>0 AND alturaActual<2.5),
CONSTRAINT CK_indiceGrasaCorporal CHECK (indiceGrasaCorporal>0 AND indiceGrasaCorporal <60),
CONSTRAINT CK_Somatipo CHECK (somatipo IN ('Hectomorfo','Mesomorfo','Endomorfo')),
CONSTRAINT CK_operaciones CHECK (PATINDEX('%[0-9]%', operaciones) = 0),
CONSTRAINT CK_alergias CHECK (PATINDEX('%[0-9]%', alergias) = 0)
);

--Creación de la tabla PlanNutricional.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'PlanNutricional')
BEGIN
    DROP TABLE PlanNutricional;
END
CREATE TABLE PlanNutricional(
idPlanNutricional SMALLINT IDENTITY (1,1),
idRegistroMedico SMALLINT NOT NULL,
nombre varchar(20) NOT NULL,
cantidadComidasDia TINYINT NOT NULL,
indicacionesGenerales NVARCHAR(300) NULL,
alergiasConsideradas NVARCHAR (100) NULL,
fechaInicio DATE NOT NULL,
fechaFin DATE NOT NULL,
CONSTRAINT PK_PlanNutricional PRIMARY KEY (idPlanNutricional),
CONSTRAINT FK_RegistroMedico FOREIGN KEY (idRegistroMedico) REFERENCES RegistroMedico (idRegistroMedico),
CONSTRAINT UQ_NOMBREPN UNIQUE (nombre),
CONSTRAINT CK_cantidadComidasDia CHECK (cantidadComidasDia>0 AND cantidadComidasDia <=5),
CONSTRAINT CK_fechaInicioP CHECK (fechaInicio>=GETDATE()),
CONSTRAINT CK_fechaFinP CHECK (fechaFin>FechaInicio),
CONSTRAINT CK_alergiasConsideradas CHECK (PATINDEX('%[0-9]%', alergiasConsideradas) = 0)
);

--Creación de la tabla Comida.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Comida')
BEGIN
    DROP TABLE Comida;
END
CREATE TABLE Comida(
idComida SMALLINT IDENTITY (1,1),
nombre VARCHAR(20) NOT NULL,
cantidadProteina DECIMAL (5,1) NOT NULL,
cantidadCarbohidratos DECIMAL (5,1) NOT NULL,
cantidadGrasas DECIMAL (5,1) NOT NULL,
cantidadFibra DECIMAL (5,1) NOT NULL,
preparacion NVARCHAR(300) NOT NULL,
CONSTRAINT PK_Comida PRIMARY KEY (idComida),
CONSTRAINT CK_CantidadProteina CHECK (cantidadProteina>0 AND cantidadProteina<=9999),
CONSTRAINT CK_CantidadCarbohidratos CHECK (cantidadCarbohidratos>0 AND cantidadCarbohidratos<=9999),
CONSTRAINT CK_CantidadGrasas CHECK (cantidadGrasas>0 AND cantidadGrasas<=9999),
CONSTRAINT CK_CantidadFibra CHECK (cantidadFibra>0 AND cantidadFibra<=9999),
CONSTRAINT UQ_NombreComida UNIQUE (nombre)
);

--Creación de la tabla Menu.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Menu')
BEGIN
    DROP TABLE Menu;
END
CREATE TABLE Menu (
idMenu SMALLINT IDENTITY (1,1),
idComida SMALLINT NOT NULL,
idPlanNutricional SMALLINT NOT NULL,
nombre varchar(20) NOT NULL,
horarioMenu varchar(10) NOT NULL,
informacionAdicional NVARCHAR (300) NULL,
cantidadTotalCalorias DECIMAL (6,1) NOT NULL,
CONSTRAINT PK_Menu PRIMARY KEY (idMenu),
CONSTRAINT FK_ComidaM FOREIGN KEY (idComida) REFERENCES Comida (idComida),
CONSTRAINT FK_PlanNutricional FOREIGN KEY (idPlanNutricional) REFERENCES PlanNutricional (idPlanNutricional),
CONSTRAINT UQ_NOMBREM UNIQUE (nombre),
CONSTRAINT CK_CantidadTotalCalorias CHECK (cantidadTotalCalorias>0 AND cantidadTotalCalorias<=99999),
CONSTRAINT CK_horarioMenu CHECK (horarioMenu IN ('Dia','Medio dia','Tarde','Media tarde','Noche'))
);

--Creación de la tabla Ingrediente.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Ingrediente')
BEGIN
    DROP TABLE Ingrediente;
END
CREATE TABLE Ingrediente (
idIngrediente SMALLINT IDENTITY (1,1),
nombre NVARCHAR (35) NOT NULL,
descripcion NVARCHAR (140) NOT NULL,
microNutrienetes varchar(150) NOT NULL,
proteina DECIMAL (4,1) NOT NULL,
grasas DECIMAL (4,1) NOT NULL,
carbohidratos DECIMAL (4,1) NOT NULL,
fibra DECIMAL (4,1) NOT NULL,
CONSTRAINT PK_Ingrediente PRIMARY KEY (idIngrediente),
CONSTRAINT CK_Proteina CHECK (proteina>0 AND proteina<=999),
CONSTRAINT CK_Grasas CHECK (grasas>0 AND grasas<=999),
CONSTRAINT CK_Carbohidratos CHECK (carbohidratos>0 AND carbohidratos<=999),
CONSTRAINT CK_Fibra CHECK (fibra>0 AND fibra<=999),
CONSTRAINT UQ_NombreI UNIQUE(nombre),
CONSTRAINT CK_nombreI CHECK (PATINDEX('%[0-9]%', nombre) = 0)
);

--Creación de la tabla IngredienteComida.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'IngredienteComida')
BEGIN
    DROP TABLE IngredienteComida;
END

CREATE TABLE IngredienteComida (
idIngredienteComida SMALLINT IDENTITY (1,1),
idComida SMALLINT NOT NULL,
idIngrediente SMALLINT NOT NULL,
cantidad TINYINT NOT NULL,
unidad VARCHAR (12) NOT NULL,
CONSTRAINT PK_IngredienteComida PRIMARY KEY (idIngredienteComida),
CONSTRAINT FK_ComidaIC FOREIGN KEY (idComida) REFERENCES Comida (idComida),
CONSTRAINT FK_IngredienteIC FOREIGN KEY (idIngrediente) REFERENCES Ingrediente (idIngrediente),
CONSTRAINT CK_Cantidad CHECK (cantidad>0),
CONSTRAINT CK_Unidad CHECK (unidad IN ('gramos','kilos','onzas','cucharadas','litros','libras','cucharaditas'))
);

--Creación de la tabla ReporteIncidente.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'ReporteIncidente')
BEGIN
    DROP TABLE ReporteIncidente;
END
CREATE TABLE ReporteIncidente (
idReporteIncidente SMALLINT IDENTITY (1,1),
idCliente SMALLINT NOT NULL,
idEntrenador TINYINT NOT NULL,
idPersonalSalud TINYINT NOT NULL,
descripcionIncidente NVARCHAR (200) NOT NULL,
fechaIncidente DATE DEFAULT GETDATE(),
CONSTRAINT PK_ReporteIncidente PRIMARY KEY (idReporteIncidente),
CONSTRAINT FK_ClienteRepor FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente),
CONSTRAINT FK_EntrenadorRepor FOREIGN KEY (idEntrenador) REFERENCES Entrenador (idEntrenador),
CONSTRAINT FK_PersonalSaludRepor FOREIGN KEY (idPersonalSalud) REFERENCES PersonalSalud (idPersonalSalud),
--CONSTRAINT CK_fechaIncidente CHECK (fechaIncidente=GETDATE())
);


/*
**********************************
-- Objetos Programables
**********************************
*/

/*
************
-- Trigger para validar que: Los nutricionistas, serán los únicos que puedan emitir planes de alimentación para
los usuarios y el personal.
************
*/
--Verificar si existe el Trigger
/*
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'TR' AND name = 'tr_ValidarRegistroMedicoNutricionista')
BEGIN
    DROP TRIGGER tr_ValidarRegistroMedicoNutricionista
END
GO

CREATE TRIGGER tr_ValidarRegistroMedicoNutricionista
ON PlanNutricional
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN RegistroMedico rm ON i.idRegistroMedico = rm.idRegistroMedico
        INNER JOIN Cita c ON rm.idCita = c.idCita
        INNER JOIN PersonalSalud ps ON c.idPersonalSalud = ps.idPersonalSalud
        WHERE ps.tipo = 'Nutricionista'
    )
    BEGIN
        PRINT 'El registro médico pertenece a un nutricionista.'
    END
    ELSE
    BEGIN
        RAISERROR('Solo un nutricionista puede crear el plan nutricional.',16,10)
        ROLLBACK TRANSACTION
    END
END*/

/*

************

-- Trigger para validar que: Si ocurre un accidente dentro de las instalaciones el médico es el único que puede crear un reporte del caso.

************

*/

--Verificar si existe el Trigger
 
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'TR' AND name = 'tr_ValidarPersonalSaludDoctor')
BEGIN
    DROP TRIGGER tr_ValidarPersonalSaludDoctor

END

GO
 
CREATE TRIGGER tr_ValidarPersonalSaludDoctor

ON ReporteIncidente

AFTER INSERT, UPDATE

AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN PersonalSalud ps ON i.idPersonalSalud = ps.idPersonalSalud
        WHERE ps.tipo = 'Doctor'
    )

    BEGIN
        PRINT 'El personal de salud es un doctor.'
    END
    ELSE
    BEGIN
       RAISERROR('Solo un doctor puede atender un incidente.',16,10)
        ROLLBACK TRANSACTION
    END
END


/*
************
-- Trigger para validar que: Los planes de nutrición creados por los nutricionistas deben tener tres comidas al
día como mínimo y cinco comidas al día como máximo para los miembros.
************
*/
--Verificar si existe el Trigger 
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'TR' AND name = 'trg_InsertarPlanNutricional')
BEGIN
    DROP TRIGGER trg_InsertarPlanNutricional
END
GO

CREATE TRIGGER trg_InsertarPlanNutricional
ON Cliente
AFTER INSERT
AS
BEGIN
DECLARE @nombrePlan VARCHAR(20)
SET @nombrePlan = 'Plan de alimentación'
DECLARE @contador INT
SET @contador = 1
WHILE EXISTS (SELECT * FROM PlanNutricional WHERE nombre = @nombrePlan)
BEGIN
SET @nombrePlan = 'Plan de alimentación ' + CAST(@contador AS VARCHAR(10))
SET @contador = @contador + 1
END
INSERT INTO PlanNutricional (idRegistroMedico, nombre, cantidadComidasDia, indicacionesGenerales, alergiasConsideradas, fechaInicio, fechaFin)
SELECT r.idRegistroMedico, @nombrePlan, 5, 'Indicaciones generales', NULL, GETDATE(), DATEADD(month, 1, GETDATE())
FROM RegistroMedico r
WHERE r.idRegistroMedico IN (SELECT MAX(idRegistroMedico) FROM RegistroMedico)
END



/*
************
-- Stored Procedura para validar que el plan de nutrición debe actualizase cada mes para los empleados y clientes. Dicha información que define si se cambia el
plan de alimentación abarca el: peso, altura, índice de masa corporal, porcentaje
de grasa corporal.
************
*/

IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ActualizarPlanNutricional')
BEGIN
    DROP PROCEDURE ActualizarPlanNutricional
END
GO

CREATE PROCEDURE ActualizarPlanNutricional
@idRegistroMedico SMALLINT,
@fechaActual DATE
AS
BEGIN
DECLARE @idPlanNutricional SMALLINT
DECLARE @fechaFin DATE
DECLARE @cantidadComidasDia TINYINT
DECLARE @indicacionesGenerales NVARCHAR(300)
DECLARE @alergiasConsideradas NVARCHAR(100)
DECLARE @pesoActual DECIMAL(5,2)
DECLARE @alturaActual DECIMAL(3,2)
DECLARE @indiceGrasaCorporal DECIMAL (3,1)
-- Obtener información del registro médico
SELECT @pesoActual = pesoActual, @alturaActual = alturaActual, @indiceGrasaCorporal = indiceGrasaCorporal
FROM RegistroMedico
WHERE idRegistroMedico = @idRegistroMedico

 

-- Verificar si se cumplen las condiciones para actualizar el plan de nutrición
IF DATEDIFF(month, @fechaFin, @fechaActual) >= 1 OR @fechaActual >= @fechaFin
BEGIN
    IF EXISTS (
        SELECT 1
        FROM PlanNutricional
        WHERE idRegistroMedico = @idRegistroMedico
        AND fechaFin >= @fechaActual
    )
    BEGIN
        -- Obtener información del plan nutricional actual
        SELECT TOP 1 @idPlanNutricional = idPlanNutricional, @cantidadComidasDia = cantidadComidasDia, @indicacionesGenerales = indicacionesGenerales, @alergiasConsideradas = alergiasConsideradas
        FROM PlanNutricional
        WHERE idRegistroMedico = @idRegistroMedico
        AND fechaFin >= @fechaActual
        ORDER BY fechaInicio DESC

 

        -- Verificar si se cumplen las condiciones para actualizar el plan de nutrición
        IF @pesoActual IS NOT NULL AND @alturaActual IS NOT NULL AND @indiceGrasaCorporal IS NOT NULL
        BEGIN
            -- Actualizar el plan de nutrición con la nueva información
            UPDATE PlanNutricional
            SET cantidadComidasDia = @cantidadComidasDia,
                indicacionesGenerales = @indicacionesGenerales,
                alergiasConsideradas = @alergiasConsideradas
            WHERE idPlanNutricional = @idPlanNutricional
        END
    END
END
END

/*
************
-- Trigger para validar que Cada vez que se actualice el plan alimenticio de una persona, el anterior plan
deberá parar a un estado de anterior y asignarle la fecha de fin de forma
automática.

 

************
*/

 IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'tr_ActualizarFechaFin')
BEGIN
    DROP PROCEDURE tr_ActualizarFechaFin
END
GO

CREATE TRIGGER tr_ActualizarFechaFin
ON PlanNutricional
AFTER INSERT
AS
BEGIN
DECLARE @idCliente SMALLINT, @idEntrenador TINYINT, @fechaActual DATE, @idRegistroMedico SMALLINT;
SELECT @idRegistroMedico = i.idRegistroMedico, @fechaActual = GETDATE()
FROM inserted i;
SELECT @idCliente = c.idCliente, @idEntrenador = c.idEntrenador
FROM Cita c
WHERE c.idCita = (SELECT idCita FROM RegistroMedico WHERE idRegistroMedico = @idRegistroMedico);

 

IF EXISTS (
    SELECT 1
    FROM PlanNutricional pn
    INNER JOIN RegistroMedico rm ON pn.idRegistroMedico = rm.idRegistroMedico
    INNER JOIN Cita c ON rm.idCita = c.idCita
    WHERE (c.idCliente = @idCliente OR c.idEntrenador = @idEntrenador)
    AND pn.fechaFin IS NULL
    AND pn.idPlanNutricional <> (SELECT TOP 1 idPlanNutricional FROM inserted ORDER BY idPlanNutricional DESC)
)
BEGIN
    UPDATE PlanNutricional
    SET fechaFin = @fechaActual
    WHERE idPlanNutricional IN (
        SELECT pn.idPlanNutricional
        FROM PlanNutricional pn
        INNER JOIN RegistroMedico rm ON pn.idRegistroMedico = rm.idRegistroMedico
        INNER JOIN Cita c ON rm.idCita = c.idCita
        WHERE (c.idCliente = @idCliente OR c.idEntrenador = @idEntrenador)
        AND pn.fechaFin IS NULL
        AND pn.idPlanNutricional <> (SELECT TOP 1 idPlanNutricional FROM inserted ORDER BY idPlanNutricional DESC)
    );
END
END



/*

************

-- Trigger para validar que para el entrenamiento de cada grupo muscular, no se debe sobrepasar la cantidad

de 10 ejercicios

 

************

*/

 
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'TR' AND name = 'tr_LimiteRegistros')
BEGIN
    DROP TRIGGER tr_LimiteRegistros
END
GO


CREATE TRIGGER tr_LimiteRegistros

ON Rutina

INSTEAD OF INSERT

AS

BEGIN

    DECLARE @grupoMuscular NVARCHAR(20);

    DECLARE @cantidadEjercicios INT;

    SET @grupoMuscular = (SELECT grupoMuscular FROM inserted);

    SELECT @cantidadEjercicios = COUNT(*) FROM Rutina WHERE grupoMuscular = @grupoMuscular;

    IF (@cantidadEjercicios >= 10)

    BEGIN

        RAISERROR('No se pueden insertar más registros para este grupo muscular', 16, 1);

        ROLLBACK TRANSACTION;

    END

    ELSE

    BEGIN

        INSERT INTO Rutina (idPlanEntrenamiento, nombreEjercicio, descripcionEjercicio, grupoMuscular, cantidadRepeticiones, tiempoDescanso, cantidadSeries, diaSemana, caloriasQuemadas)

        SELECT idPlanEntrenamiento, nombreEjercicio, descripcionEjercicio, grupoMuscular, cantidadRepeticiones, tiempoDescanso, cantidadSeries, diaSemana, caloriasQuemadas

        FROM inserted;

    END

END;

 

 

/*

************

-- Trigger para validar que Cada vez que se cambie el plan de entrenamiento de un miembro, el antiguo plan

deberá pasar a un estado de anterior y colocar automáticamente la fecha en la que

termina.

 



***

*/

 IF EXISTS(SELECT name FROM sys.objects WHERE type = 'TR' AND name = 'ActualizarFechaCambio')
BEGIN
    DROP TRIGGER ActualizarFechaCambio
END
GO

CREATE TRIGGER ActualizarFechaCambio
ON PlanEntrenamiento
AFTER INSERT
AS
BEGIN
    DECLARE @idCliente SMALLINT;
    DECLARE @fechaActual DATE;
    SELECT @idCliente = idCliente, @fechaActual = GETDATE()
    FROM inserted;
    UPDATE PlanEntrenamiento
    SET fechaCambio = @fechaActual
    WHERE idCliente = @idCliente
    AND idPlanEntrenamiento <> (SELECT TOP 1 idPlanEntrenamiento
                                FROM PlanEntrenamiento
                                WHERE idCliente = @idCliente
                                ORDER BY fechaInicio DESC);
END;



/*
************
-- Funcion  para validar que se podrá entrenar 3 grupos musculares como máximo por día.
automática. 
************
*/
/*
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_CantidadGruposMuscularesPorDia]') AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fn_CantidadGruposMuscularesPorDia];
GO

CREATE FUNCTION [dbo].[fn_CantidadGruposMuscularesPorDia] (@idPlanEntrenamiento SMALLINT, @diaSemana VARCHAR(9))
RETURNS INT
AS
BEGIN
    DECLARE @cantidadGruposMusculares INT;
    SELECT @cantidadGruposMusculares = COUNT(DISTINCT grupoMuscular)
    FROM Rutina
    WHERE idPlanEntrenamiento = @idPlanEntrenamiento AND diaSemana = @diaSemana;
    RETURN @cantidadGruposMusculares;
END;
GO

ALTER TABLE Rutina ADD CONSTRAINT CK_GruposMuscularesPorDia CHECK ( -- Verificar que la cantidad de grupos musculares distintos por día no sea mayor a 3 
	dbo.fn_CantidadGruposMuscularesPorDia(idPlanEntrenamiento, 'Lunes') <= 3 
	AND dbo.fn_CantidadGruposMuscularesPorDia(idPlanEntrenamiento, 'Martes') <= 3 
	AND dbo.fn_CantidadGruposMuscularesPorDia(idPlanEntrenamiento, 'Miercoles') <= 3 
	AND dbo.fn_CantidadGruposMuscularesPorDia(idPlanEntrenamiento, 'Jueves') <= 3 
	AND dbo.fn_CantidadGruposMuscularesPorDia(idPlanEntrenamiento, 'Viernes') <= 3 
	AND dbo.fn_CantidadGruposMuscularesPorDia(idPlanEntrenamiento, 'Sabado') <= 3 );*/



/*
************
-- Funcion  para validar el tiempo muerto de 20 minutos o más. 
************
*/
/*
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_TiempoTotalDescanso]') AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
    DROP FUNCTION [dbo].[fn_TiempoTotalDescanso];
GO
CREATE FUNCTION [dbo].[fn_TiempoTotalDescanso] ()
RETURNS INT
AS
BEGIN
    DECLARE @tiempoTotal INT;
    -- Calcular el tiempo total de descanso
    SELECT @tiempoTotal = SUM(tiempoDescanso)
    FROM Rutina;
    -- Devolver el tiempo total de descanso en segundos
    RETURN @tiempoTotal;
END;
GO
ALTER TABLE Rutina
ADD CONSTRAINT CK_TiempoMuerto CHECK (
    -- Verificar que exista un tiempo muerto de 20 minutos
    dbo.fn_TiempoTotalDescanso() >= 1200
);*/


/*
************
-- Función para validar que todos los entrenadores o clientes tengan planes nutricionales asignados.
************
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_VerificarPlanNutricional]') AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
    DROP FUNCTION [dbo].[fn_VerificarPlanNutricional];
END
GO
CREATE FUNCTION [dbo].[fn_VerificarPlanNutricional] ()
RETURNS NVARCHAR(100)
AS
BEGIN
DECLARE @mensajeError NVARCHAR(100)
SET @mensajeError = ''
IF EXISTS (
    SELECT c.idCliente
    FROM Cliente c
    LEFT JOIN Cita ci ON  c.idCliente= ci.idCliente
    LEFT JOIN PersonalSalud ps ON ci.idPersonalSalud = ps.idPersonalSalud
    WHERE ps.tipo = 'Nutricionista' AND ci.idCita IS NULL
)
BEGIN
    SET @mensajeError = 'Hay clientes sin plan nutricional asignado.'
END

IF EXISTS (
    SELECT e.idEntrenador
    FROM Entrenador e
    LEFT JOIN Cita c ON e.idEntrenador = c.idEntrenador
    LEFT JOIN PersonalSalud ps ON c.idPersonalSalud = ps.idPersonalSalud
    WHERE ps.tipo = 'Nutricionista' AND c.idCita IS NULL AND e.FechaSalida IS NULL
)
BEGIN
    IF @mensajeError <> ''
    BEGIN
        SET @mensajeError = @mensajeError + ' '
    END
    SET @mensajeError = @mensajeError + 'Hay entrenadores sin planes asignados.'
END
RETURN @mensajeError
END;
GO

DECLARE @mensajeError NVARCHAR(100)
IF OBJECT_ID(N'[dbo].[fn_VerificarPlanNutricional]', N'FN') IS NOT NULL
BEGIN
    SET @mensajeError = dbo.fn_VerificarPlanNutricional()
END
IF @mensajeError <> ''
BEGIN
    RAISERROR(@mensajeError, 16, 1)
END



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


/*
**********************************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Plan Entrenamiento
**********************************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoPlanEntrenamiento')
BEGIN
    DROP PROCEDURE ingresoPlanEntrenamiento
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla PlanEntrenamiento, 
--a través de la cédula del paciente, y el nombre del examen. 
CREATE PROCEDURE ingresoPlanEntrenamiento

 --Se declaran los argumentos que recibe el procedimiento almacenado
	@nombre VARCHAR(20),
	@intensidad VARCHAR(5),
	@objetivoPlan NVARCHAR(40),
	@fechaInicio DATE,
	@fechaCambio DATE,
	@monitoreo CHAR (7),
	@asistencia TINYINT,
	@numeroCedulaC cedulaIdentidad,
	@numeroCedulaE cedulaIdentidad
AS
    --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM Cliente WHERE numeroCedula = @numeroCedulaC) = 0
    BEGIN
        RAISERROR('El cliente no existe.',16,10)
    END
    ELSE
    BEGIN
        --Se verifica si existe el entrenador con esa cédula que se está intentando ingresar. 
        IF (SELECT COUNT(*) FROM Entrenador WHERE numeroCedula = @numeroCedulaE) = 0
        BEGIN
            RAISERROR('El entrenador no existe.',16,10)
        END
        ELSE
        BEGIN
            --Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del examen. 
            DECLARE @idCliente SMALLINT
            DECLARE @idEntrenador TINYINT

 

            SET @idCliente = (SELECT idCliente FROM Cliente WHERE numeroCedula = @numeroCedulaC);
            SET @idEntrenador = (SELECT idEntrenador FROM Entrenador WHERE numeroCedula = @numeroCedulaE);


 --Se realiza la inserción de la tupla en la tabla Resultado.
		INSERT INTO PlanEntrenamiento(idCliente,idEntrenador,nombre,intensidad,objetivoPlan,fechaInicio,fechaCambio,monitoreo,asistencia)
		VALUES(@idCliente,@idEntrenador,@nombre,@intensidad,@objetivoPlan,@fechaInicio,@fechaCambio,@monitoreo,@asistencia)
	END
 END
GO


/*
**********************************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Rutina
**********************************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoRutina')
BEGIN
    DROP PROCEDURE ingresoRutina
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Rutina, 
--a través del nombre del plan de entrenamiento. 
CREATE PROCEDURE ingresoRutina
    --Se declaran los argumentos que recibe el procedimiento almacenado
    @nombreEjercicio NVARCHAR(30),
	@descripcionEjercicio NVARCHAR(120) ,
	@grupoMuscular NVARCHAR(20) ,
	@cantidadRepeticiones TINYINT ,
	@tiempoDescanso DECIMAL (3,1),
	@cantidadSeries TINYINT ,
	@diaSemana VARCHAR(9),
	@caloriasQuemadas DECIMAL (5,1) ,
	@nombre VARCHAR (20)
AS
    --Se verifica si existe el plan de entrenamiento con el nombre que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM PlanEntrenamiento WHERE nombre = @nombre) = 0
    BEGIN
        RAISERROR('El plan de entrenamiento no existe.',16,10)
    END
    ELSE
        
        BEGIN
            --Si el plan de entrenamient existe, se obtiene el id del plan de entrenamiento. 
            DECLARE @idPlanEntrenamiento SMALLINT
 
            SET @idPlanEntrenamiento = (SELECT idPlanEntrenamiento FROM PlanEntrenamiento WHERE nombre = @nombre);


 --Se realiza la inserción de la tupla en la tabla Resultado.
 INSERT INTO Rutina(idPlanEntrenamiento, nombreEjercicio, descripcionEjercicio, grupoMuscular, cantidadRepeticiones,tiempoDescanso, cantidadSeries,diaSemana,caloriasQuemadas)						
 VALUES(@idPlanEntrenamiento,@nombreEjercicio,@descripcionEjercicio,@grupoMuscular,@cantidadRepeticiones,@tiempoDescanso,@cantidadSeries,@diaSemana,@caloriasQuemadas)
 END
GO


/*
**********************************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Cita
**********************************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoCitaCliente')
BEGIN
    DROP PROCEDURE ingresoCitaCliente
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita, 
--a través de la cedula del cliente. 
CREATE PROCEDURE ingresoCitaCliente
    --Se declaran los argumentos que recibe el procedimiento almacenado
    @nombre VARCHAR (20),
	@fechaCita SMALLDATETIME,
	@tipo NVARCHAR(20),
	@descripcion NVARCHAR (25),
	@asistencia BIT,
	@fechaAsistencia SMALLDATETIME,
	@numeroCedulaC cedulaIdentidad,
	@numeroCedulaP cedulaIdentidad

AS
    --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM Cliente WHERE numeroCedula = @numeroCedulaC) = 0
    BEGIN
        RAISERROR('El cliente no existe.',16,10)
    END
    ELSE
    BEGIN
        --Se verifica si existe el personal de salud con esa cédula que se está intentando ingresar. 
        IF (SELECT COUNT(*) FROM PersonalSalud WHERE numeroCedula = @numeroCedulaP) = 0
        BEGIN
            RAISERROR('El personal de salud no existe.',16,10)
        END
        ELSE
        BEGIN
            --Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del personal de salud. 
            DECLARE @idCliente SMALLINT
            DECLARE @idPersonalSalud TINYINT

 

            SET @idCliente = (SELECT idCliente FROM Cliente WHERE numeroCedula = @numeroCedulaC);
            SET @idPersonalSalud = (SELECT idPersonalSalud FROM PersonalSalud WHERE numeroCedula = @numeroCedulaP);

            --Se realiza la inserción de la tupla en la tabla Cita.
            INSERT INTO Cita(idPersonalSalud,idCliente,nombre,fechaCita,tipo,descripcion,asistencia,fechaAsistencia) 
            VALUES(@idPersonalSalud,@idCliente,@nombre,@fechaCita,@tipo,@descripcion,@asistencia,@fechaAsistencia)
        END
    END
GO

/*
**********************************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Cita
**********************************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoCitaEntrenador')
BEGIN
    DROP PROCEDURE ingresoCitaEntrenador
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita, 
--a través de la cedula del cliente. 
CREATE PROCEDURE ingresoCitaEntrenador
    --Se declaran los argumentos que recibe el procedimiento almacenado
    @nombre VARCHAR (20),
	@fechaCita SMALLDATETIME,
	@tipo NVARCHAR(20),
	@descripcion NVARCHAR (25),
	@asistencia BIT,
	@fechaAsistencia SMALLDATETIME,
	@numeroCedulaE cedulaIdentidad,
	@numeroCedulaP cedulaIdentidad

AS

 --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
 IF (SELECT COUNT(*) FROM Entrenador WHERE numeroCedula = @numeroCedulaE) = 0
	BEGIN
	RAISERROR('El entrenador no existe.',16,10)
 END
 ELSE
	BEGIN
 --Se verifica si existe el personal de salud con esa cédula que se está intentando ingresar.
 IF (SELECT COUNT(*) FROM PersonalSalud WHERE numeroCedula = @numeroCedulaP) = 0
	BEGIN
	RAISERROR('El personal de salud no existe.',16,10)
 END
 ELSE
	BEGIN
 --Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del personal de salud.
	DECLARE @idEntrenador TINYINT
	DECLARE @idPersonalSalud TINYINT

 

            SET @idEntrenador = (SELECT idEntrenador FROM Entrenador WHERE numeroCedula = @numeroCedulaE);
            SET @idPersonalSalud = (SELECT idPersonalSalud FROM PersonalSalud WHERE numeroCedula = @numeroCedulaP);

            --Se realiza la inserción de la tupla en la tabla Cita.
            INSERT INTO Cita(idPersonalSalud,idEntrenador,nombre,fechaCita,tipo,descripcion,asistencia,fechaAsistencia) 
            VALUES(@idPersonalSalud,@idEntrenador,@nombre,@fechaCita,@tipo,@descripcion,@asistencia,@fechaAsistencia)
        END
    END
GO



/*
**********************************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Registro Médico
**********************************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoRegistroMedico')
BEGIN
DROP PROCEDURE ingresoRegistroMedico
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita,
--a través de la cedula del cliente.
CREATE PROCEDURE ingresoRegistroMedico
 --Se declaran los argumentos que recibe el procedimiento almacenado
	@nombre VARCHAR (20),
	@tipoSangre VARCHAR(3),
	@estadoSalud NVARCHAR(10),
	@pesoActual DECIMAL(5,2),
	@alturaActual DECIMAL(3,2),
	@indiceGrasaCorporal DECIMAL (3,1),
	@lesiones NVARCHAR(120),
	@enfermedades NVARCHAR (180),
	@somatipo VARCHAR(10) ,
	@operaciones NVARCHAR(120) ,
	@alergias NVARCHAR(100) ,
	@objetivoCliente NVARCHAR(150),
	@nombreCi VARCHAR (20)
	

AS
 --Se verifica si existe el plan de entrenamiento con el nombre que se está intentando ingresar.
 IF (SELECT COUNT(*) FROM Cita WHERE nombre = @nombreCi) = 0
	BEGIN
	RAISERROR('La cita no existe.',16,10)
 END
 ELSE
 
	BEGIN
 --Si el plan de entrenamient existe, se obtiene el id del plan de entrenamiento.
	DECLARE @idCita SMALLINT
	SET @idCita = (SELECT idCita FROM Cita WHERE nombre = @nombreCi);

 --Se realiza la inserción de la tupla en la tabla Resultado.
	INSERT INTO RegistroMedico(idCita,nombre,tipoSangre,estadoSalud,pesoActual,alturaActual,indiceGrasaCorporal,lesiones,enfermedades,somatipo,operaciones,alergias,objetivoCliente)
	VALUES(@idCita, @nombre, @tipoSangre,@estadoSalud,@pesoActual,@alturaActual,@indiceGrasaCorporal,@lesiones,@enfermedades,@somatipo,@operaciones,	@alergias,@objetivoCliente)
 END
GO

/*
************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Registro Médico
************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoIngredienteComida')
BEGIN
    DROP PROCEDURE ingresoIngredienteComida
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita, 
--a través de la cedula del cliente. 
CREATE PROCEDURE ingresoIngredienteComida
    --Se declaran los argumentos que recibe el procedimiento almacenado
    @cantidad TINYINT ,
	@unidad VARCHAR (12) ,
	@nombreC VARCHAR(20),
	@nombreI VARCHAR (20)

AS
    --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM Comida WHERE nombre = @nombreC) = 0
    BEGIN
        RAISERROR('La comida no existe.',16,10)
    END
    ELSE
    BEGIN
        --Se verifica si existe el personal de salud con esa cédula que se está intentando ingresar. 
        IF (SELECT COUNT(*) FROM Ingrediente WHERE nombre = @nombreI) = 0
        BEGIN
            RAISERROR('El ingrediente no existe.',16,10)
        END
        ELSE
        BEGIN
            --Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del personal de salud. 
            DECLARE @idComida SMALLINT
            DECLARE @idIngrediente SMALLINT

 

            SET @idComida = (SELECT idComida FROM Comida WHERE nombre = @nombreC);
            SET @idIngrediente = (SELECT idIngrediente FROM Ingrediente WHERE nombre = @nombreI);

            --Se realiza la inserción de la tupla en la tabla Cita.
            INSERT INTO IngredienteComida(idComida,idIngrediente,cantidad,unidad) 
            VALUES(@idComida,@idIngrediente,@cantidad,@unidad)
        END
    END
GO

/*
************
-- Procedimiento almacenado que controla el ingreso de tuplas en la tabla Registro Médico
************
*/

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoReporteIncidente')
BEGIN
    DROP PROCEDURE ingresoReporteIncidente
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita, 
--a través de la cedula del cliente. 
CREATE PROCEDURE ingresoReporteIncidente
    --Se declaran los argumentos que recibe el procedimiento almacenado
    @descripcionIncidente NVARCHAR (200),
	@numeroCedulaE cedulaIdentidad,
	@numeroCedulaP cedulaIdentidad,
	@numeroCedulaC cedulaIdentidad

AS
    --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM Entrenador WHERE numeroCedula = @numeroCedulaE) = 0
    BEGIN
        RAISERROR('El entrenador no existe.',16,10)
    END
    ELSE
    BEGIN
        --Se verifica si existe el personal de salud con esa cédula que se está intentando ingresar. 
        IF (SELECT COUNT(*) FROM PersonalSalud WHERE numeroCedula = @numeroCedulaP) = 0
        BEGIN
            RAISERROR('El personal de salud no existe.',16,10)
        END
        ELSE

       		BEGIN
           	--Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del personal de salud. 
            DECLARE @idEntrenador TINYINT
            DECLARE @idPersonalSalud TINYINT
			DECLARE @idCliente SMALLINT

 

            SET @idEntrenador = (SELECT idEntrenador FROM Entrenador WHERE numeroCedula = @numeroCedulaE);
            SET @idPersonalSalud = (SELECT idPersonalSalud FROM PersonalSalud WHERE numeroCedula = @numeroCedulaP);
			SET @idCliente = (SELECT idCliente FROM Cliente WHERE numeroCedula = @numeroCedulaC);

           		--Se realiza la inserción de la tupla en la tabla Cita.
           		INSERT INTO ReporteIncidente(idCliente,idEntrenador,idPersonalSalud,descripcionIncidente) 
           		VALUES(@idCliente,@idEntrenador,@idPersonalSalud,@descripcionIncidente)
       		END
    END
GO

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoPlanNutricional')
BEGIN
    DROP PROCEDURE ingresoPlanNutricional
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita, 
--a través de la cedula del cliente. 
CREATE PROCEDURE ingresoPlanNutricional
    --Se declaran los argumentos que recibe el procedimiento almacenado
	
	@nombreRM VARCHAR (20),
	@nombre VARCHAR (20),
	@cantidadComidasDia TINYINT,
	@indicacionesGenerales NVARCHAR(300),
	@alergiasConsideradas NVARCHAR(100),
	@fechaInicio DATE,
	@fechaFin DATE

AS
    --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM RegistroMedico WHERE nombre = @nombreRM) = 0
    BEGIN
        RAISERROR('El registro medico no existe.',16,10)
    END
    ELSE
    BEGIN

            --Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del personal de salud. 
            DECLARE @idRegistroMedico SMALLINT

            SET @idRegistroMedico = (SELECT idRegistroMedico FROM RegistroMedico WHERE nombre = @nombreRM);

            --Se realiza la inserción de la tupla en la tabla Cita.
            INSERT INTO PlanNutricional(idRegistroMedico,nombre,cantidadComidasDia,indicacionesGenerales, alergiasConsideradas, fechaInicio, fechaFin) 
            VALUES(@idRegistroMedico,@nombre,@cantidadComidasDia,@indicacionesGenerales,@alergiasConsideradas, @fechaInicio, @fechaFin)
        
    END
GO


--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'ingresoMenu')
BEGIN
    DROP PROCEDURE ingresoMenu
END
GO
--Creación de un Procedimiento Almacenado que permita ingresar un registro a la tabla Cita, 
--a través de la cedula del cliente. 
CREATE PROCEDURE ingresoMenu
    --Se declaran los argumentos que recibe el procedimiento almacenado
	@nombre VARCHAR (20),
	@nombreC VARCHAR (20),
	@nombrePN VARCHAR (20),
	@horarioMenu VARCHAR (10),
	@informacionAdicional NVARCHAR(300),
	@cantidadTotalCalorias DECIMAL (6,1)

AS
    --Se verifica si existe el cliente con esa cédula que se está intentando ingresar.
    IF (SELECT COUNT(*) FROM Comida WHERE nombre = @nombreC) = 0
    BEGIN
        RAISERROR('La comida no existe.',16,10)
    END
    ELSE
    BEGIN
        --Se verifica si existe el personal de salud con esa cédula que se está intentando ingresar. 
        IF (SELECT COUNT(*) FROM PlanNutricional WHERE nombre = @nombrePN) = 0
        BEGIN
            RAISERROR('El plan nutricional no existe.',16,10)
        END
        ELSE
        BEGIN
            --Si el cliente y el entrenador existen, se obtiene el id del paciente y el id del personal de salud. 
            DECLARE @idComida SMALLINT
            DECLARE @idPlanNutricional SMALLINT

 

            SET @idComida = (SELECT idComida FROM Comida WHERE nombre = @nombreC);
            SET @idPlanNutricional = (SELECT idPlanNutricional FROM PlanNutricional WHERE nombre = @nombrePN);

            --Se realiza la inserción de la tupla en la tabla Cita.
            INSERT INTO Menu(idComida,idPlanNutricional ,nombre,horarioMenu,informacionAdicional,cantidadTotalCalorias) 
            VALUES(@idComida,@idPlanNutricional,@nombre,@horarioMenu,@informacionAdicional,@cantidadTotalCalorias)
        END
    END
GO


IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'sp_insertar_plan_nutricional')
BEGIN
    DROP PROCEDURE sp_insertar_plan_nutricional
END
GO

/*********
		 Stored procedure para ingresar un plan nutricional directamente con una cédula
**********/

CREATE PROCEDURE sp_insertar_plan_nutricional
    @numeroCedula cedulaIdentidad,
    @nombrePlan NVARCHAR(20),
    @cantidadComidasDia TINYINT,
    @indicacionesGenerales NVARCHAR(300) = NULL,
    @alergiasConsideradas NVARCHAR(100) = NULL,
    @fechaInicio DATE,
    @fechaFin DATE
AS
BEGIN
    DECLARE @idRegistroMedico SMALLINT
    DECLARE @idCliente SMALLINT
    DECLARE @idEntrenador TINYINT

    -- Buscar el registro médico asociado a la cédula del cliente o del entrenador
    IF EXISTS (SELECT 1 FROM Cliente WHERE numeroCedula = @numeroCedula)
    BEGIN
        SELECT @idRegistroMedico = rm.idRegistroMedico, @idCliente = c.idCliente
        FROM RegistroMedico rm
        INNER JOIN Cita c ON rm.idCita = c.idCita
        INNER JOIN Cliente cl ON c.idCliente = cl.idCliente
        WHERE cl.numeroCedula = @numeroCedula
    END
    ELSE IF EXISTS (SELECT 1 FROM Entrenador WHERE numeroCedula = @numeroCedula)
    BEGIN
        SELECT @idRegistroMedico = rm.idRegistroMedico, @idEntrenador = e.idEntrenador
        FROM RegistroMedico rm
        INNER JOIN Cita c ON rm.idCita = c.idCita
        INNER JOIN Entrenador e ON c.idEntrenador = e.idEntrenador
        WHERE e.numeroCedula = @numeroCedula
    END
    ELSE
    BEGIN
        RAISERROR('No se encontró un cliente o entrenador con la cédula especificada', 16, 1)
        RETURN
    END

    -- Insertar el nuevo plan nutricional
    INSERT INTO PlanNutricional (idRegistroMedico, nombre, cantidadComidasDia, indicacionesGenerales, alergiasConsideradas, fechaInicio, fechaFin)
    VALUES (@idRegistroMedico, @nombrePlan, @cantidadComidasDia, @indicacionesGenerales, @alergiasConsideradas, @fechaInicio, @fechaFin)

    -- Obtener el ID del nuevo plan nutricional
    DECLARE @idPlanNutricional SMALLINT
    SET @idPlanNutricional = SCOPE_IDENTITY()

    -- Actualizar la tabla de citas para indicar que se ha creado un nuevo plan nutricional
    IF @idCliente IS NOT NULL
    BEGIN
        UPDATE Cita SET tipo = 'Cita nutricionista' WHERE idCliente = @idCliente
    END
    ELSE IF @idEntrenador IS NOT NULL
    BEGIN
        UPDATE Cita SET tipo = 'Cita nutricionista' WHERE idEntrenador = @idEntrenador
    END

    -- Mostrar un mensaje de éxito
    PRINT 'Se ha insertado un nuevo plan nutricional para el registro médico asociado a la cédula ' + @numeroCedula
END

EXEC sp_insertar_plan_nutricional '1104491862', 'Plan peso a', 3, 'Coma mucho', null, '2023-08-01', '2023-09-03'


/*****************************************************************
INFORMES
******************************************************************/
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
	--Se verifica que eXita el cliente
	if ((SELECT COUNT (*) FROM Cliente C WHERE C.numeroCedula = @cedulaCliente) = 0)
	BEGIN
		RAISERROR('INGRESE UNA CEDULA VALIDA O VERIFIQUE QUE EL CLIENTE EXISTA', 16,1)
		RETURN
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
GO

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'asistenciaCliente')
BEGIN
    DROP PROCEDURE asistenciaCliente
END
GO
--Procedure para ver la asistencia del cliente de acuerdo con cada rutinaque tenga y hacer un calculo total de dias que ha asistido
CREATE PROCEDURE asistenciaCliente (@cedulaCliente nvarchar(12))
AS
	
	--Validacino de datos segun la cedula
	if ((SELECT COUNT (*) FROM Cliente C WHERE C.numeroCedula = @cedulaCliente) = 0)
	BEGIN
		RAISERROR('INGRESE UNA CEDULA VALIDA O VERIFIQUE QUE EL CLIENTE EXISTA', 16,1)
		RETURN
	END

	--Declarar las variables

	DECLARE @idCliente AS INT
	DECLARE @nombresCliente AS NVARCHAR(100)
	DECLARE @apellidosClientes AS NVARCHAR(100)
	DECLARE @fechaInicioPlanEntenamiento AS DATE
	DECLARE	@asistenciasTotales SMALLINT

	--Inicializacion de las variables

	SET @idCliente = (SELECT TOP 1 idCliente FROM Cliente WHERE numeroCedula = @cedulaCliente)
	SET @nombresCliente = (SELECT TOP 1 nombres FROM Cliente WHERE idCliente = @idCliente)
	SET @apellidosClientes = (SELECT TOP 1 apellidos FROM Cliente WHERE idCliente = @idCliente)
	SET @fechaInicioPlanEntenamiento = (SELECT TOP 1 fechaInicio FROM PlanEntrenamiento P WHERE P.idCliente = @idCliente)
	SET @asistenciasTotales = (SELECT SUM(asistencia) FROM PlanEntrenamiento P WHERE P.idCliente = @idCliente)

	--Datos generales del cliente

	PRINT('****************************************Life Fitness Gym****************************************')
	PRINT('Cliente: ' + @nombresCliente + ' ' + @apellidosClientes)
	PRINT('Fecha de inicio de entrenmiento: ' + CONVERT(NVARCHAR(10), @fechaInicioPlanEntenamiento, 120))
	PRINT('************************************************************************************************')
	PRINT('')

	DECLARE @idPlanEntrenamiento SMALLINT, @asistencia TINYINT, @fechaInicio DATE, @fechaCambio DATE
	
	/*Se declara y se usa el cursor*/
	DECLARE cursorAsistencia CURSOR FOR 
		SELECT idPlanEntrenamiento, asistencia, fechaInicio , fechaCambio
		FROM PlanEntrenamiento
		WHERE idCliente = @idCliente

	OPEN cursorAsistencia

	FETCH NEXT FROM cursorAsistencia INTO @idPlanEntrenamiento, @asistencia , @fechaInicio, @fechaCambio

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		PRINT('*****************************************************************')
		PRINT(' Asistencia fechas desde' + CONVERT(NVARCHAR(10), @fechaInicio, 120)+' hasta ' + 
			CONVERT(NVARCHAR(10), @fechaCambio, 120)+': ' + CONVERT(NVARCHAR(10), @asistencia, 120) + 'dias')

		PRINT('*****************************************************************')
		PRINT('')
		FETCH NEXT FROM cursorAsistencia INTO @idPlanEntrenamiento, @asistencia , @fechaInicio, @fechaCambio
	END
	PRINT('')
	PRINT('')
	PRINT('')
	PRINT ('Dias totales asistidos: ' + CONVERT(NVARCHAR(10), @asistenciasTotales, 120))
	CLOSE cursorAsistencia
	DEALLOCATE cursorAsistencia
GO

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
	/*Validacion de datos de entrada de cliente*/
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

	

	/*Se muestra la informacion con la que el cliente llego al gimnasio, es decir la inicial*/
	PRINT('****************************************Life Fitness Gym****************************************')
	PRINT('Cliente: ' + @nombresCliente + ' ' + @apellidosClientes)
	PRINT('************************Información inicial del cliente sobre su progreso************************')
	PRINT('Altura inicial: ' + CONVERT(NVARCHAR(10), @alturaInicial, 120))
	PRINT('Peso inicial: ' + CONVERT(NVARCHAR(10), @pesoInicial, 120))
	PRINT('Indice de grasa corporal inicial: ' + CONVERT(NVARCHAR(10), @IGCInicial, 120))

	/*Se declaran la variables que se van a usar en el cursor*/
	DECLARE @idCita SMALLINT, @fechaRegistro DATE, @alturaActual DECIMAL(3,2), @pesoActual DECIMAL(5,2), @indiceGrasaCorporal DECIMAL (3,1), @estadoSalud NVARCHAR(10)
	
	/*SE declara y se usa el cursor*/
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
		PRINT('************************Fecha registro: ' + CONVERT(NVARCHAR(10), @fechaRegistro, 120) + ' ************************')
		PRINT('Altura a la fecha: ' + CONVERT(NVARCHAR(10), @alturaActual, 120))
		PRINT('Peso a la fecha: ' + CONVERT(NVARCHAR(10), @pesoActual, 120))
		PRINT('Indice de grasa corporal a la fecha: ' + CONVERT(NVARCHAR(10), @indiceGrasaCorporal, 120))
		PRINT('Estado de salud a la fecha: ' + CONVERT(NVARCHAR(10), @estadoSalud, 120))
		PRINT('')
		
		FETCH NEXT FROM cursorRegistroMedico INTO @idCita, @fechaRegistro, @alturaActual, @pesoActual, @indiceGrasaCorporal, @estadoSalud
	END

	CLOSE cursorRegistroMedico
	DEALLOCATE cursorRegistroMedico
GO

--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'rutinaCliente')
BEGIN
    DROP PROCEDURE rutinaCliente
END
GO
--Creación de un Procedimiento Almacenado que permita isualizar la rutina actual del cliente, 
--a través de la cedula del cliente. 
CREATE PROCEDURE rutinaCliente (@cedulaCliente nvarchar(12))
AS
	--Validacino de datos segun la cedula
	if ((SELECT COUNT (*) FROM Cliente C WHERE C.numeroCedula = @cedulaCliente) = 0)
	BEGIN
		RAISERROR('INGRESE UNA CEDULA VALIDA O VERIFIQUE QUE EL CLIENTE EXISTA', 16,1)
		RETURN
	END

	--Declarar las variables

	DECLARE @idCliente AS INT
	DECLARE @nombresCliente AS NVARCHAR(100)
	DECLARE @apellidosClientes AS NVARCHAR(100)
	DECLARE @fechaInicioPlanEntenamiento AS DATE

	--Inicializacion de las variables

	SET @idCliente = (SELECT TOP 1 idCliente FROM Cliente WHERE numeroCedula = @cedulaCliente)
	SET @nombresCliente = (SELECT TOP 1 nombres FROM Cliente WHERE idCliente = @idCliente)
	SET @apellidosClientes = (SELECT TOP 1 apellidos FROM Cliente WHERE idCliente = @idCliente)
	SET @fechaInicioPlanEntenamiento = (SELECT TOP 1 fechaInicio FROM PlanEntrenamiento P WHERE P.idCliente = @idCliente)

	--Datos generales del cliente

	PRINT('****************************************Life Fitness Gym****************************************')
	PRINT('Cliente: ' + @nombresCliente + ' ' + @apellidosClientes)
	PRINT('Fecha de inicio del plan de entrenamiento: ' + CONVERT(NVARCHAR(10), @fechaInicioPlanEntenamiento, 120))
	PRINT('************************************************************************************************')
	
	--Se declaran las variables para el cursor

	DECLARE @idRutina SMALLINT, 
		@nombreEjercicio NVARCHAR(30),
		@descripcionEjercicio NVARCHAR(120), 
		@grupoMuscular NVARCHAR(20),
		@cantidadRepeticiones TINYINT,
		@tiempoDescanso DECIMAL (3,1),
		@cantidadSeries TINYINT,
		@diaSemana VARCHAR(9)
	
	/*Se declara y se usa el cursor*/
	DECLARE cursorRutina CURSOR FOR 
		SELECT Rut.idRutina, Rut.nombreEjercicio, Rut.descripcionEjercicio, Rut.grupoMuscular, Rut.cantidadRepeticiones, Rut.tiempoDescanso, Rut.cantidadSeries, Rut.diaSemana
		FROM Rutina Rut
		WHERE idPlanEntrenamiento = (SELECT TOP 1 idPlanEntrenamiento FROM PlanEntrenamiento WHERE idCliente = @idCliente ORDER BY idPlanEntrenamiento DESC)
	OPEN cursorRutina

	FETCH NEXT FROM cursorRutina INTO @idRutina, @nombreEjercicio, @descripcionEjercicio, @grupoMuscular, @cantidadRepeticiones, @tiempoDescanso, @cantidadSeries, @diaSemana

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		PRINT('')
		PRINT('**********Dia de la semana: ' + @diaSemana + ' ************')
		PRINT('Grupo Muscular: ' + @grupoMuscular)
		PRINT('Nombre del ejercicio: ' + @nombreEjercicio)
		PRINT('Cant. Series: ' + CONVERT(NVARCHAR(10), @cantidadSeries, 120))
		PRINT('Cant. Repeticiones: ' + CONVERT(NVARCHAR(10), @cantidadRepeticiones, 120))
		PRINT('Descanso entre series: ' + CONVERT(NVARCHAR(10), @tiempoDescanso, 120))
		PRINT('')
		
		FETCH NEXT FROM cursorRutina INTO @idRutina, @nombreEjercicio, @descripcionEjercicio, @grupoMuscular, @cantidadRepeticiones, @tiempoDescanso, @cantidadSeries, @diaSemana
	END

	CLOSE cursorRutina
	DEALLOCATE cursorRutina
GO


--Verificar si existe el Procedimiento Almacenado
IF EXISTS(SELECT name FROM sys.objects WHERE type = 'P' AND name = 'informePlanNutricionalActual')
BEGIN
    DROP PROCEDURE informePlanNutricionalActual
END
GO
--Creación de un Procedimiento Almacenado que permita ver el plan nutricional actual del cliente o del entrenador, 
--a través de la cedula del cliente. 
CREATE PROCEDURE informePlanNutricionalActual (@cedula nvarchar(12))
AS
	/*VALIDACION DE DATOS DEL CLIENTE*/
	if (SELECT COUNT (*) FROM Cliente C WHERE C.numeroCedula = @cedula) = 0 AND (SELECT COUNT (*) FROM Entrenador E WHERE E.numeroCedula = @cedula) = 0
	BEGIN
		RAISERROR('INGRESE UNA CEDULA VALIDA O VERIFIQUE QUE EL CLIENTE EXISTA', 16,1)
		RETURN
	END

	/*DECLARACION Y ASIGANCION DE VARIABLES*/
	DECLARE @idCliente AS TINYINT = NULL
	DECLARE @idEntrenador AS TINYINT = NULL
	DECLARE @nombresCliente AS NVARCHAR(100)
	DECLARE @apellidosClientes AS NVARCHAR(100)
	DECLARE @nombresEntrenador AS NVARCHAR(100)
	DECLARE @apellidosEntrenador AS NVARCHAR(100)
	DECLARE @idUltimaCitaCliente AS TINYINT
	DECLARE @idUltimaCitaEntrenador AS TINYINT


	SET @idCliente = (SELECT TOP 1 idCliente FROM Cliente WHERE numeroCedula = @cedula)
	SET @idEntrenador = (SELECT TOP 1 idEntrenador FROM Entrenador WHERE numeroCedula = @cedula)
	SET @idUltimaCitaCliente = (SELECT TOP 1 idCita FROM Cita WHERE idCliente = @idCliente ORDER BY idCita DESC)
	SET @idUltimaCitaEntrenador = (SELECT TOP 1 idCita FROM Cita WHERE idEntrenador = @idEntrenador ORDER BY idCita DESC)

	/*Se muestra la ifnormacion general del cliente o del entrenador*/
	PRINT('****************************************Life Fitness Gym****************************************')
	IF (@idCliente IS NOT NULL)
		BEGIN
			SET @nombresCliente = (SELECT TOP 1 nombres FROM Cliente WHERE idCliente = @idCliente)
			SET @apellidosClientes = (SELECT TOP 1 apellidos FROM Cliente WHERE idCliente = @idCliente)
			PRINT('Cliente: ' + @nombresCliente + ' ' + @apellidosClientes)
		END
	IF(@idEntrenador IS NOT NULL)
		BEGIN
			SET @nombresEntrenador = (SELECT TOP 1 nombres FROM Entrenador WHERE idEntrenador = @idEntrenador)
			SET @apellidosEntrenador = (SELECT TOP 1 apellidos FROM Entrenador WHERE idEntrenador = @idEntrenador)
			PRINT('Entrenador: ' + @nombresEntrenador + ' ' + @apellidosEntrenador)
		END
	PRINT('************************************************************************************************')
	PRINT ('')

	--Se muestra las alrgias que constan el los registros del cliente o del entrenador
	IF (@idCliente IS NOT NULL)
		BEGIN
			IF EXISTS ((SELECT TOP 1 alergias FROM RegistroMedico WHERE idCita = @idUltimaCitaCliente AND alergias IS NOT NULL ORDER BY idRegistroMedico DESC) )
				BEGIN
					DECLARE @alergiasCliente AS NVARCHAR(100) = (SELECT TOP 1 alergias FROM RegistroMedico WHERE idCita = @idUltimaCitaCliente ORDER BY idRegistroMedico DESC)
					PRINT('************************Informacion medica relevante************************')
					PRINT('Alergias: ' + @alergiasCliente)
					PRINT('****************************************************************************')
					PRINT('')
				END
		END

	IF (@idEntrenador IS NOT NULL)
		BEGIN
			IF EXISTS ((SELECT TOP 1 alergias FROM RegistroMedico WHERE idCita = @idUltimaCitaEntrenador AND alergias IS NOT NULL ORDER BY idRegistroMedico DESC) )
				BEGIN
					DECLARE @alergiasEntrenador AS NVARCHAR(100) = (SELECT TOP 1 alergias FROM RegistroMedico WHERE idCita = @idUltimaCitaEntrenador ORDER BY idRegistroMedico DESC)
					PRINT('************************Informacion medica relevante************************')
					PRINT('Alergias: ' + @alergiasEntrenador)
					PRINT('****************************************************************************')
					PRINT('')
				END
		END

	--Se muetra la informacion general de los planes nutricionales de los clientes o de los entrenadores
	IF (@idCliente IS NOT NULL)
		BEGIN
			DECLARE @ultimoRegistroCli AS TINYINT = (SELECT idRegistroMedico FROM RegistroMedico WHERE idCita = @idUltimaCitaCliente)
			DECLARE @nombrePlanCli AS VARCHAR(20) = (SELECT nombre FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)
			DECLARE @indicacionesGeneralesCli AS NVARCHAR(300) = (SELECT indicacionesGenerales FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)
			DECLARE @cantidadComidasCli AS TINYINT = (SELECT cantidadComidasDia FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)
			DECLARE @alergiasConsideradasCli AS NVARCHAR(100) = (SELECT alergiasConsideradas FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)
			DECLARE @fechaInicioCli AS DATE = (SELECT fechaInicio FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)
			DECLARE @fechaFinCli AS DATE = (SELECT fechaFin FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)

			PRINT('************************Informacion plan nutricional actual del cliente************************')
			PRINT('Nombre del plan: ' + @nombrePlanCli)
			PRINT('Indicaciones generales: ' + @indicacionesGeneralesCli)
			PRINT('Cant. de Comidas al dia: ' + CONVERT(NVARCHAR(10), @cantidadComidasCli, 120))
			PRINT('Alegias Consideradas: ' + @alergiasConsideradasCli)
			PRINT('Fecha de inicio plan: ' + CONVERT(NVARCHAR(10), @fechaInicioCli, 120))
			PRINT('Fecha de fin del plan: ' + CONVERT(NVARCHAR(10), @fechaFinCli, 120))
			PRINT('**************************Menu que consta el plan nutricional del cliente************************')

			/*DECLARAR VARIBLES QUE SE VAN A USAR EN EL CURSOR*/
			DECLARE @idMenuC SMALLINT ,@nombreC varchar(20), @horarioMenuC varchar(10), @informacionAdicionalC NVARCHAR (300), @cantidadTotalCaloriasC DECIMAL (6,1)
			DECLARE @nombreMenuComida varchar(20), @nombreComidaC VARCHAR(20), @cantidadProteinaC DECIMAL (5,1), @cantidadCarbohidratosC DECIMAL (5,1), @cantidadGrasasC DECIMAL (5,1), @cantidadFibraC DECIMAL (5,1), @preparacionC NVARCHAR(300)
			
			/*SE DECLARA Y SE USA EL CURSOR*/
			DECLARE cursorPlanNutricionalCliente CURSOR FOR SELECT idMenu, nombre, horarioMenu ,informacionAdicional, cantidadTotalCalorias 
				FROM Menu WHERE idPlanNutricional = (SELECT idPlanNutricional FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)


			DECLARE cursorComidasCliente CURSOR FOR SELECT M.nombre, C.nombre, C.cantidadProteina, C.cantidadCarbohidratos, C.cantidadGrasas, C.cantidadFibra, C.preparacion 
				FROM Comida C
				INNER JOIN MENU M ON M.idComida = C.idComida
				WHERE M.idPlanNutricional = (SELECT idPlanNutricional FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroCli)
			BEGIN

				OPEN cursorPlanNutricionalCliente
				FETCH NEXT FROM cursorPlanNutricionalCliente INTO @idMenuC, @nombreC, @horarioMenuC, @informacionAdicionalC, @cantidadTotalCaloriasC

				WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT('		************************Nombre del menu: ' + @nombreC + '************************')
					PRINT('		Horario Menu: ' + @horarioMenuC)
					PRINT('		Informacion Adicional: ' + @informacionAdicionalC)
					PRINT('		Cantidad de calorias totales: ' + CONVERT(NVARCHAR(10), @cantidadTotalCaloriasC, 120))
					PRINT('')
					PRINT('')
					FETCH NEXT FROM cursorPlanNutricionalCliente INTO  @idMenuC, @nombreC, @horarioMenuC, @informacionAdicionalC, @cantidadTotalCaloriasC
				END

				CLOSE cursorPlanNutricionalCliente
				DEALLOCATE cursorPlanNutricionalCliente
			END
			
			PRINT('		****************************Comidas de acuerdo con cada menu *********************************')

			--Cursor para comidas
			OPEN cursorComidasCliente
					FETCH NEXT FROM cursorComidasCliente INTO  @nombreComidaC, @cantidadProteinaC, @cantidadCarbohidratosC, @cantidadGrasasC, @cantidadFibraC, @preparacionC
				
					WHILE @@FETCH_STATUS = 0
					BEGIN
						PRINT('')
						PRINT('		*****************Comida: ' + @nombreComidaC + ' del menu:' +  @nombreMenuComida + '********************')
						PRINT('		Preparacion: ' + @preparacionC)
						PRINT('		Cantidad de proteina     : ' + CONVERT(NVARCHAR(10), @cantidadProteinaC, 120))
						PRINT('		Cantidad de carbohidratos: ' + CONVERT(NVARCHAR(10), @cantidadCarbohidratosC, 120))
						PRINT('		Cantidad de grasas       : ' + CONVERT(NVARCHAR(10), @cantidadGrasasC, 120))
						PRINT('		Cantidad de fibra        : ' + CONVERT(NVARCHAR(10), @cantidadFibraC, 120))
						PRINT('')

						FETCH NEXT FROM cursorComidasCliente INTO @nombreComidaC, @cantidadProteinaC, @cantidadCarbohidratosC, @cantidadGrasasC, @cantidadFibraC, @preparacionC
					END

					CLOSE cursorComidasCliente
					DEALLOCATE cursorComidasCliente
		END
	IF (@idEntrenador IS NOT NULL)
		BEGIN
			DECLARE @ultimoRegistroEnt AS TINYINT = (SELECT idRegistroMedico FROM RegistroMedico WHERE idCita = @idUltimaCitaEntrenador)
			DECLARE @nombrePlanEnt AS VARCHAR(20) = (SELECT nombre FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)
			DECLARE @indicacionesGeneralesEnt AS NVARCHAR(300) = (SELECT indicacionesGenerales FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)
			DECLARE @cantidadComidasEnt AS TINYINT = (SELECT cantidadComidasDia FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)
			DECLARE @alergiasConsideradasEnt AS NVARCHAR(100) = (SELECT alergiasConsideradas FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)
			DECLARE @fechaInicioEnt AS DATE = (SELECT fechaInicio FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)
			DECLARE @fechaFinEnt AS DATE = (SELECT fechaFin FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)

			PRINT('************************Informacion plan nutricional actual del entrenador************************')
			PRINT('Nombre del plan: ' + @nombrePlanEnt)
			PRINT('Indicaciones generales: ' + @indicacionesGeneralesEnt)
			PRINT('Cant. de Comidas al dia: ' + CONVERT(NVARCHAR(10), @cantidadComidasEnt, 120))
			PRINT('Alegias Consideradas: ' + @alergiasConsideradasEnt)
			PRINT('Fecha de inicio plan: ' + CONVERT(NVARCHAR(10), @fechaInicioEnt, 120))
			PRINT('Fecha de fin del plan: ' + CONVERT(NVARCHAR(10), @fechaFinEnt, 120))

			PRINT('**************************Menu que consta el plan nutricional del entrendaor************************')

			/*DECLARAR VARIBLES QUE SE VAN A USAR EN EL CURSOR*/
			DECLARE @nombreE varchar(20), @horarioMenuE varchar(10), @informacionAdicionalE NVARCHAR (300), @cantidadTotalCaloriasE DECIMAL (6,1)
			
			/*SE DECLARA Y SE USA EL CURSOR*/
			DECLARE cursorPlanNutricionalEntrenador CURSOR FOR SELECT nombre, horarioMenu ,informacionAdicional, cantidadTotalCalorias 
				FROM Menu WHERE idPlanNutricional = (SELECT idPlanNutricional FROM PlanNutricional WHERE idRegistroMedico = @ultimoRegistroEnt)

			OPEN cursorPlanNutricionalEntrenador

			FETCH NEXT FROM cursorPlanNutricionalEntrenador INTO @nombreE, @horarioMenuE, @informacionAdicionalE, @cantidadTotalCaloriasE

			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT('		************************Nombre del menu: ' + @nombreE + '************************')
				PRINT('		Horario Menu: ' + @horarioMenuE)
				PRINT('		Informacion Adicional: ' + @informacionAdicionalE)
				PRINT('		Cantidad de calorias totales: ' + CONVERT(NVARCHAR(10), @cantidadTotalCaloriasE, 120))
				PRINT('')
				PRINT('')
				FETCH NEXT FROM cursorPlanNutricionalEntrenador INTO @nombreE, @horarioMenuE, @informacionAdicionalE, @cantidadTotalCaloriasE
			END

			CLOSE cursorPlanNutricionalEntrenador
			DEALLOCATE cursorPlanNutricionalEntrenador
		END
GO









/*

sp_addlogin 'academico','c@ntya1e;a','master'
    sp_adduser 'academico', 'academico'

grant select, insert on Material to academico
grant select, insert on Ejemplar to academico
grant select, insert on Prestamo to academico
grant select, insert on Reserva to academico
*/


/***********************************
-- Encriptación de la base de datos
***********************************
*/

 
/*
--Permisos de usuario/admin DB
GRANT ALTER ON DATABASE::ProyectoBD2Prog1 TO usuario

--Crear master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<password>';
CREATE CERTIFICATE MyCertificate
WITH SUBJECT = 'Certificate for encryption';
SELECT name, thumbprint, subject FROM sys.certificates WHERE name = 'MyCertificate'
 
--Permisos de usuario/admin cerificado
GRANT CONTROL ON CERTIFICATE::MyCertificate TO usuario


--Crear database encrytion key
USE ProyectoBD2Prog1;
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyCertificate;


--Guardar el certificado 
USE master;
BACKUP CERTIFICATE MyCertificate
TO FILE = 'C:\DB2prog1\RepoDB2prog1\MyCertificate.cer'
WITH PRIVATE KEY (
     FILE = 'C:\DB2prog1\RepoDB2prog1\MyCertificate.pvk',
     ENCRYPTION BY PASSWORD = 'password'
);


--Activar la base con encriptacion
ALTER DATABASE ProyectoBD2Prog1
SET ENCRYPTION ON;*/




--Trigger Alergias

--Cuando se ingrese Rutina validar cliente y plan entrenamiento para


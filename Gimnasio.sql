/*
El siguiente script fue desarrollado por: David Trujillo, Sebasti�n Andrade y Jose Miguel Merlo
Fecha de creacion: 08-05-2023 
�ltima versi�n: 19-04-2023 

**********************************
-- Verificacion de existencia de la base de datos y creacion de la misma
**********************************
*/
-- Usar master para creaci�n de base.
USE Master
GO

-- Verificar si la base de datos Gimnasio ya existe; si existe, eliminarla
IF EXISTS(SELECT name FROM sys.databases WHERE name = 'Gimnasio')
BEGIN
    DROP DATABASE Gimnasio;
END

CREATE DATABASE Gimnasio;
GO

/*
**********************************
-- Verificacion de existencia de reglas y tipos; creacion de las mismas
**********************************
*/

-- Usar la base de datos Gimnasio
USE Gimnasio
GO

-- Validar si existe el tipo de dato correo y crear tipo de dato para correo electr�nico
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

-- Creaci�n de la regla que valide que el tipo de dato cedulaIdentidad siga los par�metros de una c�dula de identidad Ecuatoriana
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

-- Creaci�n de la regla que valide que el tipo de dato correo siga los par�metros requeridos por un email.
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

-- Creaci�n de la regla que valide que el tipo de dato celular siga los par�metros de un celular ecuatoriano
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

--Creaci�n de la tabla Cliente.
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
CONSTRAINT UQ_CorreoElectronicoC UNIQUE (correoElectronico),
CONSTRAINT UQ_NumeroCelularC UNIQUE (numeroCelular),
CONSTRAINT CK_nombres CHECK (PATINDEX('%[0-9]%', nombres)�=�0),
CONSTRAINT CK_apellidos CHECK (PATINDEX('%[0-9]%', apellidos)�=�0)
);

--Creaci�n de la tabla Entrenador.
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
CONSTRAINT CK_nombresE CHECK (PATINDEX('%[0-9]%', nombres)�=�0),
CONSTRAINT CK_apellidosE CHECK (PATINDEX('%[0-9]%', apellidos)�=�0)
);

--Creaci�n de la tabla Plan Entrenamiento.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'PlanEntrenamiento')
BEGIN
    DROP TABLE PlanEntrenamiento;
END
CREATE TABLE PlanEntrenamiento(
idPlanEntrenamiento SMALLINT IDENTITY (1,1),
idCliente SMALLINT NOT NULL,
nombre VARCHAR(20) NOT NULL,
idEntrenador TINYINT NOT NULL,
intensidad VARCHAR(5) NOT NULL,
objetivoPlan NVARCHAR(40) NOT NULL,
fechaInicio DATE NOT NULL,
fechaCambio DATE NULL,
monitoreo CHAR(7) NULL,
CONSTRAINT PK_PlanEntrenamiento PRIMARY KEY (idPlanEntrenamiento),
CONSTRAINT FK_Cliente FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente),
CONSTRAINT FK_Entrenador FOREIGN KEY (idEntrenador) REFERENCES Entrenador (idEntrenador),
CONSTRAINT CK_Intensidad CHECK (intensidad IN ('Alta','Media','Baja')),
CONSTRAINT CK_FechaInicio CHECK (fechaInicio>=GETDATE()),
CONSTRAINT CK_FechaCambio CHECK (fechaCambio>fechaInicio),
CONSTRAINT CK_Monitoreo CHECK (monitoreo IN ('Semanal','Mensual')),
CONSTRAINT UQ_NombreP UNIQUE (nombre),
CONSTRAINT CK_nombre CHECK (PATINDEX('%[0-9]%', nombre)�=�0)
);

--Creaci�n de la tabla Rutina.
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
asistencia BIT DEFAULT 0,
CONSTRAINT PK_Rutina PRIMARY KEY (idRutina),
CONSTRAINT FK_PlanEntrenamiento FOREIGN KEY (idPlanEntrenamiento) REFERENCES PlanEntrenamiento (idPlanEntrenamiento),
CONSTRAINT CK_CantidadRepeticiones CHECK (cantidadRepeticiones>0 AND cantidadRepeticiones<=8),
CONSTRAINT CK_TiempoDescanso CHECK (tiempoDescanso>10),
CONSTRAINT CK_CantidadSeries CHECK (cantidadSeries>0 AND cantidadSeries<=8),
CONSTRAINT CK_DiaSemana CHECK (diaSemana IN ('Lunes', 'Martes','Miercoles', 'Jueves', 'Viernes', 'Sabado')),
CONSTRAINT CK_caloriasQuemadas CHECK (caloriasQuemadas>0),
CONSTRAINT CK_nombreEjercicio CHECK (PATINDEX('%[0-9]%', nombreEjercicio)�=�0)
);

--Creaci�n de la tabla PersonalSalud.
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
CONSTRAINT CK_nombresP CHECK (PATINDEX('%[0-9]%', nombres)�=�0),
CONSTRAINT CK_apellidosP CHECK (PATINDEX('%[0-9]%', apellidos)�=�0),
CONSTRAINT CK_especialidad CHECK (PATINDEX('%[0-9]%', especialidad)�=�0)
);

--Creaci�n de la tabla Cita.
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
fechaCita SMALLDATETIME NOT NULL,
tipo NVARCHAR(15) NOT NULL,
descripcion NVARCHAR (25) NULL,
asistencia BIT NOT NULL DEFAULT 0,
fechaAsistencia SMALLDATETIME NOT NULL,
CONSTRAINT PK_Cita PRIMARY KEY (idCita),
CONSTRAINT FK_PersonalSalud FOREIGN KEY (idPersonalSalud) REFERENCES PersonalSalud (idPersonalSalud),
CONSTRAINT FK_EntrenadorC FOREIGN KEY (idEntrenador) REFERENCES Entrenador (idEntrenador),
CONSTRAINT FK_ClienteC FOREIGN KEY (idCliente) REFERENCES Cliente (idCliente),
CONSTRAINT CK_fechaCita CHECK (fechaCita>=GETDATE()),
CONSTRAINT CK_fechaAsistencia CHECK (fechaAsistencia>=GETDATE()),
CONSTRAINT CK_tipoC CHECK (tipo IN ('Cita m�dica', 'Cita nutricionista'))
);

--Creaci�n de la tabla RegistroMedico.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'RegistroMedico')
BEGIN
    DROP TABLE RegistroMedico;
END
CREATE TABLE RegistroMedico(
idRegistroMedico SMALLINT IDENTITY (1,1),
idPersonalSalud TINYINT NOT NULL,
idCita SMALLINT NOT NULL,
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
CONSTRAINT FK_PersonalSaludR FOREIGN KEY (idPersonalSalud) REFERENCES PersonalSalud (idPersonalSalud),
CONSTRAINT FK_Cita FOREIGN KEY (idCita) REFERENCES Cita (idCita),
CONSTRAINT CK_FechaRegistro CHECK (fechaRegistro=GETDATE()),
CONSTRAINT CK_TipoSangre CHECK (tipoSangre IN ('O+','O-','A+','A-','B+','B-','AB+','AB-')),
CONSTRAINT CK_EstadoSalud CHECK (estadoSalud IN ('Excelente','Bueno','Cr�tico')),
CONSTRAINT CK_PesoActual CHECK(pesoActual>0 AND pesoActual<400),
CONSTRAINT CK_alturaActual CHECK (alturaActual>0 AND alturaActual<2.5),
CONSTRAINT CK_indiceGrasaCorporal CHECK (indiceGrasaCorporal>0 AND indiceGrasaCorporal <60),
CONSTRAINT CK_Somatipo CHECK (somatipo IN ('Hectomorfo','Mesomorfo','Endomorfo')),
CONSTRAINT CK_operaciones CHECK (PATINDEX('%[0-9]%', operaciones)�=�0),
CONSTRAINT CK_alergias CHECK (PATINDEX('%[0-9]%', alergias)�=�0)
);

--Creaci�n de la tabla PlanNutricional.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'PlanNutricional')
BEGIN
    DROP TABLE PlanNutricional;
END
CREATE TABLE PlanNutricional(
idPlanNutricional SMALLINT IDENTITY (1,1),
idRegistroMedico SMALLINT NOT NULL,
cantidadComidasDia TINYINT NOT NULL,
indicacionesGenerales NVARCHAR(300) NULL,
alergiasConsideradas NVARCHAR (100) NULL,
fechaInicio DATE NOT NULL,
fechaFin DATE NOT NULL,
CONSTRAINT PK_PlanNutricional PRIMARY KEY (idPlanNutricional),
CONSTRAINT FK_RegistroMedico FOREIGN KEY (idRegistroMedico) REFERENCES RegistroMedico (idRegistroMedico),
CONSTRAINT CK_cantidadComidasDia CHECK (cantidadComidasDia>0 AND cantidadComidasDia <=5),
CONSTRAINT CK_fechaInicioP CHECK (fechaInicio>=GETDATE()),
CONSTRAINT CK_fechaFinP CHECK (fechaFin>FechaInicio),
CONSTRAINT CK_alergiasConsideradas CHECK (PATINDEX('%[0-9]%', alergiasConsideradas)�=�0)
);

--Creaci�n de la tabla Comida.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Comida')
BEGIN
    DROP TABLE Comida;
END
CREATE TABLE Comida(
idComida SMALLINT IDENTITY (1,1),
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
);

--Creaci�n de la tabla Menu.
--Antes se valida si existe la tabla y se la elimina de la base de datos, para posteriormente crearla.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'Menu')
BEGIN
    DROP TABLE Menu;
END
CREATE TABLE Menu (
idMenu SMALLINT IDENTITY (1,1),
idComida SMALLINT NOT NULL,
idPlanNutricional SMALLINT NOT NULL,
horarioMenu varchar(10) NOT NULL,
informacionAdicional NVARCHAR (300) NULL,
cantidadTotalCalorias DECIMAL (6,1) NOT NULL,
CONSTRAINT PK_Menu PRIMARY KEY (idMenu),
CONSTRAINT FK_ComidaM FOREIGN KEY (idComida) REFERENCES Comida (idComida),
CONSTRAINT FK_PlanNutricional FOREIGN KEY (idPlanNutricional) REFERENCES PlanNutricional (idPlanNutricional),
CONSTRAINT CK_CantidadTotalCalorias CHECK (cantidadTotalCalorias>0 AND cantidadTotalCalorias<=99999),
CONSTRAINT CK_horarioMenu CHECK (horarioMenu IN ('Dia','Medio dia','Tarde','Media tarde','Noche'))
);

--Creaci�n de la tabla Ingrediente.
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
CONSTRAINT UQ_Nombre UNIQUE(nombre),
CONSTRAINT CK_nombreI CHECK (PATINDEX('%[0-9]%', nombre)�=�0)
);

--Creaci�n de la tabla IngredienteComida.
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

/*
**********************************
-- Objetos Programables
**********************************
*/

 
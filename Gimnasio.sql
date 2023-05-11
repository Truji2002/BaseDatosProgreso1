--Esto es una prueba

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
CONSTRAINT CK_FechaRegistro CHECK (fechaRegistro=GETDATE()),
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
horarioMenu varchar(10) NOT NULL,
informacionAdicional NVARCHAR (300) NULL,
cantidadTotalCalorias DECIMAL (6,1) NOT NULL,
CONSTRAINT PK_Menu PRIMARY KEY (idMenu),
CONSTRAINT FK_ComidaM FOREIGN KEY (idComida) REFERENCES Comida (idComida),
CONSTRAINT FK_PlanNutricional FOREIGN KEY (idPlanNutricional) REFERENCES PlanNutricional (idPlanNutricional),
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
CONSTRAINT CK_fechaIncidente CHECK (fechaIncidente=GETDATE())
);

/*
**********************************
-- INSERTS
**********************************
*/
--Insert Tabla Cliente
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Juan', 'Perez', '1104491862', '1990-05-01', 'Calle 123', 'juanperez@email.com', '0987654321', '0976543210');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Maria', 'Gonzalez', '1758326503', '1985-12-10', 'Avenida Principal', 'mariagonzalez@email.com', '0923456789', '0987654321');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Pedro', 'Lopez', '0923081847', '1992-08-15', 'Calle Secundaria', 'pedrolopez@email.com', '0987123456', '0921654987');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Ana', 'Martinez', '0911276548', '1988-03-22', 'Avenida Central', 'anamartinez@email.com', '0964321987', '0954987321');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Luis', 'Rodriguez', '1705682925', '1995-07-05', 'Calle Principal', 'luisrodriguez@email.com', '0921654987', '0989654123');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Laura', 'Sanchez', '1301167859', '1991-11-30', 'Avenida Secundaria', 'laurasanchez@email.com', '0954987321', '0923987456');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Carlos', 'Gomez', '1721694285', '1994-04-12', 'Calle 456', 'carlosgomez@email.com', '0921987654', '0987123654');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Sofia', 'Lopez', '1705862756', '1987-09-18', 'Avenida 789', 'sofialopez@email.com', '0954123987', '0921789654');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Diego', 'Hernandez', '1741643297', '1993-02-25', 'Calle 890', 'diegohernandez@email.com', '0989654321', '0956123789');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Carolina', 'Torres', '0400609954', '1996-06-08', 'Avenida 567', 'carolinatorres@email.com', '0987321654', '0921789123');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Andres', 'Silva', '0412864712', '1990-03-15', 'Calle 901', 'andressilva@email.com', '0923789456', '0954321988');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Valeria', 'Lopez', '1708071024', '1989-07-20', 'Avenida 234', 'valerialopez@email.com', '0989456123', '0987654321');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Manuel', 'Garcia', '0913876254', '1994-04-05', 'Calle 567', 'manuelgarcia@email.com', '0956123789', '0921987654');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Camila', 'Rojas', '1209567834', '1991-10-12', 'Avenida 890', 'camilarojas@email.com', '0989654123', '0954987321');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Daniel', 'Vargas', '1203567890', '1987-05-27', 'Calle 123', 'danielvargas@email.com', '0921987684', '0987123456');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Valentina', 'Soto', '1754446720', '1993-01-03', 'Avenida Principal', 'valentinasoto@email.com', '0954321987', '0981654987');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Julio', 'Lopez', '1303753618', '1990-06-18', 'Calle 456', 'juliolopez@email.com', '0991654987', '0987321654');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Marina', 'Gomez', '1103756134', '1988-02-13', 'Avenida Secundaria', 'marinagomez@email.com', '0987123654', '0954987123');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Roberto', 'Herrera', '1305267542', '1995-09-28', 'Calle 789', 'robertoherrera@email.com', '0954987331', '0971654987');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Eduardo', 'Morales', '1200984761', '1987-11-11', 'Calle 901', 'eduardomorales@email.com', '0994321987', '0984987321');

--Insert Tabla Entrenador
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Juan', 'Pérez', '1101234567', '1990-05-01', 'Av. Amazonas y Naciones Unidas', 'juan.perez@gmail.com', '0991234567', 5, '2022-06-01', '2023-06-01');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('María', 'García', '1102345678', '1995-07-15', 'Av. 6 de Diciembre y Eloy Alfaro', 'maria.garcia@hotmail.com', '0982345678', 3, '2021-02-15', '2022-08-15');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Pedro', 'Velasco', '1103456789', '1988-11-30', 'Calle 18 de Septiembre y Av. Quito', 'pedro.velasco@yahoo.com', '0963456789', 10, '2019-05-10', '2019-05-10');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Ana', 'Sánchez', '1104567890', '1992-03-20', 'Av. 10 de Agosto y Av. Colón', 'ana.sanchez@gmail.com', '0994567890', 2, '2022-01-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Luis', 'Gómez', '1105678901', '1985-09-10', 'Calle García Moreno y Av. Bolivar', 'luis.gomez@hotmail.com', '0985678901', 15, '2018-11-20', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Carla', 'Martínez', '1106789012', '1998-01-05', 'Av. 9 de Octubre y Av. Malecón', 'carla.martinez@yahoo.com', '0966789012', 1, '2023-04-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Jorge', 'Herrera', '1107890123', '1991-06-25', 'Calle Olmedo y Av. 24 de Mayo', 'jorge.herrera@gmail.com', '0997890123', 4, '2020-08-15', '2022-06-11');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Fernanda', 'Castillo', '1108901234', '1987-12-15', 'Av. 12 de Octubre y Av. Patria', 'fernanda.castillo@hotmail.com', '0988901234', 12, '2019-02-10', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Diego', 'Vega', '1109012345', '1994-08-05', 'Calle Sucre y Av. Rocafuerte', 'diego.ga@yahoo.com', '0969012345', 2, '2022-03-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Sofía', 'Paz', '1100123456', '1997-02-28', 'Av. 6 de Diciembre y Av. Naciones Unidas', 'sofia.paz@gmail.com', '0990123456', 1, '2023-01-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Andrés', 'Moreno', '1101234568', '1990-05-01', 'Av. Amazonas y Naciones Unidas', 'andres.moreno@hotmail.com', '0981234567', 6, '2019-12-01', '2021-11-01');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Valeria', 'Guzmán', '1102345679', '1995-07-15', 'Av. 6 de Diciembre y Eloy Alfaro', 'valeria.guzman@yahoo.com', '0962345678', 4, '2021-05-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Gabriel', 'Ruiz', '1002858874', '1988-11-30', 'Calle 18 de Septiembre y Av. Quito', 'gabriel.ruiz@gmail.com', '0993456789', 11, '2018-06-10', '2019-08-10');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Lucía', 'Santos', '1000052132', '1992-03-20', 'Av. 10 de Agosto y Av. Colón', 'lucia.santos@hotmail.com', '0984567890', 3, '2022-02-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Mario', 'Gallardo', '1105678904', '1985-09-10', 'Calle García Moreno y Av. Bolivar', 'mario.gallardo@yahoo.com', '0965678901', 16, '2017-10-20', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Laura', 'Mendoza', '1106789016', '1998-01-05', 'Av. 9 de Octubre y Av. Malecón', 'laura.mendoza@gmail.com', '0996789012', 2, '2023-02-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Carlos', 'Paredes', '1707890123', '1991-06-25', 'Calle Olmedo y Av. 24 de Mayo', 'carlos.paredes@hotmail.com', '0987890123', 5, '2020-10-15', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Paola', 'Vera', '1008901234', '1987-12-15', 'Av. 12 de Octubre y Av. Patria', 'paola.vera@yahoo.com', '0968901234', 13, '2019-01-01', '2023-01-03');
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Andrea', 'Gángora', '0109012345', '1994-08-05', 'Calle Sucre y Av. Rocafuerte', 'andrea.gongora@gmail.com', '0999012345', 3, '2022-04-01', null);
INSERT INTO Entrenador (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, aniosExperiencia, fechaIngreso, fechaSalida)
VALUES ('Javier', 'Cruz', '1000123456', '1997-02-28', 'Av. 6 de Diciembre y Av. Naciones Unidas', 'javier.cruz@hotmail.com', '0980123456', 2, '2023-03-01', null);


--Insert Tabla Personal Salud
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Juan', 'Pérez', '1104567890', '1990-05-11', 'juanperez@gmail.com', '0987654321', 'Av. Amazonas y Naciones Unidas', 5, 'Doctor', 'Cardiología', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('María', 'García', '1104567891', '1985-02-15', 'mariagarc@gmail.com', '0998765432', 'Av. 6 de Diciembre y Eloy Alfaro', 8, 'Doctor', 'Internista', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Luis', 'Gómez', '1104567892', '1982-11-20', 'luisgomez@gmail.com', '0976543210', 'Calle 18 de Septiembre y Av. Quito', 12, 'Doctor', 'General', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Ana', 'Martínez', '1704567893', '1995-07-03', 'anamartinez@gmail.com', '0986654311', 'Av. América y Naciones Unidas', 3, 'Nutricionista', 'Nutrición Deportiva', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Pedro', 'Sánchez', '1004567894', '1988-12-30', 'pedrosanchez@gmail.com', '0998665436', 'Calle 10 de Agosto y Av. 9 de Octubre', 6, 'Doctor', 'Traumatología', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Carla', 'López', '1004567895', '1992-10-25', 'carlalopez@gmail.com', '0976545240', 'Av. 12 de Octubre y Av. Patria', 4, 'Nutricionista', 'Nutrición Clínica', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Jorge', 'Hernández', '1104567896', '1980-09-10', 'jorgehernandez@gmail.com', '0987884321', 'Calle Guayaquil y Av. Quito', 15, 'Doctor', 'Internista', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Laura', 'Gutiérrez', '1002858866', '1998-01-05', 'lauragutierrez@gmail.com', '0998875432', 'Av. 10 de Agosto y Av. Colón', 2, 'Nutricionista', 'Nutrición Deportiva', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Carlos', 'Ramírez', '1104567898', '1987-06-18', 'carlosramirez@gmail.com', '0976567210', 'Calle Rocafuerte y Av. 9 de Octubre', 7, 'Doctor', 'Internista', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Fernanda', 'Díaz', '1104567899', '1993-11-28', 'fernandadiaz@gmail.com', '0987993271', 'Av. 6 de Dici y Av. Naciones Unidas', 3, 'Nutricionista', 'Nutrición Clínica', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Andrés', 'Fernández', '1104567900', '1981-03-22', 'andresfernandez@gmail.com', '0900765432', 'Calle Olmedo y Av. 9 de Octubre', 14, 'Doctor', 'Traumatología', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Sofía', 'González', '1104567901', '1996-08-12', 'sofiagonzalez@gmail.com', '0963843210', 'Av. 12 de Octubre y Av. Patria', 2, 'Nutricionista', 'Nutrición Deportiva', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Diego', 'Moreno', '1104567902', '1989-05-30', 'diegomoreno@gmail.com', '0966654321', 'Calle Sucre y Av. 9 Octubre', 5, 'Doctor', 'General', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Valentina', 'Paz', '1104567903', '1991-02-18', 'valentinapaz@gmail.com', '0991765432', 'Av. Amazonas y Av. Naciones Unidas', 4, 'Nutricionista', 'Internista', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Gabriel', 'Rojas', '1104567904', '1983-11-10', 'gabrielrojas@gmail.com', '0976541210', 'Calle Bolívar y Av. 9 de Octubre', 11, 'Doctor', 'General', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Isabella', 'Santos', '1104567905', '1997-06-05', 'isabellasantos@gmail.com', '0987114321', 'Av. 6 de Diciembre y Av. Naciones Unidas', 2, 'Nutricionista', 'Nutrición Deportiva', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Miguel', 'Torres', '1104567906', '1986-01-30', 'migueltorres@gmail.com', '0991165132', 'Calle Rocafuerte y Av. 9 de Octubre', 6, 'Doctor', 'Traumatología', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Valeria', 'Vargas', '1104567907', '1994-04-25', 'valeriavargas@gmail.com', '0911143210', 'Av. 12 de Octubre y Av. Patria', 3, 'Nutricionista', 'Nutrición Clínica', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Javier', 'Zambrano', '1104567908', '1982-09-22', 'javierzambrano@gmail.com', '0911154321', 'Calle Sucre y Av. 9 de Octubre', 13, 'Doctor', 'Cardiología', 1, 0, 'Tiempo Completo');



--Insert Tabla Ingrediente
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Manzana', 'Fruta dulce y jugosa', 'Vitamina C, Fibra', 0.3, 0.4, 10.3, 2.4);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Plátano', 'Fruta tropical rica en potasio', 'Vitamina B6, Fibra', 1.1, 0.2, 22, 2.6);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Zanahoria', 'Raíz vegetal anaranjada', 'Vitamina A, Fibra', 0.9, 0.2, 6.8, 2.8);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Espárragos', 'Vegetal verde y delgado', 'Vitamina K, Fibra', 2.2, 0.2, 3.7, 2);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Pollo', 'Carne blanca baja en grasas', 'Vitamina B12, Proteína', 20.4, 1.3, 3, 1.3);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Salmón', 'Pescado rico en ácidos grasos', 'Vitamina D, Omega-3', 22, 13.4, 5, 1.1);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Cebolla', 'Vegetal con sabor fuerte', 'Vitamina C, Fibra', 1.2, 0.1, 9.3, 1.7);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Arroz integral', 'Grano entero con fibra', 'Vitamina B1, Fibra', 7.1, 2.2, 77.5, 3.5);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Huevo', 'Alimento rico en proteínas', 'Vitamina B12, Proteína', 12.6, 9.5, 0.6, 1.3);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Lechuga', 'Hojas verdes para ensaladas', 'Vitamina K, Fibra', 1.4, 0.2, 2.9, 1.3);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Tomate', 'Fruta roja y jugosa', 'Vitamina C, Fibra', 0.9, 0.2, 3.9, 1.2);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Pimiento', 'Vegetal picante y colorido', 'Vitamina A, Vitamina C', 0.9, 0.3, 4.6, 1.5);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Garbanzos', 'Legumbre rica en proteínas', 'Hierro, Fibra', 19, 6, 61, 17);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Aceite de oliva', 'Aceite vegetal saludable', 'Grasas monoinsaturadas', 0.6, 91, 0.3, 0.1);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Yogur griego', 'Yogur espeso y cremoso', 'Calcio, Proteína', 10, 0.4, 3.6, 0.5);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Avena', 'Cereal integral nutritivo', 'Fibra, Magnesio', 13, 7, 56, 10);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Nueces', 'Fruto seco saludable', 'ácidos grasos omega-3, Proteína', 15, 65, 14, 7);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Lentejas', 'Legumbre rica en hierro', 'Hierro, Proteína', 25, 1.4, 60, 11);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Pera', 'Fruta jugosa y refrescante', 'Vitamina C, Fibra', 0.4, 0.2, 10.7, 2);
INSERT INTO Ingrediente (nombre, descripcion, microNutrienetes, proteina, grasas, carbohidratos, fibra) 
VALUES ('Quinoa', 'Grano sin gluten con proteínas', 'Fibra, Magnesio', 14, 6, 64, 7);


--Insert Tabla Comida
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de pollo ve', 25.5, 30.2, 10.1, 5.3, 'Ensalada de pollo con verduras: mezcla lechuga, pollo cocido, tomate, pepino, zanahoria y cebolla. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Arroz con pollo ve', 15.3, 40.5, 0.2, 8.7, 'Arroz con pollo y vegetales: cocina el arroz y saltea pollo, cebolla, pimiento y zanahoria. Mezcla todo y sirve caliente.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Salmón a la parrilla', 20.1, 35.6, 7.8, 6.4, 'Salmón a la parrilla con ensalada de espinacas: sazona el salmón con sal y pimienta y ásalo a la parrilla. Sirve con una ensalada de espinacas, tomate y aguacate.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Hamburguesa', 18.7, 25., 12.3, 4.5, 'Hamburguesa de pavo con ensalada de col: mezcla carne de pavo molida con cebolla, ajo y especias. Forma las hamburguesas y ásalas a la parrilla. Sirve con una ensalada de col y zanahoria.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Pollo al curry', 22.4, 28.9, 8.6, 7.1, 'Pollo al curry con arroz integral: saltea pollo, cebolla y pimiento en una sartén. Agrega curry en polvo y leche de coco. Sirve con arroz integral cocido.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de atún ag', 16.8, 32.1, 6.9, 5.8, 'Ensalada de atún con aguacate y tomate: mezcla lechuga, atún enlatado, aguacate y tomate. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Pasta con salsa to', 19.5, 38.7, 9.2, 6.3, 'Pasta con salsa de tomate y albóndigas: cocina la pasta y prepara albóndigas con carne molida, huevo, pan rallado y especias. Sirve con salsa de tomate casera.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Pollo a la plancha', 21.2, 27.5, 11.4, 0.9, 'Pollo a la plancha con puré de papas: ásala el pollo a la plancha y sirve con puré de papas hecho con leche y mantequilla.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de salmón', 17.9, 31.4, 8.3, 5.6, 'Ensalada de salmón con aguacate y quinoa: mezcla salmón cocido, aguacate, quinoa y espinacas. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Tacos de pollo', 23.1, 29.8, 7.5, 6.9, 'Tacos de pollo con salsa de tomate y guacamole: saltea pollo, cebolla y pimiento en una sartén. Sirve en tortillas de maíz con salsa de tomate y guacamole.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Arroz con lentejas', 14.5, 42.3, 4.8, 9.2, 'Arroz con lentejas y verduras: cocina arroz integral y lentejas. Saltea zanahoria, cebolla y pimiento en una sartén. Mezcla todo y sirve caliente.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de pollo ma', 18.3, 33.6, 6.7, 5.4, 'Ensalada de pollo con manzana y nueces: mezcla lechuga, pollo cocido, manzana y nueces. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Salmón al horno', 20.7, 26.9, 10.1, 4.8, 'Salmón al horno con patatas y zanahorias: sazona el salmón con sal y pimienta y ásalo al horno. Sirve con patatas y zanahorias asadas.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de pollo ag', 16.2, 29.5, 7.2, 5.1, 'Ensalada de pollo con aguacate y tomate cherry: mezcla lechuga, pollo cocido, aguacate y tomate cherry. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Pasta con salsa po', 22.9, 34.8, 8.9, 6.7, 'Pasta con salsa de champiñones y pollo: cocina la pasta y saltea champiñones y pollo en una sartén. Agrega crema de leche y queso parmesano. Sirve con la pasta.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Pollo al horno', 19.3, 27.6, 11.8, 5.7, 'Pollo al horno con arroz y verduras: sazona el pollo con sal y pimienta y ásalo al horno. Sirve con arroz y verduras asadas.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de atun y h', 17.6, 30.9, 7.9, 5.3, 'Ensalada de atun con huevo y lechuga: mezcla lechuga, atún enlatado, huevo cocido y tomate. Aliña con aceite de oliva y vinagre balsómico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Arroz con pollo', 21.5, 36.2, 9.5, 7.2, 'Arroz con pollo y verduras al curry: cocina arroz y saltea pollo, cebolla, pimiento y zanahoria en una sartén. Agrega curry en polvo y leche de coco. Sirve con el arroz.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Ensalada de pollo',15.8, 28.4, 6.1, 0.9, 'Ensalada de pollo con espinacas y fresas: mezcla espinacas, pollo cocido, fresas y nueces. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Tacos de pescado',24.3, 31.7, 8.3, 7.5, 'Tacos de pescado con salsa de aguacate y cilantro: sazona el pescado con sal y pimienta a la parrilla. Sirve en tortillas de maíz con salsa de aguacate y cilantro.');



/*
**********************************
-- Objetos Programables
**********************************
*/

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
		INSERT INTO PlanEntrenamiento(idCliente,idEntrenador,nombre,intensidad,objetivoPlan,fechaInicio,fechaCambio,asistencia)
		VALUES(@idCliente,@idEntrenador,@nombre,@intensidad,@objetivoPlan,@fechaInicio,@fechaCambio,@asistencia)
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
	@tipo NVARCHAR(15),
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
	@tipo NVARCHAR(15),
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
	@nombre VARCHAR (20)
	

AS
 --Se verifica si existe el plan de entrenamiento con el nombre que se está intentando ingresar.
 IF (SELECT COUNT(*) FROM Cita WHERE nombre = @nombre) = 0
	BEGIN
	RAISERROR('La cita no existe.',16,10)
 END
 ELSE
 
	BEGIN
 --Si el plan de entrenamient existe, se obtiene el id del plan de entrenamiento.
	DECLARE @idCita SMALLINT
	SET @idCita = (SELECT idCita FROM Cita WHERE nombre = @nombre);

 --Se realiza la inserción de la tupla en la tabla Resultado.
	INSERT INTO RegistroMedico(idCita,tipoSangre,estadoSalud,pesoActual,alturaActual,indiceGrasaCorporal,lesiones,enfermedades,somatipo,operaciones,alergias,objetivoCliente)
	VALUES(@idCita,@tipoSangre,@estadoSalud,@pesoActual,@alturaActual,@indiceGrasaCorporal,@lesiones,@enfermedades,@somatipo,@operaciones,	@alergias,@objetivoCliente)
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
            SET @idIngrediente = (SELECT @idIngrediente FROM Ingrediente WHERE nombre = @nombreI);

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



--Trigger Alergias

--Cuando se ingrese Rutina validar cliente y plan entrenamiento para


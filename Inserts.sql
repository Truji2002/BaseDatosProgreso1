
USE master
GO

Use Gimnasio
Go

/*
**********************************
-- INSERTS
**********************************
*/

--Insert Tabla Cliente
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('David', 'Trujillo', '1724399991', '1990-05-01', 'Calle 123', 'datrujillo2002@gmail.com', '0987654321', '0976543210');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Jose', 'Merlo', '1722485008', '1985-12-10', 'Avenida Principal', 'josemielmer2002@hotmail.com', '0923456789', '0987654321');
INSERT INTO Cliente (nombres, apellidos, numeroCedula, fechaNacimiento, direccionDomicilio, correoElectronico, numeroCelular, numeroContactoEmergencia)
VALUES ('Sebastian', 'Andrade', '1002858874', '1992-08-15', 'Calle Secundaria', 'sebas3092@gmail.com', '0987123456', '0921654987');
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
VALUES ('Miguel', 'Torres', '1104567906', '1986-01-30', 'sebastian.andrade.guanoquiza@udla.edu.ec', '0991165132', 'Calle Rocafuerte y Av. 9 de Octubre', 6, 'Doctor', 'Traumatología', 1, 0, 'Tiempo Completo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Valeria', 'Vargas', '1104567907', '1994-04-25', 'jose.merlo.santacruz@udla.edu.ec', '0911143210', 'Av. 12 de Octubre y Av. Patria', 3, 'Nutricionista', 'Nutrición Clínica', 1, 1, 'Medio Tiempo');
INSERT INTO PersonalSalud (nombres, apellidos, numeroCedula, fechaNacimiento, correoElectronico, numeroCelular, direccionDomicilio, aniosExperiencia, tipo, especialidad, activo, finesSemana, tipoContrato) 
VALUES ('Javier', 'Zambrano', '1104567908', '1982-09-22', 'david.trujillo.robalino@udla.edu.ec', '0911154321', 'Calle Sucre y Av. 9 de Octubre', 13, 'Doctor', 'Cardiología', 1, 0, 'Tiempo Completo');



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
VALUES ('Ensalada pollo veg', 25.5, 30.2, 10.1, 5.3, 'Ensalada de pollo con verduras: mezcla lechuga, pollo cocido, tomate, pepino, zanahoria y cebolla. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Arroz y pollo veg', 15.3, 40.5, 0.2, 8.7, 'Arroz con pollo y vegetales: cocina el arroz y saltea pollo, cebolla, pimiento y zanahoria. Mezcla todo y sirve caliente.');
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
VALUES ('Ensalada pollo man', 18.3, 33.6, 6.7, 5.4, 'Ensalada de pollo con manzana y nueces: mezcla lechuga, pollo cocido, manzana y nueces. Aliña con aceite de oliva y vinagre balsámico.');
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
VALUES ('Ensalada de pollo es',15.8, 28.4, 6.1, 0.9, 'Ensalada de pollo con espinacas y fresas: mezcla espinacas, pollo cocido, fresas y nueces. Aliña con aceite de oliva y vinagre balsámico.');
INSERT INTO Comida (nombre, cantidadProteina, cantidadCarbohidratos, cantidadGrasas, cantidadFibra, preparacion) 
VALUES ('Tacos de pescado',24.3, 31.7, 8.3, 7.5, 'Tacos de pescado con salsa de aguacate y cilantro: sazona el pescado con sal y pimienta a la parrilla. Sirve en tortillas de maíz con salsa de aguacate y cilantro.');


/*
**********************************
-- INSERTS PROCESOS ALMACENADOS
**********************************
*/

--Ingreso de datos en la tabla PlanEntrenamiento
EXEC ingresoPlanEntrenamiento 'Plan peso a', 'Alta', 'Perder peso', '2023-08-13', '2023-09-20', 'Semanal', 1, '1724399991', '1000123456'
EXEC ingresoPlanEntrenamiento 'Plan tonificar m', 'Media', 'Tonificar músculos', '2023-09-18', '2023-10-01', 'Mensual', 0, '1722485008', '0109012345'
EXEC ingresoPlanEntrenamiento 'Plan flexibilidad b', 'Baja', 'Mejorar flexibilidad', '2023-10-13', '2023-11-02', NULL, NULL, '1002858874', '1008901234'
EXEC ingresoPlanEntrenamiento 'Plan musculo a', 'Alta', 'Ganar masa muscular', '2023-11-14', '2023-12-03', 'Semanal', 1, '0911276548', '1707890123'
EXEC ingresoPlanEntrenamiento 'Plan resistencia m', 'Media', 'Mejorar resistencia', '2023-10-15', '2023-11-04', 'Mensual', 0, '1705682925', '1106789016'
EXEC ingresoPlanEntrenamiento 'Plan estrés b', 'Baja', 'Reducir estrés', '2023-09-16', '2023-10-05', NULL, NULL, '1301167859', '1105678904'
EXEC ingresoPlanEntrenamiento 'Plan velocidad a', 'Alta', 'Aumentar velocidad', '2023-08-17', '2023-09-06', 'Semanal', 1, '1721694285', '1000052132'
EXEC ingresoPlanEntrenamiento 'Plan equilibrio m', 'Media', 'Mejorar equilibrio', '2023-09-18', '2023-10-07', 'Mensual', 0, '1705862756', '1002858874'
EXEC ingresoPlanEntrenamiento 'Plan postura b', 'Baja', 'Mejorar postura', '2023-09-19', '2023-10-08', NULL, NULL, '1741643297', '1102345679'
EXEC ingresoPlanEntrenamiento 'Plan fuerza a', 'Alta', 'Aumentar fuerza', '2023-10-20', '2023-11-09', 'Semanal', 1, '0400609954', '1101234568'
EXEC ingresoPlanEntrenamiento 'Plan coordinación m', 'Media', 'Mejorar coordinación', '2023-11-21', '2023-12-10', 'Mensual', 0, '0412864712', '1100123456'
EXEC ingresoPlanEntrenamiento 'Plan agilidad b', 'Baja', 'Mejorar agilidad', '2023-10-22', '2023-11-11', NULL, NULL, '1708071024', '1109012345'
EXEC ingresoPlanEntrenamiento 'Plan cardiovascular a', 'Alta', 'Mejorar resistencia cardiovascular', '2023-09-23', '2023-10-12', 'Semanal', 1, '0913876254', '1108901234'
EXEC ingresoPlanEntrenamiento 'Plan flexibilidad m', 'Media', 'Mejorar flexibilidad muscular', '2023-08-24', '2023-09-13', 'Mensual', 0, '1209567834', '1107890123'
EXEC ingresoPlanEntrenamiento 'Plan articular b', 'Baja', 'Mejorar movilidad articular', '2023-07-25', '2023-08-14', NULL, NULL, '1203567890', '1106789012'
EXEC ingresoPlanEntrenamiento 'Plan potencia a', 'Alta', 'Mejorar potencia muscular', '2023-08-26', '2023-09-15', 'Semanal', 1, '1754446720', '1105678901'
EXEC ingresoPlanEntrenamiento 'Plan velocidad m', 'Media', 'Mejorar velocidad de reacción', '2023-09-27', '2023-10-16', 'Mensual', 0, '1303753618', '1104567890'
EXEC ingresoPlanEntrenamiento 'Plan estabulidad b', 'Baja', 'Mejorar estabilidad corporal', '2023-10-28', '2023-11-17', NULL, NULL, '1103756134', '1103456789'
EXEC ingresoPlanEntrenamiento 'Plan anaeróbica a', 'Alta', 'Mejorar capacidad anaeróbica', '2023-11-29', '2023-12-18', 'Semanal', 1, '1305267542', '1102345678'
EXEC ingresoPlanEntrenamiento 'Plan aeróbica m', 'Media', 'Mejorar capacidad aeróbica', '2023-10-30', '2023-11-19', 'Mensual', 0, '1200984761', '1101234567'


--Ingreso de datos en la tabla Rutina
EXEC ingresoRutina 'Flexiones', 'Ejercicio de fuerza para pecho y brazos', 'Pecho', 5, 12.0, 3, 'Lunes', 50.0, 'Plan peso a'
EXEC ingresoRutina 'Sentadillas', 'Ejercicio de fuerza para piernas', 'Piernas', 6, 22.0, 4, 'Martes', 70.0, 'Plan peso a'
EXEC ingresoRutina 'Abdominales', 'Ejercicio de fuerza para abdomen', 'Abdomen', 7, 11.0, 3, 'Miercoles', 40.0, 'Plan peso a'
EXEC ingresoRutina 'Press de hombros', 'Ejercicio de fuerza para hombros', 'Hombros', 4, 12.5, 3, 'Jueves', 60.0, 'Plan peso a'
EXEC ingresoRutina 'Remo con mancuernas', 'Ejercicio de fuerza para espalda', 'Espalda', 5, 22.0, 4, 'Viernes', 80.0, 'Plan peso a'
EXEC ingresoRutina 'Curl de biceps', 'Ejercicio de fuerza biceps', 'Biceps', 6, 21.5, 3, 'Sabado', 45.0, 'Plan tonificar m'
EXEC ingresoRutina 'Prensa de piernas', 'Ejercicio de fuerza para piernas', 'Piernas', 2, 12.0, 4, 'Lunes', 70.0, 'Plan tonificar m'
EXEC ingresoRutina 'Plancha', 'Ejercicio de fuerza para abdomen', 'Abdomen', 7, 21.0, 3, 'Martes', 50.0, 'Plan tonificar m'
EXEC ingresoRutina 'Fondos en paralelas', 'Ejercicio de fuerza para triceps', 'Triceps', 6, 12.5, 3, 'Miercoles', 60.0, 'Plan tonificar m'
EXEC ingresoRutina 'Dominadas', 'Ejercicio de fuerza para espalda', 'Espalda', 5, 12.0, 4, 'Jueves', 80.0, 'Plan tonificar m'
EXEC ingresoRutina 'Press de banca', 'Ejercicio de fuerza para pecho', 'Pecho', 6, 11.5, 3, 'Viernes', 55.0, 'Plan musculo a'
EXEC ingresoRutina 'Curl de martillo', 'Ejercicio de fuerza para biceps', 'Biceps', 8, 11.5, 3, 'Sabado', 40.0, 'Plan musculo a'
EXEC ingresoRutina 'Zancadas', 'Ejercicio de fuerza para piernas', 'Piernas', 4, 12.0, 4, 'Lunes', 75.0, 'Plan musculo a'
EXEC ingresoRutina 'Abdominales oblic', 'Ejercicio de fuerza para abdomen', 'Abdomen', 2, 11.0, 3, 'Martes', 60.0, 'Plan musculo a'
EXEC ingresoRutina 'Extensiones de triceps', 'Ejercicio de fuerza para triceps', 'Triceps', 3, 12.5, 3, 'Miercoles', 70.0, 'Plan musculo a'
EXEC ingresoRutina 'Peso muerto', 'Ejercicio de fuerza para espalda y piernas', 'Espalda', 8, 12.0, 4, 'Jueves', 90.0, 'Plan estrés b'
EXEC ingresoRutina 'Flexiones diamante', 'Ejercicio de fuerza para triceps', 'Triceps', 6, 11.5, 3, 'Viernes', 50.0, 'Plan estrés b'
EXEC ingresoRutina 'Curl de concentración', 'Ejercicio de fuerza para biceps', 'Biceps', 7, 11.5, 3, 'Sabado', 45., 'Plan estrés b'

--Ingreso de datos en la tabla cita Cliente
EXEC ingresoCitaCliente 'Cita 1', '2023-08-15 10:00:00', 'Cita médica', 'Consulta general', 1, '2023-05-15 11:00:00', '1724399991', '1104567908';
EXEC ingresoCitaCliente 'Cita 2', '2023-08-16 14:30:00', 'Cita nutricionista', 'Plan de alimentación', 0, '2023-05-16 15:30:00', '1722485008', '1104567907';
EXEC ingresoCitaCliente 'Cita 3', '2023-08-17 11:00:00', 'Cita médica', 'Control de presión arterial', 1, '2023-05-17 12:00:00', '1002858874', '1104567906';
EXEC ingresoCitaCliente 'Cita 4', '2023-08-18 09:30:00', 'Cita médica', 'Control de diabetes', 1, '2023-05-18 10:30:00', '0911276548', '1104567905';
EXEC ingresoCitaCliente 'Cita 5', '2023-08-19 15:00:00', 'Cita nutricionista', 'Plan de alimentación', 0, '2023-05-19 16:00:00', '1705682925', '1104567904';
EXEC ingresoCitaCliente 'Cita 6', '2023-08-20 11:30:00', 'Cita médica', 'Consulta general', 1, '2023-05-20 12:30:00', '1301167859', '1104567903';
EXEC ingresoCitaCliente 'Cita 7', '2023-08-21 10:00:00', 'Cita médica', 'Control de presión arterial', 1, '2023-05-21 11:00:00', '1721694285', '1104567902';
EXEC ingresoCitaCliente 'Cita 8', '2023-08-22 14:00:00', 'Cita nutricionista', 'Plan de alimentación', 0, '2023-05-22 15:00:00', '1705862756', '1104567901';
EXEC ingresoCitaCliente 'Cita 9', '2023-08-23 16:30:00', 'Cita médica', 'Control de diabetes', 1, '2023-05-23 17:30:00', '1741643297', '1104567900';
EXEC ingresoCitaCliente 'Cita 10', '2023-08-24 12:00:00', 'Cita médica', 'Consulta general', 1, '2023-05-24 13:00:00', '0400609954', '1104567899';

--Ingreso de datos en la tabla cita Entrenador
EXEC ingresoCitaEntrenador 'Cita 11', '2023-08-12 10:00:00', 'Cita médica', 'Consulta general', 1, '2023-09-12 10:30:00', '1101234567', '1104567898'
EXEC ingresoCitaEntrenador 'Cita 12', '2023-08-13 14:00:00', 'Cita nutricionista', 'Plan de alimentación', 0, '2023-09-13 14:30:00', '1102345678', '1002858866'
EXEC ingresoCitaEntrenador 'Cita 13', '2023-08-14 11:00:00', 'Cita médica', 'Control de presión arterial', 1, '2023-09-14 11:30:00', '1103456789', '1104567896'
EXEC ingresoCitaEntrenador 'Cita 14', '2023-08-15 15:00:00', 'Cita nutricionista', 'Evaluación de hábitos alimenticios', 1, '2023-09-15 15:30:00', '1104567890', '1004567895'
EXEC ingresoCitaEntrenador 'Cita 15', '2023-08-16 12:00:00', 'Cita médica', 'Control de glucemia', 0, '2023-09-16 12:30:00', '1105678901', '1004567894'
EXEC ingresoCitaEntrenador 'Cita 16', '2023-08-17 16:00:00', 'Cita nutricionista', 'Plan de alimentación', 1, '2023-09-17 16:30:00', '1106789012', '1704567893'
EXEC ingresoCitaEntrenador 'Cita 17', '2023-08-18 13:00:00', 'Cita médica', 'Control de presión arterial', 0, '2023-10-18 13:30:00', '1107890123', '1104567892'
EXEC ingresoCitaEntrenador 'Cita 18', '2023-08-19 17:00:00', 'Cita nutricionista', 'Evaluación de hábitos alimenticios', 1, '2023-08-19 17:30:00', '1108901234', '1104567891'
EXEC ingresoCitaEntrenador 'Cita 19', '2023-08-20 14:00:00', 'Cita médica', 'Control de glucemia', 1, '2023-09-20 14:30:00', '1109012345', '1104567890'



--Ingreso de datos en la tabla RegistroMedico
EXEC ingresoRegistroMedico 'Registro1' ,'O+', 'Excelente', 70.5, 1.75, 20.5, NULL, NULL, 'Mesomorfo', NULL, NULL, 'Perder peso', 'Cita 1'
EXEC ingresoRegistroMedico 'Registro2' ,'A-', 'Bueno', 65.2, 1.68, 18.2, NULL, NULL, 'Endomorfo', NULL, NULL, 'Ganar masa muscular', 'Cita 2'
EXEC ingresoRegistroMedico 'Registro3' ,'B+', 'Crítico', 80.0, 1.80, 25.0, 'Fractura de tobillo', 'Diabetes tipo 2', 'Hectomorfo', 'Cirugía de apéndice', 'Polen', 'Mejorar condición física','Cita 3'
EXEC ingresoRegistroMedico 'Registro4' ,'AB-', 'Bueno', 62.0, 1.60, 22.0, NULL, NULL, 'Endomorfo', NULL, NULL, 'Tonificar músculos', 'Cita 4'
EXEC ingresoRegistroMedico 'Registro5' ,'O-', 'Excelente', 75.0, 1.85, 18.5, NULL, NULL, 'Mesomorfo', NULL, NULL, 'Aumentar resistencia', 'Cita 5'
EXEC ingresoRegistroMedico 'Registro6' ,'A+', 'Crítico', 90.0, 1.90, 30.0, 'Esguince de rodilla', 'Hipertensión', 'Endomorfo', 'Cirugía de hernia', 'Lactosa', 'Reducir estrés', 'Cita 6'
EXEC ingresoRegistroMedico 'Registro7' ,'B-', 'Bueno', 70.0, 1.70, 20.0, NULL, NULL, 'Hectomorfo', NULL, NULL, 'Mejorar flexibilidad', 'Cita 7'
EXEC ingresoRegistroMedico 'Registro8' ,'AB+', 'Excelente', 80.0, 1.80, 25.0, NULL, NULL, 'Mesomorfo', NULL, NULL, 'Aumentar masa muscular', 'Cita 8'
EXEC ingresoRegistroMedico 'Registro9' ,'O+', 'Bueno', 65.0, 1.70, 22.0, 'Tendinitis', NULL, 'Endomorfo', NULL, NULL, 'Mejorar postura', 'Cita 9'
EXEC ingresoRegistroMedico 'Registro10' ,'A-', 'Crítico', 75.0, 1.75, 28.0, 'Fractura de clavícula', 'Asma', 'Hectomorfo', 'Cirugía de nariz', 'Polvo', 'Reducir ansiedad', 'Cita 10'
EXEC ingresoRegistroMedico 'Registro11' ,'B+', 'Excelente', 85.0, 1.85, 23.0, NULL, NULL, 'Mesomorfo', NULL, NULL, 'Aumentar fuerza', 'Cita 11'
EXEC ingresoRegistroMedico 'Registro12' ,'AB-', 'Bueno', 70.0, 1.70, 20.0, NULL, NULL, 'Endomorfo', NULL, NULL, 'Mejorar equilibrio', 'Cita 12'
EXEC ingresoRegistroMedico 'Registro13' ,'O-', 'Crítico', 95.0, 1.95, 35.0, 'Lesión de menisco', 'Artritis', 'Hectomorfo', 'Cirugía de vesícula', 'Gluten', 'Reducir colesterol', 'Cita 13'
EXEC ingresoRegistroMedico 'Registro14' ,'A+', 'Bueno', 60.0, 1.60, 18.0, NULL, NULL, 'Mesomorfo', NULL, NULL, 'Aumentar resistencia', 'Cita 14'
EXEC ingresoRegistroMedico 'Registro15' ,'B-', 'Excelente', 75.0, 1.75, 22.0, NULL, NULL, 'Endomorfo', NULL, NULL, 'Mejorar coordinación', 'Cita 15'
EXEC ingresoRegistroMedico 'Registro16' ,'AB+', 'Crítico', 100.0, 2.00, 40.0, 'Fractura de muñeca', 'Diabetes tipo 1', 'Hectomorfo', 'Cirugía de cadera', 'Lactosa', 'Reducir estrés', 'Cita 16'
EXEC ingresoRegistroMedico 'Registro17' ,'O+', 'Bueno', 70.0, 1.70, 20.0, NULL, NULL, 'Mesomorfo', NULL, NULL, 'Mejorar flexibilidad', 'Cita 17'
EXEC ingresoRegistroMedico 'Registro18' ,'A-', 'Excelente', 80.0, 1.80, 25.0, NULL, NULL, 'Endomorfo', NULL, NULL, 'Aumentar masa muscular', 'Cita 18'
EXEC ingresoRegistroMedico 'Registro19' ,'B+', 'Bueno', 65.0, 1.65, 20.0, NULL, NULL, 'Hectomorfo', NULL, NULL, 'Mejorar postura', 'Cita 19'

--Ingreso de datos en la tabla IngredienteComida
EXEC ingresoIngredienteComida 100, 'gramos', 'Arroz y pollo veg', 'Tomate';
EXEC ingresoIngredienteComida 200, 'gramos', 'Arroz y pollo veg', 'Pollo';
EXEC ingresoIngredienteComida 50, 'gramos', 'Arroz y pollo veg', 'Espárragos';
EXEC ingresoIngredienteComida 50, 'gramos', 'Arroz y pollo veg', 'Pimiento';
EXEC ingresoIngredienteComida 100, 'gramos', 'Ensalada pollo veg', 'Cebolla';
EXEC ingresoIngredienteComida 50, 'gramos', 'Ensalada pollo veg', 'Pollo';
EXEC ingresoIngredienteComida 50, 'gramos', 'Ensalada pollo veg', 'Garbanzos';
EXEC ingresoIngredienteComida 20, 'gramos', 'Ensalada pollo veg', 'Nueces';
EXEC ingresoIngredienteComida 100, 'gramos', 'Pollo al horno', 'Pollo';
EXEC ingresoIngredienteComida 50, 'gramos', 'Pollo al horno', 'Zanahoria';
EXEC ingresoIngredienteComida 50, 'gramos', 'Pollo al horno', 'Cebolla';
EXEC ingresoIngredienteComida 50, 'gramos', 'Pollo al horno', 'Tomate';
EXEC ingresoIngredienteComida 100, 'gramos', 'Pollo al horno', 'Lentejas';
EXEC ingresoIngredienteComida 50, 'gramos', 'Pasta con salsa po', 'Pollo';
EXEC ingresoIngredienteComida 20, 'gramos', 'Pasta con salsa po', 'Tomate';
EXEC ingresoIngredienteComida 50, 'gramos', 'Pasta con salsa po', 'Cebolla';
EXEC ingresoIngredienteComida 100, 'gramos', 'Hamburguesa', 'Tomate';
EXEC ingresoIngredienteComida 50, 'gramos', 'Hamburguesa', 'Huevo';
EXEC ingresoIngredienteComida 20, 'gramos', 'Hamburguesa', 'Pimiento';
EXEC ingresoIngredienteComida 50, 'gramos', 'Hamburguesa', 'Pollo';




--Ingreso de datos en la tabla ReporteIncidente
EXEC ingresoReporteIncidente 'Un cliente resbala en una máquina de cardio y cae al suelo', '1000123456', '1104567908', '1724399991'
EXEC ingresoReporteIncidente 'Un proyector de techo se desprende y cae durante una clase de yoga', '1008901234', '1104567906', '1002858874'
EXEC ingresoReporteIncidente 'Se desata una pelea entre dos clientes por el uso de una máquina', '1707890123', '1104567904', '1705682925'
EXEC ingresoReporteIncidente 'Una clase intensa provoca que un participante se deshidrate', '1105678904', '1104567902', '1721694285'
EXEC ingresoReporteIncidente 'Un ciclista se resbala y cae en una bicicleta estática durante una clase', '1102345679', '1104567900', '1741643297'
EXEC ingresoReporteIncidente 'Un cliente se hace una lesión en la muñeca al realizar una flexión de forma incorrecta', '1100123456', '1104567898', '0412864712'
EXEC ingresoReporteIncidente 'Un cliente se queja de mareos y falta de aire durante una sesión de entrenamiento intensoe 13', '1108901234', '1104567896', '0913876254'
EXEC ingresoReporteIncidente 'Un cliente se rompe un tendón al levantar mucho peso', '1107890123', '1004567894', '1209567834'

--Ingreso de datos en la tabla PlanNutricional
EXEC ingresoPlanNutricional 'Registro1', 'Plan1', 3, 'Comer más proteínas y menos carbohidratos', 'Nueces, mariscos', '2023-07-14', '2023-08-14';
EXEC ingresoPlanNutricional 'Registro2', 'Plan2', 4, 'Comer más frutas y verduras', 'Lácteos', '2023-08-15', '2023-09-15';
EXEC ingresoPlanNutricional 'Registro3', 'Plan3', 2, 'Reducir el consumo de azúcar', 'Gluten', '2023-09-16', '2023-10-16';
EXEC ingresoPlanNutricional 'Registro4', 'Plan4', 5, 'Aumentar la ingesta de fibra', 'Huevos', '2023-10-17', '2023-11-17';
EXEC ingresoPlanNutricional 'Registro5', 'Plan5', 3, 'Beber más agua', 'Soja', '2023-11-18', '2023-12-18';
EXEC ingresoPlanNutricional 'Registro6', 'Plan6', 4, 'Evitar alimentos procesados', 'Cacahuetes', '2023-10-19', '2023-11-19';
EXEC ingresoPlanNutricional 'Registro7', 'Plan7', 2, 'Comer menos grasas saturadas', 'Pescado', '2023-09-20', '2023-10-20';
EXEC ingresoPlanNutricional 'Registro8', 'Plan8', 5, 'Incluir más alimentos ricos en omega-3', 'Trigo', '2023-08-21', '2023-09-21';
EXEC ingresoPlanNutricional 'Registro9', 'Plan9', 3, 'Reducir el consumo de sal', 'Frutos secos', '2023-07-22', '2023-08-22';
EXEC ingresoPlanNutricional 'Registro10', 'Plan10', 4, 'Aumentar la ingesta de calcio', 'Lácteos', '2023-08-23', '2023-09-23';
EXEC ingresoPlanNutricional 'Registro11', 'Plan11', 2, 'Comer más alimentos ricos en hierro', 'Mariscos', '2023-09-24', '2023-10-24';
EXEC ingresoPlanNutricional 'Registro12', 'Plan12', 5, 'Incluir más alimentos ricos en vitamina C', 'Cítricos', '2023-10-25', '2023-11-25';
EXEC ingresoPlanNutricional 'Registro13', 'Plan13', 3, 'Aumentar la ingesta de proteínas magras', 'Carne roja', '2023-11-26', '2023-12-26';
EXEC ingresoPlanNutricional 'Registro14', 'Plan14', 4, 'Comer más alimentos ricos en antioxidantes', 'Bayas', '2023-09-27', '2023-10-27';
EXEC ingresoPlanNutricional 'Registro15', 'Plan15', 2, 'Reducir el consumo de bebidas azucaradas', 'Ninguna', '2023-08-28', '2023-09-28';
EXEC ingresoPlanNutricional 'Registro16', 'Plan16', 5, 'Incluir más alimentos ricos en potasio', 'Plátanos', '2023-07-29', '2023-08-29';
EXEC ingresoPlanNutricional 'Registro17', 'Plan17', 3, 'Aumentar la ingesta de alimentos ricos en vitamina D', 'Pescado', '2023-08-30', '2023-09-30';
EXEC ingresoPlanNutricional 'Registro18', 'Plan18', 4, 'Comer más alimentos ricos en vitamina B12', 'Huevos', '2023-09-12', '2023-10-12';
EXEC ingresoPlanNutricional 'Registro19', 'Plan19', 2, 'Incluir más alimentos ricos en zinc', 'Ostras', '2023-10-01', '2023-11-01';

--Ingreso de datos en la tabla Menu
EXEC ingresoMenu 'Menu1', 'Ensalada pollo veg', 'Plan1', 'Dia', 'Informacion adicional 1', 500.0;
EXEC ingresoMenu 'Menu2', 'Arroz y pollo veg', 'Plan1', 'Medio dia', 'Informacion adicional 2', 600.0;
EXEC ingresoMenu 'Menu3', 'Salmón a la parrilla', 'Plan1', 'Tarde', 'Informacion adicional 3', 450.0;
EXEC ingresoMenu 'Menu4', 'Hamburguesa', 'Plan1', 'tarde', 'Informacion adicional 4', 550.0;
EXEC ingresoMenu 'Menu5', 'Pollo al curry', 'Plan1', 'Noche', 'Informacion adicional 5', 700.0;
EXEC ingresoMenu 'Menu6', 'Ensalada de atún ag', 'Plan2', 'Dia', 'Informacion adicional 6', 520.0;
EXEC ingresoMenu 'Menu7', 'Pasta con salsa to', 'Plan2', 'Medio dia', 'Informacion adicional 7', 610.0;
EXEC ingresoMenu 'Menu8', 'Pollo a la plancha', 'Plan2', 'Tarde', 'Informacion adicional 8', 460.0;
EXEC ingresoMenu 'Menu9', 'Ensalada de salmón', 'Plan2', 'tarde', 'Informacion adicional 9', 560.0;
EXEC ingresoMenu 'Menu10', 'Arroz con lentejas', 'Plan2', 'Noche', 'Informacion adicional 10', 710.0;
EXEC ingresoMenu 'Menu11', 'Ensalada pollo man', 'Plan3', 'Dia', 'Informacion adicional 11', 530.0;
EXEC ingresoMenu 'Menu12', 'Salmón al horno', 'Plan3', 'Medio dia', 'Informacion adicional 12', 620.0;
EXEC ingresoMenu 'Menu13', 'Ensalada de pollo ag', 'Plan3', 'Tarde', 'Informacion adicional 13', 470.0;
EXEC ingresoMenu 'Menu14', 'Pasta con salsa po', 'Plan3', 'tarde', 'Informacion adicional 14', 570.0;
EXEC ingresoMenu 'Menu15', 'Pollo al horno', 'Plan3', 'Noche', 'Informacion adicional 15', 720.0;
EXEC ingresoMenu 'Menu16', 'Ensalada de atun y h', 'Plan4', 'Dia', 'Informacion adicional 16', 540.0;
EXEC ingresoMenu 'Menu17', 'Arroz con pollo', 'Plan4', 'Medio dia', 'Informacion adicional 17', 630.0;
EXEC ingresoMenu 'Menu18', 'Ensalada de pollo es', 'Plan4', 'Tarde', 'Informacion adicional 18', 480.0;
EXEC ingresoMenu 'Menu19', 'Tacos de pescado', 'Plan4', 'tarde', 'Informacion adicional 19', 580.0;


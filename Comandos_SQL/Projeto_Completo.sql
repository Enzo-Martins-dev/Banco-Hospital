ALTER TABLE Usuario DROP CONSTRAINT IF EXISTS Check_Person;
ALTER TABLE Servicos DROP CONSTRAINT IF EXISTS Servico_Existe;

DROP TABLE IF EXISTS Estoque CASCADE;
DROP TABLE IF EXISTS Materiais_Hospitalares CASCADE;
DROP TABLE IF EXISTS Enfermeiros_Cirurgia CASCADE;
DROP TABLE IF EXISTS Cirurgias CASCADE;
DROP TABLE IF EXISTS Medicamentos CASCADE;
DROP TABLE IF EXISTS Plantoes CASCADE;
DROP TABLE IF EXISTS Internacoes CASCADE;
DROP TABLE IF EXISTS Consultas CASCADE;
DROP TABLE IF EXISTS Servicos CASCADE;
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Setores CASCADE;
DROP TABLE IF EXISTS Pessoa CASCADE;
DROP TABLE IF EXISTS Medicamentos_Cirurgias CASCADE;

DROP SEQUENCE IF EXISTS seq_id_pessoa CASCADE;
DROP SEQUENCE IF EXISTS seq_id_setor CASCADE;
DROP SEQUENCE IF EXISTS seq_id_usuario CASCADE;
DROP SEQUENCE IF EXISTS seq_id_consulta CASCADE;
DROP SEQUENCE IF EXISTS seq_id_cirurgia CASCADE;
DROP SEQUENCE IF EXISTS seq_id_enfermeiro_cirurgia CASCADE;
DROP SEQUENCE IF EXISTS seq_id_internacao CASCADE;
DROP SEQUENCE IF EXISTS seq_id_plantao CASCADE;
DROP SEQUENCE IF EXISTS seq_id_servico CASCADE;
DROP SEQUENCE IF EXISTS seq_id_medicamento CASCADE;
DROP SEQUENCE IF EXISTS seq_id_material_hospitalar CASCADE;
DROP SEQUENCE IF EXISTS seq_id_historico CASCADE;

CREATE SEQUENCE seq_id_pessoa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_setor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_consulta START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_cirurgia START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_enfermeiro_cirurgia START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_internacao START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_plantao START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_servico START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_medicamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_material_hospitalar START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_historico START WITH 1 INCREMENT BY 1;

ALTER SEQUENCE seq_id_pessoa RESTART WITH 1; 
ALTER SEQUENCE seq_id_setor RESTART WITH 1; 
ALTER SEQUENCE seq_id_usuario RESTART WITH 1; 
ALTER SEQUENCE seq_id_consulta RESTART WITH 1; 
ALTER SEQUENCE seq_id_cirurgia RESTART WITH 1; 
ALTER SEQUENCE seq_id_enfermeiro_cirurgia RESTART WITH 1; 
ALTER SEQUENCE seq_id_internacao RESTART WITH 1; 
ALTER SEQUENCE seq_id_plantao RESTART WITH 1; 
ALTER SEQUENCE seq_id_servico RESTART WITH 1; 
ALTER SEQUENCE seq_id_medicamento RESTART WITH 1; 
ALTER SEQUENCE seq_id_material_hospitalar RESTART WITH 1;

CREATE TABLE Pessoa (
  ID_Pessoa int PRIMARY KEY DEFAULT nextval('seq_id_pessoa'),
  nome varchar NOT NULL,
  sexo char NOT NULL,
  data_nascimento DATE
);

CREATE TABLE Setores (
  ID_Setor int PRIMARY KEY DEFAULT nextval('seq_id_setor'),
  Nome_Setor varchar NOT NULL
);

CREATE TABLE Usuario (
  ID_Usuario int PRIMARY KEY DEFAULT nextval('seq_id_usuario'),
  Nome_Usuario varchar NOT NULL,
  ID_Pessoa int NOT NULL,
  Tipo_Usuario varchar NOT NULL,
  Especialidade varchar,
  Permissao_Cirurgia bool,
  ID_Setor int,
  FOREIGN KEY (ID_Setor) REFERENCES Setores(ID_Setor),
  CONSTRAINT Check_Person CHECK (Tipo_Usuario = 'Administrador' OR Tipo_Usuario = 'Medico' OR Tipo_Usuario = 'Enfermeiro'),
  FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa(ID_Pessoa)
);

CREATE TABLE Servicos (
  ID_Servico int PRIMARY KEY DEFAULT nextval('seq_id_servico'),
  Tipo_Servico varchar NOT NULL,
  ID_Pessoa_Paciente int,
  ID_Usuario_Medico int,
  Data_Inicio DATE NOT NULL,
  Hora_Inicio TIME NOT NULL,
  Hora_Fim TIME,
  CONSTRAINT Servico_Existe CHECK (Tipo_Servico IN ('Consulta', 'Cirurgia', 'Internacao', 'Plantao')),
  FOREIGN KEY (ID_Pessoa_Paciente) REFERENCES Pessoa(ID_Pessoa),
  FOREIGN KEY (ID_Usuario_Medico) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE Consultas (
  ID_Consulta int PRIMARY KEY DEFAULT nextval('seq_id_consulta'),
  ID_Pessoa_Paciente int NOT NULL,
  ID_Usuario_Medico int NOT NULL,
  Data_Consulta DATE NOT NULL,
  Hora_Inicio TIME NOT NULL,
  Hora_Fim TIME,
  Descricao_Consulta varchar,
  FOREIGN KEY (ID_Pessoa_Paciente) REFERENCES Pessoa(ID_Pessoa),
  FOREIGN KEY (ID_Usuario_Medico) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE Internacoes (
  ID_Internacao int PRIMARY KEY DEFAULT nextval('seq_id_internacao'),
  ID_Pessoa_Paciente int NOT NULL,
  Data_Internacao DATE NOT NULL,
  Data_Internacao_Fim DATE NOT NULL,
  Ala_Internacao varchar NOT NULL,
  FOREIGN KEY (ID_Pessoa_Paciente) REFERENCES Pessoa(ID_Pessoa)
);

CREATE TABLE Plantoes (
  ID_Plantao int PRIMARY KEY DEFAULT nextval('seq_id_plantao'),
  ID_Usuario_Medico int,
  ID_Usuario_Enfermeiro int,
  Data_Plantao DATE NOT NULL,
  Hora_Inicio TIME NOT NULL,
  Hora_Fim TIME NOT NULL,
  FOREIGN KEY (ID_Usuario_Medico) REFERENCES Usuario(ID_Usuario),
  FOREIGN KEY (ID_Usuario_Enfermeiro) REFERENCES Usuario(ID_Usuario),
  CHECK (ID_Usuario_Medico IS NOT NULL OR ID_Usuario_Enfermeiro IS NOT NULL)
);

CREATE TABLE Cirurgias (
  ID_Cirurgia int PRIMARY KEY DEFAULT nextval('seq_id_cirurgia'),
  ID_Pessoa_Paciente int NOT NULL,
  ID_Usuario_Medico int NOT NULL,
  Data_Cirurgia DATE NOT NULL,
  Hora_Inicio TIME NOT NULL,
  Hora_Fim TIME,
  Descricao_Cirurgia varchar,
  FOREIGN KEY (ID_Pessoa_Paciente) REFERENCES Pessoa(ID_Pessoa),
  FOREIGN KEY (ID_Usuario_Medico) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE Medicamentos (
    ID_Medicamento SERIAL PRIMARY KEY,
    Nome_Medicamento VARCHAR(255) NOT NULL,
    Descricao TEXT NOT NULL, 
    Dosagem VARCHAR(50) NOT NULL,
    Laboratorio VARCHAR(255) NOT NULL,
    Tipo_Medicamento VARCHAR(100) NOT NULL
);

CREATE TABLE Medicamentos_Cirurgias (
	ID_Cirurgia int,
	ID_Medicamento int,
	foreign key (ID_Cirurgia) references Cirurgias(ID_Cirurgia),
	foreign key (ID_Medicamento) references Medicamentos(ID_Medicamento)
);

CREATE TABLE Enfermeiros_Cirurgia (
  ID_Cirurgia int NOT NULL,
  ID_Usuario_Enfermeiro int NOT NULL,
  FOREIGN KEY (ID_Cirurgia) REFERENCES Cirurgias(ID_Cirurgia),
  FOREIGN KEY (ID_Usuario_Enfermeiro) REFERENCES Usuario(ID_Usuario)
);

CREATE TABLE Materiais_Hospitalares (
  ID_Material int PRIMARY KEY DEFAULT nextval('seq_id_material_hospitalar'),
  Nome_Material varchar NOT NULL,
  Quantidade_Estoque int NOT NULL,
  Descricao varchar
);

CREATE TABLE Estoque (
    ID_Estoque SERIAL PRIMARY KEY,
    ID_Medicamento INT REFERENCES Medicamentos(ID_Medicamento) ON DELETE CASCADE,
    ID_Material INT REFERENCES Materiais_Hospitalares(ID_Material) ON DELETE CASCADE,
    Quantidade_Estoque INT NOT NULL,
	Data_Fabricacao DATE NOT NULL,
    Data_Validade DATE NOT NULL
);

INSERT INTO Pessoa (nome, sexo, data_nascimento) VALUES 
('João Silva', 'M', '1990-05-15'),
('Maria Oliveira', 'F', '1985-08-20'),
('Carlos Pereira', 'M', '1978-02-10'),
('Ana Souza', 'F', '1992-12-25'),
('Felipe Gomes', 'M', '1988-03-12'),
('Patrícia Lima', 'F', '1993-11-30'),
('Eduardo Alves', 'M', '1975-06-18'),
('Juliana Martins', 'F', '1980-01-05'),
('Roberto Santos', 'M', '1969-09-22'),
('Fernanda Costa', 'F', '1995-02-07'),
('Thiago Rocha', 'M', '1987-04-14'),
('Cláudia Ferreira', 'F', '1991-07-01'),
('Marcos Silva', 'M', '1983-10-28'),
('Juliana Almeida', 'F', '1994-08-13'),
('Gustavo Ramos', 'M', '1986-12-16'),
('Lúcia Oliveira', 'F', '1990-03-22'),
('André Nascimento', 'M', '1981-11-19'),
('Simone Ribeiro', 'F', '1984-05-27'),
('Rafael Lima', 'M', '1989-09-10'),
('Sofia Martins', 'F', '1992-02-25');

INSERT INTO Setores (Nome_Setor) VALUES 
('Emergência'),
('UTI'),
('Cirurgia Geral'),
('Pediatria'),
('Cardiologia'),
('Neurologia'),
('Ortopedia'),
('Dermatologia'),
('Ginecologia'),
('Pneumologia'),
('Oncologia'),
('Gastroenterologia'),
('Oftalmologia'),
('Endocrinologia'),
('Reumatologia'),
('Psicologia'),
('Fisioterapia'),
('Nutrição'),
('Anestesiologia'),
('Radiologia');

INSERT INTO Usuario (Nome_Usuario, ID_Pessoa, Tipo_Usuario, Especialidade, Permissao_Cirurgia, ID_Setor) VALUES 
('Dr. Paulo', 1, 'Medico', 'Cirurgião', TRUE, 3),
('Enf. Ana', 4, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Rita', 2, 'Medico', 'Pediatra', TRUE, 4),
('Adm. Carla', 3, 'Administrador', NULL, FALSE, NULL),
('Dr. Roberto', 5, 'Medico', 'Cardiologista', TRUE, 5),
('Enf. Fernanda', 6, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Gustavo', 7, 'Medico', 'Neurologista', TRUE, 6),
('Enf. Juliana', 8, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Marcos', 9, 'Medico', 'Ortopedista', TRUE, 7),
('Enf. Lúcia', 10, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Thiago', 11, 'Medico', 'Dermatologista', TRUE, 8),
('Enf. Simone', 12, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Felipe', 13, 'Medico', 'Ginecologista', TRUE, 9),
('Enf. André', 14, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Cláudia', 15, 'Medico', 'Pneumologista', TRUE, 10),
('Enf. Patrícia', 16, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Sofia', 17, 'Medico', 'Oncologista', TRUE, 11),
('Enf. Gustavo', 18, 'Enfermeiro', NULL, FALSE, 1),
('Dr. Rafael', 19, 'Medico', 'Gastroenterologista', TRUE, 12),
('Enf. Mariana', 20, 'Enfermeiro', NULL, FALSE, 1);

INSERT INTO Consultas (ID_Pessoa_Paciente, ID_Usuario_Medico, Data_Consulta, Hora_Inicio, Hora_Fim, Descricao_Consulta) VALUES 
(1, 1, '2024-10-01', '08:00', '09:00', 'Consulta de rotina'),
(2, 3, '2024-10-02', '14:00', '15:00', 'Consulta pediátrica'),
(4, 1, '2024-10-03', '10:00', '11:00', 'Avaliação de saúde geral'),
(5, 2, '2024-10-04', '11:00', '12:00', 'Consulta de seguimento'),
(6, 3, '2024-10-05', '09:30', '10:30', 'Avaliação neurológica'),
(7, 4, '2024-10-06', '15:00', '16:00', 'Consulta ginecológica'),
(8, 1, '2024-10-07', '13:00', '14:00', 'Consulta dermatológica'),
(9, 3, '2024-10-08', '08:00', '09:00', 'Avaliação cardiovascular'),
(10, 4, '2024-10-09', '10:00', '11:00', 'Consulta ortopédica'),
(11, 5, '2024-10-10', '09:00', '10:00', 'Consulta de retorno'),
(12, 1, '2024-10-11', '14:00', '15:00', 'Avaliação pediátrica'),
(13, 3, '2024-10-12', '08:30', '09:30', 'Consulta de rotina'),
(14, 2, '2024-10-13', '15:30', '16:30', 'Consulta psicológica'),
(15, 4, '2024-10-14', '11:00', '12:00', 'Avaliação gastroenterológica'),
(16, 5, '2024-10-15', '09:00', '10:00', 'Consulta de seguimento'),
(17, 3, '2024-10-16', '14:00', '15:00', 'Consulta de rotina'),
(18, 1, '2024-10-17', '10:00', '11:00', 'Avaliação ortopédica'),
(19, 2, '2024-10-18', '13:00', '14:00', 'Consulta cardiológica'),
(20, 4, '2024-10-19', '08:00', '09:00', 'Consulta de retorno'),
(14, 5, '2022-10-10', '09:00', '10:00', 'Consulta de retorno');

INSERT INTO Medicamentos (Nome_Medicamento, Descricao, Dosagem, Laboratorio, Tipo_Medicamento) VALUES 
('Paracetamol', 'Analgésico e antipirético', '500mg', 'Laboratório A', 'Comprimido'),
('Amoxicilina', 'Antibiótico', '250mg', 'Laboratório B', 'Cápsula'),
('Ibuprofeno', 'Anti-inflamatório', '400mg', 'Laboratório C', 'Comprimido'),
('Propofol', 'Anestésico', '1,5mg', 'Laboratório D', 'Injeção'),
('Simvastatina', 'Anticolesterol', '20mg', 'Laboratório E', 'Comprimido'),
('Loratadina', 'Antialérgico', '10mg', 'Laboratório F', 'Comprimido'),
('Omeprazol', 'Inibidor de bomba de prótons', '20mg', 'Laboratório G', 'Comprimido'),
('Furosemida', 'Diurético', '40mg', 'Laboratório H', 'Comprimido'),
('Losartana', 'Antihipertensivo', '50mg', 'Laboratório I', 'Comprimido'),
('AAS', 'Antiplaquetário', '100mg', 'Laboratório J', 'Comprimido'),
('Captopril', 'Antihipertensivo', '25mg', 'Laboratório K', 'Comprimido'),
('Levotiroxina', 'Hormônio tireoidiano', '50mcg', 'Laboratório L', 'Comprimido'),
('Alprazolam', 'Ansiolítico', '1mg', 'Laboratório M', 'Comprimido'),
('Diazepam', 'Ansiolítico', '10mg', 'Laboratório N', 'Comprimido'),
('Amiodarona', 'Antiarrítmico', '200mg', 'Laboratório O', 'Comprimido'),
('Clopidogrel', 'Antiplaquetário', '75mg', 'Laboratório P', 'Comprimido'),
('Atorvastatina', 'Anticolesterol', '40mg', 'Laboratório Q', 'Comprimido'),
('Amlodipino', 'Antihipertensivo', '5mg', 'Laboratório R', 'Comprimido'),
('Bromoprida', 'Antiemético', '10mg', 'Laboratório S', 'Comprimido'),
('Sertralina', 'Antidepressivo', '50mg', 'Laboratório T', 'Comprimido');


INSERT INTO Cirurgias (ID_Pessoa_Paciente, ID_Usuario_Medico, Data_Cirurgia, Hora_Inicio, Hora_Fim, Descricao_Cirurgia) VALUES 
(1, 1, '2024-10-05', '15:00', '16:30', 'Apêndice'),
(2, 3, '2024-10-06', '10:00', '12:00', 'Apendicectomia'),
(3, 2, '2024-10-07', '14:00', '15:30', 'Colecistectomia'),
(4, 4, '2024-10-08', '11:00', '13:00', 'Herniorrafia'),
(5, 1, '2024-10-09', '09:30', '11:00', 'Artroplastia de joelho'),
(6, 2, '2024-10-10', '13:00', '14:30', 'Laminectomia'),
(7, 3, '2024-10-11', '15:00', '16:30', 'Cirurgia bariátrica'),
(8, 4, '2024-10-12', '10:00', '11:30', 'Cirurgia de catarata'),
(9, 5, '2024-10-13', '14:00', '15:30', 'Cirurgia plástica'),
(10, 1, '2024-10-14', '09:00', '10:30', 'Cirurgia torácica'),
(11, 2, '2024-10-15', '11:00', '12:30', 'Rinoplastia'),
(12, 3, '2024-10-16', '08:00', '09:30', 'Apendicectomia'),
(13, 4, '2024-10-17', '13:00', '14:30', 'Colecistectomia'),
(14, 5, '2024-10-18', '10:00', '11:30', 'Cirurgia ortopédica'),
(15, 1, '2024-10-19', '15:00', '16:30', 'Cirurgia de hérnia inguinal'),
(16, 2, '2024-10-20', '09:00', '10:30', 'Cirurgia cardíaca'),
(17, 3, '2024-10-21', '11:00', '12:30', 'Cirurgia de varizes'),
(18, 4, '2024-10-22', '13:00', '14:30', 'Cirurgia de próstata'),
(19, 5, '2024-10-23', '10:00', '11:30', 'Cirurgia de coluna'),
(20, 1, '2024-10-24', '08:00', '09:30', 'Cirurgia de joelho');

INSERT INTO Medicamentos_Cirurgias (ID_Cirurgia, ID_Medicamento) VALUES 
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(3, 5),
(3, 6),
(5, 7),
(6, 8),
(6, 9),
(7, 10),
(9, 11),
(9, 12),
(9, 13),
(10, 14),
(10, 15),
(11, 16),
(13, 17),
(13, 18),
(14, 19),
(14, 20),
(14, 1),
(16, 2),
(17, 3),
(17, 4),
(18, 5),
(20, 6),
(20, 7),
(20, 8);


INSERT INTO Internacoes (ID_Pessoa_Paciente, Data_Internacao, Data_Internacao_Fim, Ala_Internacao) VALUES 
(1, '2024-10-01', '2024-10-07', 'Ala A'),
(2, '2024-10-02', '2024-10-15', 'Ala B'),
(3, '2024-10-03', '2024-10-05', 'Ala C'),
(4, '2024-10-04', '2024-10-06', 'Ala A'),
(5, '2024-10-05', '2024-10-08', 'Ala B'),
(6, '2024-10-06', '2024-10-09', 'Ala C'),
(7, '2024-10-07', '2024-10-12', 'Ala A'),
(8, '2024-10-08', '2024-10-12', 'Ala B'),
(9, '2024-10-09', '2024-10-11', 'Ala C'),
(10, '2024-10-10', '2024-10-10', 'Ala A'),
(11, '2024-10-11', '2024-10-15', 'Ala B'),
(12, '2024-10-12', '2024-10-20', 'Ala C'),
(13, '2024-10-13', '2024-10-20', 'Ala A'),
(14, '2024-10-14', '2024-10-19', 'Ala B'),
(15, '2024-10-15', '2024-10-25', 'Ala C'),
(16, '2024-10-16', '2024-10-17', 'Ala A'),
(17, '2024-10-17', '2024-10-19', 'Ala B'),
(18, '2024-10-18', '2024-10-19', 'Ala C'),
(19, '2024-10-19', '2024-10-23', 'Ala A'),
(20, '2024-10-20', '2024-10-21', 'Ala B');

INSERT INTO Plantoes (ID_Usuario_Medico, ID_Usuario_Enfermeiro, Data_Plantao, Hora_Inicio, Hora_Fim) VALUES 
(1, NULL, '2024-10-07', '19:00', '07:00'),  
(NULL, 4, '2024-10-08', '19:00', '07:00'), 
(2, NULL, '2024-10-09', '19:00', '07:00'),  
(NULL, 6, '2024-10-10', '19:00', '07:00'),  
(5, NULL, '2024-10-11', '19:00', '07:00'),  
(NULL, 8, '2024-10-12', '19:00', '07:00'),  
(7, NULL, '2024-10-13', '19:00', '07:00'),  
(NULL, 10, '2024-10-14', '19:00', '07:00'), 
(9, NULL, '2024-10-15', '19:00', '07:00'),  
(NULL, 12, '2024-10-16', '19:00', '07:00'),  
(11, NULL, '2024-10-17', '19:00', '07:00'),  
(NULL, 14, '2024-10-18', '19:00', '07:00'),  
(13, NULL, '2024-10-19', '19:00', '07:00'), 
(NULL, 16, '2024-10-20', '19:00', '07:00'), 
(15, NULL, '2024-10-21', '19:00', '07:00'),  
(NULL, 18, '2024-10-22', '19:00', '07:00'), 
(17, NULL, '2024-10-23', '19:00', '07:00'), 
(NULL, 20, '2024-10-24', '19:00', '07:00'),  
(19, NULL, '2024-10-25', '19:00', '07:00'),  
(NULL, 2, '2024-10-26', '19:00', '07:00');  

INSERT INTO Materiais_Hospitalares (Nome_Material, Quantidade_Estoque, Descricao) VALUES 
('Gaze', 100, 'Gaze estéril para curativos'),
('Atadura', 50, 'Ataduras de diferentes tamanhos'),
('Sutura', 200, 'Suturas de diversos tipos'),
('Seringa', 300, 'Seringas descartáveis de 10ml'),
('Agulha', 500, 'Agulhas descartáveis para injeção'),
('Esparadrapo', 150, 'Esparadrapo adesivo'),
('Termômetro', 80, 'Termômetro digital'),
('Estetoscópio', 25, 'Estetoscópios profissionais'),
('Bisturi', 60, 'Bisturis cirúrgicos descartáveis'),
('Luvas', 200, 'Luvas de látex descartáveis'),
('Máscara', 150, 'Máscaras cirúrgicas descartáveis'),
('Seringa de Insulina', 100, 'Seringas para insulina'),
('Oximetro', 30, 'Oximetros de pulso'),
('Nebulizador', 15, 'Nebulizadores para tratamento respiratório'),
('Ventilador', 5, 'Ventiladores mecânicos para UTI'),
('Cama hospitalar', 10, 'Camas hospitalares ajustáveis'),
('Monitoração cardíaca', 8, 'Equipamentos de monitoramento cardíaco'),
('Sonda', 50, 'Sondas de diferentes tamanhos'),
('Equipamento de raio-x', 2, 'Máquinas de raio-x portáteis'),
('Equipamento de ultrassom', 3, 'Máquinas de ultrassom portáteis');

INSERT INTO Estoque (ID_Medicamento, ID_Material, Quantidade_Estoque, Data_Fabricacao, Data_Validade) VALUES
(1, 1, 100, '2024-12-31', '2025-12-31'), 
(2, 2, 50, '2023-11-30', '2024-11-30'),
(3, 3, 200, '2024-01-15', '2026-01-15'),
(4, 4, 150, '2024-05-20', '2025-05-20'),
(5, 5, 75, '2023-06-15', '2024-06-15'),
(6, 6, 90, '2024-08-10', '2025-08-10'),
(7, 7, 60, '2023-09-25', '2024-09-25'),
(8, 8, 120, '2024-07-18', '2025-07-18'),
(9, 9, 30, '2023-10-05', '2024-10-05'),
(10, 10, 110, '2024-04-30', '2025-04-30'),
(11, 11, 80, '2023-12-20', '2024-12-20'),
(12, 12, 45, '2024-03-15', '2025-03-15'),
(13, 13, 95, '2024-02-28', '2026-02-28'),
(14, 14, 55, '2024-01-10', '2025-01-10'),
(15, 15, 40, '2023-07-30', '2024-07-30'),
(16, 16, 100, '2024-09-05', '2025-09-05'),
(17, 17, 70, '2023-10-20', '2024-10-20'),
(18, 18, 85, '2024-06-15', '2025-06-15'),
(19, 19, 130, '2024-11-01', '2025-11-01'),
(20, 20, 60, '2023-08-12', '2024-08-12');



-- Selecionando os pacientes realizaram consultas com médicos da especialidade 
--'Cardiologia' nos últimos 6 meses.
SELECT DISTINCT p.nome AS Nome_Paciente
FROM Consultas c
JOIN Usuario ON c.ID_Usuario_Medico = Usuario.ID_Usuario
JOIN Pessoa p ON c.ID_Pessoa_Paciente = p.ID_Pessoa
WHERE Usuario.Especialidade = 'Cardiologista' AND 
	c.Data_Consulta >= (CURRENT_DATE - INTERVAL '6 months');

-- Selecionando medicamentos que vão passar da válidade dentro de 30 dias.
SELECT Nome_Medicamento
FROM Medicamentos AS me
JOIN Estoque ON me.ID_medicamento = Estoque.ID_medicamento
WHERE Data_Validade >= CURRENT_DATE + INTERVAL '30 days';

--Selecionando Médicos que trabalharam mais que 30 horas nos últimos 30 dias,
--considerando consultas e plantões.
SELECT Nome_Usuario, SUM((consultas.Hora_Fim - consultas.Hora_Inicio) + (plantoes.Hora_inicio - plantoes.Hora_fim)) AS total_horas
FROM Usuario AS U
JOIN Consultas ON U.ID_Usuario = Consultas.ID_Usuario_Medico
JOIN Plantoes ON U.ID_Usuario = Plantoes.ID_Usuario_Medico
WHERE 
	U.Tipo_Usuario = 'Medico' AND 
	Plantoes.Data_Plantao >= CURRENT_DATE - INTERVAL '30 days' and
	consultas.Data_Consulta >= CURRENT_DATE - INTERVAL '30 days' 
GROUP BY Nome_Usuario
HAVING SUM((consultas.Hora_Fim - consultas.Hora_Inicio) + (plantoes.Hora_inicio - plantoes.Hora_fim)) > '30 hours';

--Selecionando os pacientes que foram internados por mais de 7 dias nos últimos
--3 meses, junto à ala em que foram internados
SELECT nome, Internacoes.Data_Internacao, Internacoes.Data_Internacao_Fim, Internacoes.Ala_Internacao
FROM Pessoa AS pe
JOIN Internacoes ON pe.ID_Pessoa = Internacoes.ID_Pessoa_Paciente
WHERE Data_Internacao >= CURRENT_DATE - INTERVAL '3 months' AND Internacoes.Data_Internacao_Fim - Internacoes.Data_Internacao > 7;

--Selecionando o medicamento mais utilizado em cirurgias nos últimos 6 meses.
SELECT 
	Nome_Medicamento as Medicamento,
	sum(Medicamentos_Cirurgias.ID_Medicamento) as Quantidade_Total
FROM Medicamentos AS me
JOIN Medicamentos_Cirurgias ON me.ID_Medicamento = Medicamentos_Cirurgias.ID_Medicamento
join Cirurgias on Medicamentos_Cirurgias.ID_Cirurgia = Cirurgias.ID_Cirurgia
WHERE Cirurgias.Data_Cirurgia >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY Nome_Medicamento 
ORDER BY Quantidade_Total DESC;
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
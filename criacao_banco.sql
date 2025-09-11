CREATE DATABASE gestao_escola;

USE gestao_escola;

CREATE TABLE aluno (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(255) NOT NULL
);

CREATE TABLE turma (
	id INT PRIMARY KEY AUTO_INCREMENT,
	descricao VARCHAR(10) NOT NULL,
    periodo BIT NOT NULL -- matutino = 0 | vespertino = 1
);

CREATE TABLE professor (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(255) NOT NULL
);

CREATE TABLE disciplina (
	id INT PRIMARY KEY AUTO_INCREMENT,
	descricao VARCHAR(50) NOT NULL,
	carga_horaria INT NOT NULL
);

CREATE TABLE dia_semana (
	id INT PRIMARY KEY AUTO_INCREMENT,
	dia VARCHAR(20) NOT NULL
);

CREATE TABLE calendario (
	id INT PRIMARY KEY AUTO_INCREMENT,
	data_letivo DATE NOT NULL,
    dia_semana_id INT NOT NULL,
    FOREIGN KEY (dia_semana_id) REFERENCES dia_semana(id)
);

CREATE TABLE avaliacao (
	id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE grade (
	id INT PRIMARY KEY AUTO_INCREMENT,
	turma_id INT NOT NULL,
	FOREIGN KEY (turma_id) REFERENCES turma(id),
	professor_id INT NOT NULL,
	FOREIGN KEY (professor_id) REFERENCES professor(id),
	disciplina_id INT NOT NULL,
	FOREIGN KEY (disciplina_id) REFERENCES disciplina(id),
    dia_semana_id INT NOT NULL,
    FOREIGN KEY (dia_semana_id) REFERENCES dia_semana(id)
);

CREATE TABLE matricula (
	id INT PRIMARY KEY AUTO_INCREMENT,
	aluno_id INT NOT NULL,
	FOREIGN KEY (aluno_id) REFERENCES aluno(id),
	grade_id INT NOT NULL,
	FOREIGN KEY (grade_id) REFERENCES grade(id)
);

CREATE TABLE presenca (
	id INT PRIMARY KEY AUTO_INCREMENT,
    aluno_id INT NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES aluno(id),
    calendario_id INT NOT NULL,
    FOREIGN KEY (calendario_id) REFERENCES calendario(id),
    presenca BIT NOT NULL -- falta = 0 | presente = 1
);

CREATE TABLE notas (
id INT PRIMARY KEY AUTO_INCREMENT,
aluno_id INT NOT NULL,
FOREIGN KEY (aluno_id) REFERENCES aluno(id),
grade_id INT NOT NULL,
FOREIGN KEY (grade_id) REFERENCES grade(id),
avaliacao_id INT NOT NULL,
FOREIGN KEY (avaliacao_id) REFERENCES avaliacao(id)
);
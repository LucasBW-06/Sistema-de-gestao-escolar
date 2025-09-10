CREATE DATABASE gestao_escola;

USE gestao_escola;

CREATE TABLE aluno (
	id INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(255) NOT NULL
);

CREATE TABLE turma (
	id INT PRIMARY KEY AUTO_INCREMENT,
	descricao VARCHAR(10) NOT NULL
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

CREATE TABLE calendario (
	id INT PRIMARY KEY AUTO_INCREMENT,
	data_letivo DATE NOT NULL
);

CREATE TABLE avaliacao (
	id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE grade (
	id INT PRIMARY KEY AUTO_INCREMENT,
	turma_id INT NOT NULL,
	FOREIGN KEY (turma_id) REFERENCES turma(id),
	professor_id INT NOT NULL,
	FOREIGN KEY (professor_id) REFERENCES professor(id),
	disciplina_id INT NOT NULL,
	FOREIGN KEY (disciplina_id) REFERENCES disciplina(id)
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
    grade_id INT NOT NULL,
    FOREIGN KEY (grade_id) REFERENCES grade(id),
    calendario_id INT NOT NULL,
    FOREIGN KEY (calendario_id) REFERENCES calendario(id)
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
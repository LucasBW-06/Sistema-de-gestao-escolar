USE gestao_escola;

-- Listar alunos com total de faltas por turma e disciplina (ordenado do maior p/ o menor).
SELECT a.nome AS Aluno, t.descricao AS Turma, d.descricao AS Disciplina, COUNT(p.id) AS Faltas FROM presenca p
	JOIN aluno a ON p.aluno_id = a.id
    JOIN calendario c ON p.calendario_id = c.id
    JOIN turma t ON a.turma_id = t.id
    JOIN grade g ON g.turma_id = t.id AND g.dia_semana_id = c.dia_semana_id
    JOIN disciplina d ON g.disciplina_id = d.id
    WHERE p.presenca = "Falta"
    GROUP BY a.id, t.id, d.id
    ORDER BY Faltas DESC;

-- Taxa de presença (%) por aluno em cada turma e disciplina.
SELECT a.nome AS Aluno, t.descricao AS Turma, d.descricao AS Disciplina, ROUND(100 * SUM(CASE WHEN p.presenca = "Presente" THEN 1 ELSE 0 END) / COUNT(p.id), 2) AS Taxa_Presenca FROM presenca p
	JOIN aluno a ON p.aluno_id = a.id
    JOIN calendario c ON p.calendario_id = c.id
    JOIN turma t ON a.turma_id = t.id
    JOIN grade g ON g.turma_id = t.id AND g.dia_semana_id = c.dia_semana_id
    JOIN disciplina d ON g.disciplina_id = d.id
    GROUP BY a.id, t.id, d.id;

-- Média final do aluno na disciplina.
SELECT a.nome AS Aluno, d.descricao AS Disciplina, ROUND(AVG(n.nota), 2) AS Media FROM nota n
	JOIN aluno a ON n.aluno_id = a.id
    JOIN disciplina d ON n.disciplina_id = d.id
    GROUP BY a.id, d.id;

-- Aluno com maior média em cada turma.
SELECT x.Turma, x.Aluno, x.Media FROM (
	SELECT t.id AS TurmaId, t.descricao AS Turma, a.nome AS Aluno, ROUND(AVG(n.nota), 2) AS Media FROM nota n
		JOIN aluno a ON n.aluno_id = a.id
        LEFT JOIN turma t ON a.turma_id = t.id
        GROUP BY t.id, a.id) x
	WHERE x.Media = (
		SELECT MAX(y.Media) FROM (
			SELECT ROUND(AVG(n.nota), 2) AS Media FROM nota n
				JOIN aluno a ON n.aluno_id = a.id
				LEFT JOIN turma t ON a.turma_id = t.id
                WHERE t.id = x.TurmaId
                GROUP BY t.id, a.id) y);

-- Ranking de alunos (média) dentro de uma turma específica.
SET @turma_selecionada = 1;
SELECT a.nome AS Aluno, t.descricao AS Turma, ROUND(AVG(n.nota), 2) AS Media FROM nota n
	JOIN aluno a ON n.aluno_id = a.id
    JOIN turma t ON a.turma_id = t.id AND t.id = @turma_selecionada
    GROUP BY a.id, t.id
    ORDER BY t.descricao DESC, Media DESC;

-- Disciplinas com maior taxa média de faltas.
SELECT d.descricao AS Disciplina, ROUND(100 * SUM(CASE WHEN p.presenca = "Falta" THEN 1 ELSE 0 END) / COUNT(p.id), 2) AS Taxa_Falta FROM presenca p
	JOIN aluno a ON p.aluno_id = a.id
    JOIN turma t ON a.turma_id = t.id
    JOIN calendario c ON p.calendario_id = c.id
    JOIN grade g ON g.turma_id = t.id AND g.dia_semana_id = c.dia_semana_id
    JOIN disciplina d ON g.disciplina_id = d.id
    GROUP BY d.id
    ORDER BY Taxa_Falta DESC;

-- Professor com maior carga (no de turmas).
SELECT p.nome, COUNT(DISTINCT t.id) AS NTurmas FROM professor p
	JOIN grade g ON g.professor_id = p.id
    JOIN turma t ON g.turma_id = t.id
    GROUP BY p.id
    ORDER BY NTurmas DESC;

-- Turmas com média geral abaixo de 6,0 (alerta).
SELECT t.descricao AS Turma, ROUND(AVG(n.nota), 2) AS Media FROM nota n
	JOIN aluno a ON n.aluno_id = a.id
    JOIN turma t ON a.turma_id = t.id
    GROUP BY t.id
    HAVING Media < 6
    ORDER BY Media DESC;

-- Alunos em risco de reprovação por falta (presença < 75%).
SELECT a.nome AS Aluno, ROUND(100 * SUM(CASE WHEN p.presenca = "Presente" THEN 1 ELSE 0 END) / COUNT(p.id), 2) AS Taxa_Presenca FROM presenca p
	JOIN aluno a ON p.aluno_id = a.id
    GROUP BY a.id
	HAVING Taxa_Presenca < 75
    ORDER BY Taxa_Presenca DESC;

-- Distribuição de notas (média, min, max, desvio) por avaliação.
SELECT d.descricao AS Disciplina, a.descricao AS Avaliação, ROUND(AVG(n.nota), 2) AS Media, MAX(n.nota) AS Maxima, MIN(n.nota) AS Minima, ROUND(STD(n.nota), 2) AS Desvio FROM nota n
	JOIN avaliacao a ON n.avaliacao_id = a.id
    JOIN disciplina d ON n.disciplina_id = d.id
    GROUP BY d.id, a.id;

-- Top 3 alunos da escola no semestre (média global).
SELECT a.nome AS Aluno, ROUND(AVG(n.nota), 2) AS Media FROM nota n
	JOIN aluno a ON n.aluno_id = a.id
    GROUP BY a.id
    ORDER BY Media DESC
    LIMIT 3;
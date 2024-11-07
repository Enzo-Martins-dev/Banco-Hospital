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

-- Q1
SELECT COUNT(*) FROM employee WHERE sex = 'F';

-- Q2
SELECT AVG(salary) as "avg" FROM employee WHERE address LIKE '%TX%' AND sex = 'M';

-- Q3
SELECT s.ssn AS ssn_supervisor, COUNT(*) as qtd_supervisionados FROM employee e LEFT JOIN employee s ON s.ssn = e.superssn
GROUP BY s.ssn
ORDER BY qtd_supervisionados ASC;

-- Q4
SELECT s.fname as nome_supervisor, COUNT(*) as qtd_supervisionados FROM employee e INNER JOIN employee s ON s.ssn = e.superssn
GROUP BY s.fname
ORDER BY qtd_supervisionados ASC;

-- Q5
SELECT s.fname as nome_supervisor, COUNT(*) as qtd_supervisionados FROM employee e LEFT JOIN employee s ON s.ssn = e.superssn
GROUP BY s.fname
ORDER BY qtd_supervisionados ASC;

-- Q6
SELECT MIN(query.qtd) AS qtd FROM (
    SELECT COUNT(*) as qtd FROM WORKS_ON
    GROUP BY pno
) as query;

-- Q7
SELECT pno AS num_projeto, COUNT(essn) AS qtd_func FROM works_on GROUP BY pno HAVING COUNT(essn)
IN (SELECT MIN(qtd) FROM (SELECT pno, COUNT(essn) as qtd FROM WORKS_ON
GROUP BY pno) as consulta );


-- Q8
SELECT pno, AVG(salary) FROM employee INNER JOIN works_on ON ssn = essn
GROUP BY pno;

-- Q9
select pnumber AS proj_num, pname as proj_nome, AVG(salary) as media_sal
FROM project INNER JOIN works_on ON pnumber = pno INNER JOIN employee ON ssn = essn
GROUP BY pnumber
ORDER BY media_sal ASC;

-- Q10 
-- duvida - o group by funciona tanto com as colunas selecionadas (fname, salary), como apenas o identificador do empregado
-- (ssn), gostaria de saber se e uma boa pratica deixar as colunas projetadas no group by ou posso deixar o identificador
SELECT fname, salary
FROM employee LEFT JOIN works_on on ssn = essn
GROUP BY fname,salary
HAVING salary > ALL(
    SELECT salary FROM employee INNER JOIN works_on ON ssn = essn
    WHERE pno = 92
)
ORDER BY salary ASC;

-- Q11
SELECT ssn, COUNT(pno) AS qtd_proj
FROM employee LEFT JOIN works_on ON ssn = essn
GROUP BY ssn
ORDER BY qtd_proj ASC;

-- Q12
SELECT pno as num_proj, COUNT(ssn) as qtd_func
FROM employee LEFT JOIN works_on ON ssn = essn
GROUP BY pno
HAVING COUNT(ssn) < 5
ORDER BY qtd_func ASC;

-- Q13
SELECT e.fname FROM employee e WHERE e.ssn IN (
    SELECT essn FROM dependent WHERE e.dno IN(    
        SELECT dnumber from dept_locations WHERE dlocation = 'Sugarland'
));


-- Q14
SELECT dname FROM department
WHERE NOT EXISTS (SELECT dnum FROM project WHERE dnum = dnumber);


SELECT e.fname, e.lname FROM employee e
WHERE e.ssn <> '123456789' AND NOT EXISTS(
    (SELECT pno FROM works_on WHERE essn = '123456789')
    EXCEPT (SELECT pno FROM works_on WHERE
            essn = e.ssn
    ));


-- Q16
SELECT fname, salary
FROM employee LEFT JOIN works_on on ssn = essn
GROUP BY fname,salary
HAVING salary > ALL(
    SELECT salary FROM employee INNER JOIN works_on ON ssn = essn
    WHERE pno IN(
        SELECT Q1.pno FROM (
            SELECT pno, AVG(salary) avg_salary FROM employee INNER JOIN WORKS_ON ON ssn = essn GROUP BY pno) Q1
            WHERE avg_salary = (
                SELECT MAX(Q2.avg_salary) FROM (
                SELECT pno,AVG(salary) avg_salary FROM employee INNER JOIN WORKS_ON on ssn = essn GROUP BY pno
            )Q2
        )
    )
)
ORDER BY salary ASC;

-- Q1
SELECT * FROM department;

-- Q2
SELECT * FROM dependent;

-- Q3
SELECT * FROM dept_locations;

-- Q4
SELECT * FROM employee;

-- Q5
SELECT * FROM project;

-- Q6
SELECT * FROM works_on;

-- Q7
SELECT fname,lname FROM employee WHERE sex='M';

-- Q8
SELECT fname FROM employee WHERE sex='M' AND superssn IS NULL;

-- Q9
SELECT e.fname AS "employee_fname", s.fname AS "supervisor_fname" FROM employee e, employee s
WHERE e.superssn = s.ssn;

-- Q10
SELECT e.fname AS "employee_fname" FROM employee e, employee s
WHERE e.superssn = s.ssn AND s.fname='Franklin';

-- Q11
SELECT d.dname, dl.dlocation AS "location_name" FROM department d, dept_locations dl
WHERE d.dnumber = dl.dnumber; 

-- Q12
SELECT d.dname AS "dept_name" FROM department d, dept_locations dl
WHERE d.dnumber = dl.dnumber AND dl.dlocation LIKE 'S%';

-- Q13
SELECT e.fname, e.lname, s.fname, s.lname FROM employee e, employee s
WHERE e.superssn = s.ssn;

-- Q14
SELECT fname || ' ' || minit || ' ' || lname AS "full_name", salary FROM employee WHERE salary > 50000;

-- Q15
SELECT pname, dname FROM project, department
where dnum = dnumber;

-- Q16
SELECT p.pname, e.fname FROM project p, department d, employee e
WHERE p.dnum = d.dnumber AND e.ssn = d.mgrssn AND p.pnumber > 30;

-- Q17
SELECT p.pname, e.fname FROM employee e, project p, works_on w
where p.pnumber = w.pno AND w.essn = e.ssn;

-- Q18
SELECT e.fname, d.dependent_name, d.relationship FROM dependent d, employee e, works_on w
WHERE e.ssn = d.essn AND w.essn = e.ssn AND w.pno = 91;
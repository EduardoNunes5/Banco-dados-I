
-- 1

CREATE VIEW vw_dptmgr AS
    SELECT dnumber, fname AS manager_name
    from department
    INNER JOIN employee ON mgrssn = ssn;

CREATE VIEW vw_empl_houston AS
    SELECT ssn, fname FROM employee
    WHERE address LIKE '%Houston%';

CREATE VIEW vw_deptstats AS
    SELECT d.dnumber, d.dname, COUNT(e.ssn) AS emp_number
    FROM employee e INNER JOIN department d ON e.dno = d.dnumber
    GROUP BY d.dnumber;


CREATE VIEW vw_projstats AS
SELECT p.pnumber, COUNT(*) AS emp_number
FROM project p INNER JOIN works_on w ON w.pno = p.pnumber
GROUP BY p.pnumber;

-- 2 --
SELECT * FROM vw_dptmgr;
SELECT * FROM vw_empl_houston;
SELECT * FROM vw_deptstats;
SELECT * FROM vw_projstats;

-- 3 --
DROP VIEW vw_dptmgr;
DROP VIEW vw_empl_houston;
DROP VIEW vw_deptstats;
DROP VIEW vw_projstats;


-- 4 --

CREATE FUNCTION check_age(essn VARCHAR(9)) RETURNS VARCHAR(7) AS
$$
DECLARE
    age INT;
    result VARCHAR(7);
BEGIN
    SELECT EXTRACT(YEAR from AGE(bdate)) from employee e INTO age WHERE e.ssn = essn;
    IF age >= 50 THEN
        result = 'SENIOR';
    ELSIF age < 50 AND age >= 0 THEN
        result = 'YOUNG';
    ELSIF age IS NULL THEN
        result = 'UNKNOWN';
    ELSE
        result = 'INVALID';
    END IF;
    return result;
END;
$$ LANGUAGE plpgsql;


SELECT check_age('666666609');
SELECT check_age('555555500');
SELECT check_age('987987987');
SELECT check_age('x');
SELECT check_age(null);

SELECT ssn FROM employee WHERE check_age(ssn) = 'SENIOR';

-- 5 --

--funcao auxiliar para saber se um funcionario tem subordinados (utilizada no check_mgr)
CREATE FUNCTION has_subordinates(essn VARCHAR(9)) RETURNS BOOLEAN AS
$$
DECLARE
    sub_number INT;
BEGIN
    select count(*) from employee e, employee mgr INTO sub_number
    WHERE e.superssn = mgr.ssn;

    IF sub_number > 0 THEN
        return TRUE;
    ELSE
        return FALSE;
    END IF;

END;
$$ LANGUAGE plpgsql;

-- funcao de verificar o gerente do roteiro
CREATE FUNCTION check_mgr () RETURNS trigger AS
$$
DECLARE
    emp_number_on_department INT;
BEGIN
    SELECT count(*) FROM employee e INTO emp_number_on_department WHERE e.ssn = NEW.mgrssn AND e.dno = NEW.dnumber;
    IF emp_number_on_department = 0 OR NEW.mgrssn IS NULL THEN
        raise exception 'manager must be a department''s employee';
    END IF;
    IF check_age(NEW.mgrssn) <> 'SENIOR' THEN
        raise exception 'manager must be a SENIOR employee';
    END IF;
    IF (NOT has_subordinates(NEW.mgrssn)) THEN
        raise exception 'manager must have supevisees';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_mgr BEFORE INSERT OR UPDATE ON department FOR EACH ROW EXECUTE PROCEDURE check_mgr();
DROP TRIGGER check_mgr ON department;

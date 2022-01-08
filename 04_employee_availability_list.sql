USE WWW;
SELECT nickname, CONCAT(first_name, '', last_name) AS "employee name", role_name
FROM employee, role
ORDER BY nickname, role_name;
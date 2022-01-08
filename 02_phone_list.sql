USE WWW;
SELECT employee_id, nickname, CONCAT(first_name, '', last_name) AS "employee name", mobile_phone, home_phone
FROM employee
ORDER BY nickname;
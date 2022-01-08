USE www;
SELECT 
    d.destination_name,
    ty.trip_type_name,
    t.trip_number,
    t.trip_date,
    guide_emp.nickname AS guide_nickname,
    gear_emp.nickname AS gear_nickname,
    t.capacity,
    COUNT(r.guest_id) AS guests_booked,
    (t.capacity - COUNT(r.guest_id)) AS positions_available
FROM
    trip t
        JOIN
    trip_type ty ON t.trip_type_code = ty.trip_type_code
        JOIN
    destination d ON t.destination_code = d.destination_code
        JOIN
    reservation r ON t.trip_number = r.trip_number
        JOIN
    employee gear_emp ON gear_emp.employee_id = t.gear_employee_id
        JOIN
    employee guide_emp ON guide_emp.employee_id = t.guide_employee_id
GROUP BY trip_number
ORDER BY destination_name , trip_type_name , trip_date , t.trip_number;


USE WWW;
SELECT 
    d.destination_name,
    tt.trip_type_name,
    t.trip_number,
    t.trip_date,
    guide_emp.nickname AS 'guide_nickname',
    gear_emp.nickname AS 'gear_nickname',
    guide_emp.mobile_phone AS guide_mobile_phone,
    gear_emp.mobile_phone AS gear_mobile_phone,
    t.latest_guest_arrival_time,
    t.departure_time,
    t.estimated_return_time,
    gp.gathering_point_description
FROM
    trip t
        JOIN
    trip_type tt ON tt.trip_type_code = t.trip_type_code
        LEFT JOIN
    employee guide_emp ON guide_emp.employee_id = t.gear_employee_id
        JOIN
    employee gear_emp ON gear_emp.employee_id = t.guide_employee_id
        JOIN
    gathering_point gp ON gp.gathering_point_id = t.gathering_point_id
        JOIN
    destination d ON d.destination_code = t.destination_code
ORDER BY destination_name , trip_type_name , trip_date;
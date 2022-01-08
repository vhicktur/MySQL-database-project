USE WWW;
SELECT 
    d.destination_name,
    tt.trip_type_name,
    t.trip_number,
    t.trip_date,
    e.experience_name,
    g.age,
    g.weight,
    	CONCAT(g.first_name, ' ', g.last_name) AS guest_full_name,
    IF(g.isSwimmer = 0, 'false', 'true') AS isSwimmer,
    g.mobile_phone
FROM
    trip t
        JOIN
    destination d ON d.destination_code = t.destination_code
        JOIN
    trip_type tt ON t.trip_type_code = tt.trip_type_code
		LEFT JOIN
    reservation r ON t.trip_number = r.trip_number
        JOIN
    guest g ON g.guest_id = r.guest_id
        JOIN
    experience e ON e.experience_code = g.experience_code
ORDER BY destination_name , trip_type_name , trip_date, guest_full_name
   
    
    

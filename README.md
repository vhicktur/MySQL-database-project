	# MySQL-database-project
	This project uses DML(insert, update, delete, select) and DDL (create, replace, alter, drop) to populate a Database schema with information about customers of a local Kayaking businesses alongside various queries using joins, unions, aggregate functions, views and subqueries to manipulate data.


	#02_phone_list.sql
	USE WWW;
	SELECT employee_id, nickname, CONCAT(first_name, '', last_name) AS "employee name", mobile_phone, home_phone
	FROM employee
	ORDER BY nickname;


	#03_guide_roles_list: In order of nickname, role_name. One row per employee, per role.)
	• nickname
	• employee name (first_name + space + last_name)
	• role_name

	 USE WWW;
	SELECT nickname, CONCAT(first_name, '', last_name) AS "employee name", role_name
	FROM employee, role
	ORDER BY nickname, role_name;


	#04_employee_availability_list:In order of nickname. One row per employee.
	• nickname
	• employee name (first_name + space + last_name)
	• availability_notes

	USE WWW;
	SELECT nickname, CONCAT(first_name, '', last_name) AS "employee name", role_name
	FROM employee, role
	ORDER BY nickname, role_name;


	#05_booking_summary: In order of destination_name, trip_type_name, trip_date, trip_number. One row per
	trip. Make sure that trips without a gear employee and trips without reservations are
	present in the result set.

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


	#06_trip_roster.sql
	(In order of destination_name, trip_type_name, trip_date, guest_name. One row per
	trip per reservation. Do NOT include rows for trips that do not have reservations.)
	• destination_name
	• trip_type_name
	• trip_number
	• trip_date
	• guest full name (first_name + space + last_name)
	• experience_name
	• age
	• weight
	• IsSwimmer (Display value 0 as “False”. Display value 1 as “True”)
	• guest mobile_phone

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


	#07_trip_detail_sheet.sql
	(In order of Destination Name, Trip Type Name, Trip Date. One row per trip. Make sure
	that trips without a gear employee are present in the result set.)
	• destination_name, trip_type_name, trip_number, trip_date,guide nickname, guide mobile_phone, gear nickname,gear mobile phone, Wilma’s Wild Wisconsin Office Phone (always 414-555-1212), latest_guest_arrival_time, departure_time,estimated_return_time, gathering point description

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



	This query will have two parts. The first part will create a view named
	trip_assignments_view. The second part will be a SELECT that uses
	trip_assignments_view.
	The following are the requirements for trip_assignments_view:
	(One row per trip. Make sure that trips without a gear employee are present in the result
	set. Also, make sure that trips without reservations are present in the result set.)
	• trip_date,trip_number, destination_name,trip_type_name,reservation_count, guide_nickname, gear_nickname

	USE WWW;
	CREATE OR REPLACE VIEW trip_assignments_view AS
	SELECT trip_date, trip.trip_number, destination_name, 
		COUNT(reservation.guest_id) AS reservation_count, 
	    guide_emp.nickname AS guide_nickname, gear_emp.nickname AS gear_nickname
	    FROM trip
	    JOIN destination ON destination.destination_code=trip.destination_code
	    JOIN employee guide_emp ON guide_emp.employee_id=trip.guide_employee_id
	    LEFT JOIN employee gear_emp ON gear_emp.employee_id=trip.gear_employee_id
	   LEFT JOIN reservation ON reservation.trip_number=trip.trip_number GROUP BY reservation.trip_number;


	SELECT * FROM trip_assignments_view 
	ORDER by trip_date, trip_number;


	#09_add_a_new_reservation.sql
	This script will both create a new guest and it will add a new reservation for that guest
	on existing trip #562. 

	 USE WWW;
	INSERT INTO guest (guest_id, first_name, last_name, age, weight, isSwimmer, experience_code) 
	VALUES('21', 'Lilly', 'Ludsen', '25', '120', '1', '4');
	INSERT INTO reservation (trip_number, guest_id) 
	VALUES ('562', '21');



	#10_transfer_a_reservation.sql
	This script will DELETE the reservation for Lamar Lincoln from trip #562, and it will add
	a new reservation for Lamar Lincoln to trip #564. Don’t worry about the transferred
	reservation putting the new trip over its capacity limit. As an alternative, you may
	accomplish the same result using UPDATE.

	 USE WWW;
	UPDATE reservation 
	SET 
	    trip_number = '564'
	WHERE
	    (trip_number = '562')
		AND (guest_id = '11');
        
        
 
	 #11_delete_a_reservation.sql
	This script will delete the reservation of Bart Samuels, Jr. on trip #562.

   	USE WWW;
	DELETE FROM reservation WHERE (trip_number = '562') AND (guest_id = '2');  


	#12_add_a_new_employee.sql
	This script will insert rows into the tables of the www database in order to create a new
	guide employee

	 USE WWW;
	INSERT INTO employee (employee_id, first_name, last_name, nickname, mobile_phone, availability_notes) VALUES ('10', 'Patrick L.', 'Patterson', 'Pat', '847-555-9706', 'All Saturdays and Sundays');
	INSERT INTO plays_role (employee_id, role_code) VALUES ('10', '2');
	INSERT INTO plays_role (employee_id, role_code) VALUES ('10', '3');

	#13_delete_an_existing_employee.sql
	This script should delete the employee Summer Simms.

	 USE WWW;
	DELETE FROM plays_role WHERE (employee_id = '6') ;
	DELETE FROM employee WHERE (employee_id = '6');



	#14_add_a_new_trip.sql
	This script will add a new trip into the database

	 USE WWW;
	INSERT INTO trip (trip_number, trip_date, capacity, latest_guest_arrival_time, departure_time, estimated_return_time, estimated_return_time, destination_name, trip_type_name, guide_employee, gear_employee, gathering_point)
	 VALUES ('666', '2021-02-08', '7', '07:30:00', '08:15:00', '16:00:00', 'Upper Wisconsin River', 'Kayak', 'Patt Patterson', 'NONE' , 'Omars Live Bait and Bridal Salon,
	3421 Highway KZ, Casino Springs,
	WI 54776');


	#15_delete_an_existing_trip.sql
	This script will DELETE trip #576
	 use WWW;
	DELETE FROM reservation WHERE (trip_number='576');
	DELETE FROM trip WHERE (trip_number = '576');

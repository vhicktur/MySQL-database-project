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


USE WWW;
UPDATE reservation 
SET 
    trip_number = '564'
WHERE
    (trip_number = '562')
        AND (guest_id = '11');
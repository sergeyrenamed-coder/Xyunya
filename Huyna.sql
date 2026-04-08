INSERT INTO Reviews (id, reservation_id, rating)
SELECT t.new_id, r.id, 5
FROM Reservations r
JOIN Users u ON r.user_id = u.id
JOIN Rooms ro ON r.room_id = ro.id
CROSS JOIN (
    SELECT COUNT(*) + 1 AS new_id
    FROM (SELECT * FROM Reviews) x
) t
WHERE u.name = 'George Clooney'
  AND ro.address = '11218, Friel Place, New York';

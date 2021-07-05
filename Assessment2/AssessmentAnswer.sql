-- question 1
SELECT User.name, COUNT(Location.user) AS numRecorded
FROM User LEFT OUTER JOIN Location
ON User.id = Location.user
GROUP BY User.name;

-- question 2
SELECT COUNT(*) AS num
FROM City
WHERE state = 
	(SELECT state
    From City
    WHERE cityName = 'Melbourne')
AND cityName <> 'Melbourne';

-- question 3
SELECT DISTINCT User.name
FROM User INNER JOIN Location INNER JOIN Gym
ON User.id = Location.user
AND User.gym = 
	(SELECT Gym.id
    FROM Gym
    WHERE Gym.name = 'Academia')
WHERE Location.latitude > 
	(SELECT Gym.latitude
    FROM Gym
    WHERE Gym.name = 'Brunswick');
    
-- question 4
SELECT COUNT(*) AS num
FROM User INNER JOIN Gym INNER JOIN City
ON User.gym = Gym.id AND Gym.city = City.id
WHERE City.state = 'Vic';

-- question 5
SELECT CONCAT(FORMAT(
	(SELECT COUNT(id)
	FROM User
	WHERE gym IS NULL) /
    (SELECT COUNT(id)
    FROM User) * 100, 2), '%') AS percentage;
    
-- question 6
SELECT CONCAT(TIMESTAMPDIFF(MINUTE, 
	(SELECT MIN(whenRecorded)
	FROM Location
	WHERE user = 4),
    (SELECT MAX(whenRecorded)
	FROM Location
	WHERE user = 4)),' minute(s)') AS timeElapsed;

-- question 7
SELECT 
	(SELECT FORMAT(AVG(num),2)
	FROM (SELECT COUNT(Location.user) AS num
		FROM User LEFT OUTER JOIN Location
		ON User.id = Location.user
		WHERE User.gym IS NOT NULL
		GROUP BY User.name, User.gym) AS RegTable) AS RegisteredAvg,
	(SELECT FORMAT(AVG(num),2)
	FROM (SELECT COUNT(Location.user) AS num
		FROM User LEFT OUTER JOIN Location
		ON User.id = Location.user
		WHERE User.gym IS NULL
		GROUP BY User.name, User.gym) AS UnregTable) AS UnregisteredAvg;

-- question 8
SELECT DISTINCT name
FROM User INNER JOIN Location
ON User.id = Location.user
WHERE SQRT(POWER(Location.longitude - 144.9630, 2) + 
   	 POWER(Location.latitude - (-37.7990), 2)) * 100 <= 0.1;

-- question 9
-- Since for most times, the maximum distance is used for analysing, I used max function in this problem.
SELECT CONCAT(FORMAT(MAX(SQRT
	(POWER(North.longitude - South.longitude, 2) + 
    POWER(North.latitude - South.latitude, 2)) * 100 * 1000),2), ' m')
    AS distance
FROM (SELECT longitude, latitude
	FROM Location
    WHERE latitude = 
		(SELECT MAX(latitude)
        FROM Location
        WHERE Location.user = 
			(SELECT User.id
			FROM User
			WHERE User.name = 'Alice'))) AS North CROSS JOIN
	(SELECT longitude, latitude
	FROM Location
    WHERE latitude = 
		(SELECT MIN(latitude)
        FROM Location
        WHERE Location.user = 
			(SELECT User.id
			FROM User
			WHERE User.name = 'Alice'))) AS South;

-- question 10
SELECT CONCAT(FORMAT(SUM(SQRT
	(POWER(EndPostion.longitude - StartPostion.longitude, 2) + 
	POWER(EndPostion.latitude - StartPostion.latitude, 2)) * 100),2), ' km') AS totalDis
FROM (SELECT longitude, latitude, whenRecorded
	FROM Location
	WHERE Location.user = 
		(SELECT id
		FROM User
		WHERE User.name = 'Alice')) AS StartPostion JOIN
    (SELECT longitude, latitude, whenRecorded
	FROM Location
	WHERE Location.user = 
		(SELECT id
		FROM User
		WHERE User.name = 'Alice')) AS EndPostion
WHERE TIMESTAMPDIFF(MINUTE,
	StartPostion.whenRecorded, EndPostion.whenRecorded) = 1;
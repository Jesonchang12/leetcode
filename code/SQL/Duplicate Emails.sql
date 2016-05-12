SELECT Email
FROM (SELECT Email, COUNT(Email) AS numOfEmail
    FROM Person
    GROUP BY Email) AS T1 
WHERE T1.numOfEmail > 1
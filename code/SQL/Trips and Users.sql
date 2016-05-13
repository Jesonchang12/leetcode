SELECT
    Request_at,
    round(
        count(

            IF (STATUS != 'completed', TRUE, NULL)
        ) / count(*),
        2
    ) AS 'Cancellation Rate'
FROM
    (
        SELECT
            Request_at,
            STATUS
        FROM
            Users
        JOIN (
            SELECT
                Client_Id,
                Request_at,
                Status
            FROM
                Trips
            WHERE
                Request_at >= '2013-10-01'
            AND Request_at <= '2013-10-03'
        ) AS a ON Users.Users_Id = a.Client_Id
        WHERE
            Role = 'client'
        AND Banned = 'No'
    ) b
GROUP BY
    Request_at

# without join    
SELECT Request_at as Day,
       ROUND(COUNT(IF(Status != 'completed', TRUE, NULL)) / COUNT(*), 2) AS 'Cancellation Rate'
FROM Trips
WHERE (Request_at BETWEEN '2013-10-01' AND '2013-10-03')
      AND Client_id NOT IN (SELECT Users_Id FROM Users WHERE Banned = 'Yes')
GROUP BY Request_at;


# join + sum
select t.Request_at as Day,
       round(sum(if(t.Status <> 'completed', 1, 0))/sum(1), 2) as 'Cancellation Rate'
from Trips as t
inner join Users as u on t.Client_id = u.Users_id and u.Banned <> 'Yes'
where t.Request_at >= '2013-10-01' and t.Request_at <='2013-10-03'
group by t.Request_at;
    
    
    
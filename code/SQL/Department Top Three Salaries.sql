# 1) count + join:
  select d.Name as Department, e.Name as Employee, e.Salary from Employee as e 
  inner join Department d on e.DepartmentId = d.Id
  where (select count(distinct e1.Salary) from Employee e1 where e1.Salary > e.Salary 
        and e1.DepartmentId = e.DepartmentId) < 3
  order by d.Name, e.Salary DESC;

  
# 2) Three variables + join :
select d.Name Department, t.Name Employee, t.Salary
from (select Name, Salary, DepartmentId,
             @rank := IF(@prev_department = DepartmentId, @rank + (@prev_salary <> Salary), 1) AS rank,
             @prev_department := DepartmentId,
             @prev_salary := Salary
             from Employee, (select @prev_department := -1, @prev_salary := 0.0, @rank := 1) as init 
             ORDER BY DepartmentId, Salary DESC) t 
             inner join Department d on d.Id = t.DepartmentId
             where t.rank <= 3 ORDER BY d.Name, t.Salary DESC;
             

select d.Name as Department, computed.Name as Employee, computed.Salary as Salary
    from (
        select Name, Salary, DepartmentId, @row := IF(DepartmentId=@did, @row + 1,1) as Rank , @did:=DepartmentId
        from (
            select Name, Salary, DepartmentId
            from Employee
            order by DepartmentId, Salary desc
            ) ordered, (select @row:=0, @did:=0) variables
        ) computed
    join Department d
    on computed.DepartmentId=d.Id
    where computed.Rank<=3



select 
d.name Department
, b.name Employee
, b.salary
from 
(
select e1.name
, e1.salary
, e1.DepartmentId
, count(distinct(e2.salary)) cnt
from Employee e1
inner join Employee e2
on e1.DepartmentId=e2.DepartmentId
and e1.salary <= e2.salary
group by e1.name
, e1.salary
, e1.DepartmentId
) b
inner join Department d
on b.DepartmentId=d.Id
where b.cnt<4


# My simple solution with order by and limit
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select if(count(*)<N,null,min(s.Salary))
      from 
      (select distinct Salary
      from Employee
      order by Salary DESC
      limit 0,N) s
  );
END    


SELECT
    a. NAME AS Department,
    g. NAME AS Employee,
    g.Salary
FROM
    Department a
INNER JOIN Employee g ON a.Id = g.DepartmentId
LEFT JOIN (
    SELECT
        e.DepartmentId,
        max(e.Salary) AS Salary
    FROM
        Employee e
    INNER JOIN (
        SELECT
            c.DepartmentId,
            max(c.Salary) AS Salary
        FROM
            Employee c
        INNER JOIN (
            SELECT
                DepartmentId,
                max(Salary) AS Salary
            FROM
                Employee
            GROUP BY
                DepartmentId
        ) b ON c.DepartmentId = b.DepartmentId
        WHERE
            c.Salary < b.Salary
        GROUP BY
            c.DepartmentId
    ) d ON e.DepartmentId = d.DepartmentId
    WHERE
        e.Salary < d.Salary
    GROUP BY
        e.DepartmentId
) f ON g.DepartmentId = f.DepartmentId
WHERE
    f.DepartmentId IS NULL
OR g.Salary >= f.Salary
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
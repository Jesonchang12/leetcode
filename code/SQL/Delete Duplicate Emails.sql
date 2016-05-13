delete from Person
where Id not in
(select MinId from
    (select min(Id) MinId from Person group by Email) tmp)
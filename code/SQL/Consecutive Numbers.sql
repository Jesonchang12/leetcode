select distinct a.Num from Logs a 
inner join Logs b on a.id = b.id+1 
inner join Logs c on a.id = c.id+2
where a.Num = b.Num and a.Num = c.Num

select distinct t1.num 
from Logs t1 join Logs t2 on t1.Num = t2.Num 
    join Logs t3 on t1.Num = t3.Num 
where t2.Id - t1.Id = 1 and t3.Id - t2.Id =1;

select distinct r.num  from 
    (select num,
        case when @last = num then @count:=@count+1
            when @last<>@last:=num then @count:=1
            end as n
        from Logs
    ) r ,(select @count:=0,@last:=(select num from Logs limit 0,1)) temp
where r.n>=3
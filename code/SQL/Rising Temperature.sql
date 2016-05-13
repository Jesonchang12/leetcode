select w.Id
from
(
select w1.Id, IF(@temp<w1.Temperature, true, false) as rise, IF(@date=subdate(w1.Date,1), true, false) as cont, (@temp:=w1.Temperature)
as Temperature, (@date:=w1.Date) as Date
from (select * from Weather order by Date asc) w1, (select @temp:=null, @date:=null) var
) w
where w.rise and w.cont and w.Id is not null
order by w.Id asc;

select latter.Id 
from Weather former, Weather latter where latter.Temperature > former.Temperature and datediff(latter.Date, former.Date)=1
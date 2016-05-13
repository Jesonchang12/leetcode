select Score,Rank from 
(
SELECT Score,
       CASE
           WHEN @dummy <=> Score THEN @Rank := @Rank 
           ELSE @Rank := @Rank +1
    END AS Rank,@dummy := Score as dummy
FROM
  (SELECT @Rank := 0,@dummy := NULL) r,
     Scores
ORDER BY Score DESC
) AS C

select Score,
    (select count(*)
    from
        (select distinct Score 
        from Scores
        order by Score DESC) tmp
    where t.Score <= tmp.Score) Rank
from Scores t
order by Score DESC
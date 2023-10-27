use projectq3;

/* 1.SELECT COUNTRY CODE FROM ORDERID */

select  substring(`Order ID` ,1,2) from store2;


/* 2.top5 profit for sales eaxch city wise */

select * from  
(select city,sales,profit,
row_number() over( partition  by city order by profit desc )
topvalues from store2  )  topval 
where topval.topvalues < 6 ;


/* 3. maximum value of profit uing rownumber */

select city,profit from  
(select city,sales,profit,
row_number() over( partition  by city order by profit desc )
rowmax from store2  )  rowmaxvalue
where rowmaxvalue.rowmax = 1 ;

/* 4. removing duplicates in a single query */

select distinct least( state, city) as col1 , greatest(state, city) as col2 from store2;
  
/* 5. segment wise sales >500 */
select segment, sales from  
(select segment, sales,
row_number() over( partition  by segment order by sales desc )
segmentwise from store2  )  segmenttab
where segmenttab.sales > 500 ;
 
 
/*6.categorise sales s low,high ,medium */
  
  select sales ,
  case
  when sales <= 100  then " LOW"
  when sales >100  && sales <=500  then "MEDIUM"
  when sales > 500 && sales < 2000 then "HIGH"
  else " BEST"
  end as salerating
  from store2;
  

/* 7 ..city, region wise sum of sales, sum opf profits, count of sales , count of profits *using groupby*/ 
select city, region,  sum(sales ) as Sumofsales , sum( profit) as sumofprofit , 
count(sales) as countofsales , count(profit) as countofprofit 
from store2  
group by city, region;

/* 8.select all records belongimng to region east and west with sales >500 */

select * from store2 
where region in ('East' ,'West') and sales> 500;

/* 9.rank andc dense rank over city and sales*/
/*only city*/

select city,  
rank() over( order by city )  as myrank ,
dense_rank() over( order by city )  as myd
from store2;

/*only sale*/
select sales,  
rank() over( order by sales )  as myrank ,
dense_rank() over( order by sales)  as myd
from store2;

/* sale and city*/
select city, sales, 
rank() over(partition by city order by sales asc )  as myrank,
dense_rank() over(partition by city order by sales asc )  as mydenserank
from store2;

/*10. Inner join , Left join, Right Join , self join , cross join, union */
create table customer ( custid int, fname varchar(255));
insert into customer values ( 1 , "john");
insert into customer values ( 2 , "robert");
insert into customer values ( 3 , "david");
insert into customer values ( 4 , "john");
insert into customer values ( 5 , "betty");

create table order1 (orderid int , amount int, custid int);
insert into order1 values ( 1,200,10);
insert into order1 values ( 2,500,3);
insert into order1 values ( 3,300,6);
insert into order1 values ( 4,800,5);
insert into order1 values ( 5,150,8);

select * from customer;
select * from order1;

/*inner join */
select fname , amount, customer.custid
from customer
inner join order1 on customer.custid=order1.custid;

/*left join */
select fname , amount, customer.custid
from customer
left join order1 on customer.custid=order1.custid;

/*right join */
select fname , amount, customer.custid
from customer
right join order1 on customer.custid=order1.custid;

/* self join*/
SELECT fname, amount
FROM customer T1, order1 T2
WHERE amount > 200;

/*cross join*/
SELECT customer.custid, customer.fname, order1.amount
FROM customer
CROSS JOIN order1;

/* union*/
SELECT custid FROM customer
UNION
SELECT custid FROM order1;



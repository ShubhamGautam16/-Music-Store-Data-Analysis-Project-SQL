create database music;
select * from employee
--number of rows present into our employee table 
select count (*) from employee
select count (*) from track
select * from customer
where city in ('london','delhi');

-- Q1. who is the senior most employee based on the job title?
select top 1 * from employee
order by levels desc;

--Q2. which countries have the most invoices?
Select count (*) as c, billing_country
From invoice
GROUP BY billing_country
order by c desc;

--Q3.what are the top3 values of total invoice?
select top 3 total from invoice
ORDER BY total desc;  

--Q4. which city has the best customers? we would  like to throw a promotional music festival in the city we made the most money
--write a query that returns one city that has the highest sum of sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT  sum (total) as invoice_total, billing_city
FROM invoice
group by billing_city
order by invoice_total desc;

--Q5. who is the best customer? the customer who has spent the most money will be declared the best customer. 
--write a query that return the person who has spent the most money 
select TOP 1 c.customer_id,c.first_name,c.last_name, sum(i.total ) AS total
From customer c
join invoice i
on c.customer_id = i.customer_id
group by c.customer_id,c.first_name,c.last_name
ORDER BY  total desc;

select * from customer 
select * from invoice 

--Q6. write query to return the email, first name , last name, henre of all rock music listeners.
--returen your list orderd alphabeticalluy by email starting with A.
select distinct email, first_name , last_name 
from customer 
join invoice on customer.customer_id =invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id 
where track_id IN(
select track_id from track
join genre on track.genre_id= genre.genre_id
where genre.name like 'ROCK')
order by email;

--Q.7 lets invite the artist who have written the most rock music in our date set
--write a query that returns the artist name and total track count of the top 10 rock bands.
select * from genre
select * from artist
select * from track
select * from album

select TOP 10
artist.artist_id,count(artist.artist_id) as number_of_songs,artist.name
from track
join album on album.albumid = track.album_id
join artist on artist.artist_id = album.artistid
join genre on genre.genre_id = track.genre_id
where genre.name LIKE 'ROCK'
GROUP BY artist.artist_id,artist.name
order by number_of_songs DESC;

--Q8. Return all the track names that have a song length longer than the average song length.
--return the name and milliseconds for each track.
--order by the song length with the longest songs listed first

select * from track

select name,milliseconds 
from track
where milliseconds > (
select AVG(milliseconds) As avg_song_length
from track)
order by milliseconds desc;


---Q3.1.Find how much amount spent by each customer on artist?
-- write a query to return customer name , artist name and total spent
 select * from customer
 select * from invoice_line
 select * from track
 select * from artist
 select * from invoice
  select * from album

 
 With best_selling_artist as(
 select  top 1 artist.artist_id as artist_id,artist.name as artist_name,
 SUM (invoice_line.unit_price * invoice_line.quantity) as total_sales
 from invoice_line
 join track on track.track_id=invoice_line.track_id
 join album on album.albumid =track.album_id
 join artist on artist.artist_id = album.artistid
 group by artist.artist_id,artist.name
 order by 3 desc
 )
   select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
   SUM(il.unit_price * il.quantity) as amount_spent
   from invoice i
   join customer c on c.customer_id=i.customer_id
   join invoice_line il on il.invoice_id=i.invoice_id
   join track t on t.track_id=il.track_id
   join album alb on alb.albumid=t.album_id
   join best_selling_artist bsa on bsa.artist_id =alb.artistid 
   group by c.customer_id,c.first_name,c.last_name,bsa.artist_name
   order by 5 desc;

--Q3.2. we want to find out the most popular music genre for each country
-- we determine the most popular genre as the genre with the highest amount of 
-- purchases. write a query that returns each country along with the top genre.
-- for countries where the maximum number of purchases is shared return all genres.
 
 with popular_genre as 
 (
     select count(il.quantity) AS purchases,c.country, g.name,g.genre_id, 
	 ROW_NUMBER() over(PARTITION by c.country order by count(il.quantity) desc) as Rowno
	 from invoice_line il
	 join invoice i on i.invoice_id=il.invoice_id
	 join customer c on c.customer_id=i.customer_id
	 join track t on t.track_id=il.track_id
	 join genre g on g.genre_id=t.genre_id
	 group by c.country,g.name,g.genre_id
	-- order by 2 asc, 1 desc
)
select * from popular_genre where Rowno <= 1
--ROW_NUMBER() function generates a sequential number for each row within a partition in the resultant output. In each partition, the first-row number begins with initial
--Q3.3 write a query that determines the customer that has spent the most
--on music for each country. write a query that returns the country along 
-- with the top customer and how mush they spent. for countries where the top amount 
--spent is shared, provide all customer who spent this amount .


  with customer_with_country as(
  select c.customer_id,first_name,last_name,billing_country, 
  SUM (total) as total_spending,
  ROW_NUMBER() over(PARTITION by billing_country order by sum(total) desc) as rowno
  from invoice i
  join customer c on c.customer_id=i.customer_id
  group by c.customer_id,first_name,last_name,billing_country
  --order by 4 ASC, 5 desc 
  )
  select * from customer_with_country where rowno <= 1


   

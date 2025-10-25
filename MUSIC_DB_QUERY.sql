select * from album;
-- Q1
select * from artist;
select * from employee;
select * from employee order by levels desc limit 1;
-- Q2
select * from invoice;

select count(*) as c, billing_country from invoice group by billing_country order by c desc;
-- Q3
select * from invoice;
select * from invoice order by total desc limit 3;
select total from invoice order by total desc limit 3;
--Q4
select * from invoice;
select sum(total) as total_bill, billing_city from invoice group by billing_city order by total_bill desc;
-- Q5
SELECT * FROM CUSTOMER;
SELECT customer.customer_id,customer.first_name,customer.last_name, sum(invoice.total) as total1 from customer join invoice on invoice.customer_id=customer.customer_id group by customer.customer_id order by total1 desc limit 1;
-- Mode Q1
select * from customer;
select * from artist;
select * from genre;
select * from customer;
select distinct email,first_name, last_name  from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
)
order by email;

-- Q2
select artist.artist_id, artist.name, count(artist.artist_id) as no_of_songs
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
join genre on genre.genre_id=track.genre_id
where  genre.name like 'Rock'
group by artist.artist_id
order by no_of_songs desc
limit 10;


-- Q3
SELECT NAME, MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (
SELECT AVG(MILLISECONDS) AS AVG_TRACK_LENGTH FROM TRACK)
ORDER BY MILLISECONDS DESC;

--ADV Q1
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Q2
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1


--Q3
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1






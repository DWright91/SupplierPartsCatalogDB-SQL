-- SupplierPartsCatalogDB Script and Queries

-- Drop tables.
drop table suppliers cascade constraints;
drop table parts cascade constraints;
drop table catalog cascade constraints;

-- Create tables.
create table suppliers(
	sid number(9,0) primary key,
	sname varchar2(30),
	address varchar2(60)
	);
create table parts(
	pid number(9,0) primary key,
	pname varchar2(40),
	color varchar2(15)
	);
create table catalog(
	sid number(9,0),
	pid number(9,0),
	cost number(10,2),
	primary key(sid,pid),
	foreign key(sid) references suppliers,
	foreign key(pid) references parts
	);

-- Insert data into tables.
insert into suppliers (sid, sname, address) values (1,'Acme Widget Suppliers','1 Grub St., Potemkin Village, IL 61801');
insert into suppliers values (2,'Big Red Tool and Die','4 My Way, Bermuda Shorts, OR 90305');
insert into suppliers values (3,'Perfunctory Parts','99999 Short Pier, Terra Del Fuego, TX 41299');
insert into suppliers values (4,'Alien Aircaft Inc.','2 Groom Lake, Rachel, NV 51902');

insert into parts values (1,'Left Handed Bacon Stretcher Cover','Red');
insert into parts values (2,'Smoke Shifter End','Black');
insert into parts values (3,'Acme Widget Washer','Red');
insert into parts values (4,'Acme Widget Washer','Silver');
insert into parts values (5,'I Brake for Crop Circles Sticker','Translucent');
insert into parts values (6,'Anti-Gravity Turbine Generator','Cyan');
insert into parts values (7,'Anti-Gravity Turbine Generator','Magenta');
insert into parts values (8,'Fire Hydrant Cap','Red');
insert into parts values (9,'7 Segment Display','Green');

insert into catalog values (1,3,0.50);
insert into catalog values (1,4,0.50);
insert into catalog values (1,8,11.70);
insert into catalog values (2,3,0.55);
insert into catalog values (2,8,7.95);
insert into catalog values (2,1,16.50);
insert into catalog values (3,8,12.50);
insert into catalog values (3,9,1.00);
insert into catalog values (4,5,2.20);
insert into catalog values (4,6,1247548.23);
insert into catalog values (4,7,1247548.23);

-- Exercise 5.2 Queries.
-- 1). Find the pnames of parts for which there is some supplier.
select distinct P.pname
from Parts P, Catalog C
where P.pid = C.pid

-- 2). Find the snames of suppliers who supply every part.
SELECT S.sname
FROM Suppliers S, Parts P, Catalog C
WHERE S.sid = C.sid AND P.pid = C.pid

-- 3). Find the snames of suppliers who supply every red part.
SELECT DISTINCT S.sname
FROM Suppliers S, Parts P, Catalog C
WHERE P.color = 'Red'
AND C.pid = P.pid
AND C.sid = S.sid;

-- 4). Find the pnames of parts supplied by Acme Widget Suppliers and no one else.
SELECT P.pname
FROM
Parts P, Catalog C, Suppliers S
WHERE
P.pid = C.pid AND C.sid = S.sid
AND
S.sname = 'Acme Widget Suppliers'
AND NOT EXISTS ( SELECT *
FROM
Catalog C1, Suppliers S1
WHERE
P.pid = C1.pid AND C1.sid = S1.sid AND
S1.sname <> 'Acme Widget Suppliers' )

-- 5). Find the sids of suppliers who charge more for some part than the
--     average cost that part (averaged over all the suplliers who supply
--     that part).
SELECT DISTINCT C.sid
FROM
Catalog C
WHERE
C.cost > ( SELECT AVG (C1.cost)
FROM
Catalog C1
WHERE
C1.pid = C.pid )

-- 6). For each part, find the sname of the supplier who charges the most for that part.
SELECT DISTINCT P.pid, S.sname
FROM
Parts P, Suppliers S, Catalog C
WHERE
C.pid = P.pid
AND
C.sid = S.sid
AND
C.cost = (SELECT MAX (C1.cost)
FROM
Catalog C1
WHERE
C1.pid = P.pid)

-- 7). Find the sids of suppliers who supply only red parts.
SELECT DISTINCT C.sid
FROM
Catalog C
WHERE NOT EXISTS ( SELECT *
FROM
Parts P
WHERE
P.pid = C.pid AND P.color = 'Red' )

-- 8). Find the sids of suppliers who supply a red part and a green part.
SELECT DISTINCT C.sid
FROM
Catalog C, Parts P
WHERE
C.pid = P.pid AND P.color = 'Red'
INTERSECT
SELECT DISTINCT C1.sid
FROM
Catalog C1, Parts P1
WHERE
C1.pid = P1.pid AND P1.color = 'Green'

-- 9). Find the sids of suppliers who supply a red part or a green part.
SELECT DISTINCT C.sid
FROM
Catalog C, Parts P
WHERE
C.pid = P.pid AND P.color = 'Red'
UNION
SELECT DISTINCT C1.sid
FROM
Catalog C1, Parts P1
WHERE
C1.pid = P1.pid AND P1.color = 'Green'

-- 10). For every supplier that only supplies green parts, print the name of the
--      supplier and the total number of parts that she supplies.
SELECT
S.sname, COUNT(*) as PartCount
FROM
Suppliers S, Parts P, Catalog C
WHERE
P.pid = C.pid AND C.sid = S.sid
GROUP BY S.sname, S.sid
HAVING EVERY (P.color='Green')

-- 11). For every supplier that supplies a green part and a red part, print the
--      name and price of the most expensive part that she supplies. 
SELECT s.sname, max(c.cost) as "Most Expensive part"
FROM suppliers s join catalog_tbl
	on s.sid = c.sid
	join parts p
	on c.pid = p.pid
where lower(p.color) in ('green', 'red')
--or lower(p.color) = 'red' --or works
group by s.sname, s.sid

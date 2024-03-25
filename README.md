# Supplier Parts Catalog DB - SQL

Purpose: create SQL Database using the following schema, and write the following queries.

![image](https://github.com/DWright91/SupplierPartsCatalogDB-SQL/assets/94549091/ed4cb2ac-242d-4e89-8247-4b6c1971f257)
        
    

Exercise 4.4:
![image](https://github.com/DWright91/SupplierPartsCatalogDB-SQL/assets/94549091/f48df8ab-18b6-430b-86db-390d87d6212f)

    • 1). Find the suppler names of the suppliers who supply a red part that costs less than 100 dollars.
    • 2). This relational algebra query or statement does not return anythig because of the sequence of projection operators.
    • 3). Find the supplier names of the suppliers that supply a red part that costs less than 100 dollars and a green part that costs less than 100 dollars.
    • 4). Find supplier IDs of the suppliers who supply a red part that costs less than 100 dollars and a green part that costs less than 100 dollars
    • 5). Find the supplier names of the suppliers who supply a red part that costs less than 100 dollars and a green part that costs less tha 100 dollars.

----------------------------------------------------------------------------------------
Exercise 5.2:

The Catalog relation lists the prices charged for parts by Suppliers. Create these tables in SQL Developer, populate the tables, and write the following queries in SQL:

1.	Find the pnames of parts for which there is some supplier.

        select distinct P.pname
        from Parts P, Catalog C
        where P.pid = C.pid

2.	Find the snames of suppliers who supply every part.

        SELECT S.sname
        FROM Suppliers S, Parts P, Catalog C
        WHERE S.sid = C.sid AND P.pid = C.pid

3.	Find the snames of suppliers who supply every red part.

        SELECT DISTINCT S.sname
        FROM Suppliers S, Parts P, Catalog C
        WHERE P.color = 'Red'
        AND C.pid = P.pid
        AND C.sid = S.sid;

4.	Find the pnames of parts supplied by Acme Widget Suppliers and no one else.

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

5.	Find the sids of suppliers who charge more for some part than the average cost that part (averaged over all the suppliers who supply that part).

        SELECT DISTINCT C.sid
        FROM
        Catalog C
        WHERE
        C.cost > ( SELECT AVG (C1.cost)
        FROM
        Catalog C1
        WHERE
        C1.pid = C.pid )

6.	For each part, find the sname of the supplier who charges the most for that part.

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

7.	Find the sids of suppliers who supply only red parts.

        SELECT DISTINCT C.sid
        FROM
        Catalog C
        WHERE NOT EXISTS ( SELECT *
        FROM
        Parts P
        WHERE
        P.pid = C.pid AND P.color = 'Red' )

8.	Find the sids of suppliers who supply a red part and a green part.

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

9.	Find the sids of suppliers who supply a red part or a green part.

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

10.	For every supplier that only supplies green parts, print the name of the supplier and the total number of parts that she supplies.

        SELECT
        S.sname, COUNT(*) as PartCount
        FROM
        Suppliers S, Parts P, Catalog C
        WHERE
        P.pid = C.pid AND C.sid = S.sid
        GROUP BY S.sname, S.sid
        HAVING EVERY (P.color='Green')

11.	For every supplier that supplies a green part and a red part, print the name and price of the most expensive part that she supplies.

        SELECT s.sname, max(c.cost) as "Most Expensive part"
        FROM suppliers s join catalog_tbl
        on s.sid = c.sid
        join parts p
        on c.pid = p.pid
        where lower(p.color) in ('green', 'red')
        group by s.sname, s.sid

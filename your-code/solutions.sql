--- CHALLENGE 1
-- 1.1
SELECT
    s.title_id AS "Title ID",
    ta.au_id AS "Author ID",
    (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS "Royalty of each sale for each author"
FROM
    sales s
JOIN
    titles t ON s.title_id = t.title_id
JOIN
    titleauthor ta ON t.title_id = ta.title_id;


-- 1.2

SELECT
    Title_ID,
    Author_ID,
    SUM(Royalty_of_each_sale_for_each_author) AS Aggregated_royalties_of_each_title_for_each_author
FROM
    (SELECT
        t.title_id AS Title_ID,
        ta.au_id AS Author_ID,
        (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS Royalty_of_each_sale_for_each_author
    FROM
        titles t
    JOIN
        titleauthor ta ON t.title_id = ta.title_id
    JOIN
        sales s ON t.title_id = s.title_id) AS Subquery
GROUP BY
    Title_ID, Author_ID;

-- 1.3

WITH SalesRoyalties AS (
    SELECT
        ta.title_id AS Title_ID,
        ta.au_id AS Author_ID,
        (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS Sales_Royalty
    FROM
        sales AS s
    JOIN
        titleauthor ta ON s.title_id = ta.title_id
    JOIN
        titles t ON s.title_id = t.title_id
),
AuthorProfits AS (
    SELECT
        r.Author_ID,
        SUM(r.Sales_Royalty) + t.advance AS Profit
    FROM
        SalesRoyalties AS r
    JOIN
        titles t ON r.Title_ID = t.title_id
    GROUP BY
        r.Author_ID, t.advance
)
SELECT
    Author_ID,
    SUM(Profit) AS Profit
FROM
    AuthorProfits
GROUP BY
    Author_ID
ORDER BY
    Profit DESC
    
LIMIT 3;

-- CHALLENGE 2


--2.1
CREATE TEMPORARY TABLE TempSalesRoyalties AS
SELECT
    ta.title_id AS Title_ID,
    ta.au_id AS Author_ID,
    (t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100) AS Sales_Royalty
FROM
    sales s
JOIN
    titleauthor ta ON s.title_id = ta.title_id
JOIN
    titles t ON s.title_id = t.title_id;


--2.2
CREATE TEMPORARY TABLE TempAggregatedRoyalties AS
SELECT
    Title_ID,
    Author_ID,
    SUM(Sales_Royalty) AS Aggregated_Royalties
FROM
    TempRoyalties
GROUP BY
    Title_ID, Author_ID;

SELECT
    Title_ID,
    Author_ID,
    Aggregated_Royalties
FROM
    TempAggregatedRoyalties;

--2.3
SELECT
    Author_ID,
    SUM(Profit) AS Profit
FROM
    TempAuthorProfits
GROUP BY
    Author_ID
ORDER BY
    Profit DESC;

-- CHALLENGE 3

CREATE TABLE most_profiting_authors AS
SELECT
    Author_ID,
    SUM(Profit) AS Profit
FROM
    TempAuthorProfits
GROUP BY
    Author_ID
ORDER BY
    Profit DESC;
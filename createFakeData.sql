/* Create 4 users */
INSERT INTO profile (id, name)  SELECT id, 'asimister' from auth.users where email = 'a@a.com';
INSERT INTO profile (id, name)  SELECT id, 'martinecko' from auth.users where email = 'm@m.com';
INSERT INTO profile (id, name)  SELECT id, 'samko' from auth.users where email = 's@s.com';
INSERT INTO profile (id, name)  SELECT id, 'petko' from auth.users where email = 'p@p.com';

/* Create group 'chata' */
INSERT INTO user_group (name) VALUES ('chata');

/* Create expense 'vinko' */
INSERT INTO expense (name, group_id, paying_user_id, amount, currency) 
SELECT 'vinko', g.id, p.id, 12, 'EUR'  
from profile as p
join user_group as g on true
where p.name = 'petko';

/* Create 4 expense participants */
INSERT INTO expense_participant (expense_id, user_id, amount, version_number)
SELECT e.id, p.id, e.amount/4, 1
FROM expense AS e
JOIN profile AS p ON TRUE
WHERE p.name IN ('petko', 'martinecko', 'samko', 'asimister')
GROUP BY e.id, p.id;

/* Update the record (create a new one with higher version_number) so that Samko isn't included */
INSERT INTO expense_participant (expense_id, user_id, amount, version_number)
SELECT e.id, p.id, e.amount/3, 2
FROM expense AS e
JOIN profile AS p ON TRUE
WHERE p.name IN ('petko', 'martinecko', 'asimister')
GROUP BY e.id, p.id;

-- select * 
-- from expense as e
-- join user_group as g on e.group_id = g.id
-- join profile as p on e.paying_user_id = p.id;
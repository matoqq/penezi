/* Create currencies */
INSERT INTO currency (code) VALUES ('EUR'), ('CZK'), ('GBP');

/* Create 4 users */
INSERT INTO profile (id, name)  SELECT id, 'asimister' from auth.users where email = 'a@a.com';
INSERT INTO profile (id, name)  SELECT id, 'martinecko' from auth.users where email = 'm@m.com';
INSERT INTO profile (id, name)  SELECT id, 'samko' from auth.users where email = 's@s.com';
INSERT INTO profile (id, name)  SELECT id, 'petko' from auth.users where email = 'p@p.com';

/* Create group 'chata' */
INSERT INTO user_group (name) VALUES ('chata');

/* Create records of new users in group 'chata' */
INSERT INTO group_participant (user_id, group_id)
SELECT p.id, g.id
FROM profile AS p
JOIN user_group AS g ON g.name = 'chata';

/* Create expense 'vinko' */
INSERT INTO expense (name, group_id, paying_user_id, amount, currency) 
SELECT 'vinko', g.id, p.id, 12, 'EUR'  
from profile as p
join user_group as g on true
where p.name = 'petko';

/* Create expense 'cokolada' */
INSERT INTO expense (name, group_id, paying_user_id, amount, currency) 
SELECT 'cokolada', g.id, p.id, 5, 'EUR'  
from profile as p
join user_group as g on true
where p.name = 'samko';

/* Create expense 'benzin' */
INSERT INTO expense (name, group_id, paying_user_id, amount, currency) 
SELECT 'benzin', g.id, p.id, 6, 'EUR'  
from profile as p
join user_group as g on true
where p.name = 'martinecko';

/* Create 4 expense participants */
INSERT INTO expense_participant (expense_id, user_id, amount, version_number)
SELECT e.id, p.id, e.amount/4, 1
FROM expense AS e
JOIN profile AS p ON TRUE
WHERE p.name IN ('petko', 'martinecko', 'samko', 'asimister')
AND e.name = 'vinko'
GROUP BY e.id, p.id;

/* Update the record (create a new one with higher version_number) so that Samko isn't included */
INSERT INTO expense_participant (expense_id, user_id, amount, version_number)
SELECT e.id, p.id, e.amount/3, 2
FROM expense AS e
JOIN profile AS p ON TRUE
WHERE p.name IN ('petko', 'martinecko', 'asimister')
AND e.name = 'vinko'
GROUP BY e.id, p.id;

/* Create 3 expense_participants for 'cokoladka' */
INSERT INTO expense_participant (expense_id, user_id, amount, version_number)
SELECT e.id, p.id, e.amount/3, 1
FROM expense AS e
JOIN profile AS p ON TRUE
WHERE p.name IN ('martinecko', 'samko', 'asimister')
AND e.name = 'cokolada'
GROUP BY e.id, p.id;

/* Create 2 expense_participants for 'benzin' */
INSERT INTO expense_participant (expense_id, user_id, amount, version_number)
SELECT e.id, p.id, e.amount/1, 1
FROM expense AS e
JOIN profile AS p ON TRUE
WHERE p.name IN ('asimister')
AND e.name = 'benzin'
GROUP BY e.id, p.id;

/* Create records for each debtor in group 'chata' */
--INSERT INTO group_balance (group_id, benefactor_id, beneficiary_id, amount)
SELECT
  id as group_id, 
  paying_user_id as benefactor_id, 
  user_id as beneficiary_id,
  SUM(amount) as total,
  wallet_master,
  loan_slave
FROM (
  SELECT g.id, e.paying_user_id, ep.user_id, ep.amount, p.name as wallet_master, p2.name as loan_slave, DENSE_RANK() OVER(PARTITION BY e.id ORDER BY ep.version_number desc) AS rank
  FROM expense as e
  JOIN expense_participant as ep on ep.expense_id = e.id
  JOIN user_group as g on g.id = e.group_id
  JOIN profile as p on p.id = e.paying_user_id
  JOIN profile as p2 on p2.id = ep.user_id
  WHERE g.name = 'chata'
) AS t
WHERE 
  rank = 1
  AND wallet_master != loan_slave
GROUP BY group_id, benefactor_id, beneficiary_id, wallet_master, loan_slave;
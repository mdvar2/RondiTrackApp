-- Removes exactly what add_test_contributions.sql added: every row whose
-- id starts feedfeed-, and Lerato's membership of that stokvel. Nothing
-- else in the database has such an id, so nothing else is touched.
\set ON_ERROR_STOP on
BEGIN;

DELETE FROM "Contributions" WHERE "Id"::text LIKE 'feedfeed-%';
DELETE FROM "ContributionArrears"
WHERE "StokvelId"::text LIKE 'feedfeed-%';
DELETE FROM "StokvelMembers" WHERE "StokvelId"::text LIKE 'feedfeed-%';
DELETE FROM "ContributionCycles" WHERE "Id"::text LIKE 'feedfeed-%';
DELETE FROM "Users" WHERE "Id"::text LIKE 'feedfeed-%';
DELETE FROM "Stokvels" WHERE "Id"::text LIKE 'feedfeed-%';

COMMIT;

SELECT
  (SELECT count(*) FROM "Contributions" WHERE "Id"::text LIKE 'feedfeed-%')
    AS contributions_left,
  (SELECT count(*) FROM "Users" WHERE "Id"::text LIKE 'feedfeed-%')
    AS users_left;

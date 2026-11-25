-- Adds a stokvel of 300 test members, each with one contribution, to a
-- LOCAL seed database, for measuring the contributions list (README
-- "Performance"). Lerato (the seed treasurer) is its Treasurer, so she can
-- open its list on the phone.
--
-- Every row this adds has an id starting feedfeed-, and nothing else in
-- the database does. remove_test_contributions.sql deletes exactly those.
-- Never run against data you can't put back: tool/perf/perf_data.sh only
-- connects to localhost.
\set ON_ERROR_STOP on
BEGIN;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM "Stokvels" WHERE "Id"::text LIKE 'feedfeed-%') THEN
    RAISE EXCEPTION 'Test contributions are already in. Remove them first.';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM "Users" WHERE "NormalizedEmail" = 'lerato@ronditrack.example'
  ) THEN
    RAISE EXCEPTION 'No seed treasurer (lerato@ronditrack.example): run the API dev seed first.';
  END IF;
END $$;

INSERT INTO "Stokvels" ("Id", "Name", "ContributionAmount")
VALUES ('feedfeed-0000-4000-8000-000000000001', 'Perf Test Stokvel', 500);

INSERT INTO "ContributionCycles"
  ("Id", "StokvelId", "Period", "TargetAmount", "Status", "EndDate")
VALUES ('feedfeed-0000-4000-8000-000000000002',
        'feedfeed-0000-4000-8000-000000000001',
        '2026-11', 150000, 'Open', DATE '2026-11-30');

-- Lerato, as Treasurer.
INSERT INTO "StokvelMembers" ("StokvelId", "UserId", "JoinedAtUtc", "Role")
SELECT 'feedfeed-0000-4000-8000-000000000001', "Id", now(), 'Treasurer'
FROM "Users" WHERE "NormalizedEmail" = 'lerato@ronditrack.example';

-- 300 test members: no password, so nobody can sign in as them.
INSERT INTO "Users"
  ("Id", "Name", "Email", "PasswordHash", "PlatformRole")
SELECT ('feedfeed-0001-4000-8000-' || lpad(i::text, 12, '0'))::uuid,
       'Test Member ' || lpad(i::text, 3, '0'),
       'perf-' || lpad(i::text, 3, '0') || '@perf.ronditrack.test',
       NULL,
       'User'
FROM generate_series(1, 300) AS i;

INSERT INTO "StokvelMembers" ("StokvelId", "UserId", "JoinedAtUtc", "Role")
SELECT 'feedfeed-0000-4000-8000-000000000001',
       ('feedfeed-0001-4000-8000-' || lpad(i::text, 12, '0'))::uuid,
       now(), 'Member'
FROM generate_series(1, 300) AS i;

-- One contribution each, a minute apart; every seventh is Confirmed.
INSERT INTO "Contributions"
  ("Id", "StokvelId", "UserId", "ContributionCycleId", "Amount",
   "RecordedAtUtc", "Status")
SELECT ('feedfeed-0002-4000-8000-' || lpad(i::text, 12, '0'))::uuid,
       'feedfeed-0000-4000-8000-000000000001',
       ('feedfeed-0001-4000-8000-' || lpad(i::text, 12, '0'))::uuid,
       'feedfeed-0000-4000-8000-000000000002',
       500,
       TIMESTAMPTZ '2026-11-01 08:00:00+00' + make_interval(mins => i),
       CASE WHEN i % 7 = 0 THEN 'Confirmed' ELSE 'Paid' END
FROM generate_series(1, 300) AS i;

COMMIT;

SELECT count(*) AS test_contributions_added
FROM "Contributions" WHERE "Id"::text LIKE 'feedfeed-%';

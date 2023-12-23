DROP TABLE debt_settlement CASCADE;
DROP TABLE expense CASCADE;
DROP TABLE expense_participant CASCADE;
DROP TABLE group_balance CASCADE;
DROP TABLE group_participant CASCADE;
DROP TABLE profile CASCADE;
DROP TABLE user_group CASCADE;
DROP TABLE currency CASCADE;

CREATE TABLE debt_settlement (
  id uuid PRIMARY KEY default gen_random_uuid(),
  paying_user_id uuid NOT NULL,
  beneficiary_user_id uuid NOT NULL,
  amount int NOT NULL,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE expense (
  id uuid PRIMARY KEY default gen_random_uuid(),
  name text NOT NULL,
  group_id uuid NOT NULL,
  paying_user_id uuid NOT NULL,
  amount int NOT NULL,
  currency text NOT NULL,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE expense_participant (
  id uuid PRIMARY KEY default gen_random_uuid(),
  expense_id uuid NOT NULL,
  user_id uuid NOT NULL,
  amount int NOT NULL,
  version_number int NOT NULL,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE group_balance (
  id uuid PRIMARY KEY default gen_random_uuid(),
  group_id uuid NOT NULL,
  benefactor_id uuid NOT NULL,
  beneficiary_id uuid NOT NULL,
  amount int NOT NULL,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE group_participant (
  id uuid PRIMARY KEY default gen_random_uuid(),
  user_id uuid NOT NULL,
  group_id uuid NOT NULL,
  is_active bool NOT NULL default TRUE,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE profile (
  id uuid PRIMARY KEY default gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE user_group (
  id uuid PRIMARY KEY default gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz NOT NULL default now(),
  updated_at timestamptz NOT NULL default now()
);
CREATE TABLE currency (
  code text PRIMARY KEY
);


-- Relations
ALTER TABLE debt_settlement ADD FOREIGN KEY (paying_user_id) REFERENCES profile (id);
ALTER TABLE debt_settlement ADD FOREIGN KEY (beneficiary_user_id) REFERENCES profile (id);

ALTER TABLE expense ADD FOREIGN KEY (group_id) REFERENCES user_group (id);
ALTER TABLE expense ADD FOREIGN KEY (paying_user_id) REFERENCES profile (id);
ALTER TABLE expense ADD FOREIGN KEY (currency) REFERENCES currency (code);

ALTER TABLE expense_participant ADD FOREIGN KEY (expense_id) REFERENCES expense (id);
ALTER TABLE expense_participant ADD FOREIGN KEY (user_id) REFERENCES profile (id);

ALTER TABLE group_balance ADD FOREIGN KEY (group_id) REFERENCES user_group (id);
ALTER TABLE group_balance ADD FOREIGN KEY (benefactor_id) REFERENCES profile (id);
ALTER TABLE group_balance ADD FOREIGN KEY (beneficiary_id) REFERENCES profile (id);

ALTER TABLE group_participant ADD FOREIGN KEY (user_id) REFERENCES profile (id);
ALTER TABLE group_participant ADD FOREIGN KEY (group_id) REFERENCES user_group (id);

ALTER TABLE public.profile ADD FOREIGN KEY (id) REFERENCES auth.users (id);

/* Enable Row Level Security */
ALTER TABLE debt_settlement ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_participant ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_balance ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_participant ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_group ENABLE ROW LEVEL SECURITY;
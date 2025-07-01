-- ------------------------------
-- OPTION
-- ------------------------------

OPTION IMPORT;

-- ------------------------------
-- ACCESSES
-- ------------------------------

DEFINE ACCESS auth0 ON DATABASE TYPE RECORD WITH JWT URL 'https://dev-5krezjctqt2gwxge.jp.auth0.com/.well-known/jwks.json' AUTHENTICATE { IF ($token.aud.is_array() AND $token.aud CONTAINS '06bpmmcoatqbdejl287p05gtno' AND $token.aud CONTAINS 'https://dev-5krezjctqt2gwxge.jp.auth0.com/userinfo' AND $token['https://surrealdb.com/email_verified'] = true) { RETURN (UPSERT ONLY users CONTENT { email: $token['https://surrealdb.com/email'], id: $token.sub }); }; } DURATION FOR TOKEN 1h, FOR SESSION NONE;

-- ------------------------------
-- FUNCTIONS
-- ------------------------------

DEFINE FUNCTION fn::get_users() {
LET $res = api::invoke('/users', { headers: { DB: 'dev', NS: 'test' }, method: 'GET' });
RETURN $res.body;
} PERMISSIONS FULL;

-- ------------------------------
-- TABLE: owns
-- ------------------------------

DEFINE TABLE owns TYPE ANY SCHEMALESS PERMISSIONS NONE;

DEFINE FIELD in ON owns TYPE record<tenant> PERMISSIONS FULL;
DEFINE FIELD out ON owns TYPE record<person> PERMISSIONS FULL;



-- ------------------------------
-- TABLE DATA: owns
-- ------------------------------

INSERT RELATION [ { __: true, id: owns:9pkgsggsjyvzjnj3ylst, in: tenant:acme, out: person:jane, since: d'2025-06-26T02:45:34.325137295Z' }, { __: true, id: owns:hlinyvb6r2e6cdntajoa, in: tenant:beta, out: person:john, since: d'2025-06-26T02:36:38.817845880Z' }, { __: true, id: owns:iize7aeosu6u1vv1rukj, in: tenant:acme, out: person:john, since: d'2025-06-26T02:32:07.727870838Z' } ];

-- ------------------------------
-- TABLE: person
-- ------------------------------

DEFINE TABLE person TYPE ANY SCHEMALESS PERMISSIONS FOR select, create, update WHERE $auth.id != NONE, FOR delete NONE;




-- ------------------------------
-- TABLE DATA: person
-- ------------------------------

INSERT [ { id: person:jane, name: 'Jane Smith', telegram_id: '987654321' }, { id: person:john, name: 'John Doe', telegram_id: '123456789' } ];

-- ------------------------------
-- TABLE: tenant
-- ------------------------------

DEFINE TABLE tenant TYPE ANY SCHEMALESS PERMISSIONS NONE;




-- ------------------------------
-- TABLE DATA: tenant
-- ------------------------------

INSERT [ { id: tenant:acme, name: 'Acme Inc', slug: 'acme' }, { id: tenant:beta, name: 'Beta Ltd', slug: 'beta' } ];

-- ------------------------------
-- TABLE: users
-- ------------------------------

DEFINE TABLE users TYPE ANY SCHEMALESS PERMISSIONS FOR select, create, update WHERE id = $auth.id, FOR delete NONE;




-- ------------------------------
-- TABLE DATA: users
-- ------------------------------

INSERT [ { email: 'awadakendagua996@gmail.com', id: users:⟨google-oauth2|106723226693763790721⟩ } ];


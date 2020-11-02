-- LOGIN as root user of RDS instance
-- CREATE EXTENSION can only be run as root user

CREATE ROLE mypkgname INHERIT;
CREATE ROLE mypkgname_admin INHERIT LOGIN IN ROLE mypkgname ENCRYPTED PASSWORD '' VALID UNTIL 'infinity';
CREATE ROLE mypkgname_prod INHERIT LOGIN IN ROLE mypkgname ENCRYPTED PASSWORD '' VALID UNTIL 'infinity';

CREATE DATABASE mypkgname_prod;

REVOKE CONNECT ON DATABASE mypkgname_prod     FROM PUBLIC;

REVOKE ALL ON SCHEMA public               FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;

GRANT ALL ON DATABASE mypkgname_prod     TO mypkgname_admin;
GRANT ALL ON SCHEMA public TO mypkgname_admin;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO mypkgname_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO mypkgname_admin;
GRANT ALL ON ALL TABLES IN SCHEMA public TO mypkgname_admin;

GRANT CONNECT ON DATABASE mypkgname_prod     TO mypkgname;

\c mypkgname_prod
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
SET ROLE mypkgname_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT ALL ON FUNCTIONS TO mypkgname_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT ALL ON SEQUENCES TO mypkgname_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT ALL ON TYPES TO mypkgname_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin
  GRANT ALL ON SCHEMAS TO mypkgname_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT ALL ON TABLES TO mypkgname_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT EXECUTE ON FUNCTIONS TO mypkgname;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT ALL ON SEQUENCES TO mypkgname;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT USAGE ON TYPES TO mypkgname;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin
  GRANT USAGE ON SCHEMAS TO mypkgname;
ALTER DEFAULT PRIVILEGES FOR ROLE mypkgname_admin IN SCHEMA public
  GRANT SELECT,
        INSERT,
        UPDATE,
        DELETE ON TABLES TO mypkgname;
RESET ROLE;
GRANT USAGE   ON SCHEMA public  TO mypkgname;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO mypkgname;
GRANT ALL     ON ALL SEQUENCES IN SCHEMA public TO mypkgname;
GRANT SELECT,
      INSERT,
      UPDATE,
      DELETE  ON ALL TABLES IN SCHEMA public TO mypkgname;

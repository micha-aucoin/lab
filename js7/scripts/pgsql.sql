/*
 | Tables for PostGres
 | SOS GmbH, 2022-11-30
*/

/* Table for IAM_BLOCKLIST */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_BLOCKLIST' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_BLOCKLIST (
                    "ID"                     BIGINT          NOT NULL,
                    "ACCOUNT_NAME"           VARCHAR(255)    NOT NULL,
                    "COMMENT"                VARCHAR(255)    NOT NULL,
                    "SINCE"                  TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("ID")
                )';
       
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_BLOCKLIST' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_BLOCKLIST
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for IAM_HISTORY */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_HISTORY' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_HISTORY (
                    "ID"                     BIGINT       NOT NULL,
                    "ACCOUNT_NAME"           VARCHAR(255) NOT NULL,
                    "LOGIN_DATE"             TIMESTAMP    NOT NULL,
                    "LOGIN_SUCCESS"          NUMERIC(1)   DEFAULT 0     NOT NULL,
                    PRIMARY KEY ("ID")
                )';
       
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_HISTORY' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_HISTORY
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
 
/* Table for IAM_HISTORY_DETAILS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_HISTORY_DETAILS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_HISTORY_DETAILS (
                    "ID"                       BIGINT        NOT NULL,
                    "IAM_HISTORY_ID"           BIGINT        NOT NULL,
                    "IDENTITY_SERVICE_NAME"    VARCHAR(255)  NOT NULL,
                    "MESSAGE"                  VARCHAR(2000) NOT NULL,
                    PRIMARY KEY ("ID")
                )';
       
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_HISTORY_DETAILS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_HISTORY_DETAILS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

 
/* Table for IAM_ACCOUNTS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_ACCOUNTS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_ACCOUNTS (
                    "ID"                     BIGINT       NOT NULL,
                    "IDENTITY_SERVICE_ID"    BIGINT       NOT NULL,
                    "ACCOUNT_NAME"           VARCHAR(255) NOT NULL,
                    "ACCOUNT_PASSWORD"       VARCHAR(255) NOT NULL,
                    "EMAIL"                  VARCHAR(255),
                    "FORCE_PASSWORD_CHANGE"  NUMERIC(1)   DEFAULT 0     NOT NULL,
                    "DISABLED"               NUMERIC(1)   DEFAULT 0     NOT NULL,
                    CONSTRAINT UNIQUE_IAM_A_IN UNIQUE ("IDENTITY_SERVICE_ID","ACCOUNT_NAME"),
                    PRIMARY KEY ("ID")
                )';
       
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_ACCOUNTS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_ACCOUNTS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for IAM_FIDO2_DEVICES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_FIDO2_DEVICES' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_FIDO2_DEVICES (
                    "ID"                     BIGINT        NOT NULL,
                    "IDENTITY_SERVICE_ID"    BIGINT        NOT NULL,
                    "ACCOUNT_ID"             BIGINT        NOT NULL,
                    "PUBLIC_KEY"             VARCHAR(1024) NOT NULL,
                    "ALGORITHM"              VARCHAR(60)   NOT NULL,
                    "CREDENTIAL_ID"          VARCHAR(255),
                    "ORIGIN"                 VARCHAR(255)  NOT NULL,
                    PRIMARY KEY ("ID")
                )';
       
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_FIDO2_DEVICES' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_FIDO2_DEVICES
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

 
/* Table for IAM_ROLES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_ROLES' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_ROLES (
                    "ID"                    BIGINT       NOT NULL,
                    "IDENTITY_SERVICE_ID"   BIGINT       NOT NULL,
                    "ROLE_NAME"             VARCHAR(255) NOT NULL,
                    "ORDERING"              NUMERIC(10)  NULL,
                    CONSTRAINT UNIQUE_IAM_A_IA UNIQUE ("IDENTITY_SERVICE_ID","ROLE_NAME"),
                    PRIMARY KEY ("ID")
                )';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_ROLES' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_ROLES
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table for IAM_ACCOUNT2ROLES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_ACCOUNT2ROLES' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_ACCOUNT2ROLES(
                    "ID"              BIGINT  NOT NULL,
                    "ROLE_ID"         BIGINT  NOT NULL,
                    "ACCOUNT_ID"      BIGINT  NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_ACCOUNT2ROLES' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_ACCOUNT2ROLES
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table for IAM_PERMISSIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_PERMISSIONS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_PERMISSIONS(
                    "ID"                    BIGINT       NOT NULL,
                    "IDENTITY_SERVICE_ID"   BIGINT       NOT NULL,
                    "CONTROLLER_ID"         VARCHAR(255) NULL,
                    "ACCOUNT_ID"            BIGINT       NULL,
                    "ROLE_ID"               BIGINT       NULL,
                    "ACCOUNT_PERMISSION"    VARCHAR(255) NULL,
                    "FOLDER_PERMISSION"     VARCHAR(255) NULL,
                    "EXCLUDED"              NUMERIC(1)   DEFAULT 0     NOT NULL,
                    "RECURSIVE"             NUMERIC(1)   DEFAULT 0     NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_PERMISSIONS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_PERMISSIONS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table for IAM_IDENTITY_SERVICES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_IDENTITY_SERVICES' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_IDENTITY_SERVICES(
                    "ID"                      BIGINT       NOT NULL,
                    "IDENTITY_SERVICE_TYPE"   VARCHAR(255) NOT NULL,
                    "IDENTITY_SERVICE_NAME"   VARCHAR(255) NOT NULL,
                    "SECOND_FACTOR_IS_ID"     BIGINT,
                    "AUTHENTICATION_SCHEME"   VARCHAR(255) NOT NULL,
                    "SECOND_FACTOR"           NUMERIC(1)   DEFAULT 0     NOT NULL,
                    "ORDERING"                NUMERIC(10)  DEFAULT 0     NOT NULL,
                    "REQUIRED"                NUMERIC(1)   DEFAULT 0     NOT NULL,
                    "DISABLED"                NUMERIC(1)   DEFAULT 0     NOT NULL,
                    CONSTRAINT UNIQUE_IAM_S_N UNIQUE ("IDENTITY_SERVICE_NAME"),
                    PRIMARY KEY ("ID")
                )';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_IDENTITY_SERVICES' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_IDENTITY_SERVICES
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for IAM_FIDO2_REGISTRATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_FIDO2_REGISTRATIONS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_FIDO2_REGISTRATIONS(
                               "ID"                  BIGINT         NOT NULL,
                               "EMAIL"               VARCHAR(255)   NOT NULL,
                               "IDENTITY_SERVICE_ID" BIGINT         NOT NULL,
                               "ACCOUNT_NAME"        VARCHAR(255)   NOT NULL,
                               "TOKEN"               VARCHAR(255),
                               "PUBLIC_KEY"          VARCHAR(1024),
                               "ALGORITHM"           VARCHAR(60),
                               "CREDENTIAL_ID"       VARCHAR(255),
                               "ORIGIN"              VARCHAR(255),
                               "DEFERRED"            NUMERIC(1)     DEFAULT 0     NOT NULL,
                               "CONFIRMED"           NUMERIC(1)     DEFAULT 0     NOT NULL,
                               "COMPLETED"           NUMERIC(1)     DEFAULT 0     NOT NULL,
                               "CHALLENGE"           VARCHAR(255),
                               "CREATED"             TIMESTAMP      NOT NULL,                                
                    CONSTRAINT UNIQUE_IAM_FIDO2_IID_AN UNIQUE ("IDENTITY_SERVICE_ID","ACCOUNT_NAME"),       
                    PRIMARY KEY ("ID")
                )';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_IAM_FIDO2_REGISTRATIONS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_FIDO2_REGISTRATIONS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for IAM_FIDO2_REQUESTS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='IAM_FIDO2_REQUESTS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE IAM_FIDO2_REQUESTS(
                               "ID"                  BIGINT         NOT NULL,
                               "IDENTITY_SERVICE_ID" BIGINT         NOT NULL,
                               "CHALLENGE"           VARCHAR(255)   NOT NULL,
                               "REQUEST_ID"          VARCHAR(255)   NOT NULL,
                               "CREATED"             TIMESTAMP      NOT NULL,                                
                    PRIMARY KEY ("ID")
                )';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_IAM_FIDO2_REQUESTS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_IAM_FIDO2_REQUESTS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;




 
/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Tables for PostGres
 | SOS GmbH, 2021-05-28
*/

/* Table for DPL_ORDERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='DPL_ORDERS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE DPL_ORDERS (
                    "ID"                        BIGINT          NOT NULL,
                    "SUBMISSION_HISTORY_ID"     BIGINT          NOT NULL,
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "WORKFLOW_NAME"             VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "WORKFLOW_PATH"             VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "WORKFLOW_FOLDER"           VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "ORDER_ID"                  VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "ORDER_NAME"                VARCHAR(30)     DEFAULT ''.'' NOT NULL,
                    "SCHEDULE_NAME"             VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "SCHEDULE_PATH"             VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "SCHEDULE_FOLDER"           VARCHAR(255)    DEFAULT ''.'' NOT NULL,
                    "CALENDAR_ID"               BIGINT          NOT NULL,
                    "START_MODE"                NUMERIC(1)      DEFAULT 0     NOT NULL,
                    "SUBMITTED"                 NUMERIC(1)      DEFAULT 0     NOT NULL,
                    "SUBMIT_TIME"               TIMESTAMP       NULL,
                    "PERIOD_BEGIN"              TIMESTAMP       NULL,
                    "PERIOD_END"                TIMESTAMP       NULL,
                    "REPEAT_INTERVAL"           INTEGER         NULL,
                    "PLANNED_START"             TIMESTAMP       NOT NULL,
                    "EXPECTED_END"              TIMESTAMP       NULL,
                    "ORDER_PARAMETERISATION"    VARCHAR(1000)   NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    "MODIFIED"                  TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_DPL_O_SHID    ON DPL_ORDERS("SUBMISSION_HISTORY_ID")';
        EXECUTE 'CREATE INDEX IDX_DPL_O_ON      ON DPL_ORDERS("ORDER_NAME")';
        EXECUTE 'CREATE INDEX IDX_DPL_O_OID     ON DPL_ORDERS("ORDER_ID")';
        EXECUTE 'CREATE INDEX IDX_DPL_O_PSCID   ON DPL_ORDERS("PLANNED_START","CONTROLLER_ID")';
        EXECUTE 'CREATE INDEX IDX_DPL_O_WN      ON DPL_ORDERS("WORKFLOW_NAME")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_DPL_ORDERS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_DPL_ORDERS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for DPL_SUBMISSIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='DPL_SUBMISSIONS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE DPL_SUBMISSIONS (
                    "ID"                    BIGINT       NOT NULL,
                    "CONTROLLER_ID"         VARCHAR(100) NOT NULL,
                    "SUBMISSION_FOR_DATE"   TIMESTAMP    NOT NULL,
                    "USER_ACCOUNT"          VARCHAR(255) NOT NULL,
                    "CREATED"               TIMESTAMP    NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_DPL_S_SFDCID ON DPL_SUBMISSIONS("SUBMISSION_FOR_DATE","CONTROLLER_ID")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_DPL_SUBMISSIONS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_DPL_SUBMISSIONS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for DPL_HISTORY */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='DPL_HISTORY' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE DPL_HISTORY(
                    "ID"                    BIGINT        NOT NULL,
                    "CONTROLLER_ID"         VARCHAR(100)  NOT NULL,
                    "SUBMITTED"             NUMERIC(1)    DEFAULT 0 NOT NULL,
                    "MESSAGE"               VARCHAR(2000) NULL,
                    "DAILY_PLAN_DATE"       TIMESTAMP     NOT NULL,
                    "ORDER_ID"              VARCHAR(255)  NULL,
                    "WORKFLOW_PATH"         VARCHAR(255)  NULL,
                    "WORKFLOW_FOLDER"       VARCHAR(255)  NULL,
                    "SCHEDULED_FOR"         TIMESTAMP     NULL, 
                    "USER_ACCOUNT"          VARCHAR(255)  NOT NULL,
                    "SUBMISSION_TIME"       TIMESTAMP     NOT NULL,
                    "CREATED"               TIMESTAMP     NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_DPL_H_DPDSCID ON DPL_HISTORY("DAILY_PLAN_DATE","SUBMITTED","CONTROLLER_ID")';
        EXECUTE 'CREATE INDEX IDX_DPL_H_OID     ON DPL_HISTORY("ORDER_ID")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_DPL_HISTORY' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_DPL_HISTORY
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for DPL_ORDER_VARIABLES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='DPL_ORDER_VARIABLES' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE DPL_ORDER_VARIABLES(
                    "ID"                    BIGINT        NOT NULL,
                    "CONTROLLER_ID"         VARCHAR(100)  NOT NULL,
                    "ORDER_ID"              VARCHAR(255)  NOT NULL,
                    "VARIABLE_VALUE"        TEXT          NOT NULL,
                    "CREATED"               TIMESTAMP     NOT NULL,
                    "MODIFIED"              TIMESTAMP     NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_DPL_OV_OIDCID ON DPL_ORDER_VARIABLES("ORDER_ID","CONTROLLER_ID")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_DPL_ORDER_VARS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_DPL_ORDER_VARS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for DPL_PROJECTIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='DPL_PROJECTIONS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE DPL_PROJECTIONS(
                    "ID"        NUMERIC(6)  NOT NULL,
                    "CONTENT"   BYTEA       NOT NULL,
                    "CREATED"   TIMESTAMP   NOT NULL,
                    PRIMARY KEY ("ID")
                )';
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Tables for PostGres
 | SOS GmbH, 2021-05-28
*/


/* Table for DEP_HISTORY */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_DEP_HIS' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_DEP_HIS
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='DEP_HISTORY';
IF c = 0 THEN EXECUTE '
CREATE TABLE DEP_HISTORY (
    "ID"              BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_DEP_HIS''),
    "ACCOUNT"         VARCHAR(100)        NOT NULL,
    "PATH"            VARCHAR(255)        NOT NULL,
    "FOLDER"          VARCHAR(255)        NOT NULL,
    "NAME"            VARCHAR(255)        DEFAULT '''' NOT NULL,
    "TITLE"           VARCHAR(255)        NULL,
    "TYPE"            SMALLINT            NOT NULL,
    "INV_CID"         BIGINT              NOT NULL,
    "INV_IID"         BIGINT              NOT NULL,   /* Inventory Instance ID */
    "CONTROLLER_ID"   VARCHAR(100)        NOT NULL,
    "CONTENT"         TEXT                NOT NULL,
    "INV_CONTENT"     TEXT                DEFAULT '''' NOT NULL,
    "SIGNATURE"       VARCHAR(2000)       NOT NULL,
    "COMMIT_ID"       VARCHAR(255)        NULL,
    "VERSION"         VARCHAR(50)         NULL,
    "OPERATION"       SMALLINT            NULL,       /* UPDATE, DELETE */
    "STATE"           SMALLINT            NOT NULL,   /* DEPLOYED, NOT_DEPLOYED */
    "ERROR_MESSAGE"   VARCHAR(255)        NULL,       /* ERROR MESSAGE */
    "DEPLOYMENT_DATE" TIMESTAMP           NOT NULL,
    "DELETED_DATE"    TIMESTAMP           NULL,
    "AUDITLOG_ID"     BIGINT              NULL,
    CONSTRAINT UNIQUE_DH_NTCC UNIQUE ("NAME", "TYPE", "CONTROLLER_ID", "COMMIT_ID"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_DH_P                     ON DEP_HISTORY("PATH")
'; EXECUTE '
CREATE INDEX IDX_DH_N                     ON DEP_HISTORY("NAME")
'; EXECUTE '
CREATE INDEX IDX_DH_F                     ON DEP_HISTORY("FOLDER")
'; EXECUTE '
CREATE INDEX IDX_DH_INVCID                ON DEP_HISTORY("INV_CID")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for DEP_KEYS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_DEP_K' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_DEP_K
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='DEP_KEYS';
IF c = 0 THEN EXECUTE '
CREATE TABLE DEP_KEYS (
    "ID"              BIGINT           NOT NULL DEFAULT NEXTVAL(''SEQ_DEP_K''),
    "KEY_TYPE"        SMALLINT         NOT NULL, /* PRIVATE, PUBLIC, X.509 */ 
    "KEY_ALG"         SMALLINT         NOT NULL, /* PGP, RSA, ECDSA */
    "KEY"             VARCHAR(4000)    NULL,
    "CERTIFICATE"     VARCHAR(4000)    NULL,     /* X.509 Certificate*/
    "ACCOUNT"         VARCHAR(255)     NOT NULL,
    "SECLVL"          SMALLINT         DEFAULT 0 NOT NULL,
    CONSTRAINT DEP_K_UNIQUE UNIQUE ("ACCOUNT", "KEY_TYPE", "SECLVL"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_DK_A                     ON DEP_KEYS("ACCOUNT")
'; EXECUTE '
CREATE INDEX IDX_DK_SL                    ON DEP_KEYS("SECLVL")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for DEP_SIGNATURES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_DEP_SIG' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_DEP_SIG
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='DEP_SIGNATURES';
IF c = 0 THEN EXECUTE '
CREATE TABLE DEP_SIGNATURES (
    "ID"              BIGINT           NOT NULL DEFAULT NEXTVAL(''SEQ_DEP_SIG''),
    "INV_CID"         BIGINT           NULL, 
    "DEP_HID"         BIGINT           NULL,
    "SIGNATURE"       VARCHAR(2000)    NOT NULL,
    "ACCOUNT"         VARCHAR(255)     NOT NULL,
    "MODIFIED"        TIMESTAMP        NOT NULL,
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_DS_A                    ON DEP_SIGNATURES("ACCOUNT")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for DEP_VERSIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_DEP_VER' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_DEP_VER
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='DEP_VERSIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE DEP_VERSIONS (
    "ID"              BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_DEP_VER''),
    "INV_CID"         BIGINT        NULL, 
    "DEP_HID"         BIGINT        NULL,
    "VERSION"         VARCHAR(100)  NOT NULL,
    "MODIFIED"        TIMESTAMP     NOT NULL,
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_DV_V                    ON DEP_VERSIONS("VERSION")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for DEP_COMMIT_IDS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_DEP_COM' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_DEP_COM
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='DEP_COMMIT_IDS';
IF c = 0 THEN EXECUTE '
CREATE TABLE DEP_COMMIT_IDS (
    "ID"              BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_DEP_COM''),
    "INV_CID"         BIGINT        NULL, 
    "DEP_HID"         BIGINT        NULL,
    "CFG_PATH"        VARCHAR(255)  NOT NULL,
    "COMMIT_ID"       VARCHAR(255)  NOT NULL,
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for DEP_SUBMISSIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_DEP_SUB' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_DEP_SUB
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='DEP_SUBMISSIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE DEP_SUBMISSIONS (
    "ID"              BIGINT            NOT NULL DEFAULT NEXTVAL(''SEQ_DEP_SUB''),
    "DEP_HID"         BIGINT            NOT NULL,
    "ACCOUNT"         VARCHAR(100)      NOT NULL,
    "FOLDER"          VARCHAR(255)      NOT NULL,
    "PATH"            VARCHAR(255)      NOT NULL,
    "TYPE"            SMALLINT          NOT NULL,
    "INV_CID"         BIGINT            NOT NULL,
    "INV_IID"         BIGINT            NOT NULL,   /* Inventory Instance ID */
    "CONTROLLER_ID"   VARCHAR(100)      NOT NULL,
    "CONTENT"         TEXT              NOT NULL,
    "SIGNATURE"       VARCHAR(2000)     NOT NULL,
    "COMMIT_ID"       VARCHAR(255)      NULL,
    "VERSION"         VARCHAR(50)       NULL,
    "OPERATION"       SMALLINT          NULL,       /* UPDATE, DELETE */
    "CREATED"         TIMESTAMP         NOT NULL,
    "DELETED_DATE"    TIMESTAMP         NULL,
    CONSTRAINT DEP_SUB_UNIQUE UNIQUE ("PATH", "CONTROLLER_ID", "COMMIT_ID", "CREATED"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | tables for PostgreSQL
 | SOS GmbH, 2021-05-20
*/

/* Table for HISTORY_CONTROLLERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='HISTORY_CONTROLLERS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE HISTORY_CONTROLLERS (
                    "READY_EVENT_ID"            NUMERIC(16)     NOT NULL,
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "URI"                       VARCHAR(255)    NOT NULL,
                    "TIMEZONE"                  VARCHAR(100)    NOT NULL,
                    "TOTAL_RUNNING_TIME"        NUMERIC(16)     NOT NULL,   /* in milliseconds */
                    "READY_TIME"                TIMESTAMP       NOT NULL,
                    "SHUTDOWN_TIME"             TIMESTAMP       NULL,
                    "LAST_KNOWN_TIME"           TIMESTAMP       NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("READY_EVENT_ID","CONTROLLER_ID")
                )'; 
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for HISTORY_AGENTS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='HISTORY_AGENTS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE HISTORY_AGENTS (
                    "READY_EVENT_ID"            NUMERIC(16)     NOT NULL,
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "AGENT_ID"                  VARCHAR(255)    NOT NULL,
                    "URI"                       VARCHAR(255)    NOT NULL,
                    "TIMEZONE"                  VARCHAR(100)    NOT NULL,
                    "READY_TIME"                TIMESTAMP       NOT NULL,
                    "COUPLING_FAILED_TIME"      TIMESTAMP       NULL,
                    "COUPLING_FAILED_MESSAGE"   VARCHAR(500)    NULL,
                    "SHUTDOWN_TIME"             TIMESTAMP       NULL,
                    "LAST_KNOWN_TIME"           TIMESTAMP       NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("READY_EVENT_ID","CONTROLLER_ID")
                )'; 
        EXECUTE 'CREATE INDEX IDX_HA_AID ON HISTORY_AGENTS("AGENT_ID")';
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for HISTORY_ORDERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='HISTORY_ORDERS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE HISTORY_ORDERS (
                    "ID"                        BIGINT          NOT NULL,
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "ORDER_ID"                  VARCHAR(255)    NOT NULL,
                    "WORKFLOW_PATH"             VARCHAR(255)    NOT NULL,
                    "WORKFLOW_VERSION_ID"       VARCHAR(255)    NOT NULL,   /* #2019-06-13T08:43:29Z */
                    "WORKFLOW_POSITION"         VARCHAR(255)    NOT NULL,   /* 1#fork_1#0 */
                    "WORKFLOW_FOLDER"           VARCHAR(255)    NOT NULL,
                    "WORKFLOW_NAME"             VARCHAR(255)    NOT NULL,
                    "WORKFLOW_TITLE"            VARCHAR(255)    NULL,       
                    "MAIN_PARENT_ID"            BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID of the main order */
                    "PARENT_ID"                 BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID of the parent order */
                    "PARENT_ORDER_ID"           VARCHAR(255)    NOT NULL,   /* HISTORY_ORDERS.ORDER_ID */
                    "HAS_CHILDREN"              NUMERIC(1)      NOT NULL,
                    "RETRY_COUNTER"             INTEGER         NOT NULL,
                    "NAME"                      VARCHAR(255)    NOT NULL,   /* orderId or branchId by fork */
                    "START_CAUSE"               VARCHAR(50)     NOT NULL,   /* order, fork, file_trigger, setback, unskip, unstop */
                    "START_TIME_SCHEDULED"      TIMESTAMP       NULL,       
                    "START_TIME"                TIMESTAMP       NOT NULL,
                    "START_WORKFLOW_POSITION"   VARCHAR(255)    NOT NULL,
                    "START_EVENT_ID"            NUMERIC(16)     NOT NULL,   /* OrderStarted eventId */
                    "START_VARIABLES"           TEXT            NULL,       
                    "CURRENT_HOS_ID"            BIGINT          NOT NULL,   /* HISTORY_ORDER_STEPS.ID */
                    "END_TIME"                  TIMESTAMP       NULL,
                    "END_WORKFLOW_POSITION"     VARCHAR(255)    NULL,
                    "END_EVENT_ID"              NUMERIC(16)     NULL,       /* OrderFinisched eventId */
                    "END_HOS_ID"                BIGINT          NOT NULL,   /* HISTORY_ORDER_STEPS.ID */
                    "END_RETURN_CODE"           INTEGER         NULL,
                    "END_MESSAGE"               VARCHAR(500)    NULL,    
                    "SEVERITY"                  SMALLINT        NOT NULL,   /* 0,1,2 */
                    "STATE"                     SMALLINT        NOT NULL,   
                    "STATE_TIME"                TIMESTAMP       NOT NULL,
                    "STATE_TEXT"                VARCHAR(255)    NULL,       
                    "HAS_STATES"                NUMERIC(1)      NOT NULL,   /* has entries in HISTORY_ORDER_STATES */
                    "ERROR"                     NUMERIC(1)      NOT NULL,
                    "ERROR_STATE"               VARCHAR(20)     NULL,       /*  failed, disrupted ... - event outcome*/
                    "ERROR_REASON"              VARCHAR(50)     NULL,       /*  other ... - event outcome*/
                    "ERROR_RETURN_CODE"         INTEGER         NULL,
                    "ERROR_CODE"                VARCHAR(50)     NULL,       
                    "ERROR_TEXT"                VARCHAR(500)    NULL,       
                    "LOG_ID"                    BIGINT          NOT NULL,   /* HISTORY_LOGS.ID */
                    "CONSTRAINT_HASH"           CHAR(64)        NOT NULL,   /* hash from "CONTROLLER_ID", "ORDER_ID"*/
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    "MODIFIED"                  TIMESTAMP       NOT NULL,
                    CONSTRAINT UNIQUE_HO_CH UNIQUE ("CONSTRAINT_HASH"), /* used by history*/
                    PRIMARY KEY ("ID")
                )'; 
        EXECUTE 'CREATE INDEX IDX_HO_OID                ON HISTORY_ORDERS("ORDER_ID")'; 
        EXECUTE 'CREATE INDEX IDX_HO_WPATH              ON HISTORY_ORDERS("WORKFLOW_PATH")';
        EXECUTE 'CREATE INDEX IDX_HO_WNAME              ON HISTORY_ORDERS("WORKFLOW_NAME")';        
        EXECUTE 'CREATE INDEX IDX_HO_STIME_PID_SY_CID   ON HISTORY_ORDERS("START_TIME","PARENT_ID","SEVERITY","CONTROLLER_ID")'; 
        EXECUTE 'CREATE INDEX IDX_HO_LID                ON HISTORY_ORDERS("LOG_ID")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_HISTORY_O' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_HISTORY_O
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for HISTORY_ORDER_STATES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='HISTORY_ORDER_STATES' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE HISTORY_ORDER_STATES (
                    "ID"                        BIGINT          NOT NULL,
                    "HO_MAIN_PARENT_ID"         BIGINT          NOT NULL,   /* HISTORY_ORDERS.MAIN_PARENT_ID */
                    "HO_PARENT_ID"              BIGINT          NOT NULL,   /* HISTORY_ORDERS.PARENT_ID */
                    "HO_ID"                     BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID */
                    "STATE"                     SMALLINT        NOT NULL,   
                    "STATE_TIME"                TIMESTAMP       NOT NULL,
                    "STATE_EVENT_ID"            CHAR(16)        NOT NULL,   
                    "STATE_CODE"                VARCHAR(50)     NULL,
                    "STATE_TEXT"                VARCHAR(255)    NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("ID")
                )'; 
        EXECUTE 'CREATE INDEX IDX_HOSTATES_HOID ON HISTORY_ORDER_STATES("HO_ID")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_HISTORY_OSTATES' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_HISTORY_OSTATES
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for HISTORY_ORDER_STEPS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE HISTORY_ORDER_STEPS (
                    "ID"                        BIGINT          NOT NULL,
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "ORDER_ID"                  VARCHAR(255)    NOT NULL,
                    "WORKFLOW_PATH"             VARCHAR(255)    NOT NULL,
                    "WORKFLOW_VERSION_ID"       VARCHAR(255)    NOT NULL,   /* #2019-06-13T08:43:29Z */
                    "WORKFLOW_POSITION"         VARCHAR(255)    NOT NULL,   /* 1#fork_1#3 */
                    "WORKFLOW_FOLDER"           VARCHAR(255)    NOT NULL,
                    "WORKFLOW_NAME"             VARCHAR(255)    NOT NULL,
                    "HO_MAIN_PARENT_ID"         BIGINT          NOT NULL,   /* HISTORY_ORDERS.MAIN_PARENT_ID */
                    "HO_ID"                     BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID */
                    "POSITION"                  INTEGER         NOT NULL,   /* 3 - last position from WORKFLOW_POSITION */
                    "RETRY_COUNTER"             INTEGER         NOT NULL,
                    "JOB_NAME"                  VARCHAR(255)    NOT NULL,
                    "JOB_LABEL"                 VARCHAR(255)    NOT NULL,
                    "JOB_TITLE"                 VARCHAR(255)    NULL,       
                    "JOB_NOTIFICATION"          VARCHAR(1000)   NULL,
                    "CRITICALITY"               SMALLINT        NOT NULL,
                    "AGENT_ID"                  VARCHAR(255)    NOT NULL,
                    "AGENT_NAME"                VARCHAR(255)    NULL,
                    "AGENT_URI"                 VARCHAR(255)    NOT NULL,
                    "SUBAGENT_CLUSTER_ID"       VARCHAR(255)    NULL,
                    "START_CAUSE"               VARCHAR(50)     NOT NULL,   /* order, file_trigger, setback, unskip, unstop */
                    "START_TIME"                TIMESTAMP       NOT NULL,
                    "START_EVENT_ID"            NUMERIC(16)     NOT NULL,   /* ProcessingStarted eventId */
                    "START_VARIABLES"           TEXT            NULL,       
                    "END_TIME"                  TIMESTAMP       NULL,
                    "END_EVENT_ID"              NUMERIC(16)     NULL,       /* Processed eventId */
                    "END_VARIABLES"             TEXT            NULL,                          
                    "RETURN_CODE"               INTEGER         NULL,
                    "SEVERITY"                  SMALLINT        NOT NULL,   /* 0,1,2 */
                    "ERROR"                     NUMERIC(1)      NOT NULL,   
                    "ERROR_STATE"               VARCHAR(20)     NULL,       /* failed, disrupted ... - event outcome*/
                    "ERROR_REASON"              VARCHAR(50)     NULL,       /* other ... - event outcome*/
                    "ERROR_CODE"                VARCHAR(50)     NULL,       
                    "ERROR_TEXT"                VARCHAR(500)    NULL,       
                    "LOG_ID"                    BIGINT          NOT NULL,   /* HISTORY_LOGS.ID */
                    "CONSTRAINT_HASH"           CHAR(64)        NOT NULL,   /* hash from "CONTROLLER_ID", "ORDER_ID", "WORKFLOW_POSITION"*/
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    "MODIFIED"                  TIMESTAMP       NOT NULL,
                    CONSTRAINT UNIQUE_HOSTEPS_CH UNIQUE ("CONSTRAINT_HASH"),    /* used by history*/
                    PRIMARY KEY ("ID")
                )'; 
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_STIME_SY_CID  ON HISTORY_ORDER_STEPS("START_TIME","SEVERITY","CONTROLLER_ID")'; 
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_HOID          ON HISTORY_ORDER_STEPS("HO_ID")'; 
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_HOMPID_WPOS   ON HISTORY_ORDER_STEPS("HO_MAIN_PARENT_ID","WORKFLOW_POSITION")'; 
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_WPATH         ON HISTORY_ORDER_STEPS("WORKFLOW_PATH")';
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_WNAME         ON HISTORY_ORDER_STEPS("WORKFLOW_NAME")';         
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_CY_JN         ON HISTORY_ORDER_STEPS("CRITICALITY","JOB_NAME")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_HISTORY_OSTEPS' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_HISTORY_OSTEPS
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for HISTORY_LOGS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='HISTORY_LOGS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE HISTORY_LOGS (
                    "ID"                        BIGINT          NOT NULL,
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "HO_MAIN_PARENT_ID"         BIGINT          NOT NULL,  /* HISTORY_ORDERS.MAIN_PARENT_ID */
                    "HO_ID"                     BIGINT          NOT NULL,  /* HISTORY_ORDERS.ID */
                    "HOS_ID"                    BIGINT          NOT NULL,  /* HISTORY_ORDER_STEPS.ID */
                    "COMPRESSED"                NUMERIC(1)      NOT NULL,
                    "FILE_BASENAME"             VARCHAR(255)    NOT NULL,
                    "FILE_SIZE_UNCOMPRESSED"    INTEGER         NOT NULL,
                    "FILE_LINES_UNCOMPRESSED"   INTEGER         NOT NULL,
                    "FILE_CONTENT"              BYTEA           NOT NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("ID")
                )'; 
        EXECUTE 'CREATE INDEX IDX_HLOGS_HOID    ON HISTORY_LOGS("HO_ID")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_HISTORY_L' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_HISTORY_L
                            INCREMENT BY 1
                            START WITH 1
                            MINVALUE 1 CYCLE;';
            END IF; 
        END;        
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* HISTORY_ORDER_STEPS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND UPPER(COLUMN_NAME)='START_VARIABLES' AND UPPER(UDT_NAME)='TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE HISTORY_ORDER_STEPS ALTER COLUMN "START_VARIABLES" TYPE TEXT;';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Tables for PostGres
 | SOS GmbH, 2021-05-28
*/


/* Table for INV_OPERATING_SYSTEMS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_OS' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_OS
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_OPERATING_SYSTEMS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_OPERATING_SYSTEMS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_INV_OS''),
    "HOSTNAME"              VARCHAR(100)  NOT NULL,
    "NAME"                  VARCHAR(50)   NULL,
    "ARCHITECTURE"          VARCHAR(255)  NULL,
    "DISTRIBUTION"          VARCHAR(255)  NULL,
    "MODIFIED"              TIMESTAMP     NOT NULL,
    CONSTRAINT UNIQUE_IOS_HOST UNIQUE ("HOSTNAME"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for INV_JS_INSTANCES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_JI' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_JI
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_JS_INSTANCES';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_JS_INSTANCES (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_JI''),
    "CONTROLLER_ID"         VARCHAR(100)        NOT NULL,
    "SECURITY_LEVEL"        SMALLINT            DEFAULT 0 NOT NULL, /* 0=LOW, 1=MEDIUM, 2=HIGH */
    "URI"                   VARCHAR(255)        NOT NULL,
    "CLUSTER_URI"           VARCHAR(255)        NULL,
    "OS_ID"                 BIGINT              NOT NULL,
    "VERSION"               VARCHAR(30)         NULL,
    "JAVA_VERSION"          VARCHAR(30)         NULL,
    "STARTED_AT"            TIMESTAMP           NULL,
    "TITLE"                 VARCHAR(30)         NULL,
    "IS_CLUSTER"            NUMERIC(1)          DEFAULT 0 NOT NULL, /* 0=standalone, 1=cluster */
    "IS_PRIMARY"            NUMERIC(1)          DEFAULT 1 NOT NULL, /* 1=primary, 0=backup */
    "CERTIFICATE"           VARCHAR(4000)       NULL,     /* X.509 Certificate*/
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IJI_CCP UNIQUE ("CONTROLLER_ID", "IS_CLUSTER", "IS_PRIMARY"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_IJI_CID                     ON INV_JS_INSTANCES("CONTROLLER_ID")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for INV_AGENT_INSTANCES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_AI' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_AI
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_AGENT_INSTANCES';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_AGENT_INSTANCES (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_AI''),
    "AGENT_ID"              VARCHAR(255)        NOT NULL, /* (technical) agentName for the Controller in Job configuration. Cannot overwritten */
    "AGENT_NAME"            VARCHAR(255)        NOT NULL, /* (displayed) agentName for JOC in Job configuration */
    "URI"                   VARCHAR(255)        NOT NULL,
    "PROCESS_LIMIT"         NUMERIC(10)         NULL,
    "ORDERING"              NUMERIC(10)         DEFAULT 0 NOT NULL,
    "HIDDEN"                NUMERIC(1)          DEFAULT 0 NOT NULL, /* boolean */
    "DISABLED"              NUMERIC(1)          DEFAULT 0 NOT NULL, /* boolean */
    "DEPLOYED"              NUMERIC(1)          DEFAULT 0 NOT NULL, /* boolean */
    "IS_WATCHER"            NUMERIC(1)          DEFAULT 0 NOT NULL,
    "CONTROLLER_ID"         VARCHAR(100)        NOT NULL,
    "OS_ID"                 BIGINT              NOT NULL,
    "TITLE"                 VARCHAR(255)        NULL,
    "VERSION"               VARCHAR(30)         NULL,
    "JAVA_VERSION"          VARCHAR(30)         NULL,
    "CERTIFICATE"           VARCHAR(4000)       NULL,     /* X.509 Certificate*/
    "STARTED_AT"            TIMESTAMP           NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IAI_A UNIQUE ("AGENT_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table for INV_AGENT_NAME_ALIASES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_AGENT_NAME_ALIASES';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_AGENT_NAME_ALIASES (
    "AGENT_ID"              VARCHAR(255)  NOT NULL, /* (technical) agentName for the Controller in Jobs configuration. Cannot overwritten*/
    "AGENT_NAME"            VARCHAR(255)  NOT NULL, /* (displayed) agentName for JOC in Jobs configuration */
    PRIMARY KEY ("AGENT_ID", "AGENT_NAME")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table INV_SUBAGENT_INSTANCES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_SAI' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_SAI
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_SUBAGENT_INSTANCES';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_SUBAGENT_INSTANCES (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_SAI''),
    "SUB_AGENT_ID"          VARCHAR(255)        NOT NULL, 
    "AGENT_ID"              VARCHAR(255)        NOT NULL, 
    "URI"                   VARCHAR(255)        NOT NULL,
    "IS_DIRECTOR"           NUMERIC(1)          DEFAULT 0 NOT NULL, /* 0=No director, 1=primary director, 2=standby director */
    "ORDERING"              NUMERIC(10)         DEFAULT 0 NOT NULL,
    "DISABLED"              NUMERIC(1)          DEFAULT 0 NOT NULL, /* boolean */
    "DEPLOYED"              NUMERIC(1)          DEFAULT 0 NOT NULL, /* boolean */
    "IS_WATCHER"            NUMERIC(1)          DEFAULT 0 NOT NULL,
    "TITLE"                 VARCHAR(255)        NULL,
    "OS_ID"                 BIGINT              NOT NULL,
    "VERSION"               VARCHAR(30)         NULL,
    "JAVA_VERSION"          VARCHAR(30)         NULL,
    "CERTIFICATE"           VARCHAR(4000)       NULL,     /* X.509 Certificate*/
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_ISI_S UNIQUE ("SUB_AGENT_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table INV_SUBAGENT_CLUSTERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_SAC' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_SAC
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_SUBAGENT_CLUSTERS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_SUBAGENT_CLUSTERS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_INV_SAC''),
    "AGENT_ID"              VARCHAR(255)  NOT NULL,
    "SUBAGENT_CLUSTER_ID"   VARCHAR(255)  NOT NULL,
    "TITLE"                 VARCHAR(255)      NULL,
    "DEPLOYED"              NUMERIC(1)    DEFAULT 0 NOT NULL, /* boolean */
    "ORDERING"              NUMERIC(10)   DEFAULT 0 NOT NULL,
    "MODIFIED"              TIMESTAMP     NOT NULL,    
    CONSTRAINT UNIQUE_ISC_AC UNIQUE ("SUBAGENT_CLUSTER_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table INV_SUBAGENT_CLUSTER_MEMBERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_SACM' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_SACM
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_SUBAGENT_CLUSTER_MEMBERS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_SUBAGENT_CLUSTER_MEMBERS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_INV_SACM''),
    "SUBAGENT_CLUSTER_ID"   VARCHAR(255)  NOT NULL,
    "SUBAGENT_ID"           VARCHAR(255)  NOT NULL,
    "PRIORITY"              NUMERIC(10)   NOT NULL,
    "MODIFIED"              TIMESTAMP     NOT NULL,    
    CONSTRAINT UNIQUE_ISCM_CS UNIQUE ("SUBAGENT_CLUSTER_ID", "SUBAGENT_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table for INV_CONFIGURATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_C' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_C
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_CONFIGURATIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_CONFIGURATIONS (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_C''),
    "TYPE"                  SMALLINT            NOT NULL,   /* com.sos.joc.model.inventory.ConfigurationType */
    "PATH"                  VARCHAR(255)        NOT NULL,
    "NAME"                  VARCHAR(255)        NOT NULL,
    "FOLDER"                VARCHAR(255)        NOT NULL,
    "TITLE"                 VARCHAR(255)        NULL,
    "CONTENT"               TEXT                NULL,
    "JSON_CONTENT"          JSONB               NULL,
    "VALID"                 NUMERIC(1)          NOT NULL, /* boolean */
    "DELETED"               NUMERIC(1)          NOT NULL, /* boolean */
    "DEPLOYED"              NUMERIC(1)          NOT NULL, /* boolean */
    "RELEASED"              NUMERIC(1)          NOT NULL, /* boolean */
    "REPO_CTRL"             NUMERIC(1)          NOT NULL, /* boolean */
    "AUDIT_LOG_ID"          BIGINT              NOT NULL,
    "CREATED"               TIMESTAMP           NOT NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IC_TP UNIQUE ("TYPE", "PATH"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_IC_F                     ON INV_CONFIGURATIONS("FOLDER")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for INV_CONFIGURATION_TRASH */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_CT' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_CT
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_CONFIGURATION_TRASH';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_CONFIGURATION_TRASH (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_CT''),
    "TYPE"                  SMALLINT            NOT NULL,   /* com.sos.joc.model.inventory.ConfigurationType */
    "PATH"                  VARCHAR(255)        NOT NULL,
    "NAME"                  VARCHAR(255)        NOT NULL,
    "FOLDER"                VARCHAR(255)        NOT NULL,
    "TITLE"                 VARCHAR(255)        NULL,
    "CONTENT"               TEXT                NULL,
    "VALID"                 NUMERIC(1)          NOT NULL, /* boolean */
    "AUDIT_LOG_ID"          BIGINT              NOT NULL,
    "CREATED"               TIMESTAMP           NOT NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_ICT_TP UNIQUE ("TYPE", "PATH"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_ICT_F                     ON INV_CONFIGURATION_TRASH("FOLDER")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for INV_RELEASED_CONFIGURATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_RC' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_RC
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_RELEASED_CONFIGURATIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_RELEASED_CONFIGURATIONS (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_RC''),
    "TYPE"                  SMALLINT            NOT NULL,   /* com.sos.joc.model.inventory.ConfigurationType */
    "PATH"                  VARCHAR(255)        NOT NULL,
    "CID"                   BIGINT              NOT NULL, /* 1:1 foreign key INV_CONFIGURATIONS.ID */
    "NAME"                  VARCHAR(255)        NOT NULL,
    "FOLDER"                VARCHAR(255)        NOT NULL,
    "TITLE"                 VARCHAR(255)        NULL,
    "CONTENT"               TEXT                NOT NULL,
    "JSON_CONTENT"          JSONB               NOT NULL,
    "AUDIT_LOG_ID"          BIGINT              NOT NULL,
    "CREATED"               TIMESTAMP           NOT NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IRC_TP UNIQUE ("TYPE", "PATH"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_IRC_C                     ON INV_RELEASED_CONFIGURATIONS("CID")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for INV_CERTS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_CRTS' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_CRTS
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_CERTS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_CERTS (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_CRTS''),
    "KEY_TYPE"              SMALLINT            NOT NULL, /* PRIVATE, X509 */ 
    "KEY_ALG"               SMALLINT            NOT NULL, /* RSA, ECDSA */
    "PEM"                   VARCHAR(4000)       NOT NULL,
    "CA"                    NUMERIC(1)          NOT NULL, /* boolean */
    "ACCOUNT"               VARCHAR(255)        NOT NULL,
    "SECLVL"                SMALLINT            DEFAULT 0 NOT NULL,
    CONSTRAINT UNIQUE_ICS_KTCAS UNIQUE ("KEY_TYPE", "CA", "ACCOUNT", "SECLVL"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table for INV_DOCUMENTATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_D' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_D
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_DOCUMENTATIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_DOCUMENTATIONS(
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_D''),
    "NAME"                  VARCHAR(255)        NOT NULL,
    "FOLDER"                VARCHAR(255)        NOT NULL,
    "PATH"                  VARCHAR(255)        NOT NULL,
    "TYPE"                  VARCHAR(25)         DEFAULT ''''  NOT NULL,
    "CONTENT"               TEXT                NULL,
    "IMAGE_ID"              BIGINT              NULL,
    "IS_REF"                NUMERIC(1)          DEFAULT 0 NOT NULL,
    "DOC_REF"               VARCHAR(255)        NULL,
    "CREATED"               TIMESTAMP           NOT NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IDOC_PATH UNIQUE ("PATH"),
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_ID_IR                     ON INV_DOCUMENTATIONS("IS_REF")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for INV_DOCUMENTATION_IMAGES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_DI' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_DI
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_DOCUMENTATION_IMAGES';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_DOCUMENTATION_IMAGES(
    "ID"                    BIGINT          NOT NULL DEFAULT NEXTVAL(''SEQ_INV_DI''),
    "IMAGE"                 BYTEA           NOT NULL,
    "MD5_HASH"              CHAR(32)        NOT NULL,
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* Table INV_FAVORITES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_F' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_F
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_FAVORITES';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_FAVORITES (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_F''),
    "TYPE"                  SMALLINT            NOT NULL,   /* e.g. 1=facet, 2=agent */
    "NAME"                  VARCHAR(255)        NOT NULL,
    "FAVORITE"              TEXT                NULL,
    "ORDERING"              NUMERIC(10)         DEFAULT 0 NOT NULL,
    "ACCOUNT"               VARCHAR(255)        NOT NULL,
    "SHARED"                NUMERIC(1)          DEFAULT 0 NOT NULL,
    "CREATED"               TIMESTAMP           NOT NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IF_TNA UNIQUE ("TYPE","NAME","ACCOUNT"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table INV_TAGS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_T' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_T
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_TAGS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_TAGS (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_T''),
    "NAME"                  VARCHAR(255)        NOT NULL,
    "ORDERING"              NUMERIC(10)         NOT NULL DEFAULT 0,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_IT_N UNIQUE ("NAME"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table INV_TAGGINGS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_INV_TG' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_INV_TG
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='INV_TAGGINGS';
IF c = 0 THEN EXECUTE '
CREATE TABLE INV_TAGGINGS (
    "ID"                    BIGINT              NOT NULL DEFAULT NEXTVAL(''SEQ_INV_TG''),
    "CID"              	    BIGINT              NOT NULL,
    "NAME"                  VARCHAR(255)        NOT NULL,
    "TYPE"                  SMALLINT            NOT NULL, /* com.sos.joc.model.inventory.ConfigurationType */
    "TAG_ID"              	BIGINT              NOT NULL,
    "MODIFIED"              TIMESTAMP           NOT NULL,
    CONSTRAINT UNIQUE_ITG_CT UNIQUE ("CID","TAG_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Tables for PostGres
 | SOS GmbH, 2021-05-28
*/


/* Table for JOC_VARIABLES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_VARIABLES';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_VARIABLES (
    "NAME"                  VARCHAR(255)  NOT NULL,
    "NUMERIC_VALUE"         INTEGER       NULL,
    "TEXT_VALUE"            VARCHAR(255)  NULL,
    "BINARY_VALUE"          BYTEA         NULL,
    PRIMARY KEY ("NAME")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table JOC_INSTANCES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_JOC_I' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_JOC_I
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_INSTANCES';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_INSTANCES (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_JOC_I''),
    "CLUSTER_ID"            VARCHAR(10)   NOT NULL,
    "MEMBER_ID"             VARCHAR(165)  NOT NULL, /* HOSTNAME:hash(DATA_DIRECTORY) */
    "OS_ID"                 BIGINT        NOT NULL,
    "DATA_DIRECTORY"        VARCHAR(255)  NOT NULL,
    "SECURITY_LEVEL"        VARCHAR(10)   NOT NULL,
    "TIMEZONE"              VARCHAR(30)   NOT NULL,
    "STARTED_AT"            TIMESTAMP     NOT NULL,
    "TITLE"                 VARCHAR(30)   NULL,
    "ORDERING"              SMALLINT      DEFAULT 0 NOT NULL,
    "URI"                   VARCHAR(255)  NULL,
    "HEART_BEAT"            TIMESTAMP     NOT NULL,
    "API_SERVER"            NUMERIC(1)    NOT NULL,
    "VERSION"               VARCHAR(30)   NULL,
    "CERTIFICATE"           VARCHAR(4000) NULL,     /* X.509 Certificate*/
    CONSTRAINT UNIQUE_JI_MID UNIQUE ("MEMBER_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table JOC_CLUSTER */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_CLUSTER';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_CLUSTER (
    "ID"                        VARCHAR(10)   NOT NULL,
    "MEMBER_ID"                 VARCHAR(165)  NOT NULL,
    "HEART_BEAT"                TIMESTAMP     NOT NULL,
    "SWITCH_MEMBER_ID"          VARCHAR(165)  NULL,
    "SWITCH_HEART_BEAT"         TIMESTAMP     NULL,
    "NOTIFICATION_MEMBER_ID"    VARCHAR(165)  NULL,
    "NOTIFICATION"              VARCHAR(100)  NULL,
    CONSTRAINT UNIQUE_JC_MID UNIQUE ("MEMBER_ID"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table JOC_CONFIGURATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_JOC_C' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_JOC_C
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_CONFIGURATIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_CONFIGURATIONS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_JOC_C''),
    "INSTANCE_ID"           BIGINT        NULL,
    "CONTROLLER_ID"         VARCHAR(100)  NULL,
    "ACCOUNT"               VARCHAR(255)  NOT NULL,
    "OBJECT_TYPE"           VARCHAR(30)   NULL,
    "CONFIGURATION_TYPE"    VARCHAR(30)   NOT NULL,
    "NAME"                  VARCHAR(255)  NULL,
    "SHARED"                NUMERIC(1)    DEFAULT 0 NOT NULL,
    "CONFIGURATION_ITEM"    TEXT          NOT NULL,
    "MODIFIED"              TIMESTAMP     NOT NULL,
    CONSTRAINT UNIQUE_JC_CIDAOTCTN UNIQUE ("CONTROLLER_ID","ACCOUNT","OBJECT_TYPE","CONFIGURATION_TYPE","NAME"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table JOC_AUDIT_LOG */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_JOC_AL' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_JOC_AL
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_AUDIT_LOG';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_AUDIT_LOG (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_JOC_AL''),
    "CONTROLLER_ID"         VARCHAR(100)  NOT NULL,
    "ACCOUNT"               VARCHAR(255)  NOT NULL,
    "REQUEST"               VARCHAR(50)   NOT NULL,
    "PARAMETERS"            TEXT          NULL,
    "CATEGORY"              SMALLINT      DEFAULT 0 NOT NULL,
    "COMMENT"               VARCHAR(2000) NULL,
    "CREATED"               TIMESTAMP     NOT NULL,
    "TICKET_LINK"           VARCHAR(255)  NULL,
    "TIME_SPENT"            INTEGER       NULL,
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_JAL_CCC                  ON JOC_AUDIT_LOG("CREATED","CONTROLLER_ID","CATEGORY")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table JOC_AUDIT_LOG_DETAILS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_JOC_ALD' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_JOC_ALD
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_AUDIT_LOG_DETAILS';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_AUDIT_LOG_DETAILS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_JOC_ALD''),
    "AUDITLOG_ID"           BIGINT        NOT NULL, /* ID from JOC_AUDIT_LOG */
    "TYPE"                  SMALLINT      DEFAULT 0 NOT NULL, 
    "FOLDER"                VARCHAR(255)  NOT NULL,
    "PATH"                  VARCHAR(255)  NOT NULL,
    "NAME"                  VARCHAR(255)  NOT NULL,
    "ORDER_ID"              VARCHAR(255)  NULL, /*For an order the workflow name fills the NAME field */
    "CREATED"               TIMESTAMP     NOT NULL,
    PRIMARY KEY ("ID")
)
'; 
EXECUTE 'CREATE INDEX IDX_JALD_JALID    ON JOC_AUDIT_LOG_DETAILS("AUDITLOG_ID")'; 
EXECUTE 'CREATE INDEX IDX_JALD_FOLDER   ON JOC_AUDIT_LOG_DETAILS("FOLDER")'; 
EXECUTE 'CREATE INDEX IDX_JALD_TYPE     ON JOC_AUDIT_LOG_DETAILS("TYPE")';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table JOC_LOCKS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_JOC_L' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_JOC_L
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='JOC_LOCKS';
IF c = 0 THEN EXECUTE '
CREATE TABLE JOC_LOCKS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_JOC_L''),
    "RANGE"                 SMALLINT      NOT NULL,
    "FOLDER"                VARCHAR(255)  NOT NULL,
    "ACCOUNT"               VARCHAR(255)  NOT NULL,
    "CREATED"               TIMESTAMP     NOT NULL,
    CONSTRAINT UNIQUE_JL_RF UNIQUE ("RANGE", "FOLDER"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Monitoring Interface tables for PostgreSQL
*/

/* Table for MON_ORDERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_ORDERS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_ORDERS(
                    "HISTORY_ID"                BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID */
                    "CONTROLLER_ID"             VARCHAR(100)    NOT NULL,
                    "ORDER_ID"                  VARCHAR(255)    NOT NULL,
                    "WORKFLOW_PATH"             VARCHAR(255)    NOT NULL,
                    "WORKFLOW_VERSION_ID"       VARCHAR(255)    NOT NULL,   /* #2019-06-13T08:43:29Z */
                    "WORKFLOW_POSITION"         VARCHAR(255)    NOT NULL,   /* 1#fork_1#0 */
                    "WORKFLOW_FOLDER"           VARCHAR(255)    NOT NULL,
                    "WORKFLOW_NAME"             VARCHAR(255)    NOT NULL,
                    "WORKFLOW_TITLE"            VARCHAR(255)    NULL,                           
                    "MAIN_PARENT_ID"            BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID of the main order */
                    "PARENT_ID"                 BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID of the parent order */
                    "PARENT_ORDER_ID"           VARCHAR(255)    NOT NULL,   /* HISTORY_ORDERS.ORDER_ID */
                    "HAS_CHILDREN"              NUMERIC(1)      NOT NULL,
                    "NAME"                      VARCHAR(255)    NOT NULL,   /* orderId or branchId by fork */
                    "START_CAUSE"               VARCHAR(50)     NOT NULL,   /* order, fork, file_trigger, setback, unskip, unstop */
                    "START_TIME_SCHEDULED"      TIMESTAMP       NULL,                               
                    "START_TIME"                TIMESTAMP       NOT NULL,
                    "START_WORKFLOW_POSITION"   VARCHAR(255)    NOT NULL,
                    "START_VARIABLES"           TEXT            NULL,                          
                    "CURRENT_HOS_ID"            BIGINT          NOT NULL,   /* HISTORY_ORDER_STEPS.ID */
                    "END_TIME"                  TIMESTAMP       NULL,
                    "END_WORKFLOW_POSITION"     VARCHAR(255)    NULL,
                    "END_HOS_ID"                BIGINT          NOT NULL,   /* HISTORY_ORDER_STEPS.ID */
                    "END_RETURN_CODE"           INTEGER         NULL,
                    "END_MESSAGE"               VARCHAR(500)    NULL,    
                    "SEVERITY"                  SMALLINT        NOT NULL,   /* 0,1,2 */
                    "STATE"                     SMALLINT        NOT NULL,   
                    "STATE_TIME"                TIMESTAMP       NOT NULL,
                    "ERROR"                     NUMERIC(1)      NOT NULL,
                    "ERROR_STATE"               VARCHAR(20)     NULL,       /* failed, disrupted ... - event outcome*/
                    "ERROR_REASON"              VARCHAR(50)     NULL,       /* other ... - event outcome*/
                    "ERROR_RETURN_CODE"         INTEGER         NULL,
                    "ERROR_CODE"                VARCHAR(50)     NULL,                            
                    "ERROR_TEXT"                VARCHAR(500)    NULL,                           
                    "LOG_ID"                    BIGINT          NULL,       /* HISTORY_LOGS.ID */
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    "MODIFIED"                  TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("HISTORY_ID")
                )';
        EXECUTE 'CREATE INDEX IDX_MONO_CID  ON MON_ORDERS("CONTROLLER_ID")';
        EXECUTE 'CREATE INDEX IDX_MONO_MPID ON MON_ORDERS("MAIN_PARENT_ID")';
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for MON_ORDER_STEPS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_ORDER_STEPS(
                    "HISTORY_ID"                BIGINT          NOT NULL,   /* HISTORY_ORDER_STEPS.ID */
                    "WORKFLOW_POSITION"         VARCHAR(255)    NOT NULL,   /* 1#fork_1#3 */
                    "HO_MAIN_PARENT_ID"         BIGINT          NOT NULL,   /* HISTORY_ORDERS.MAIN_PARENT_ID */
                    "HO_ID"                     BIGINT          NOT NULL,   /* HISTORY_ORDERS.ID */
                    "POSITION"                  INTEGER         NOT NULL,   /* 3 - last position from WORKFLOW_POSITION */
                    "JOB_NAME"                  VARCHAR(255)    NOT NULL,
                    "JOB_LABEL"                 VARCHAR(255)    NOT NULL,
                    "JOB_TITLE"                 VARCHAR(255)    NULL,                           
                    "JOB_NOTIFICATION"          VARCHAR(1000)   NULL,
                    "JOB_CRITICALITY"           NUMERIC(3)      NOT NULL,
                    "AGENT_ID"                  VARCHAR(255)    NOT NULL,
                    "AGENT_NAME"                VARCHAR(255)    NULL,
                    "AGENT_URI"                 VARCHAR(255)    NOT NULL,
                    "SUBAGENT_CLUSTER_ID"       VARCHAR(255)    NULL,
                    "START_CAUSE"               VARCHAR(50)     NOT NULL,   /* order, file_trigger, setback, unskip, unstop */
                    "START_TIME"                TIMESTAMP       NOT NULL,
                    "START_VARIABLES"           TEXT            NULL,                          
                    "END_TIME"                  TIMESTAMP       NULL,
                    "END_VARIABLES"             TEXT            NULL,                          
                    "RETURN_CODE"               INTEGER         NULL,
                    "SEVERITY"                  SMALLINT        NOT NULL,   /* 0,1,2 */
                    "ERROR"                     NUMERIC(1)      NOT NULL,   
                    "ERROR_STATE"               VARCHAR(20)     NULL,       /* failed, disrupted ... - event outcome*/
                    "ERROR_REASON"              VARCHAR(50)     NULL,       /* other ... - event outcome*/
                    "ERROR_CODE"                VARCHAR(50)     NULL,                            
                    "ERROR_TEXT"                VARCHAR(500)    NULL,                           
                    "LOG_ID"                    BIGINT          NULL,       /* HISTORY_LOGS.ID */
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    "MODIFIED"                  TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("HISTORY_ID")
                )';
        EXECUTE 'CREATE INDEX IDX_MONOS_HMPID ON MON_ORDER_STEPS("HO_MAIN_PARENT_ID")';
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for MON_NOTIFICATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_NOTIFICATIONS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_NOTIFICATIONS(
                    "ID"                BIGINT          NOT NULL,
                    "TYPE"              SMALLINT        NOT NULL,   /* SUCCESS(0), ERROR(1), WARNING(2), RECOVERED(3), ACKNOWLEDGED(4) */
                    "RANGE"             SMALLINT        NOT NULL,   /* WORKFLOW(0), WORKFLOW_JOB(1) */
                    "NOTIFICATION_ID"   VARCHAR(255)    NOT NULL,
                    "RECOVERED_ID"      BIGINT          NOT NULL,   /* MON_NOTIFICATIONS.ID */
                    "WARN"              SMALLINT        NOT NULL,  
                    "WARN_TEXT"         VARCHAR(500)    NULL,                           
                    "HAS_MONITORS"      NUMERIC(1)      NOT NULL,
                    "CREATED"           TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_MONN_C ON MON_NOTIFICATIONS("CREATED")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_MON_N' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_MON_N
                        INCREMENT BY 1
                        START WITH 1
                        MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for MON_NOT_WORKFLOWS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_NOT_WORKFLOWS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_NOT_WORKFLOWS(
                    "NOT_ID"                    BIGINT          NOT NULL,   /* MON_NOTIFICATIONS.ID */
                    "MON_O_HISTORY_ID"          BIGINT          NOT NULL,   /* MON_ORDERS.HISTORY_ID */
                    "MON_OS_HISTORY_ID"         BIGINT          NOT NULL,   /* MON_ORDER_STEPS.HISTORY_ID */
                    "WORKFLOW_POSITION"         VARCHAR(255)    NOT NULL,   /* 1#fork_1#3 */
                    PRIMARY KEY ("NOT_ID")
                )';
        EXECUTE 'CREATE INDEX IDX_MONNW_OHID ON MON_NOT_WORKFLOWS("MON_O_HISTORY_ID")';
        EXECUTE 'CREATE INDEX IDX_MONNW_OSHID ON MON_NOT_WORKFLOWS("MON_OS_HISTORY_ID")';
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for MON_SYSNOTIFICATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_SYSNOTIFICATIONS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_SYSNOTIFICATIONS(
                    "ID"                 BIGINT         NOT NULL,
                    "TYPE"               SMALLINT       NOT NULL,   /* ERROR(1), WARNING(2), ACKNOWLEDGED(4) */
                    "CATEGORY"           NUMERIC(1)     NOT NULL,   /* SYSTEM(0), JOC(1), CONTROLLER(2), AGENT(3) */
                    "JOC_ID"             VARCHAR(13)    NOT NULL,   /* JOC_INSTANCES.CLUSTER_ID#JOC_INSTANCES.ORDERING */
                    "SOURCE"             VARCHAR(100)   NOT NULL,
                    "NOTIFIER"           VARCHAR(255)   NOT NULL,
                    "TIME"               TIMESTAMP      NOT NULL,
                    "MESSAGE"            VARCHAR(1000)  NULL,
                    "EXCEPTION"          VARCHAR(4000)  NULL,
                    "HAS_MONITORS"       NUMERIC(1)     NOT NULL,
                    "CREATED"            TIMESTAMP      NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_MONSN_TYPE  ON MON_SYSNOTIFICATIONS("TYPE")';
        EXECUTE 'CREATE INDEX IDX_MONSN_JOCID ON MON_SYSNOTIFICATIONS("JOC_ID")';
        EXECUTE 'CREATE INDEX IDX_MONSN_TIME  ON MON_SYSNOTIFICATIONS("TIME")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_MON_SN' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_MON_SN
                        INCREMENT BY 1
                        START WITH 1
                        MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for MON_NOT_MONITORS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_NOT_MONITORS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_NOT_MONITORS(
                    "ID"                        BIGINT          NOT NULL,
                    "NOT_ID"                    BIGINT          NOT NULL,   /* MON_NOTIFICATIONS.ID or MON_SYSNOTIFICATIONS.ID */
                    "APPLICATION"               NUMERIC(1)      NOT NULL,   /* 0 - MON_NOTIFICATIONS, 1 - MON_SYSNOTIFICATIONS */
                    "TYPE"                      SMALLINT        NOT NULL,   /* COMMAND(0), MAIL(1), NSCA(2), JMS(3) */
                    "NAME"                      VARCHAR(255)    NOT NULL,
                    "CONFIGURATION"             VARCHAR(500)    NOT NULL,
                    "MESSAGE"                   VARCHAR(4000)   NOT NULL,
                    "ERROR"                     NUMERIC(1)      NOT NULL,
                    "ERROR_TEXT"                VARCHAR(500)    NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("ID")
                )';
        EXECUTE 'CREATE INDEX IDX_MONM_NIDA ON MON_NOT_MONITORS("NOT_ID","APPLICATION")';
        DECLARE sequence_exist integer; 
        BEGIN 
            SELECT COUNT(*) INTO sequence_exist FROM pg_class, pg_namespace WHERE UPPER(pg_class.relname) = 'SEQ_MON_NM' AND pg_namespace.oid = pg_class.relnamespace AND pg_namespace.nspname = current_schema; 
            IF sequence_exist = 0 THEN 
                EXECUTE 'CREATE SEQUENCE SEQ_MON_NM
                        INCREMENT BY 1
                        START WITH 1
                        MINVALUE 1 CYCLE;';
            END IF; 
        END;
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table for MON_NOT_ACKNOWLEDGEMENTS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE table_exist integer; 
BEGIN 
    SELECT COUNT(*) INTO table_exist FROM INFORMATION_SCHEMA.TABLES WHERE  UPPER(TABLE_NAME)='MON_NOT_ACKNOWLEDGEMENTS' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF table_exist = 0 THEN 
        EXECUTE 'CREATE TABLE MON_NOT_ACKNOWLEDGEMENTS(
                    "NOT_ID"                    BIGINT          NOT NULL,   /* MON_NOTIFICATIONS.ID or MON_SYSNOTIFICATIONS.ID */
                    "ACCOUNT"                   VARCHAR(255)    NOT NULL,
                    "APPLICATION"               NUMERIC(1)      NOT NULL,   /* 0 - MON_NOTIFICATIONS, 1 - MON_SYSNOTIFICATIONS */
                    "COMMENT"                   VARCHAR(2000)   NULL,
                    "CREATED"                   TIMESTAMP       NOT NULL,
                    PRIMARY KEY ("NOT_ID","APPLICATION")
                )';
    END IF; 
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* MON_ORDER_STEPS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='START_VARIABLES' AND UPPER(UDT_NAME)='TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE MON_ORDER_STEPS ALTER COLUMN "START_VARIABLES" TYPE TEXT;';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Tables for PostGres
*/


/* Table REPORTS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_REP_REP' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_REP_REP
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='REPORTS';
IF c = 0 THEN EXECUTE '
CREATE TABLE REPORTS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_REP_REP''),
    "RUN_ID"                BIGINT        NOT NULL,
    "FREQUENCY"             NUMERIC(10)   NOT NULL,
    "DATE_FROM"             TIMESTAMP     NOT NULL,
    "DATE_TO"               TIMESTAMP     NOT NULL,
    "CONTENT"               TEXT          NOT NULL,
    "CONSTRAINT_HASH"       CHAR(64)      NOT NULL,
    "MODIFIED"              TIMESTAMP     NOT NULL,
    "CREATED"               TIMESTAMP     NOT NULL,
    CONSTRAINT UNIQUE_R_CH UNIQUE ("CONSTRAINT_HASH"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table REPORT_RUNS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_REP_RUN' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_REP_RUN
INCREMENT BY 1 
START WITH 1 
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='REPORT_RUNS';
IF c = 0 THEN EXECUTE '
CREATE TABLE REPORT_RUNS (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_REP_RUN''),
    "PATH"                  VARCHAR(255)  NOT NULL,
    "FOLDER"                VARCHAR(255)  NOT NULL,
    "NAME"                  VARCHAR(255)  NOT NULL,
    "TITLE"                 VARCHAR(255)  NULL,
    "TEMPLATE_ID"           NUMERIC(10)   NOT NULL,
    "FREQUENCIES"           VARCHAR(255)  NOT NULL,
    "HITS"                  NUMERIC(10)   NOT NULL,
    "MONTH_FROM"            TIMESTAMP     NOT NULL,
    "MONTH_TO"              TIMESTAMP     NOT NULL,
    "CONTROLLER_ID"         VARCHAR(100)  NULL,
    "STATE"                 SMALLINT      NOT NULL,
    "ERROR_TEXT"            VARCHAR(500)  NULL,
    "MODIFIED"              TIMESTAMP     NOT NULL,
    "CREATED"               TIMESTAMP     NOT NULL,
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* Table REPORT_TEMPLATES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='REPORT_TEMPLATES';
IF c = 0 THEN EXECUTE '
CREATE TABLE REPORT_TEMPLATES (
    "TEMPLATE_ID"           NUMERIC(10)   NOT NULL,
    "CONTENT"               TEXT          NOT NULL,
    "CREATED"               TIMESTAMP     NOT NULL,
    PRIMARY KEY ("TEMPLATE_ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | tables for Oracle
 | SOS GmbH, 2021-05-20
*/


/* Table for SEARCH_WORKFLOWS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_SEARCH_W' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_SEARCH_W
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='SEARCH_WORKFLOWS';
IF c = 0 THEN EXECUTE '
CREATE TABLE SEARCH_WORKFLOWS (
    "ID"                    BIGINT           NOT NULL DEFAULT NEXTVAL(''SEQ_SEARCH_W''),
    "INV_CID"               BIGINT           NOT NULL, /* INV_CONFIGURATIONS.ID */
    "DEPLOYED"              NUMERIC(1)       NOT NULL, /* boolean */
    "CONTENT_HASH"          CHAR(64)         NOT NULL, /* workflow hash */
    "JOBS_COUNT"            INTEGER          NOT NULL,
    "JOBS"                  JSONB            NOT NULL,
    "ARGS"                  JSONB            NOT NULL,
    "JOBS_SCRIPTS"          JSONB            NOT NULL,
    "INSTRUCTIONS"          JSONB            NOT NULL,
    "INSTRUCTIONS_ARGS"     JSONB            NOT NULL,
    "CREATED"               TIMESTAMP        NOT NULL,
    "MODIFIED"              TIMESTAMP        NOT NULL,
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_SW_INVCID                 ON SEARCH_WORKFLOWS("INV_CID")
'; EXECUTE '
CREATE INDEX IDX_SW_DEP                    ON SEARCH_WORKFLOWS("DEPLOYED")
'; EXECUTE '
CREATE INDEX IDX_SW_CH                     ON SEARCH_WORKFLOWS("CONTENT_HASH")
'; EXECUTE '
CREATE INDEX IDX_SW_JC                     ON SEARCH_WORKFLOWS("JOBS_COUNT")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for SEARCH_WORKFLOWS_DEP_H */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='SEARCH_WORKFLOWS_DEP_H';
IF c = 0 THEN EXECUTE '
CREATE TABLE SEARCH_WORKFLOWS_DEP_H (
    "SEARCH_WID"            BIGINT               NOT NULL, /* SEARCH_WORKFLOWS.ID */
    "INV_CID"               BIGINT               NOT NULL, /* INV_CONFIGURATIONS.ID */
    "DEP_HID"               BIGINT               NOT NULL, /* DEP_HISTORY.ID */
    "CONTROLLER_ID"         VARCHAR(100)         NOT NULL,
    PRIMARY KEY ("SEARCH_WID","INV_CID","CONTROLLER_ID")
)
'; EXECUTE '
CREATE INDEX IDX_SWDH_DEPHID                     ON SEARCH_WORKFLOWS_DEP_H("DEP_HID")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | tables for Postgres
 | SOS GmbH, 2021-05-28
*/


/* Table for XMLEDITOR_CONFIGURATIONS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_XEC' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_XEC
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='XMLEDITOR_CONFIGURATIONS';
IF c = 0 THEN EXECUTE '
CREATE TABLE XMLEDITOR_CONFIGURATIONS (
    "ID"                            BIGINT         NOT NULL DEFAULT NEXTVAL(''SEQ_XEC''),
    "TYPE"                          VARCHAR(25)    NOT NULL,
    "NAME"                          VARCHAR(255)   NOT NULL,
    "SCHEMA_LOCATION"               VARCHAR(255)   NOT NULL,
    "CONFIGURATION_DRAFT"           TEXT           NULL,
    "CONFIGURATION_DRAFT_JSON"      TEXT           NULL,
    "CONFIGURATION_RELEASED"        TEXT           NULL,
    "CONFIGURATION_RELEASED_JSON"   TEXT           NULL,
    "AUDIT_LOG_ID"                  BIGINT         NOT NULL,
    "ACCOUNT"                       VARCHAR(255)   NOT NULL,
    "RELEASED"                      TIMESTAMP      NULL,
    "MODIFIED"                      TIMESTAMP      NOT NULL,
    "CREATED"                       TIMESTAMP      NOT NULL,
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_XEC_TN ON XMLEDITOR_CONFIGURATIONS("TYPE","NAME")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | tables for Postgres
 | SOS GmbH, 2021-05-28
*/


/* Table for YADE_TRANSFERS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_YADE_TRA' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_YADE_TRA
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='YADE_TRANSFERS';
IF c = 0 THEN EXECUTE '
CREATE TABLE YADE_TRANSFERS (
    "ID"                    BIGINT         NOT NULL DEFAULT NEXTVAL(''SEQ_YADE_TRA''),
    "CONTROLLER_ID"         VARCHAR(100)   NOT NULL,
    "WORKFLOW_PATH"         VARCHAR(255)   NOT NULL,
    "WORKFLOW_NAME"         VARCHAR(255)   NOT NULL,
    "ORDER_ID"              VARCHAR(255)   NOT NULL,
    "JOB"                   VARCHAR(255)   NOT NULL,
    "JOB_POSITION"          VARCHAR(255)   NOT NULL,
    "HOS_ID"                BIGINT         NOT NULL,
    "SOURCE_PROTOCOL_ID"    BIGINT         NOT NULL,
    "TARGET_PROTOCOL_ID"    BIGINT         NULL,
    "JUMP_PROTOCOL_ID"      BIGINT         NULL,
    "OPERATION"             INTEGER        NOT NULL,
    "PROFILE_NAME"          VARCHAR(100)   NULL,
    "START"                 TIMESTAMP      NOT NULL,
    "END"                   TIMESTAMP      NULL,
    "NUM_OF_FILES"          INTEGER        NOT NULL,
    "STATE"                 INTEGER        NOT NULL,
    "ERROR_MESSAGE"         VARCHAR(2000)  NULL,
    "CREATED"               TIMESTAMP      NOT NULL,
    PRIMARY KEY ("ID")
)
'; EXECUTE '
CREATE INDEX IDX_YT_START   ON YADE_TRANSFERS("START")
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;




/* Table for YADE_PROTOCOLS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_YADE_PRO' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_YADE_PRO
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='YADE_PROTOCOLS';
IF c = 0 THEN EXECUTE '
CREATE TABLE YADE_PROTOCOLS (
    "ID"                    BIGINT         NOT NULL DEFAULT NEXTVAL(''SEQ_YADE_PRO''),
    "HOSTNAME"              VARCHAR(255)   NOT NULL,
    "PORT"                  INTEGER        NOT NULL,
    "PROTOCOL"              INTEGER        NOT NULL,
    "ACCOUNT"               VARCHAR(255)   NOT NULL,
    "CREATED"               TIMESTAMP      NOT NULL,
    CONSTRAINT UNIQUE_YP_HPPA UNIQUE ("HOSTNAME", "PORT", "PROTOCOL", "ACCOUNT"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;



/* Table for YADE_FILES */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM pg_class, pg_namespace, pg_user WHERE UPPER(pg_class.relname) = 'SEQ_YADE_FIL' AND pg_namespace.oid = pg_class.relnamespace AND pg_class.relowner = pg_user.usesysid and pg_user.usename = current_user;
IF c = 0 THEN EXECUTE '
CREATE SEQUENCE SEQ_YADE_FIL
INCREMENT BY 1
START WITH 1
MINVALUE 1 CYCLE;
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer; 
BEGIN SELECT COUNT(*) INTO c FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA() AND UPPER(TABLE_NAME)='YADE_FILES';
IF c = 0 THEN EXECUTE '
CREATE TABLE YADE_FILES (
    "ID"                    BIGINT        NOT NULL DEFAULT NEXTVAL(''SEQ_YADE_FIL''),
    "TRANSFER_ID"           BIGINT        NOT NULL,
    "SOURCE_PATH"           VARCHAR(255)  NOT NULL,
    "TARGET_PATH"           VARCHAR(255)  NULL,
    "SIZE"                  BIGINT        NULL,
    "MODIFICATION_DATE"     TIMESTAMP     NULL,
    "STATE"                 INTEGER       NOT NULL,
    "INTEGRITY_HASH"        VARCHAR(255)  NULL,
    "ERROR_MESSAGE"         VARCHAR(2000) NULL,
    "CREATED"               TIMESTAMP           NOT NULL,
    CONSTRAINT INVENTORY_YF_UNIQUE UNIQUE ("TRANSFER_ID", "SOURCE_PATH"),
    PRIMARY KEY ("ID")
)';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
BEGIN 
EXECUTE  'UPDATE IAM_IDENTITY_SERVICES SET "IDENTITY_SERVICE_TYPE"=''OIDC-JOC'' WHERE "IDENTITY_SERVICE_TYPE"=''OIDC'' AND "ID" IN (SELECT "IDENTITY_SERVICE_ID" FROM IAM_ACCOUNTS)';
EXECUTE  'UPDATE JOC_CONFIGURATIONS SET "OBJECT_TYPE"=''OIDC-JOC'' WHERE "OBJECT_TYPE"=''OIDC'' AND "ID" IN 
          (SELECT T."ID" FROM (SELECT "ID" FROM JOC_CONFIGURATIONS JC
          WHERE JC."OBJECT_TYPE"=''OIDC'' AND
          JC."NAME" IN (SELECT IC."IDENTITY_SERVICE_NAME" FROM IAM_IDENTITY_SERVICES IC, IAM_ACCOUNTS IA WHERE IA."IDENTITY_SERVICE_ID"=IC."ID" AND  IC."IDENTITY_SERVICE_NAME"=JC."NAME")) T)
';
RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* IAM_IDENTITY_SERVICES Columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_IDENTITY_SERVICES' AND UPPER(COLUMN_NAME)='SECOND_FACTOR' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_IDENTITY_SERVICES ADD COLUMN "SECOND_FACTOR" NUMERIC(1) DEFAULT 0 NOT NULL';
        EXECUTE 'UPDATE IAM_IDENTITY_SERVICES SET "SECOND_FACTOR" = 0';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
 

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_IDENTITY_SERVICES' AND UPPER(COLUMN_NAME)='SECOND_FACTOR_IS_ID' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_IDENTITY_SERVICES ADD COLUMN "SECOND_FACTOR_IS_ID" BIGINT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_IDENTITY_SERVICES' AND UPPER(COLUMN_NAME)='SINGLE_FACTOR_PWD' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE IAM_IDENTITY_SERVICES DROP COLUMN "SINGLE_FACTOR_PWD"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT; 
 

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_IDENTITY_SERVICES' AND UPPER(COLUMN_NAME)='SINGLE_FACTOR_CERT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE IAM_IDENTITY_SERVICES DROP COLUMN "SINGLE_FACTOR_CERT"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT; 
 
/* IAM_ACCOUNTS Columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_ACCOUNTS' AND UPPER(COLUMN_NAME)='FORCE_PASSWORD_CHANGE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_ACCOUNTS ADD COLUMN "FORCE_PASSWORD_CHANGE" NUMERIC(1) DEFAULT 0 NOT NULL';
        EXECUTE 'UPDATE IAM_ACCOUNTS SET "FORCE_PASSWORD_CHANGE" = 0';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
 
  
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_ACCOUNTS' AND UPPER(COLUMN_NAME)='DISABLED' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_ACCOUNTS ADD COLUMN "DISABLED" NUMERIC(1) DEFAULT 0 NOT NULL';
        EXECUTE 'UPDATE IAM_ACCOUNTS SET "DISABLED" = 0';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_ACCOUNTS' AND UPPER(COLUMN_NAME)='EMAIL' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_ACCOUNTS ADD COLUMN "EMAIL" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='IAM_ROLES' AND UPPER(COLUMN_NAME)='ORDERING' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_ROLES ADD COLUMN "ORDERING" NUMERIC(10) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* IAM Constraints */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE UPPER(CONSTRAINT_NAME)='UNIQUE_IAM_A_IN' AND UPPER(TABLE_NAME)='IAM_ACCOUNTS' AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_ACCOUNTS ADD CONSTRAINT UNIQUE_IAM_A_IN UNIQUE ("IDENTITY_SERVICE_ID", "ACCOUNT_NAME");';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE UPPER(CONSTRAINT_NAME)='UNIQUE_IAM_R_IN' AND UPPER(TABLE_NAME)='IAM_ROLES' AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_ROLES ADD CONSTRAINT UNIQUE_IAM_R_IN UNIQUE ("IDENTITY_SERVICE_ID", "ROLE_NAME");';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
 
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE UPPER(CONSTRAINT_NAME)='UNIQUE_IAM_S_N' AND UPPER(TABLE_NAME)='IAM_IDENTITY_SERVICES' AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE IAM_IDENTITY_SERVICES ADD CONSTRAINT UNIQUE_IAM_S_N UNIQUE ("IDENTITY_SERVICE_NAME");';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
 
/* DPL_ORDERS Columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='DPL_ORDERS' AND UPPER(COLUMN_NAME)='START_MODE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE DPL_ORDERS ADD COLUMN "START_MODE" NUMERIC(1) DEFAULT 0 NOT NULL';
        EXECUTE 'UPDATE DPL_ORDERS SET "START_MODE" = 0  where "PERIOD_BEGIN" is null';
        EXECUTE 'UPDATE DPL_ORDERS SET "START_MODE" = 1  where "PERIOD_BEGIN" is not null';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='DPL_ORDERS' AND UPPER(COLUMN_NAME)='ORDER_PARAMETERISATION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE DPL_ORDERS ADD COLUMN "ORDER_PARAMETERISATION" VARCHAR(1000) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='DPL_ORDERS' AND UPPER(COLUMN_NAME)='MESSAGE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist > 0 THEN 
        EXECUTE 'ALTER TABLE DPL_ORDERS DROP COLUMN "MESSAGE"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_ORDERS drop indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='UNIQUE_DO_CWOP' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'ALTER TABLE DPL_ORDERS DROP CONSTRAINT UNIQUE_DO_CWOP';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_PSTART' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_O_PSTART';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_ORDER_ID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_O_ORDER_ID';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_START_MODE' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_O_START_MODE';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_ORDERS add indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_SHID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_O_SHID ON DPL_ORDERS("SUBMISSION_HISTORY_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_ON' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_O_ON ON DPL_ORDERS("ORDER_NAME")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_OID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_O_OID ON DPL_ORDERS("ORDER_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_PSCID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_O_PSCID ON DPL_ORDERS("PLANNED_START","CONTROLLER_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDERS' AND UPPER(indexrelname)='IDX_DPL_O_WN' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_O_WN ON DPL_ORDERS("WORKFLOW_NAME")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_HISTORY drop indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_HISTORY' AND UPPER(indexrelname)='IDX_DPL_DPDATE' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_DPDATE';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_HISTORY' AND UPPER(indexrelname)='IDX_DPL_CATEGORY' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_CATEGORY';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_HISTORY' AND UPPER(indexrelname)='IDX_DPL_OH_ORDER_ID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_OH_ORDER_ID';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_HISTORY add indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_HISTORY' AND UPPER(indexrelname)='IDX_DPL_H_DPDSCID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_H_DPDSCID ON DPL_HISTORY("DAILY_PLAN_DATE","SUBMITTED","CONTROLLER_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_HISTORY' AND UPPER(indexrelname)='IDX_DPL_H_OID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_H_OID ON DPL_HISTORY("ORDER_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_SUBMISSIONS add indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_SUBMISSIONS' AND UPPER(indexrelname)='IDX_DPL_S_SFDCID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_S_SFDCID ON DPL_SUBMISSIONS("SUBMISSION_FOR_DATE","CONTROLLER_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* DPL_ORDER_VARIABLES Columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='DPL_ORDER_VARIABLES' AND UPPER(COLUMN_NAME)='ORDER_ID' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'DELETE FROM DPL_ORDER_VARIABLES WHERE "PLANNED_ORDER_ID" NOT IN (SELECT "ID" FROM DPL_ORDERS)';
        EXECUTE 'ALTER TABLE DPL_ORDER_VARIABLES ADD COLUMN "CONTROLLER_ID" VARCHAR(100) NULL';
        EXECUTE 'ALTER TABLE DPL_ORDER_VARIABLES ADD COLUMN "ORDER_ID" VARCHAR(255) NULL';
        EXECUTE 'UPDATE DPL_ORDER_VARIABLES SET "CONTROLLER_ID"=DPL_ORDERS."CONTROLLER_ID","ORDER_ID"=DPL_ORDERS."ORDER_ID" FROM DPL_ORDERS WHERE DPL_ORDER_VARIABLES."PLANNED_ORDER_ID"=DPL_ORDERS."ID"';
        EXECUTE 'ALTER TABLE DPL_ORDER_VARIABLES ALTER COLUMN "CONTROLLER_ID" SET NOT NULL';
        EXECUTE 'ALTER TABLE DPL_ORDER_VARIABLES ALTER COLUMN "ORDER_ID" SET NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_ORDER_VARIABLES add indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDER_VARIABLES' AND UPPER(indexrelname)='IDX_DPL_OV_OIDCID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_DPL_OV_OIDCID ON DPL_ORDER_VARIABLES("ORDER_ID","CONTROLLER_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_ORDER_VARIABLES drop indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='DPL_ORDER_VARIABLES' AND UPPER(indexrelname)='IDX_DPL_OV_POID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_DPL_OV_POID';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DPL_ORDER_VARIABLES drop columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='DPL_ORDER_VARIABLES' AND UPPER(COLUMN_NAME)='PLANNED_ORDER_ID' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist > 0 THEN 
       EXECUTE 'ALTER TABLE DPL_ORDER_VARIABLES DROP COLUMN "PLANNED_ORDER_ID"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* DPL_ORDER_VARIABLES Columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='DPL_ORDER_VARIABLES' AND UPPER(COLUMN_NAME)='VARIABLE_VALUE' AND UPPER(UDT_NAME)='TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE DPL_ORDER_VARIABLES ALTER COLUMN "VARIABLE_VALUE" TYPE TEXT;';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* HISTORY_AGENTS add column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='HISTORY_AGENTS' AND UPPER(COLUMN_NAME)='AGENT_ID' AND UPPER(UDT_NAME)='VARCHAR' AND CHARACTER_MAXIMUM_LENGTH=100 AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE HISTORY_AGENTS ALTER COLUMN "AGENT_ID" TYPE VARCHAR(255);';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='HISTORY_AGENTS' AND UPPER(COLUMN_NAME)='URI' AND UPPER(UDT_NAME)='VARCHAR' AND CHARACTER_MAXIMUM_LENGTH=100 AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE HISTORY_AGENTS ALTER COLUMN "URI" TYPE VARCHAR(255);';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* HISTORY_ORDERS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='HISTORY_ORDERS' AND UPPER(COLUMN_NAME)='END_RETURN_CODE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE HISTORY_ORDERS ADD COLUMN "END_RETURN_CODE" INTEGER NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='HISTORY_ORDERS' AND UPPER(COLUMN_NAME)='END_MESSAGE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE HISTORY_ORDERS ADD COLUMN "END_MESSAGE" VARCHAR(500) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* HISTORY_ORDERS indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM pg_stat_all_indexes WHERE  UPPER(relname)='HISTORY_ORDERS' AND UPPER(indexrelname)='IDX_HO_LID' AND schemaname=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_HO_LID ON HISTORY_ORDERS("LOG_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM pg_stat_all_indexes WHERE  UPPER(relname)='HISTORY_ORDERS' AND UPPER(indexrelname)='IDX_HO_WNAME' AND schemaname=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_HO_WNAME ON HISTORY_ORDERS("WORKFLOW_NAME")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* HISTORY_ORDER_STEPS add column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND UPPER(COLUMN_NAME)='AGENT_ID' AND UPPER(UDT_NAME)='VARCHAR' AND CHARACTER_MAXIMUM_LENGTH=100 AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE HISTORY_ORDER_STEPS ALTER COLUMN "AGENT_ID" TYPE VARCHAR(255);';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND UPPER(COLUMN_NAME)='AGENT_URI' AND UPPER(UDT_NAME)='VARCHAR' AND CHARACTER_MAXIMUM_LENGTH=100 AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE HISTORY_ORDER_STEPS ALTER COLUMN "AGENT_URI" TYPE VARCHAR(255);';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND UPPER(COLUMN_NAME)='JOB_NOTIFICATION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE HISTORY_ORDER_STEPS ADD COLUMN "JOB_NOTIFICATION" VARCHAR(1000) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND UPPER(COLUMN_NAME)='AGENT_NAME' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE HISTORY_ORDER_STEPS ADD COLUMN "AGENT_NAME" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='HISTORY_ORDER_STEPS' AND UPPER(COLUMN_NAME)='SUBAGENT_CLUSTER_ID' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE HISTORY_ORDER_STEPS ADD COLUMN "SUBAGENT_CLUSTER_ID" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* HISTORY_ORDER_STEPS indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM pg_stat_all_indexes WHERE  UPPER(relname)='HISTORY_ORDER_STEPS' AND UPPER(indexrelname)='IDX_HOSTEPS_WNAME' AND schemaname=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_HOSTEPS_WNAME ON HISTORY_ORDER_STEPS("WORKFLOW_NAME")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* DROP tables */
DROP TABLE IF EXISTS HISTORY_TEMP_LOGS;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* HISTORY_ORDERS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='HISTORY_ORDERS' AND UPPER(COLUMN_NAME)='START_VARIABLES' AND UPPER(UDT_NAME)='TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE HISTORY_ORDERS ALTER COLUMN "START_VARIABLES" TYPE TEXT;';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* INV_AGENT_INSTANCES add column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='JAVA_VERSION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES ADD COLUMN "JAVA_VERSION" VARCHAR(30) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='DEPLOYED' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES ADD COLUMN "DEPLOYED" NUMERIC(1) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='TITLE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES ADD COLUMN "TITLE" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='HIDDEN' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES RENAME COLUMN "DISABLED" TO "HIDDEN"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='DISABLED' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES ADD COLUMN "DISABLED" NUMERIC(1) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='ORDERING' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES ADD COLUMN "ORDERING" NUMERIC(10) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_AGENT_INSTANCES' AND UPPER(COLUMN_NAME)='PROCESS_LIMIT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_AGENT_INSTANCES ADD COLUMN "PROCESS_LIMIT" NUMERIC(10) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* INV_JS_INSTANCES add column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_JS_INSTANCES' AND UPPER(COLUMN_NAME)='JAVA_VERSION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_JS_INSTANCES ADD COLUMN "JAVA_VERSION" VARCHAR(30) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* INV_SUBAGENT_INSTANCES add column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_SUBAGENT_INSTANCES' AND UPPER(COLUMN_NAME)='DISABLED' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_SUBAGENT_INSTANCES ADD COLUMN "DISABLED" NUMERIC(1) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_SUBAGENT_INSTANCES' AND UPPER(COLUMN_NAME)='DEPLOYED' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_SUBAGENT_INSTANCES ADD COLUMN "DEPLOYED" NUMERIC(1) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_SUBAGENT_CLUSTERS' AND UPPER(COLUMN_NAME)='ORDERING' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_SUBAGENT_CLUSTERS ADD COLUMN "ORDERING" NUMERIC(10) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* INV_CONFIGURATIONS add column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_CONFIGURATIONS' AND UPPER(COLUMN_NAME)='REPO_CTRL' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_CONFIGURATIONS ADD COLUMN "REPO_CTRL" NUMERIC(1) DEFAULT 0 NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='INV_SUBAGENT_INSTANCES' AND UPPER(COLUMN_NAME)='TITLE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
       EXECUTE 'ALTER TABLE INV_SUBAGENT_INSTANCES ADD COLUMN "TITLE" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* INV_CERTS */
/* DROP CONSTRAINT UNIQUE_ICS_KTC */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE UPPER(CONSTRAINT_NAME)='UNIQUE_ICS_KTC' AND UPPER(TABLE_NAME)='INV_CERTS' AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF results > 0 THEN 
        EXECUTE 'ALTER TABLE inv_certs DROP CONSTRAINT unique_ics_ktc;';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
/* add CONSTRAINT UNIQUE_ICS_KTCAS */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE UPPER(CONSTRAINT_NAME)='UNIQUE_ICS_KTCAS' AND UPPER(TABLE_NAME)='INV_CERTS' AND TABLE_SCHEMA=CURRENT_SCHEMA(); 
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE INV_CERTS ADD CONSTRAINT UNIQUE_ICS_KTCAS UNIQUE ("KEY_TYPE", "CA", "ACCOUNT", "SECLVL");';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;


/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* JOC_INSTANCES Columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='JOC_INSTANCES' AND UPPER(COLUMN_NAME)='CLUSTER_ID' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE JOC_INSTANCES ADD COLUMN "CLUSTER_ID" VARCHAR(10) NULL';
        EXECUTE 'UPDATE JOC_INSTANCES SET "CLUSTER_ID" = ''${jocClusterId}''';
        EXECUTE 'ALTER TABLE JOC_INSTANCES ALTER COLUMN "CLUSTER_ID" SET NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='JOC_INSTANCES' AND UPPER(COLUMN_NAME)='API_SERVER' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE JOC_INSTANCES ADD COLUMN "API_SERVER" NUMERIC(1) NULL';
        EXECUTE 'UPDATE JOC_INSTANCES SET "API_SERVER" = 0';
        EXECUTE 'ALTER TABLE JOC_INSTANCES ALTER COLUMN "API_SERVER" SET NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='JOC_INSTANCES' AND UPPER(COLUMN_NAME)='VERSION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE JOC_INSTANCES ADD COLUMN "VERSION" VARCHAR(30) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE column_exist integer;
BEGIN 
    SELECT COUNT(*) INTO column_exist FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='JOC_INSTANCES' AND UPPER(COLUMN_NAME)='CERTIFICATE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF column_exist = 0 THEN 
        EXECUTE 'ALTER TABLE JOC_INSTANCES ADD COLUMN "CERTIFICATE" VARCHAR(4000) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* MON_NOTIFICATIONS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_NOTIFICATIONS' AND UPPER(COLUMN_NAME)='WARN' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_NOTIFICATIONS ADD COLUMN "WARN" SMALLINT NULL';
       EXECUTE 'UPDATE MON_NOTIFICATIONS SET "WARN"=0';
       EXECUTE 'ALTER TABLE MON_NOTIFICATIONS ALTER COLUMN "WARN" SET NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_NOTIFICATIONS' AND UPPER(COLUMN_NAME)='WARN_TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_NOTIFICATIONS ADD COLUMN "WARN_TEXT" VARCHAR(500) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_ORDERS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_ORDERS' AND UPPER(COLUMN_NAME)='END_RETURN_CODE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_ORDERS ADD COLUMN "END_RETURN_CODE" INTEGER NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_ORDERS' AND UPPER(COLUMN_NAME)='END_MESSAGE' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_ORDERS ADD COLUMN "END_MESSAGE" VARCHAR(500) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_ORDERS indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM pg_stat_all_indexes WHERE  UPPER(relname)='MON_ORDERS' AND UPPER(indexrelname)='IDX_MONO_MPID' AND schemaname=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_MONO_MPID ON MON_ORDERS("MAIN_PARENT_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_ORDER_STEPS indexes */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM pg_stat_all_indexes WHERE  UPPER(relname)='MON_ORDER_STEPS' AND UPPER(indexrelname)='IDX_MONOS_HMPID' AND schemaname=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_MONOS_HMPID ON MON_ORDER_STEPS("HO_MAIN_PARENT_ID")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_ORDER_STEPS drop index */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='MON_ORDER_STEPS' AND UPPER(indexrelname)='IDX_MONOS_W' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_MONOS_W';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_ORDER_STEPS column */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='AGENT_ID' AND UPPER(UDT_NAME)='VARCHAR' AND CHARACTER_MAXIMUM_LENGTH=100 AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE MON_ORDER_STEPS ALTER COLUMN "AGENT_ID" TYPE VARCHAR(255);';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='AGENT_URI' AND UPPER(UDT_NAME)='VARCHAR' AND CHARACTER_MAXIMUM_LENGTH=100 AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE MON_ORDER_STEPS ALTER COLUMN "AGENT_URI" TYPE VARCHAR(255);';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='JOB_NOTIFICATION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_ORDER_STEPS ADD COLUMN "JOB_NOTIFICATION" VARCHAR(1000) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='AGENT_NAME' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_ORDER_STEPS ADD COLUMN "AGENT_NAME" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='SUBAGENT_CLUSTER_ID' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_ORDER_STEPS ADD COLUMN "SUBAGENT_CLUSTER_ID" VARCHAR(255) NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='WARN' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE MON_ORDER_STEPS DROP COLUMN "WARN"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='MON_ORDER_STEPS' AND UPPER(COLUMN_NAME)='WARN_TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 1 THEN 
        EXECUTE 'ALTER TABLE MON_ORDER_STEPS DROP COLUMN "WARN_TEXT"';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* starting with JS7 release 2.5.2 (JOC-1447) - MON_SYSNOTIFICATIONS related changes */

/* MON_NOT_MONITORS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_NOT_MONITORS' AND UPPER(COLUMN_NAME)='APPLICATION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_NOT_MONITORS ADD COLUMN "APPLICATION" NUMERIC(1) NULL';
       EXECUTE 'UPDATE MON_NOT_MONITORS SET "APPLICATION"=0';
       EXECUTE 'ALTER TABLE MON_NOT_MONITORS ALTER COLUMN "APPLICATION" SET NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_NOT_MONITORS drop index */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE index_exist integer;
BEGIN 
    SELECT COUNT(*) INTO index_exist FROM pg_stat_all_indexes WHERE  UPPER(relname)='MON_NOT_MONITORS' AND UPPER(indexrelname)='IDX_MONM_NID' AND schemaname=CURRENT_SCHEMA();  
    IF index_exist > 0 THEN 
        EXECUTE 'DROP INDEX IDX_MONM_NID';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_NOT_MONITORS create index */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM pg_stat_all_indexes WHERE  UPPER(relname)='MON_NOT_MONITORS' AND UPPER(indexrelname)='IDX_MONM_NIDA' AND schemaname=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'CREATE INDEX IDX_MONM_NIDA ON MON_NOT_MONITORS("NOT_ID","APPLICATION")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_NOT_ACKNOWLEDGEMENTS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE UPPER(TABLE_NAME)='MON_NOT_ACKNOWLEDGEMENTS' AND UPPER(COLUMN_NAME)='APPLICATION' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
       EXECUTE 'ALTER TABLE MON_NOT_ACKNOWLEDGEMENTS ADD COLUMN "APPLICATION" NUMERIC(1) NULL';
       EXECUTE 'UPDATE MON_NOT_ACKNOWLEDGEMENTS SET "APPLICATION"=0';
       EXECUTE 'ALTER TABLE MON_NOT_ACKNOWLEDGEMENTS ALTER COLUMN "APPLICATION" SET NOT NULL';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* MON_NOT_ACKNOWLEDGEMENTS primary key */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
idx_name varchar(255);
BEGIN 
    SELECT INTO results,idx_name COUNT(a.*),ai.indexrelname  FROM pg_index i
    JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
    JOIN pg_stat_all_indexes ai on ai.relid=i.indrelid and ai.indexrelid=i.indexrelid
    WHERE  i.indrelid = 'MON_NOT_ACKNOWLEDGEMENTS'::regclass
    AND i.indisprimary
    AND ai.schemaname=CURRENT_SCHEMA()
    GROUP BY ai.indexrelname;
    IF results <> 2 THEN 
        EXECUTE 'ALTER TABLE MON_NOT_ACKNOWLEDGEMENTS DROP CONSTRAINT '||idx_name;
        EXECUTE 'ALTER TABLE MON_NOT_ACKNOWLEDGEMENTS ADD PRIMARY KEY("NOT_ID","APPLICATION")';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/* MON_ORDERS columns */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ 
DECLARE results integer;
BEGIN 
    SELECT COUNT(*) INTO results FROM INFORMATION_SCHEMA.COLUMNS WHERE  UPPER(TABLE_NAME)='MON_ORDERS' AND UPPER(COLUMN_NAME)='START_VARIABLES' AND UPPER(UDT_NAME)='TEXT' AND TABLE_CATALOG=CURRENT_DATABASE() AND TABLE_SCHEMA=CURRENT_SCHEMA();  
    IF results = 0 THEN 
        EXECUTE 'ALTER TABLE MON_ORDERS ALTER COLUMN "START_VARIABLES" TYPE TEXT;';
    END IF; 
    RETURN; 
END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;
/*
 | Insert Script for default authentication account root:root for identity services
 | SOS GmbH, 2021-12-12
*/

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c1 integer; DECLARE c2 integer; DECLARE c3 integer; DECLARE c4 integer; DECLARE c5 integer; 

BEGIN 
SELECT COUNT(*) INTO c1 FROM IAM_IDENTITY_SERVICES;  
SELECT COUNT(*) INTO c2 FROM IAM_ACCOUNT2ROLES;   
SELECT COUNT(*) INTO c3 FROM IAM_ACCOUNT2ROLES;   
SELECT COUNT(*) INTO c4 FROM IAM_ACCOUNTS;   
SELECT COUNT(*) INTO c5 FROM IAM_ROLES; 

IF c1 = 0 and c2 = 0 and c3 = 0 and c4 = 0 and c5 = 0 THEN 
EXECUTE  
'INSERT INTO IAM_IDENTITY_SERVICES("ID","IDENTITY_SERVICE_TYPE", "IDENTITY_SERVICE_NAME","REQUIRED","DISABLED", "AUTHENTICATION_SCHEME","SECOND_FACTOR", "ORDERING") VALUES (NEXTVAL(''SEQ_IAM_IDENTITY_SERVICES''),''JOC'',''joc'',0,0,''SINGLE'',0,0)'; 
EXECUTE  
'INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL(''SEQ_IAM_ROLES''),CURRVAL(''SEQ_IAM_IDENTITY_SERVICES''),''all'')'; 
EXECUTE  
'INSERT INTO IAM_ACCOUNTS("ID","IDENTITY_SERVICE_ID", "ACCOUNT_NAME","ACCOUNT_PASSWORD") VALUES (NEXTVAL(''SEQ_IAM_ACCOUNTS''),CURRVAL(''SEQ_IAM_IDENTITY_SERVICES''),''root'',''$JS7-1.0$65536$9aRojy9RBlLyf40BVcE+pg==$QLXLz0CHFaYDNeIE3ioZIOAGoBy5xo2rTmp7i38DEEF5cK22MzpAL89jA2USWv5KfTth8yprRkvIk+iWS+q3Aw=='')'; 
EXECUTE  
'INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL(''SEQ_IAM_PERMISSIONS''),CURRVAL(''SEQ_IAM_IDENTITY_SERVICES''),CURRVAL(''SEQ_IAM_ROLES''),''sos:products'',0,0)'; 
EXECUTE  
'INSERT INTO IAM_ACCOUNT2ROLES("ID","ROLE_ID", "ACCOUNT_ID") VALUES (NEXTVAL(''SEQ_IAM_ACCOUNT2ROLES''),CURRVAL(''SEQ_IAM_ROLES''),CURRVAL(''SEQ_IAM_ACCOUNTS''))'; 

/*
 Administrator
*/
INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL('SEQ_IAM_ROLES'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),'administrator');
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration',0,0);



INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:auditlog:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:calendars:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:cluster:manage',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:dailyplan:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:documentations:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:inventory:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:notification',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:others',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:restart',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:terminate',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:switch_over',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:agents:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:deployment:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:locks:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:workflows:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:orders:view',0,0);

/*
 application_manager
*/
INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL('SEQ_IAM_ROLES'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),'application_manager');
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:controller:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:customization',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:settings',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:auditlog:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:calendars:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:dailyplan',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:documentations',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:filetransfer',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:inventory',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:notification:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:agents:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:deployment',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:locks:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:workflows:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:orders',0,0);
 
/*
 it_operator
*/
 
INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL('SEQ_IAM_ROLES'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),'it_operator');
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:customization',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:settings:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:auditlog:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:calendars:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:dailyplan',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:documentations',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:filetransfer',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:inventory:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:notification:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:agents:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:deployment:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:locks:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:workflows:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:orders',0,0);


/*
 incident_manager
*/
 
INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL('SEQ_IAM_ROLES'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),'incident_manager');
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:accounts',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:customization',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:settings',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:auditlog:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:calendars:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:dailyplan',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:documentations',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:filetransfer',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:inventory',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:notification',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:others',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller',0,0);



/*
 business_user
*/

INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL('SEQ_IAM_ROLES'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),'business_user');
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:administration:customization:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:auditlog:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:calendars:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:dailyplan:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:documentations:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:filetransfer:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:agents:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:locks:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:workflows:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:orders:view',0,0);



/*
 api_user
*/

INSERT INTO IAM_ROLES("ID","IDENTITY_SERVICE_ID", "ROLE_NAME") VALUES (NEXTVAL('SEQ_IAM_ROLES'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),'api_user');
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:auditlog:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:calendars:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:dailyplan:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:documentations:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:joc:filetransfer:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:agents:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:deployment:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:locks:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:workflows:view',0,0);
INSERT INTO IAM_PERMISSIONS("ID","IDENTITY_SERVICE_ID","ROLE_ID","ACCOUNT_PERMISSION", "EXCLUDED","RECURSIVE") VALUES (NEXTVAL('SEQ_IAM_PERMISSIONS'),CURRVAL('SEQ_IAM_IDENTITY_SERVICES'),CURRVAL('SEQ_IAM_ROLES'),'sos:products:controller:orders:view',0,0);
 



END IF; RETURN;END;
$$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;
  
 
/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;



/* set Security Level */
UPDATE INV_JS_INSTANCES SET "SECURITY_LEVEL" = 0 WHERE "SECURITY_LEVEL" <> 0;
COMMIT;

/* delete/insert version */
DELETE FROM JOC_VARIABLES WHERE "NAME"='version';
INSERT INTO JOC_VARIABLES ("NAME", "NUMERIC_VALUE", "TEXT_VALUE", "BINARY_VALUE") VALUES ('version',NULL,'2.7.0',NULL);
COMMIT;
/*
 | Insert Script for default Keys for SecurityLevel LOW and MEDIUM
 | SOS GmbH, 2021-05-22
*/

/*
 | ATTENTION:
 | The "SECLVL" field contains the security level (0=LOW, 1=MEDUIM, 2=HIGH).
 | This value MUST match the security level selected in the setup.
 | If the following two INSERT statements are to be executed before the setup, then the value of "SECLVL" may have to be adjusted.
 | 
 | BEGIN SELECT COUNT(*) INTO c FROM DEP_KEYS ... AND "SECLVL"=[number of security level];
 | INSERT INTO DEP_KEYS( ... , [number of security level])
 | INSERT INTO INV_CERTS( ... , [number of security level])
*/

/* import default */
CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM DEP_KEYS WHERE "ACCOUNT"='root' AND "SECLVL"=0; IF c = 0 THEN EXECUTE '
INSERT INTO DEP_KEYS("ID","KEY_TYPE","KEY_ALG","KEY","CERTIFICATE","ACCOUNT","SECLVL") VALUES (nextval(''SEQ_DEP_K''),0,2,''-----BEGIN EC PRIVATE KEY-----'' || chr(10) || ''MHcCAQEEID+VjMgUjVph6n1lxu5Vx9qrhoCyMrr9vcmwKBx+MSG2oAoGCCqGSM49'' || chr(10) || ''AwEHoUQDQgAEVN/5cTnhaX31K5Hh0N3sgMfKXY3JktHLvFxXTn2rPgtoKAef0NjB'' || chr(10) || ''vSA5GJ7uM48zlyX3JraqSPDkeXJqLnQdww=='' || chr(10) || ''-----END EC PRIVATE KEY-----'', ''-----BEGIN CERTIFICATE-----'' || chr(10) || ''MIID1zCCAb+gAwIBAgIJAMxQSEdXteoRMA0GCSqGSIb3DQEBCwUAMIGNMQswCQYD'' || chr(10) || ''VQQGEwJERTEPMA0GA1UECAwGQmVybGluMQ8wDQYDVQQHDAZCZXJsaW4xDDAKBgNV'' || chr(10) || ''BAoMA1NPUzELMAkGA1UECwwCSVQxHDAaBgNVBAMME1NPUyBJbnRlcm1lZGlhdGUg'' || chr(10) || ''Q0ExIzAhBgkqhkiG9w0BCQEWFGFkbWluQHNvcy1iZXJsaW4uY29tMB4XDTIwMTAx'' || chr(10) || ''MzEyNTA1NVoXDTI1MTAxMjEyNTA1NVowbDELMAkGA1UEBhMCREUxDzANBgNVBAgM'' || chr(10) || ''BkJlcmxpbjEPMA0GA1UEBwwGQmVybGluMQwwCgYDVQQKDANTT1MxCzAJBgNVBAsM'' || chr(10) || ''AklUMQ8wDQYDVQQDDAZzb3MtZWMxDzANBgNVBC4TBlNPUyBDQTBZMBMGByqGSM49'' || chr(10) || ''AgEGCCqGSM49AwEHA0IABFTf+XE54Wl99SuR4dDd7IDHyl2NyZLRy7xcV059qz4L'' || chr(10) || ''aCgHn9DYwb0gORie7jOPM5cl9ya2qkjw5Hlyai50HcOjJTAjMBEGCWCGSAGG+EIB'' || chr(10) || ''AQQEAwIHgDAOBgNVHQ8BAf8EBAMCBeAwDQYJKoZIhvcNAQELBQADggIBAGC7BKCd'' || chr(10) || ''kuhIzEGflG4tslnWlC7BXvbI2lKkUbDYlcBf04hYl4ootWfprFfF80LXBFgWUxGN'' || chr(10) || ''6HZIQDwWJch/h+UFjf/97zVxzbl0q1miZtNN2USbYK3yfrgWyOKEzZcAxUnr2pL4'' || chr(10) || ''9/t2LBmFKvgmh1RiB40Vf8s5frEQID2Am+I+pZsi4R7/OtwUo6dZJKP6IFlqZYzf'' || chr(10) || ''klWlLMgwVK6Iqo+Lu8M2oxWRHxMCTOAQyQmVWf8ZsfzEn3k412v5tejWjQsoo057'' || chr(10) || ''VCQ3p36UOl2+Qrif2PvYOz3pvdek6xwuJaqpr1fDSjEO/WSpl4Fdx0pavCFLniaN'' || chr(10) || ''odP00FpH1OfwHf3XvYMCcHO+/JRlsc4uNaalEkD6n3pNbWlpJyaneEUr7GqC8TEX'' || chr(10) || ''zHJ3r5SSKFxwEX/iAL5CyIgq8BUFLQtXFBiYVTMQXyUTNixo0h130bV4KMdpfLLm'' || chr(10) || ''u+iekRBGM59sP5Ijfg4lvQqoMZ2Ck+BGBye/tlItgDOIh+FIIVMwfHY4KOlfaqRr'' || chr(10) || ''JRzEpVkssoIVHNghl1kT3U9ZSbMtJ3W650uBtidhS0tYOXPixd5DJ8VI5cl16pwb'' || chr(10) || ''DpkAS01bxgDhQrvQINzrLTXeDuY01Lr3HC8TD/NMS+p7X5CQ1KxUhgzxaPQ8LTau'' || chr(10) || ''9DzuuCRcbkIBI+KQl5KF8kZ2ohdw/tNOH+RK'' || chr(10) || ''-----END CERTIFICATE-----'', ''root'', 0)
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

CREATE OR REPLACE FUNCTION tmp() RETURNS VOID AS $$ DECLARE c integer;
BEGIN SELECT COUNT(*) INTO c FROM INV_CERTS WHERE "ACCOUNT"='root' AND "CA"=1; IF c = 0 THEN EXECUTE '
INSERT INTO INV_CERTS("ID","KEY_TYPE","KEY_ALG","PEM", "CA","ACCOUNT","SECLVL") VALUES (nextval(''SEQ_INV_CRTS''),1,1,''-----BEGIN CERTIFICATE-----'' || chr(10) || ''MIIGpTCCBI2gAwIBAgIRANBLkv2+/RYfqQXsW1mziIYwDQYJKoZIhvcNAQELBQAw'' || chr(10) || ''gYUxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCZXJsaW4xDzANBgNVBAcMBkJlcmxp'' || chr(10) || ''bjEMMAoGA1UECgwDU09TMQswCQYDVQQLDAJJVDEUMBIGA1UEAwwLU09TIFJvb3Qg'' || chr(10) || ''Q0ExIzAhBgkqhkiG9w0BCQEWFGFkbWluQHNvcy1iZXJsaW4uY29tMB4XDTIwMDYx'' || chr(10) || ''NzIzNDkxNFoXDTMwMDYxNTIzNDkxNFowgY0xCzAJBgNVBAYTAkRFMQ8wDQYDVQQI'' || chr(10) || ''DAZCZXJsaW4xDzANBgNVBAcMBkJlcmxpbjEMMAoGA1UECgwDU09TMQswCQYDVQQL'' || chr(10) || ''DAJJVDEcMBoGA1UEAwwTU09TIEludGVybWVkaWF0ZSBDQTEjMCEGCSqGSIb3DQEJ'' || chr(10) || ''ARYUYWRtaW5Ac29zLWJlcmxpbi5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw'' || chr(10) || ''ggIKAoICAQDGmo7XDw2Bd/Y9BmLLgNhVXh6oxuAwFpY9Bho3EbtBQp4OpeaC1irb'' || chr(10) || ''m2ID8JlGtWOvCmCv//b00Zxx7KESa1PuF1J5XCxjPzoeRvlVR/BbZtdK8IZUZdL3'' || chr(10) || ''gqWSVX9UX6Go/ghknM5LXPG7y8XhrIUA27F0ts3nYYtD/djrscTTlH6luh7lZiKK'' || chr(10) || ''x5TX52YB5it7pxkHSO7DNaBgSlbDXvK/NEthwWAIHvqunwiBchWgUbH/qrne5MBW'' || chr(10) || ''VvX2G8JCDyU8JK6Fab0InU9PB/yYWz1hDUqDhMhNvRrMLSQ0KwWkMWyEbXJoEHNA'' || chr(10) || ''xBF+7Mp2pBy8gL11i46JaKvCEv5bSPCwQ+BdGDw6Oa4bt7H/aEsKHzNekl8U6pvc'' || chr(10) || ''gpuoXQ6xY2xqLx9JLTYWKDvsMftuevPV2gqqcqqEBvISc9A2FvPN0uFmioDa9WK0'' || chr(10) || ''s7JI9HsbpqpinC4CZUpNohfkLBrzSEbf6aJx9SgE3pFDdQwd2wxVD5QngMMysFd7'' || chr(10) || ''XCQnnPx5GUrMQ/us9qSiGYjuHqiH2x9gp5hurQ8qdwwO3aCwhwjYQA+czatrbWk+'' || chr(10) || ''Fe3WSzDnZrriHIfwD0P12YDdpCx5Eh93NJDAptqn1oIRfK9z6TZjgIIbXLQg4PkA'' || chr(10) || ''KTf+LGmAQItkIQKFiVAdH7daALF01erxl/n5M6FRd2ZpVZWQd+RyKQIDAQABo4IB'' || chr(10) || ''BDCCAQAwHQYDVR0OBBYEFIlZIba80QjXo5Pm+A9P2wF46MPkMIG6BgNVHSMEgbIw'' || chr(10) || ''ga+AFGt2X2MH0PCOWlWoPjVyimGYmK/PoYGLpIGIMIGFMQswCQYDVQQGEwJERTEP'' || chr(10) || ''MA0GA1UECAwGQmVybGluMQ8wDQYDVQQHDAZCZXJsaW4xDDAKBgNVBAoMA1NPUzEL'' || chr(10) || ''MAkGA1UECwwCSVQxFDASBgNVBAMMC1NPUyBSb290IENBMSMwIQYJKoZIhvcNAQkB'' || chr(10) || ''FhRhZG1pbkBzb3MtYmVybGluLmNvbYIJAM3gM6k6sCzUMBIGA1UdEwEB/wQIMAYB'' || chr(10) || ''Af8CAQAwDgYDVR0PAQH/BAQDAgGGMA0GCSqGSIb3DQEBCwUAA4ICAQBd/NR493wc'' || chr(10) || ''2FvLHLKJwOoI7WucD7sP7L0G6NqmJ2dR3cbNRe7X4bXxugCSUD470RiWKTUVpD6O'' || chr(10) || ''/fcDawS6GgqkQI8Mn9KGSRbliqjfXaTcArt2wdNi84pbC+eLakJFqjS5SZxYzAZK'' || chr(10) || ''Zdf0UmhrPkr+C1ndShkIkVLbMsZfQD5Uu78uHDDziVwdPVYVI4Ge2nLpi9i4zx06'' || chr(10) || ''GtOHbKFmv67KdZX7sXXEzJJHc206aZ7wjRSSvh1mJsplm/yGY/jsnKAKqe1VT3hB'' || chr(10) || ''JCxTnyFN5CYEnwCTF3qdZGJchv8MG5VA9QZeLpHh+ERM/BKZlXrU70JqCpmTaDov'' || chr(10) || ''tZt1dXOS8EKOm2PbaNoXZm39ol+Ky2Co8ES8UWIb9PQV69ZP2zKXBtM0UWW17m9m'' || chr(10) || ''BqjF4EfTGlViTdalorcl2UYH/1l1rR4CtJECpPr2njZD8msSs3Jh+BDKTrmJFMxn'' || chr(10) || ''YQyWkyHxWfdR7/WxMNLh4WYx6Dw+FYqN/Hw+UMkByCRpVeIzal25AzLAvfHhzVXq'' || chr(10) || ''bCOCXxSkn3d8N6V0P30BqkbieEwQx1T2SgLIfqo3G9QJ8BRCOaK+LhVJ2NaSe9FP'' || chr(10) || ''yyRb8+sd/SHRiO6CvTxqy5iCozdgjb0SRufS01iBDMQT2r31nRn8qezRL0YMes1W'' || chr(10) || ''HwphnWeOC52Ovuw2OLv1TomJKSzujvLzpA=='' || chr(10) || ''-----END CERTIFICATE-----'', 1, ''root'', 0)
';
END IF; RETURN; END; $$ LANGUAGE plpgsql;
SELECT tmp();
COMMIT;

/* clean-up temporary objects */
DROP FUNCTION tmp();
COMMIT;


/*
 | Deployment views for Postgres
 | SOS GmbH, 2021-05-28
*/


/* View for current inventory at the controllers */
CREATE OR REPLACE VIEW DEP_CONFIGURATIONS_JOIN AS SELECT
    "CONTROLLER_ID",
    "NAME",
    "TYPE",
    MAX("ID") AS "MAX_ID"
FROM DEP_HISTORY
WHERE "STATE" = 0
GROUP BY
    "CONTROLLER_ID",
    "NAME",
    "TYPE";

COMMIT;

CREATE OR REPLACE VIEW DEP_CONFIGURATIONS AS SELECT
    a."ID",
    a."NAME",
    a."PATH",
    a."FOLDER",
    a."TYPE",
    a."INV_CID",
    a."CONTROLLER_ID",
    a."INV_CONTENT" AS "CONTENT",
    a."COMMIT_ID",
    a."DEPLOYMENT_DATE" AS "CREATED",
    a."TITLE"    
FROM DEP_HISTORY a
INNER JOIN DEP_CONFIGURATIONS_JOIN b
    ON a."ID" = b."MAX_ID"
    WHERE a."OPERATION" = 0;

COMMIT;

CREATE OR REPLACE VIEW DEP_NAMEPATHS AS SELECT
    a."ID",
    a."NAME",
    a."PATH",
    a."TYPE",
    a."CONTROLLER_ID"
FROM DEP_HISTORY a
INNER JOIN DEP_CONFIGURATIONS_JOIN b
    ON a."ID" = b."MAX_ID";

COMMIT;
/*
 | Inventory views for Postgres
*/
/* drop if exists because create or replace can throw errors */
DROP VIEW IF EXISTS INV_SCHEDULE2CALENDARS;
CREATE OR REPLACE VIEW INV_SCHEDULE2CALENDARS AS 
    SELECT 
        c::jsonb->>'calendarName'   AS "CALENDAR_NAME",
        i."NAME"                    AS "SCHEDULE_NAME",
        i."PATH"                    AS "SCHEDULE_PATH",
        i."FOLDER"                  AS "SCHEDULE_FOLDER",
        i."RELEASED"                AS "SCHEDULE_RELEASED"
    FROM INV_CONFIGURATIONS i,
        JSONB_ARRAY_ELEMENTS("JSON_CONTENT"::jsonb->'calendars') AS c
    WHERE "TYPE"=7;

COMMIT;

DROP VIEW IF EXISTS INV_REL_SCHEDULE2CALENDARS;
CREATE OR REPLACE VIEW INV_REL_SCHEDULE2CALENDARS AS 
    SELECT 
        c::jsonb->>'calendarName'   AS "CALENDAR_NAME",
        i."NAME"                    AS "SCHEDULE_NAME",
        i."PATH"                    AS "SCHEDULE_PATH",
        i."FOLDER"                  AS "SCHEDULE_FOLDER"
    FROM INV_RELEASED_CONFIGURATIONS i,
        JSONB_ARRAY_ELEMENTS("JSON_CONTENT"::jsonb->'calendars') AS c
    WHERE "TYPE"=7;

COMMIT;
/*
 | Inventory views for Postgres
*/
/* drop if exists because create or replace can throw errors */
DROP VIEW IF EXISTS INV_SCHEDULE2WORKFLOWS;
CREATE OR REPLACE VIEW INV_SCHEDULE2WORKFLOWS AS 
    SELECT 
        "JSON_CONTENT"::jsonb->>'workflowName' AS "WORKFLOW_NAME",
        "NAME"          AS "SCHEDULE_NAME",
        "PATH"          AS "SCHEDULE_PATH",
        "FOLDER"        AS "SCHEDULE_FOLDER",
        "RELEASED"      AS "SCHEDULE_RELEASED",
        "JSON_CONTENT"  AS "SCHEDULE_CONTENT"
    FROM INV_CONFIGURATIONS
    WHERE "TYPE"=7
        AND JSONB_ARRAY_LENGTH("JSON_CONTENT"::jsonb->'workflowNames') IS NULL 
    UNION ALL
    SELECT 
        "WORKFLOW_NAME",
        "NAME"          AS "SCHEDULE_NAME",
        "PATH"          AS "SCHEDULE_PATH",
        "FOLDER"        AS "SCHEDULE_FOLDER",
        "RELEASED"      AS "SCHEDULE_RELEASED",
        "JSON_CONTENT"  AS "SCHEDULE_CONTENT"
    FROM INV_CONFIGURATIONS,
        JSONB_ARRAY_ELEMENTS_TEXT("JSON_CONTENT"::jsonb->'workflowNames') AS "WORKFLOW_NAME"
    WHERE "TYPE"=7;

COMMIT;

DROP VIEW IF EXISTS INV_RELEASED_SCHEDULE2WORKFLOWS;
DROP VIEW IF EXISTS INV_REL_SCHEDULE2WORKFLOWS;
CREATE OR REPLACE VIEW INV_REL_SCHEDULE2WORKFLOWS AS 
    SELECT 
        "JSON_CONTENT"::jsonb->>'workflowName' AS "WORKFLOW_NAME",
        "NAME"          AS "SCHEDULE_NAME",
        "PATH"          AS "SCHEDULE_PATH",
        "FOLDER"        AS "SCHEDULE_FOLDER",
        "JSON_CONTENT"  AS "SCHEDULE_CONTENT"
    FROM INV_RELEASED_CONFIGURATIONS
    WHERE "TYPE"=7
        AND JSONB_ARRAY_LENGTH("JSON_CONTENT"::jsonb->'workflowNames') IS NULL 
    UNION ALL
    SELECT 
        "WORKFLOW_NAME",
        "NAME"          AS "SCHEDULE_NAME",
        "PATH"          AS "SCHEDULE_PATH",
        "FOLDER"        AS "SCHEDULE_FOLDER",
        "JSON_CONTENT"  AS "SCHEDULE_CONTENT"
    FROM INV_RELEASED_CONFIGURATIONS,
        JSONB_ARRAY_ELEMENTS_TEXT("JSON_CONTENT"::jsonb->'workflowNames') AS "WORKFLOW_NAME"
    WHERE "TYPE"=7;

COMMIT;


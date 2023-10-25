--receipe APEX & 21c XE installation/configuration in Windows 11
--scope: localhost, inside XEPDB1:1521, 
--ingredients
ords-23.3.0.289.1830.zip
apex_22.1_en.zip
OracleXE213_Win64.zip
7-zip
windows command line





unzip the APEX possibly here
C:\Users\Admin\Downloads\apex_22.1_en\apex

use cmd to this path & connect sqlplus

sqlplus 

sys /as sysdba
******

alter session set container = XEPDB1;

Create Tablespace apex
logging
datafile 'C:\app\Admin\product\21c\database\apex.dbf' size 1024m
autoextend on
next 64m maxsize 8G
extent management local;


@apexins.sql apex apex temp /i/

JOB_QUEUE_PROCESSES: 320
timing for: Validating Installation
Elapsed: 00:00:01.50
#
# Actions in Phase 3:
#
    ok 1 - BEGIN                                                        |   0.00
    ok 2 - Updating DBA_REGISTRY                                        |   0.00
    ok 3 - Computing Pub Syn Dependents                                 |   0.00
    ok 4 - Upgrade Hot Metadata and Switch Schemas                      |   0.00
    ok 5 - Removing Jobs                                                |   0.00
    ok 6 - Creating Public Synonyms                                     |   0.02
    ok 7 - Granting Public Synonyms                                     |   0.03
    ok 8 - Granting to FLOWS_FILES                                      |   0.00
    ok 9 - Creating FLOWS_FILES grants and synonyms                     |   0.00
    ok 10 - Creating Jobs                                               |   0.00
    ok 11 - Creating Dev Jobs                                           |   0.00
    ok 12 - Installing FLOWS_FILES Objects                              |   0.00
    ok 13 - Installing APEX$SESSION Context                             |   0.00
    ok 14 - Recompiling APEX_220100                                     |   0.02
    ok 15 - Installing APEX REST Config                                 |   0.00
    ok 16 - Set Loaded/Upgraded in Registry                             |   0.00
    ok 17 - Removing Unused SYS Objects                                 |   0.00
    ok 18 - Validating Installation                                     |   0.03
ok 3 - 18 actions passed, 0 actions failed                              |   0.10



Thank you for installing Oracle APEX 22.1.0

Oracle APEX is installed in the APEX_220100 schema.

The structure of the link to the Oracle APEX administration services is as follows:
http://host:port/ords/apex_admin

The structure of the link to the Oracle APEX development interface is as follows:
http://host:port/ords

timing for: Phase 3 (Switch)
Elapsed: 00:00:05.88
timing for: Complete Installation
Elapsed: 00:03:03.06

SYS> @apxchpwd.sql
...set_appun.sql
================================================================================
This script can be used to change the password of an Oracle APEX
instance administrator. If the user does not yet exist, a user record will be
created.
================================================================================
Enter the administrator's username [ADMIN]
User "ADMIN" does not yet exist and will be created.
Enter ADMIN's email [ADMIN]
Enter ADMIN's password []
Created instance administrator ADMIN.


SYS> @apex_rest_config.sql












Enter a password for the APEX_LISTENER user              []
Enter a password for the APEX_REST_PUBLIC_USER user              []
...set_appun.sql
...setting session environment
...create APEX_LISTENER and APEX_REST_PUBLIC_USER users
...grants for APEX_LISTENER and ORDS_METADATA user



SYS> select username,account_status  from dba_users where username like 'APEX%';

USERNAME
--------------------------------------------------------------------------------
ACCOUNT_STATUS
--------------------------------
APEX_LISTENER
OPEN

APEX_PUBLIC_USER
LOCKED

APEX_REST_PUBLIC_USER
OPEN


USERNAME
--------------------------------------------------------------------------------
ACCOUNT_STATUS
--------------------------------
APEX_220100
LOCKED

SYS> ALTER USER APEX_LISTENER  ACCOUNT UNLOCK identified by tiger;
SYS> ALTER USER APEX_PUBLIC_USER ACCOUNT UNLOCK identified by tiger;
SYS> ALTER USER APEX_REST_PUBLIC_USER ACCOUNT UNLOCK identified by tiger;
SYS> ALTER USER APEX_220100 ACCOUNT UNLOCK identified by tiger;
SYS>

mkdir c:\app\ords
unzip ords-23.3.0.289.1830.zip here (ensure no more sub / subfolders created due to 7zip)

download and install
apache-tomcat-8.5.95.exe

JRE point to here (which was installed by Oracle 21c XE )
C:\app\Admin\product\21c\dbhomeXE\jdk\jre\

set ORDS_HOME=c:\app\ords
set ORDS_CONFIG=c:\app\config\ords
set ORDS_LOGS=%ORDS_CONFIG%\logs
set DB_HOSTNAME=localhost
set DB_PORT=1521
set DB_SERVICE=xepdb1
set SYSDBA_USER=SYS


c:\app\ords\bin\ords.exe ^
  --config %ORDS_CONFIG% install ^
  --log-folder %ORDS_LOGS% ^
  --admin-user %SYSDBA_USER% ^
  --db-hostname %DB_HOSTNAME% ^
  --db-port %DB_PORT% ^
  --db-servicename %DB_SERVICE% ^
  --feature-db-api true ^
  --feature-rest-enabled-sql true ^
  --feature-sdw true ^
  --gateway-mode proxied ^
  --gateway-user APEX_PUBLIC_USER ^
  --proxy-user

C:\app\ords\bin>ords.exe ^
More?   --config %ORDS_CONFIG% install ^
More?   --log-folder %ORDS_LOGS% ^
More?   --admin-user %SYSDBA_USER% ^
More?   --db-hostname %DB_HOSTNAME% ^
More?   --db-port %DB_PORT% ^
More?   --db-servicename %DB_SERVICE% ^
More?   --feature-db-api true ^
More?   --feature-rest-enabled-sql true ^
More?   --feature-sdw true ^
More?   --gateway-mode proxied ^
More?   --gateway-user APEX_PUBLIC_USER ^
More?   --proxy-user

ORDS: Release 23.3 Production on Wed Oct 18 18:52:28 2023

Copyright (c) 2010, 2023, Oracle.

Configuration:
  /C:/app/config/ords

Enter the database password for SYS AS SYSDBA:
Enter the database password for ORDS_PUBLIC_USER:
Confirm password:
Oracle REST Data Services - Non-Interactive Install
Created folder C:\app\config\ords

Retrieving information.
Created folder c:\app\config\ords\logs
The setting named: db.connectionType was set to: basic in configuration: default
The setting named: db.hostname was set to: localhost in configuration: default
The setting named: db.port was set to: 1521 in configuration: default
The setting named: db.servicename was set to: xepdb1 in configuration: default
The setting named: plsql.gateway.mode was set to: proxied in configuration: default
The setting named: db.username was set to: ORDS_PUBLIC_USER in configuration: default
The setting named: db.password was set to: ****** in configuration: default
The setting named: feature.sdw was set to: true in configuration: default
The global setting named: database.api.enabled was set to: true
The setting named: restEnabledSql.active was set to: true in configuration: default
The setting named: security.requestValidationFunction was set to: ords_util.authorize_plsql_gateway in configuration: default
2023-10-18T18:53:04.029Z INFO        Installing Oracle REST Data Services version 23.3.0.r2891830 in XEPDB1
2023-10-18T18:53:05.851Z INFO        ... Verified database prerequisites
2023-10-18T18:53:06.360Z INFO        ... Created Oracle REST Data Services proxy user
2023-10-18T18:53:07.081Z INFO        ... Created Oracle REST Data Services schema
2023-10-18T18:53:07.862Z INFO        ... Granted privileges to Oracle REST Data Services
2023-10-18T18:53:10.926Z INFO        ... Created Oracle REST Data Services database objects
2023-10-18T18:53:20.502Z INFO        Completed installation for Oracle REST Data Services version 23.3.0.r2891830. Elapsed time: 00:00:16.404
2023-10-18T18:53:20.558Z INFO        Completed configuring PL/SQL gateway user for Oracle REST Data Services version 23.3.0.r2891830. Elapsed time: 00:00:00.55
2023-10-18T18:53:20.559Z INFO        Log file written to c:\app\config\ords\logs\ords_install_2023-10-18_185303_95276.log
2023-10-18T18:53:20.562Z INFO        To run in standalone mode, use the ords serve command:
2023-10-18T18:53:20.562Z INFO        ords --config C:\app\config\ords serve
2023-10-18T18:53:20.563Z INFO        Visit the ORDS Documentation to access tutorials, developer guides and more to help you get started with the new ORDS Command Line Interface (http://oracle.com/rest).



cmd start C:\app\ords\bin\ords.exe --config C:\app\config\ords serve


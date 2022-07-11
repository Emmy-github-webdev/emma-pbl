# RDS Security - Encryption

1. At rest encryption
  * possibility to encrypt the master and read replicas with AWS KMS using AES-256 ENCRYPTION
  * eNCRYPTION HAS TO BE DEFINED AT LAUNCH TIME
  * iF THE MASTER IS NOT ENCRYPTED, THE READ REPLICAS CANNOT BE ENCRYPTED
2. In-flight encryption
  * SSL certificates to encrypt data to RDS in flight
  * Provide SSL options with trust certificate when connecting to database
  * To enforce SSL:
    - PostgreSQL: rds.force_ssl= I in the AWS RDS Console (Parameter Groups)
    - MYSQL: Within the DB:
      * GRANT USAGE ON *,* TO 'mysqluser'@'%'REQUIRE SSL;

### RDS Encryption Operations

1. Encrypting RDS backups
  - Snapshote of un-encrypted RDS databases are un-encrypted
  - Snapshots of encrypted RDS databases are encrypted
  - Can copy a snapshot into an encryptied one
2. To encrypt an un-encrypted RDS database
  - Create a snapshot of the un-encrypted databse
  - Copy the snapshot and enable encryption for the snapshot
  - Restore the database from the encrypted snapshot
  - Migrate applications to the new database, and delete the old database
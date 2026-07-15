/*
==========================================================================
Creating the DataWarehouse and its Layers
==========================================================================
Script Purpose:
	This script creates a new database called 'DataWarehouse' after 
	checking whether a database of this name already exists (if one does,
	this script will drop it). After creating the database, this script 
	will also create three schemas within this database, titled 'bronze',
	'silver', and 'gold'.
WARNING:
	If there is already a database titled 'DataWarehouse', running this
	script will drop it, permanently deleting all of its data.
==========================================================================
*/

USE master;
GO

-- Drops the 'DataWarehouse' database if it already exists.
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Creates the 'DataWarehouse' database.
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Creates the Schemas (Layers) of the DataWarehouse.
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

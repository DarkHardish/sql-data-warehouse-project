/*
	Create Database and Schemas

	Script Purpose:

		This script purpose is to create a new database calles 'Datawarehouse' after cheking if it already exists.
		If database exists the code drops it and creates new one.
		Scripts sets up three schemas: 'bronze', 'silver' and 'gold'.

	WARNING:

	Running this script will drop entire 'Datawarehouse' database if it exists. All data will be permamently deleted. !!!!
*/


use master;
go


--Drop and recreate the 'DataWarehouse' database
if exists (select 1 from sys.databases where name = 'DataWarehouse')
begin
	alter database DataWarehouse set single_user with rollback immediate;
	drop database Datawarehouse;
end;
go

--Create 'DataWarehouse' database
create database DataWarehouse;
go

use DataWarehouse;
go

--Create Schemas
create schema bronze;
go
create schema silver;
go
create schema gold;
go

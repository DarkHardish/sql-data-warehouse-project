/*
===========================================================
Bronze Layer Load Procedure
===========================================================

This stored procedure performs full reload of all Bronze layer tables.

What it does:
- Truncates existing data in Bronze tables
- Loads fresh data from CSV files using BULK INSERT
- Measures load duration for each table and full batch
- Prints progress logs for monitoring
- Uses TRY/CATCH for basic error handling

IMPORTANT:
- This is a FULL REFRESH process (not incremental load)
- ALL existing data in Bronze layer will be deleted before reload
- File paths are hardcoded (local environment dependency)
===========================================================
*/



exec bronze.load_bronze



create or alter procedure bronze.load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
		print '===========================================================';
		print 'Loading Bronze Layer';
		print '===========================================================';

		print '-----------------------------------------------------------';
		print 'Loading CRM Tables';
		print '-----------------------------------------------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_cust_info';

		truncate table bronze.crm_cust_info;

		print '>> Inserting Data Into: bronze.crm_cust_info';

		bulk insert bronze.crm_cust_info
		from 'C:\Users\darkh\Desktop\data-sql\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast( datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds';
		print '------------------------------------------'

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.crm_prd_info';

		truncate table bronze.crm_prd_info;

		print '>> Inserting Data Into: bronze.crm_prd_info';

		bulk insert bronze.crm_prd_info
		from 'C:\Users\darkh\Desktop\data-sql\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast( datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds';
		print '------------------------------------------'

		set @start_time = GETDATE();

		print '>> Truncating Table: bronze.crm_sales_details';

		truncate table bronze.crm_sales_details;

		print '>> Inserting Data Into: bronze.crm_sales_details';

		bulk insert bronze.crm_sales_details
		from 'C:\Users\darkh\Desktop\data-sql\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast( datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds';
		print '------------------------------------------'

		print '-----------------------------------------------------------';
		print 'Loading ERP Tables';
		print '-----------------------------------------------------------';

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_cust_az12';

		truncate table bronze.erp_cust_az12;

		print '>> Inserting Data Into: bronze.erp_cust_az12';

		bulk insert bronze.erp_cust_az12
		from 'C:\Users\darkh\Desktop\data-sql\source_erp\cust_az12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast( datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds';
		print '------------------------------------------'

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_loc_a101';

		truncate table bronze.erp_loc_a101;

		print '>> Inserting Data Into: bronze.erp_loc_a101';

		bulk insert bronze.erp_loc_a101
		from 'C:\Users\darkh\Desktop\data-sql\source_erp\loc_a101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast( datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds';
		print '------------------------------------------'

		set @start_time = GETDATE();
		print '>> Truncating Table: bronze.erp_px_cat_g1v2';

		truncate table bronze.erp_px_cat_g1v2;

		print '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\darkh\Desktop\data-sql\source_erp\px_cat_g1v2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = GETDATE();
		print '>> Load Duration: ' + cast( datediff(second, @start_time, @end_time) as nvarchar ) + ' seconds';
		print '------------------------------------------'

		set @batch_end_time = getdate();
		print '======================================================='
		print 'Loading Bronze Layer is Completed';
		print '  - Total Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';

		print '======================================================='

	end try
	begin catch
		print '=======================================================';
		print 'Error occured DURING LOADING BRONZE LAYER'
		print 'Error Message' + error_message();
		print 'Error Message' + cast (error_number() as nvarchar);
		print 'Error Message' + cast (error_state() as nvarchar);
		print '=======================================================';
	end catch
end

-- Task a)
ALTER TABLE dbo.Address
ADD  AccountNumber NVARCHAR(15),
	 MaxPrice MONEY;
ALTER TABLE dbo.Address
ADD  AccountID as 'ID' + AccountNumber;

IF OBJECT_ID('[tempdb].[dbo].[#Address]') IS NOT NULL
	DROP TABLE [dbo].[#Address];

-- Task b)
CREATE TABLE dbo.#Address(
	[AddressID] [int] NULL,
	[AddressLine1] [nvarchar](60) NULL,
	[AddressLine2] [nvarchar](60) NOT NULL CONSTRAINT [DF_AddressLine2]  DEFAULT ('Unknown'),
	[City] [nvarchar](30) NULL,
	[StateProvinceID] [int] NULL,
	[PostalCode] [nvarchar](15) NULL,
	[ModifiedDate] [datetime] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[AccountNumber] [NVARCHAR](15),
	[MaxPrice] [MONEY], 
);

-- Task c)

WITH cte AS (
	SELECT
		 Purchasing.ProductVendor.BusinessEntityID,
		 MAX(Purchasing.ProductVendor.StandardPrice) as MaxPrice
	FROM Purchasing.ProductVendor
	JOIN Purchasing.Vendor
	ON Purchasing.ProductVendor.BusinessEntityID = Purchasing.Vendor.BusinessEntityID
	GROUP BY Purchasing.ProductVendor.BusinessEntityID
	)
INSERT INTO dbo.#Address (AddressID, AccountNumber)
SELECT AddressID,
(SELECT AccountNumber from Purchasing.Vendor) from dbo.address
JOIN cte
ON Purchasing.Vendor.BusinessEntityID = cte.BusinessEntityID)  FROM dbo.Address




SELECT * from dbo.Address
SELECT * from dbo.#Address			
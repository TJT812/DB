--Task a)
ALTER TABLE dbo.Address
ADD PersonName nvarchar(100);

--Task b)
DECLARE @address_table TABLE (
	[AddressID] [int] NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NOT NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,	
	[ModifiedDate] [datetime] NOT NULL,
	[ID] int NOT NULL,
	[PersonName] nvarchar(100)	
	); 


INSERT INTO @address_table([AddressID], [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [ModifiedDate], [ID], [PersonName])
SELECT dbo.AddressID, dbo.AddressLine1, CONCAT(Person.CountryRegion.CountryRegionCode, ', ',
	Person.StateProvince.Name, ', ', dbo.City) as AddressLine2, 
	dbo.City, dbo.StateProvinceID, dbo.PostalCode, dbo.ModifiedDate, dbo.ID, dbo.PersonName  from dbo.Address AS dbo
	JOIN Person.StateProvince
	ON dbo.StateProvinceID = Person.StateProvince.StateProvinceID
	JOIN Person.CountryRegion
	ON Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode	
	WHERE dbo.StateProvinceID = 77

SELECT * FROM @address_table
--SELECT * from dbo.Address
--Task c)
UPDATE dbo.Address
SET dbo.Address.AddressLine2 = a_table.AddressLine2
FROM
	(SELECT * from @address_table) AS a_table
WHERE dbo.Address.AddressID = a_table.AddressID

UPDATE dbo.Address 
SET dbo.Address.PersonName = PT.PersonName 
FROM 
	 (SELECT Person.BusinessEntityAddress.AddressID as aid, CASE WHEN CONCAT(Person.FirstName, ' ', Person.LastName) = '' THEN 'Kiril Chasnakou'
	 ELSE CONCAT(Person.FirstName, ' ', Person.LastName) END AS PersonName
	 FROM dbo.Address
	 JOIN Person.BusinessEntityAddress
	 ON dbo.Address.AddressID = Person.BusinessEntityAddress.AddressID
	 LEFT JOIN Person.Person
	 ON Person.BusinessEntityAddress.BusinessEntityID = Person.Person.BusinessEntityID 
	 ) AS PT
WHERE PT.aid  = dbo.Address.AddressID
--SELECT * FROM @address_table
SELECT * FROM dbo.Address 

--Task d)
DELETE dbo.Address
FROM dbo.Address
JOIN Person.BusinessEntityAddress
ON dbo.Address.AddressID = Person.BusinessEntityAddress.AddressID
JOIN Person.AddressType
ON Person.BusinessEntityAddress.AddressTypeID = Person.AddressType.AddressTypeID
WHERE Person.AddressType.Name = 'Main Office'

--Task e)
ALTER TABLE dbo.Address DROP COLUMN PersonName


DECLARE @sql NVARCHAR(MAX) = N'';

DECLARE @schema NVARCHAR(MAX) = 'dbo';
DECLARE @table NVARCHAR(MAX) = 'Address';

SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(TABLE_SCHEMA)
    + '.' + QUOTENAME(TABLE_NAME) + 
    ' DROP CONSTRAINT ' + QUOTENAME(CONSTRAINT_NAME) + ';'
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @table;

SELECT @sql += N'
ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM [AdventureWorks2012].[sys].[default_constraints]  AS [dc]
WHERE SCHEMA_NAME(schema_id) = @schema and OBJECT_NAME(parent_object_id) = @table
--PRINT @sql;
EXEC sp_executesql @sql;


--Task f)
DROP TABLE dbo.Address
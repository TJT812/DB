--Task a)
CREATE TABLE dbo.Address(
	[AddressID] [int],
	[AddressLine1] [nvarchar](60),
	[AddressLine2] [nvarchar](60),
	[City] [nvarchar](30),
	[StateProvinceID] [int],
	[PostalCode] [nvarchar](15),	
	[ModifiedDate] [datetime]); 
 GO
--Task b)
ALTER TABLE dbo.Address
ADD ID int IDENTITY(1, 1) UNIQUE;

--Task c)
ALTER TABLE dbo.Address
ADD CONSTRAINT odd CHECK(StateProvinceID % 2 != 0);

--Task d)
ALTER TABLE dbo.Address ADD CONSTRAINT DF_AddressLine2 DEFAULT 'Unknown' FOR AddressLine2;

--Task e)
INSERT INTO dbo.Address (AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, ModifiedDate)
SELECT Person.Address.AddressID, Person.Address.AddressLine1, ISNULL(AddressLine2, 'Unknown') as 'AddressLine2', 
Person.Address.City, Person.Address.StateProvinceID, Person.Address.PostalCode,
Person.Address.ModifiedDate FROM Person.Address
JOIN Person.StateProvince ON Person.Address.StateProvinceID = Person.StateProvince.StateProvinceID
JOIN Person.CountryRegion ON Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode
WHERE Person.CountryRegion.Name LIKE 'a%' AND Person.Address.StateProvinceID % 2 != 0; 

SELECT * FROM dbo.Address

--Task f)
ALTER TABLE dbo.Address
ALTER COLUMN AddressLine2 nvarchar(60) NOT NULL;
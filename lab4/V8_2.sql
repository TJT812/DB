-- Task a)
IF OBJECT_ID('View_CountryRegionSales') IS NOT NULL
DROP VIEW View_CountryRegionSales



CREATE VIEW View_CountryRegionSales WITH SCHEMABINDING AS
SELECT	Person.CountryRegion.CountryRegionCode,
		Person.CountryRegion.ModifiedDate AS Country_ModifiedDate,
		Person.CountryRegion.Name AS CountryName,
		Sales.SalesTerritory.TerritoryID, 
		Sales.SalesTerritory.CostLastYear,
		Sales.SalesTerritory.SalesLastYear,
		Sales.SalesTerritory.SalesYTD,
		Sales.SalesTerritory.CostYTD,
		[Sales].[SalesTerritory].[Group],
		Sales.SalesTerritory.ModifiedDate AS Sales_ModifiedDate,
		Sales.SalesTerritory.Name AS SalesName,
		Sales.SalesTerritory.rowguid	
		FROM  Sales.SalesTerritory
INNER JOIN Person.CountryRegion
ON Sales.SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode

--SELECT * FROM Person.CountryRegion
--SELECT * FROM Sales.SalesTerritory

CREATE UNIQUE CLUSTERED INDEX [AK_View_CountryRegionSales_TerritoryID]
ON	View_CountryRegionSales (TerritoryID);

-- Task b)

IF OBJECT_ID('Trigger_CountryRegionSales') IS NOT NULL
DROP TRIGGER Trigger_CountryRegionSales

CREATE TRIGGER Trigger_CountryRegionSales
ON View_CountryRegionSales
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
-- update
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
BEGIN
    UPDATE Person.CountryRegion
	SET ModifiedDate = inserted.Country_ModifiedDate,  Name = inserted.CountryName
	FROM Person.CountryRegion
	JOIN inserted
	ON Person.CountryRegion.CountryRegionCode = inserted.CountryRegionCode

	UPDATE Sales.SalesTerritory
	SET CostLastYear = inserted.CostLastYear, CostYTD = inserted.CostYTD,
		[Group] = inserted.[Group], ModifiedDate = inserted.Sales_ModifiedDate,
		Name = inserted.SalesName, rowguid = inserted.rowguid,
		SalesLastYear = inserted.SalesLastYear, SalesYTD = inserted.SalesYTD
	FROM Sales.SalesTerritory
	JOIN inserted
	ON Sales.SalesTerritory.TerritoryID = inserted.TerritoryID
END

-- insert
IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
BEGIN
    INSERT INTO Person.CountryRegion (CountryRegionCode, Name, ModifiedDate)
	SELECT CountryRegionCode, CountryName, Country_ModifiedDate	
	FROM inserted

	INSERT INTO Sales.SalesTerritory (Name, CountryRegionCode, [Group], SalesYTD, SalesLastYear,
				CostYTD, CostLastYear, rowguid, ModifiedDate)
	SELECT SalesName, CountryRegionCode, [Group], SalesYTD, SalesLastYear,
		   CostYTD, CostLastYear, rowguid, Sales_ModifiedDate 
	FROM inserted
END

-- delete	
IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
BEGIN	

	DELETE Sales.SalesTerritory
	FROM Sales.SalesTerritory
	JOIN deleted
	ON Sales.SalesTerritory.TerritoryID = deleted.TerritoryID 
		AND Sales.SalesTerritory.CountryRegionCode = deleted.CountryRegionCode

	DELETE Person.CountryRegion
	FROM Person.CountryRegion
	JOIN deleted
	ON Person.CountryRegion.CountryRegionCode = deleted.CountryRegionCode
END
END

--SELECT * FROM Person.CountryRegion
--SELECT * FROM Sales.SalesTerritory
SELECT * FROM View_CountryRegionSales
-- Task c)

INSERT INTO View_CountryRegionSales (
		CountryRegionCode,
		Country_ModifiedDate,
		CountryName,
		TerritoryID, 
		CostLastYear,
		SalesLastYear,
		SalesYTD,
		CostYTD,
		[Group],
		Sales_ModifiedDate,
		SalesName,
		rowguid)
VALUES ('TTT', '2005-06-01 00:00:00.000', 'Test Country', 11, 1.1, 2.2, 3.3, 4.4, 'Test Group',
		 '2005-06-01 00:00:00.000', 'Test Sales', NEWID())

UPDATE View_CountryRegionSales
SET CountryName = 'Test country 2'
WHERE CountryRegionCode = 'TTT'

DELETE FROM View_CountryRegionSales
WHERE CountryRegionCode = 'TTT'

SELECT * FROM Person.CountryRegion
SELECT * FROM Sales.SalesTerritory
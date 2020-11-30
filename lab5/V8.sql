
IF OBJECT_ID('GetProductSubcategoryCount') IS NOT NULL
DROP FUNCTION GetProductSubcategoryCount

CREATE FUNCTION dbo.GetProductSubcategoryCount ( @ProductSubcategoryID INT )
RETURNS INT AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM Production.Product 
	WHERE ProductSubcategoryID = @ProductSubcategoryID
	IF (@count IS NULL)
	  SET @count = 0;
	RETURN @count;
END

SELECT dbo.GetProductSubcategoryCount(1)

--SELECT * FROM Production.ProductSubCategory

--SELECT COUNT(Production.ProductSubcategory.ProductSubcategoryID), Production.ProductSubcategory.Name from Production.ProductSubcategory
--JOIN Production.Product
--ON Production.ProductSubcategory.ProductSubcategoryID = Production.Product.ProductSubcategoryID
--GROUP BY Production.ProductSubcategory.ProductSubcategoryID, Production.ProductSubcategory.Name


CREATE FUNCTION dbo.GetProductSubcategoryCountMoreThan1000 ( @ProductSubcategoryID INT )
RETURNS TABLE AS
	RETURN (SELECT * FROM Production.Product
	WHERE ProductSubcategoryID = @ProductSubcategoryID AND StandardCost > 1000.00)


SELECT * FROM Production.Product
CROSS APPLY dbo.GetProductSubcategoryCountMoreThan1000(ProductSubcategoryID);

SELECT * FROM Production.Product
OUTER APPLY dbo.GetProductSubcategoryCountMoreThan1000(ProductSubcategoryID);



CREATE FUNCTION	dbo.MultiPart_GetProductSubcategoryCountMoreThan1000 ( @ProductSubcategoryID INT )
RETURNS @table TABLE
	([ProductID] [int] IDENTITY(1,1) NOT NULL, [Name] [dbo].[Name] NOT NULL, [ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [dbo].[Flag] NOT NULL,
	[FinishedGoodsFlag] [dbo].[Flag] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime] NOT NULL)
AS
BEGIN
INSERT INTO @table
SELECT Name, ProductNumber,  MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel,
	   ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode,
	   [Weight], DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, 
	   SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate  FROM Production.Product
WHERE ProductSubcategoryID = @ProductSubcategoryID AND StandardCost > 1000.00;
RETURN;
END

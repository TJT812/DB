CREATE PROCEDURE dbo.OrderSummaryByMonth @month TEXT
AS
BEGIN
SET NOCOUNT ON;
EXEC('SELECT Year,' + @month + ' AS month
			 FROM
			  (SELECT 
				YEAR(Production.WorkOrder.DueDate) AS Year,
				DATENAME(MONTH, Production.WorkOrder.DueDate) AS Month,
				Production.WorkOrder.OrderQty AS OrderSummary FROM Production.WorkOrder
				) AS WorkOrder
			  PIVOT (SUM(WorkOrder.OrderSummary) FOR WorkOrder.Month IN (' + @month + ')) AS sum');

END

EXECUTE dbo.OrderSummaryByMonth '[January],[February],[March],[April],[May],[June]';

SELECT * FROM Production.WorkOrder

DROP PROCEDURE dbo.OrderSummaryByMonth;


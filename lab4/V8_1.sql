-- Task a)

IF OBJECT_ID('[Person].[CountryRegionHst]') IS NOT NULL
  DROP TABLE [Person].[CountryRegionHst]
GO
CREATE TABLE Person.CountryRegionHst(
	 [ID] int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	 [Action] NVARCHAR(6) NOT NULL,
	 [ModifiedDate] DATETIME NOT NULL,
	 [SourceID] NVARCHAR(100) NOT NULL,
	 [UserName] NVARCHAR(100) NOT NULL
)

-- Task b)

SELECT * from Person.CountryRegion

CREATE TRIGGER Person.After_Trigger ON Person.CountryRegion
AFTER INSERT, UPDATE, DELETE AS
INSERT INTO Person.CountryRegionHst(Action, ModifiedDate, SourceID, UserName)
    SELECT
      CASE 
	  WHEN inserted.CountryRegionCode IS NULL
        THEN 'delete'
      WHEN deleted.CountryRegionCode IS NULL
        THEN 'insert'
      ELSE 'update'
      END AS Action,
      GETDATE() AS ModifiedDate,
      COALESCE(inserted.CountryRegionCode, deleted.CountryRegionCode) AS SourceID,
      USER_NAME() AS UserName
    FROM inserted
      FULL OUTER JOIN deleted
        ON inserted.CountryRegionCode = deleted.CountryRegionCode


-- Task c)

CREATE VIEW Person.View_CountryRegion WITH ENCRYPTION 
AS SELECT *  FROM Person.CountryRegion

-- Task d)

INSERT INTO Person.View_CountryRegion (CountryRegionCode, ModifiedDate, Name)
VALUES ('TT3', GETDATE(), 'Test')

UPDATE Person.View_CountryRegion
SET
	ModifiedDate = GETDATE(),
	Name = 'Test3'
WHERE CountryRegionCode = 'TT3'

DELETE FROM  Person.View_CountryRegion
WHERE CountryRegionCode = 'TT3'

SELECT * FROM Person.CountryRegionHst
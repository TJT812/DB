
CREATE PROCEDURE dbo.ConvertFromXML
@xml XML
AS
(SELECT	AddressID = node.value('@ID', 'INT'), City = node.value('City[1]', 'NVARCHAR(30)'),
		StateProvinceID = node.value('Province[1]/@ID', 'INT'), 
		CountryRegionCode = node.value('Province[1]/Region[1]', 'NVARCHAR(3)')
 FROM @xml.nodes('/Addresses/Address') AS xml(node))


DECLARE @xml XML; 

SELECT @xml = (SELECT AddressID as '@ID', City, Address.StateProvinceID as 'Province/@ID',
			   StateProvince.CountryRegionCode as 'Province/Region' FROM Person.Address as Address
			   INNER JOIN Person.StateProvince as StateProvince
               ON Address.StateProvinceID = StateProvince.StateProvinceID 
FOR XML PATH('Address'), ROOT('Addresses'), ELEMENTS);

SELECT @xml;

EXECUTE dbo.ConvertFromXML @xml
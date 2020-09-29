--1 Task
SELECT * FROM [HumanResources].Employee WHERE MaritalStatus='S' AND YEAR(BirthDate) <= 1960;

--2 Task
SELECT * FROM [HumanResources].Employee WHERE JobTitle='Design Engineer' ORDER BY HireDate DESC;

--3 Task
SELECT [HumanResources].Employee.BusinessEntityID, DepartmentID, StartDate, EndDate, 
DATEDIFF(YYYY, StartDate,ISNULL(EndDate, GETDATE())) as 'YearsWorked' FROM [HumanResources].Employee
JOIN [HumanResources].EmployeeDepartmentHistory
ON [HumanResources].Employee.BusinessEntityID = [HumanResources].EmployeeDepartmentHistory.BusinessEntityID
WHERE DepartmentID=1;

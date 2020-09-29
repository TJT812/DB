--1 Task
SELECT [HumanResources].[Employee].BusinessEntityID, OrganizationLevel, JobTitle, [HumanResources].[JobCandidate].JobCandidateID, 
[HumanResources].[JobCandidate].Resume  FROM [HumanResources].[Employee] 
JOIN [HumanResources].[JobCandidate]
ON [HumanResources].[Employee].BusinessEntityID = [HumanResources].[JobCandidate].BusinessEntityID
WHERE [HumanResources].[JobCandidate].Resume IS NOT NULL;

--2 Task
SELECT [HumanResources].EmployeeDepartmentHistory.DepartmentID, Name, COUNT([HumanResources].EmployeeDepartmentHistory.DepartmentID)
as 'EmpCount' FROM [HumanResources].EmployeeDepartmentHistory 
JOIN [HumanResources].Department
ON [HumanResources].EmployeeDepartmentHistory.DepartmentID = [HumanResources].Department.DepartmentID
WHERE EndDate IS NULL
GROUP BY [HumanResources].EmployeeDepartmentHistory.DepartmentID, Name
HAVING COUNT([HumanResources].EmployeeDepartmentHistory.DepartmentID) > 10;

--3 Task
SELECT Name, HireDate, SickLeaveHours, SUM(SickLeaveHours) 
OVER(PARTITION BY Name ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 'AccumulativeSum'
FROM [HumanResources].EmployeeDepartmentHistory
JOIN [HumanResources].Employee
ON [HumanResources].EmployeeDepartmentHistory.BusinessEntityID = [HumanResources].Employee.BusinessEntityID
JOIN [HumanResources].Department
ON [HumanResources].EmployeeDepartmentHistory.DepartmentID = [HumanResources].Department.DepartmentID 
WHERE EndDate IS NULL
ORDER BY Name, HireDate;

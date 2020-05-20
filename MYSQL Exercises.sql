SELECT s.Name
FROM Students s
    JOIN Friends f ON f.ID=s.ID
    JOIN Packages p ON p.ID=s.ID
    JOIN Packages fp ON fp.ID=f.Friend_ID
WHERE fp.Salary > p.Salary
ORDER BY fp.Salary
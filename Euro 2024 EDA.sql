SELECT * [Name]
      ,[Position]
      ,[Age]
      ,[Club]
      ,[Height]
      ,[Foot]
      ,[Caps]
      ,[Goals]
      ,[MarketValue]
      ,[Country]
  FROM [PortfolioProjects].[dbo].[Euro2024]

  SELECT *
    FROM [PortfolioProjects].[dbo].[Euro2024]
	

UPDATE  [PortfolioProjects].[dbo].[Euro2024]
SET Foot = 'Right'
WHERE Foot LIKE '%right%'

UPDATE  [PortfolioProjects].[dbo].[Euro2024]
SET Foot = 'Left'
WHERE Foot LIKE '%left%'


UPDATE  [PortfolioProjects].[dbo].[Euro2024]
SET Foot = 'Both'
WHERE Foot LIKE '%both%'

UPDATE  [PortfolioProjects].[dbo].[Euro2024]
SET Foot = 'Unspecified'
WHERE Foot = '-'

-- Overview of the dataset

-- Top Goalscorers
SELECT top 10 Name, Caps, Goals, Country
FROM [PortfolioProjects].[dbo].[Euro2024]
ORDER BY Goals DESC

-- Player Productivity:
SELECT 
    p.Name, 
    p.Goals, 
    p.Caps, 
    CAST(p.Goals / p.Caps AS DECIMAL(5,2)) AS Goals_Per_Cap
FROM [PortfolioProjects].[dbo].[Euro2024] p
WHERE Caps != 0
ORDER BY Goals_Per_Cap DESC;

-- Analyze players Positions
SELECT Position, COUNT(*) AS [Number of Players]
FROM [PortfolioProjects].[dbo].[Euro2024]
GROUP BY Position
ORDER BY [Number of Players] DESC;

-- Players Foot Preferences

SELECT
    SUM(CASE WHEN [Foot] = 'Right' THEN 1 ELSE 0 END) AS RightFootPlayers,
    ROUND(100.0 * SUM(CASE WHEN [Foot] = 'Right' THEN 1 ELSE 0 END) / COUNT(*), 2) AS RightFootPercentage,
    SUM(CASE WHEN [Foot] = 'Left' THEN 1 ELSE 0 END) AS LeftFootPlayers,
    ROUND(100.0 * SUM(CASE WHEN [Foot] = 'Left' THEN 1 ELSE 0 END) / COUNT(*), 2) AS LeftFootPercentage,
    SUM(CASE WHEN [Foot] = 'Both' THEN 1 ELSE 0 END) AS BothFootPlayers,
    ROUND(100.0 * SUM(CASE WHEN [Foot] = 'Both' THEN 1 ELSE 0 END) / COUNT(*), 2) AS BothFootPercentage,
    SUM(CASE WHEN [Foot] = 'Unspecified' THEN 1 ELSE 0 END) AS UnspecifiedFootPlayers,
    ROUND(100.0 * SUM(CASE WHEN [Foot] = 'Unspecified' THEN 1 ELSE 0 END) / COUNT(*), 2) AS UnspecifiedFootPercentage
FROM [PortfolioProjects].[dbo].[Euro2024]


-- Investigate player ages
SELECT MIN(Age) AS [Min Age], MAX(age) AS [Max Age], AVG(Age) AS [Avg Age]
FROM [PortfolioProjects].[dbo].[Euro2024];


-- Examine player heights
SELECT MIN(height) AS [Min Height], MAX(height) AS [Max Height], AVG(height) AS [Avg Height]
FROM [PortfolioProjects].[dbo].[Euro2024];


-- Analyze player nationalities
SELECT Country, COUNT(*) AS [Players Count]
FROM [PortfolioProjects].[dbo].[Euro2024]
GROUP BY Country
ORDER BY [Players Count] DESC;

-- Player Positions by Country:
SELECT 
    c.Country, 
    p.Position, 
    COUNT(*) AS [Number of Players]
FROM [PortfolioProjects].[dbo].[Euro2024] p
JOIN (SELECT DISTINCT Country FROM [PortfolioProjects].[dbo].[Euro2024]) c ON p.Country = c.Country
GROUP BY c.Country, p.Position
ORDER BY c.Country, [Number of Players] DESC;

-- Look at player market values
SELECT MIN([MarketValue]) AS [Min Market Value], MAX([MarketValue]) AS [Max Market Value], AVG([MarketValue]) AS [Avg Market Value]
FROM [PortfolioProjects].[dbo].[Euro2024];


-- Explore relationships between features
SELECT 
    Position, AVG(age) AS [Avg Age], AVG(height) AS [Avg Height], AVG([MarketValue]) AS [Avg Market Value]
FROM [PortfolioProjects].[dbo].[Euro2024]
GROUP BY Position
ORDER BY [Avg Market Value] DESC;


-- Players Age Distribution by Position
SELECT 
    Position, 
    MIN(age) AS [Min Age], 
    MAX(age) AS [Max Age], 
    AVG(age) AS [Avg Age]
FROM  [PortfolioProjects].[dbo].[Euro2024]
GROUP BY Position
ORDER BY [Avg Age] DESC;

-- Player Height Distribution by Postition
SELECT 
    Position,
    MIN(height) AS [Min Height],
    MAX(height) AS [Max Height],
    AVG(height) AS [Avg Height]
FROM [PortfolioProjects].[dbo].[Euro2024]
GROUP BY Position
ORDER BY [Avg Height] DESC;

-- Market Value vs Goals
SELECT 
    Name, 
    Goals, 
    marketvalue
FROM [PortfolioProjects].[dbo].[Euro2024]
ORDER BY marketvalue DESC;

-- Club Analysis
SELECT 
    Club, 
    COUNT(*) AS [Number of Players],
    AVG(age) AS [Avg Age],
    AVG(MarketValue) AS [Avg Market Value]
FROM [PortfolioProjects].[dbo].[Euro2024]
GROUP BY club
ORDER BY [Number of Players] DESC;


-- Top Goal-Scoring Clubs:
SELECT 
    p.club, 
    SUM(p.Goals) AS [Total Goals], 
    COUNT(*) AS [Number of Players],
    AVG(p.MarketValue) AS [Avg Market Value]
FROM [PortfolioProjects].[dbo].[Euro2024] p
GROUP BY p.club
ORDER BY [Total Goals] DESC;


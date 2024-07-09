SELECT [id]
      ,[Name]
      ,[Host Id]
      ,[Host Name]
      ,[Borough Name]
      ,[Neighbourhood]
      ,[Latitude]
      ,[Longitude]
      ,[Room Type]
      ,[Price]
      ,[Minimum Nights]
      ,[Number of Reviews]
      ,[Last Review]
      ,[Reviews Per Month]
      ,[Calculated Host Listings Count]
      ,[Availability 365]
  FROM [PortfolioProjects].[dbo].[ABNYC]

 -- 1. Explore the distribution of listings by borough
SELECT 
    [Borough Name], 
    COUNT(*) AS 'Listing Count'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    [Borough Name]
ORDER BY 
    [Listing Count] DESC;

-- 2. Analyze the distribution of room types
SELECT 
    [Room Type], 
    COUNT(*) AS 'Listing Count'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    [Room Type]
ORDER BY 
    [Listing Count] DESC;

-- 3. Analyze the distribution of Borough name & room types

	SELECT [Borough Name],
    [Room Type], 
    COUNT(*) AS 'Listing Count'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
   [Borough Name], [Room Type]
ORDER BY 
    [Listing Count] DESC;

-- 4. Explore the availability of listings
SELECT 
    [Availability 365], 
    COUNT(*) AS 'Listing Count'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    [Availability 365]
ORDER BY 
    [Availability 365];


-- 5. Analyze the distribution of prices
SELECT 
    FLOOR([Price] / 50) * 50 AS 'Price Range',
    COUNT(*) AS 'Listing Count'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    FLOOR([Price] / 50) * 50
ORDER BY 
    [Price Range];

-- 6. Investigate the relationship between price and neighbourhood
SELECT 
    [Neighbourhood], 
    AVG([Price]) AS 'Average Price'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    [Neighbourhood]
ORDER BY 
    [Average Price] DESC;

-- 7. Explore the relationship between price and room type
SELECT 
    [Room Type], 
    AVG([Price]) AS 'Average Price'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    [Room Type]
ORDER BY 
    [Average Price] DESC;

-- 8. Analyze the distribution of reviews
SELECT 
    CASE 
        WHEN [Number of Reviews] = 0 THEN '0 Reviews'
        WHEN [Number of Reviews] BETWEEN 1 AND 10 THEN '1-10 Reviews'
        WHEN [Number of Reviews] BETWEEN 11 AND 50 THEN '11-50 Reviews'
        WHEN [Number of Reviews] BETWEEN 51 AND 100 THEN '51-100 Reviews'
        ELSE '100+ Reviews'
    END AS 'Review Range',
    COUNT(*) AS 'Listing Count'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    CASE 
        WHEN [Number of Reviews] = 0 THEN '0 Reviews'
        WHEN [Number of Reviews] BETWEEN 1 AND 10 THEN '1-10 Reviews'
        WHEN [Number of Reviews] BETWEEN 11 AND 50 THEN '11-50 Reviews'
        WHEN [Number of Reviews] BETWEEN 51 AND 100 THEN '51-100 Reviews'
        ELSE '100+ Reviews'
    END
ORDER BY 
    [Listing Count] DESC;

-- 10. Analyze the relationship between reviews and availability
SELECT 
    [Number of Reviews], 
    AVG([Availability 365]) AS 'Average Availability'
FROM 
    [PortfolioProjects].[dbo].[ABNYC]
GROUP BY 
    [Number of Reviews]
ORDER BY 
    [Number of Reviews] DESC;

	--Thanks for your time
	 --By Abdulrahman Zumrawi 
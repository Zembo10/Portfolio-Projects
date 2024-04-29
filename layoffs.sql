SELECT *  FROM PortfolioProject.dbo.layoffs

--Creating backup table to have a copy of the original (allows restoring in case of any accidental data loss or corruption)

CREATE TABLE layoffs_staging
LIKE PortfolioProject..layoffs

SELECT * 
INTO PortfolioProject..layoffs_staging
FROM PortfolioProject..layoffs

SELECT * FROM PortfolioProject..layoffs_staging


INTO layoffs_staging

FROM layoffs

SELECT * FROM PortfolioProject..layoffs

SELECT * FROM PortfolioProject..layoffs_staging
WHERE total_laid_off IS NULL OR percentage_laid_off IS NULL

---------------------------- 
--Removing Duplicate


SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,  industry, total_laid_off, percentage_laid_off, [date], stage, country, funds_raised_millions ORDER BY company)AS row_num
FROM PortfolioProject.dbo.layoffs_staging;

WITH duplicate_cte AS(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location,  industry, total_laid_off, percentage_laid_off, [date], stage, country, funds_raised_millions ORDER BY company)AS row_num
FROM PortfolioProject.dbo.layoffs_staging
)
 DELETE
 FROM duplicate_cte 
WHERE row_num > 1
---------------------------------------

-- Standardizing  data-------

SELECT company,TRIM(company)AS TRIM_Company
from PortfolioProject..layoffs_staging

UPDATE layoffs_staging
SET company = TRIM(company)

SELECT industry
FROM PortfolioProject..layoffs_staging
WHERE industry LIKE 'Crypto%'

UPDATE PortfolioProject..layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'

UPDATE PortfolioProject..layoffs_staging
SET  funds_raised_millions = NULL
WHERE funds_raised_millions = 'NULL'

SELECT DISTINCT country FROM PortfolioProject..layoffs_staging


SELECT * FROM PortfolioProject..layoffs_staging
WHERE country LIKE '%States.%'


UPDATE PortfolioProject..layoffs_staging
SET country = 'United States'
WHERE country LIKE '%States.%'

--- In order to standardize the date format, we used both the CAST and the CONVERT function for a better understanding

SELECT CAST([date] AS DATE)AS ConvertedDate 
FROM PortfolioProject..layoffs_staging


SELECT CAST(ConvertedDate AS DATE)AS ConvertedDate
FROM PortfolioProject..layoffs_staging


SELECT [date],CONVERT(DATE, [date],101)
FROM PortfolioProject..layoffs_staging

SELECT 'date',
       CONVERT(DATE, CAST([date] AS varchar(max)), 101)
FROM PortfolioProject..layoffs_staging

SELECT 'date',
       CASE WHEN ISDATE('date') = 1 THEN CONVERT(DATE, 'date', 101) ELSE NULL END
FROM PortfolioProject..layoffs_staging

SELECT [date],
       CONVERT(DATE, CAST([date] AS varchar(max)), 101)
FROM PortfolioProject..layoffs_staging

UPDATE PortfolioProject..layoffs_staging 
SET ConvertedDate = CONVERT(DATE, CAST([date] AS varchar(max)), 101)

SELECT * FROM PortfolioProject..layoffs_staging
UPDATE PortfolioProject..layoffs_staging
SET ConvertedDate = CONVERT(DATE,ConvertedDate)


ALTER TABLE PortfolioProject..layoffs_staging
ADD ConvertedDate Date

UPDATE PortfolioProject..layoffs_staging
SET ConvertedDate =CAST(ConvertedDate AS DATE)
SELECT * FROM PortfolioProject..layoffs_staging

SELECT PARSE([date] AS DATE USING 'en-US')AS ConvertedDate
FROM PortfolioProject.dbo.layoffs_staging;


UPDATE PortfolioProject..layoffs_staging 
SET ConvertedDate = CONVERT(DATE,ConvertedDate)

ALTER TABLE PortfolioProject..layoffs_staging 
ADD Converted_Date Date

ALTER TABLE PortfolioProject..layoffs_staging 
ALTER COLUMN [date] DATE

-------------------------------------- Handling the 'NULL' and '' values in the table

SELECT * FROM PortfolioProject..layoffs_staging
WHERE total_laid_off = 'NULL' OR total_laid_off = '' AND percentage_laid_off = 'NULL' OR percentage_laid_off = ''


SELECT  *
FROM PortfolioProject..layoffs_staging
WHERE industry = 'NULL' OR industry = ''


SELECT  *
FROM PortfolioProject..layoffs_staging
WHERE company LIKE '%Carvana%'


SELECT *  --t1.industry, t2.industry
FROM PortfolioProject..layoffs_staging t1
JOIN PortfolioProject..layoffs_staging t2
	ON t1.company = t2.company
	AND t1.location = t2.location 
	WHERE t1.industry IS NULL
	AND t2. industry IS NOT NULL 


UPDATE PortfolioProject..layoffs_staging t1
JOIN PortfolioProject..layoffs_staging t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
	AND t2.industry IS NOT NULL 

UPDATE PortfolioProject..layoffs_staging 
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL'


UPDATE t1
SET t1.industry = t2.industry
FROM PortfolioProject.dbo.layoffs_staging t1
JOIN PortfolioProject.dbo.layoffs_staging t2 ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL




SELECT * FROM PortfolioProject..layoffs_staging
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL


DELETE 
FROM PortfolioProject..layoffs_staging
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL

---- Removing unused columns (not recommended in a real db but practicing)

ALTER TABLE PortfolioProject..layoffs_staging
DROP COLUMN Converted_Date

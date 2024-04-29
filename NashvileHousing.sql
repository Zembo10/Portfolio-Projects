
-- Cleaning Data in SQL
SELECT *
FROM PortfolioProject..NashvileHousing

-- Standrize Date Format

SELECT SaleDateConverted,CONVERT(DATE,SaleDate)AS SaleDate
FROM PortfolioProject..NashvileHousing

UPDATE NashvileHousing
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE NashvileHousing
ADD SaleDateConverted Date

UPDATE NashvileHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

-----------------------------------------------------------------------------------------------
-- Populate Property Address Data

SELECT PropertyAddress
FROM PortfolioProject..NashvileHousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortfolioProject..NashvileHousing a
JOIN PortfolioProject..NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvileHousing a
JOIN PortfolioProject..NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-----------------------------------------------------------------------------------------------

-- Breaking Out Adress Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..NashvileHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject..NashvileHousing

ALTER TABLE PortfolioProject.dbo.NashvileHousing  
ADD PropertySplitAddress nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing   
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE PortfolioProject.dbo.NashvileHousing 
ADD PropertySplitCity NVARCHAR(255)

UPDATE PortfolioProject.dbo.NashvileHousing  
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT * 
FROM PortfolioProject.dbo.NashvileHousing

---------------------------------------------------------------------------------------------------------------

-- Changing Owner Address To a Usable Form

-- BEFORE

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvileHousing
WHERE OwnerAddress IS NOT NULL
-----------------------------------------
--THE PROCESS

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject.dbo.NashvileHousing

ALTER TABLE PortfolioProject.dbo.NashvileHousing  
ADD OwnerSplitAddress nvarchar(255);

UPDATE PortfolioProject.dbo.NashvileHousing   
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE PortfolioProject.dbo.NashvileHousing 
ADD OwnerSplitCity NVARCHAR(255)

UPDATE PortfolioProject.dbo.NashvileHousing  
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


ALTER TABLE PortfolioProject.dbo.NashvileHousing 
ADD OwnerSplitState NVARCHAR(255)

UPDATE PortfolioProject.dbo.NashvileHousing  
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM PortfolioProject.dbo.NashvileHousing
-- AFTER

SELECT OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
FROM PortfolioProject.dbo.NashvileHousing
WHERE OwnerSplitAddress AND OwnerSplitCity AND OwnerSplitState IS NOT NULL

-------------------------------------------------------------------------------------------------------

-- Changing Y and N to YES and NO

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvileHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- THE PROCESS

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END as SoldAsVacantUpdated
FROM PortfolioProject.dbo.NashvileHousing

UPDATE PortfolioProject.dbo.NashvileHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END

----------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
		UniqueID
		) Row_Num
FROM PortfolioProject.dbo.NashvileHousing
)
--SELECT *
DELETE
FROM RowNumCTE
WHERE Row_Num > 1

------------------------------------------------------------------

-- Remove Unused Columns (not reccomend to do it in a real db but practicing)

SELECT * 
FROM PortfolioProject.dbo.NashvileHousing

ALTER TABLE PortfolioProject.dbo.NashvileHousing
DROP COLUMN Saledate
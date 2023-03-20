-- Select all columns from the table to inspect it
SELECT * FROM Tobiloba..Nashville



-- Convert the SaleDate format to Date format into a new column
ALTER TABLE Nashville
ADD SaleDateConverted DATE;

UPDATE Nashville
SET SaleDateConverted = CONVERT(DATE, SaleDate)



-- Populate empty cells in PropertyAddress through the use of self joins
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Tobiloba..Nashville a
JOIN Tobiloba..Nashville b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

-- Check to see if it worked
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM Tobiloba..Nashville a
JOIN Tobiloba..Nashville b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL



-- Separating the Address into Individual Columns Address and PropertyCity
ALTER TABLE Nashville
ADD Address VARCHAR(255);

UPDATE Nashville
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE Nashville
ADD PropertyCity VARCHAR(255);

UPDATE Nashville
SET PropertyCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



-- Separate OwnerAddress just like Property Address above
ALTER TABLE Nashville
ADD OwnerStreet VARCHAR(255);

UPDATE Nashville
SET OwnerStreet =PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville
ADD OwnerCity VARCHAR(255);

UPDATE Nashville
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville
ADD OwnerState VARCHAR(255);

UPDATE Nashville
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



-- Change 'Y' and 'N' in SoldAsVacant column to 'Yes' and 'No'respectively
UPDATE Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Nashville

SELECT DISTINCT(SoldAsVacant)
FROM Tobiloba..Nashville



-- Remove Duplicates with CTE and DELETE
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY
		UniqueID
		) row_num
FROM Tobiloba..Nashville
)
DELETE FROM RowNumCTE
WHERE row_num > 1



-- DELETE UNNEEDED COLUMNS
ALTER TABLE Tobiloba..Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

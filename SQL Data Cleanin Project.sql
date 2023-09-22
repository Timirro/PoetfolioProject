  SELECT *
  FROM dbo.NashvilleHousing

   SELECT SaleDateConverted, CONVERT(date,saleDate)
  FROM dbo.NashvilleHousing

  UPDATE NashvilleHousing
  SET SaleDate = CONVERT(Date,SaleDate)

  ALTER TABLE NashvilleHousing
  Add SaleDateConverted Date;

  UPDATE NashvilleHousing
  SET SaleDateConverted = CONVERT(Date, SaleDate)

  SELECT *
  FROM dbo.NashvilleHousing
 --WHERE PropertyAddress is null
  ORDER BY ParcelID
 

  SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM dbo.NashvilleHousing a
  JOIN dbo.NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  and a.[UniqueID ]  <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing a
  JOIN dbo.NashvilleHousing b
  ON a.ParcelID = b.ParcelID
  and a.[UniqueID ]  <> b.[UniqueID ]
WHERE a.PropertyAddress is null


SELECT PropertyAddress
  FROM dbo.NashvilleHousing
 --WHERE PropertyAddress is null
  --ORDER BY ParcelID

  SELECT
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 ) as Address
  , SUBSTRING(PropertyAddress,  CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as Address

  FROM dbo.NashvilleHousing

  ALTER TABLE NashvilleHousing
  Add PropertySplitAddress Nvarchar(255); 
   
   UPDATE NashvilleHousing
  SET  PropertySplitAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 )

  ALTER TABLE NashvilleHousing
  Add PropertySplitCity Nvarchar(255);

  UPDATE NashvilleHousing
  SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

  SELECT *
  FROM dbo.NashvilleHousing

  SELECT OwnerAddress
  FROM dbo.NashvilleHousing
 -- WHERE OwnerAddress is not null

 SELECT 
 PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
 PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
 PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
 FROM dbo.NashvilleHousing
 --WHERE OwnerAddress is not null

  ALTER TABLE NashvilleHousing
  Add OwnerSplitAddress Nvarchar(255); 
   
   UPDATE NashvilleHousing
  SET  OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

  ALTER TABLE NashvilleHousing
  Add OwnerSplitCity Nvarchar(255);

  UPDATE NashvilleHousing
  SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

   ALTER TABLE NashvilleHousing
  Add OwnerSplitState Nvarchar(255);

  UPDATE NashvilleHousing
  SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

    SELECT *
  FROM dbo.NashvilleHousing
 --WHERE OwnerAddress is not null

 SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
  FROM dbo.NashvilleHousing
  GROUP BY SoldAsVacant
  ORDER BY 2

 SELECT SoldAsVacant,
 CASE
     WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END
 FROM dbo.NashvilleHousing

 UPDATE NashvilleHousing
SET  SoldAsVacant = CASE
     WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END


WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice,SaleDate,LegalReference
ORDER BY UniqueId
) row_num

FROM dbo.NashvilleHousing
)

SELECT*
FROM RowNumCTE
WHERE row_num >1



SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate
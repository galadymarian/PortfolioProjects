 -- Cleaning Data in SQL Queries 

 Select *
 from PortfolioProject.dbo.NashvilleHousing


 -- Standardize Date Format

 Select SaleDate, CONVERT(date, SaleDate)
 from PortfolioProject.dbo.NashvilleHousing

 Update NashvilleHousing
 SET SaleDate = CONVERT(date, SaleDate)

 ALTER TABLE NashvilleHousing
 Add SaleDateConverted Date;

Update NashvilleHousing
 SET SaleDateConverted = CONVERT(date, SaleDate)


 -- Populate Property Address data

 Select *
 from PortfolioProject.dbo.NashvilleHousing
 Where PropertyAddress is null
 order by ParcelID


  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 from PortfolioProject.dbo.NashvilleHousing a
 Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b. [UniqueID ]
 where a.PropertyAddress is null

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a
 Join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b. [UniqueID ]
  where a.PropertyAddress is null


  -- Breaking out Address into Individual Columns (Address, City, State)

   Select PropertyAddress
 from PortfolioProject.dbo.NashvilleHousing
 --Where PropertyAddress is null
 --order by ParcelID


 Select
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
  from PortfolioProject.dbo.NashvilleHousing


 ALTER TABLE NashvilleHousing
 Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
 SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


  ALTER TABLE NashvilleHousing
 Add PropertySplitCity  Nvarchar(255);

Update NashvilleHousing
 SET PropertySplitCity =  SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


 Select *
 from PortfolioProject.dbo.NashvilleHousing

 
 Select OwnerAddress
 from PortfolioProject.dbo.NashvilleHousing

 
 Select 
 PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
  PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
   PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
 from PortfolioProject.dbo.NashvilleHousing


  ALTER TABLE NashvilleHousing
 Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
 SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

  ALTER TABLE NashvilleHousing
 Add OwnerSplitCity  Nvarchar(255);

Update NashvilleHousing
 SET OwnerSplitCity =    PARSENAME(REPLACE(OwnerAddress,',', '.'),2)


  ALTER TABLE NashvilleHousing
 Add OwnerSplitState  Nvarchar(255);

Update NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)


 Select *
 from PortfolioProject.dbo.NashvilleHousing


 -- Change Y and N to Yes and No in "Sold as Vacant" field

 
 Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
 from PortfolioProject.dbo.NashvilleHousing
 group by SoldAsVacant
 order by 2


 Select SoldAsVacant,
 Case when SoldAsVacant = 'Y' THEN 'Yes'
      when SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
 from PortfolioProject.dbo.NashvilleHousing

 Update NashvilleHousing
 SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
      when SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END


--Remove Duplicates

WITH RowNumCTE as(
Select *,
ROW_NUMBER () OVER (
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
from PortfolioProject.dbo.NashvilleHousing
)
--Delete (insted of Select)

Select *
From RowNumCTE
Where row_num > 1
order by PropertyAddress


-- Delete unused columns

 Select *
 from PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 DROP COLUMN SaleDate
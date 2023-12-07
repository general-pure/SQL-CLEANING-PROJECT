/*CHECKING OUT DATA*/
Select *
from NashvileHousing


/*STANDARDIZE DATE FORMAT*/
select ConvertedDate, CONVERT(Date,SaleDate)
from NashVileHousing

alter table NashVileHousing
add ConvertedDate Date

update NashvileHousing
set ConvertedDate = convert (date,SaleDate)

/*POPULATE PROPERTY ADDRESS DATA*/
select *
from NashVileHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from NashVileHousing a
join NashVileHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashVileHousing a
join NashVileHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


/*BREAKING OUT ADDRESS INTO INDIVIDUAL COLUNMS */

select PropertyAddress
from NashVileHousing

select PropertyAddress, SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address

from NashVileHousing


Alter Table NashVileHousing
Add PropertySplitAddress varchar(255)

Update NashVileHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashVileHousing
Add PropertySplitCity varchar(255)

Update  NashVileHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select *
from NashVileHousing



Select OwnerAddress
from NashVileHousing


Select PARSENAME(Replace(OwnerAddress,',','.'),3) OwnerAddress,
	PARSENAME(Replace(OwnerAddress,',','.'),2) OwnerAddressCity,
	PARSENAME(Replace(OwnerAddress,',','.'),1) OwnerAddressState
from NashVileHousing


Alter Table NashVileHousing
Add OwnerSplitAddress Varchar(255)
update NashVileHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table NashVileHousing
Add OwnerSplitCity Varchar(255)
update NashVileHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table NashVileHousing
Add OwnerSplitState Varchar(255)
update NashVileHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
from NashVileHousing


/*CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" */

select Distinct(SoldAsVacant)
from NashVileHousing

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashVileHousing
Group By SoldAsVacant
Order by 2

select SoldAsVacant,Case when SoldAsVacant = 'N' then 'No'
						when SoldAsVacant = 'Y' then 'Yes'
						else SoldAsVacant
						end
from NashVileHousing

Update NashVileHousing
set SoldAsVacant = Case when SoldAsVacant = 'N' then 'No'
						when SoldAsVacant = 'Y' then 'Yes'
						else SoldAsVacant
						end

/*REMOVE DUPLICATE */
select*,ROW_NUMBER() OVER(
Partition by ParcelID,PropertyAddress,SaleDate 
order by UniqueID) Row_Num
from NashVileHousing


With Row_NumCTE as (
select*,ROW_NUMBER() OVER(
Partition by ParcelID,PropertyAddress,SaleDate 
order by UniqueID) Row_Num
from NashVileHousing

)

select *
from Row_NumCTE
where ROW_NUM > 1
Order by PropertyAddress



With Row_NumCTE as (
select*,ROW_NUMBER() OVER(
Partition by ParcelID,PropertyAddress,SaleDate 
order by UniqueID) Row_Num
from NashVileHousing

)

delete
from Row_NumCTE
where ROW_NUM > 1

/*DELETE UNUSED COLUNMS*/
Select *
from NashVileHousing

Alter Table NashVileHousing
Drop column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict
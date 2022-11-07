
-- 1. Standardized the Data Format

Select * from [Portfolio Project]..NashvilleHousing

Alter table NashvilleHousing
Add New_Sales_Date date

Update NashvilleHousing
set New_Sales_date = convert(date,saledate)

select new_sales_date
from [Portfolio Project]..NashvilleHousing

-- 2. Populating the property address data

select x.ParcelID,x.PropertyAddress,y.ParcelID,y.PropertyAddress, ISNULL(x.propertyaddress, y.propertyaddress)
from [Portfolio Project]..NashvilleHousing x
join [Portfolio Project]..NashvilleHousing y on x.ParcelID = y.ParcelID and x.[UniqueID ] != y.[UniqueID ]
where x.PropertyAddress is null

update x
set x.PropertyAddress = ISNULL(x.propertyaddress, y.propertyaddress)
from [Portfolio Project]..NashvilleHousing x
join [Portfolio Project]..NashvilleHousing y on x.ParcelID = y.ParcelID and x.[UniqueID ] != y.[UniqueID ]
where x.PropertyAddress is null


-- 3. Breaking Address into Seperate columns such as address, city and state

-- 3.1 Fixing the property address (with charindex and substring function)

select PropertyAddress
from [Portfolio Project]..NashvilleHousing 

select 
SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) as Address, 
SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from [Portfolio Project]..NashvilleHousing 

Alter Table NashvilleHousing
Add Property_Address nvarchar(255)

Update NashvilleHousing
set Property_Address = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)
from [Portfolio Project]..NashvilleHousing


Alter Table NashvilleHousing
Add Property_City nvarchar(255)

Update NashvilleHousing
set Property_City = SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
from [Portfolio Project]..NashvilleHousing

select *
from NashvilleHousing

-- 3.2 Fixing Owner Address ( with parsename and replace function)

select OwnerAddress
from [Portfolio Project]..NashvilleHousing 

select PARSENAME(replace(owneraddress,',','.'),3)
,PARSENAME(replace(owneraddress,',','.'),2)
,PARSENAME(replace(owneraddress,',','.'),1)
from [Portfolio Project]..NashvilleHousing 

Alter Table NashvilleHousing
Add Owner_Address nvarchar(255)

Alter Table NashvilleHousing
Add Owner_City nvarchar(255)

Alter Table NashvilleHousing
Add Owner_State nvarchar(255)

Update NashvilleHousing
set Owner_Address = PARSENAME(replace(owneraddress,',','.'),3)
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
set Owner_City = PARSENAME(replace(owneraddress,',','.'),2)
from [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
set Owner_State = PARSENAME(replace(owneraddress,',','.'),1)
from [Portfolio Project]..NashvilleHousing

Select * from [Portfolio Project]..NashvilleHousing

-- 4. Changing Y and N to Yes and NO under column 'sold as vacant' Using case function and update them

select distinct(soldasvacant), COUNT(soldasvacant)
from [Portfolio Project]..NashvilleHousing
group by soldasvacant
order by 2

update NashvilleHousing
set soldasvacant = case when soldasvacant = 'y' then 'Yes' when soldasvacant = 'N' then 'No' Else soldasvacant end

-- 5. Removing Dulplicated (CTE Function)(partition by)

With RankCTE  
As(
Select *, rank()over(partition by Propertyaddress,saleprice,saledate,legalreference order by uniqueid) as Ranknumber
from [Portfolio Project]..NashvilleHousing)

delete from RankCTE
where ranknumber > 1


-- 6. Removing unused columns

select * 
from [Portfolio Project]..NashvilleHousing

Alter Table nashvillehousing
drop column owneraddress, propertyaddress, taxdistrict



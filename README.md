# Data-Cleaning-Project-with-Nashville-Housing-Dataset

In this project, I will be utilizing SQL to comeplete the Data Cleaning Project with the Nashville Housing Data source from https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data

Data Cleaning Steps:

1. Standardized the Data Format

  - by converting data type from datetime to date

2. Populating the property address data

  - isnull() function and self join technique to populate the null field in property address field.
  
3. Breaking Address into Seperate columns such as address, city and state

    3.1 Fixing the property address
    
      - Substring function to get partial string from address 
      - Chairindex to locate the position of the string
    
    3.2 Fixing Owner Address
    
      - Parsename and replace function as secondary method and it's faster
      
4. Changing Y and N to Yes and NO under column 'sold as vacant' Using case function and update them

   - Use CASE Expression to update values
   
5. Removing Dulplicated (CTE Function)(partition by)

   - Using partition by with rank() to check any duplicate value with same Propertyaddress,saleprice,saledate,legalreference and remove them.
   
6. Removing unused columns

   ** Dont Recommend to do it with raw data. Always have a copy version or consider it before removing columns from dataset
   
   

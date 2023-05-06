#Steps 1-3
#The instructions provided did not work, and thus we imported house_price_data in different manner than specified:

#1. We first ran the code 'SET GLOBAL local_infile = 1;' in SQL. This enables the workbench to read data from the local system.
#2. Although we attempted to load the csv file as per project instructions, we failed to load it in such a way that everything was intact (missing headers, missing rows etc). After multiple attempts, we decided to convert the xsls file into csv to prevent data leakage, and then loaded into onto SQL Workbench after enabling Global Infile (see above).
#3. The data was also loaded into Python to confirm that no data leakage has occured.


SHOW VARIABLES LIKE 'local_infile'; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go

SET GLOBAL local_infile = 1;

#4. Select all the data from table house_price_data to check if the data was imported correctly

SELECT * 
FROM house_price_data;  #All columns are present within the loaded database

#5.Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE house_price_data
DROP COLUMN date;

SELECT * FROM house_price_data
LIMIT 10;  #To check if the date coulmn has been dropped

#6. Use sql query to find how many rows of data you have.

SELECT COUNT(*) as number_of_rows
FROM house_price_data;

SELECT COUNT(DISTINCT id)
FROM house_price_data;

#Observation: There are a total of 21,597 rows, which corresponds to the number of rows present in the database when it is loaded onto Python. However, there are only 21,420 unique properties, indicating that these houses have been sold more tha once.

#7. Now we will try to find the unique values in some of the categorical columns:
#What are the unique values in the column bedrooms?

SELECT bedrooms, COUNT(*) as distinct_values
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;

#Observation: Most houses have 3 bedrooms on average, but there are 5 houses which have 10 bedrooms (3 houses), 11 bedrooms (1 house), and 33 bedrooms (1 house) respectively. Our team wonders if the last two houses, especially the last one, are hotels or some other type of commercial property and have been included in the dataset by mistake
#When details of the 33 bedroom house is retrieved , we can see that it only has 1.75 bathrooms -- 1 full bathroom and one bathroom with a toilet, sink, and shower.  This corroborates our suspicions that the this house is either mislabelled or a special type of property.

SELECT * 
FROM house_price_data
WHERE bedrooms = 33;

#What are the unique values in the column bathrooms?

SELECT bathrooms, COUNT(*) as distinct_values
FROM house_price_data
GROUP BY bathrooms
ORDER BY bathrooms ASC;

#Obvservation: Upon further research, the float values as demonstrated by the category of bathrooms is a real estate convention used to describe partial bathrooms or partitioned bathrooms (only toilet, only shower, with bathtub etc).

#What are the unique values in the column floors?

SELECT floors, COUNT(*) as distinct_values
FROM house_price_data
GROUP BY floors;

#Observation: The number of floors a house can have varies between 1-4 floors.

#What are the unique values in the column condition?

SELECT `condition`, COUNT(*) as distinct_values
FROM house_price_data
GROUP BY `condition`
ORDER BY `condition` ASC;

#Observation: The condition of a house can range from values 1-5.

#What are the unique values in the column grade?

SELECT grade, COUNT(*) as distinct_values
FROM house_price_data
GROUP BY grade
ORDER BY grade ASC;

#Observation: The grade of the house can range from 3 to  13.

#8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

SELECT id as house_id, price
FROM house_price_data
ORDER by price DESC
LIMIT 10;

#Observation: The most expensive house is priced at #7,700,000, while the tenth most expensive house is listed at $4,490,000 -- almost half the amount.

#9. What is the average price of all the properties in your data?

SELECT CONCAT('$',  ROUND(AVG(price), 2)) as average_price
FROM house_price_data;

#Observation: The average price of all the houses is $540,296.57

#10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data.

#What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.

SELECT bedrooms, CONCAT('$',  ROUND(AVG(price), 2)) as average_price
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;


#What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.

SELECT bedrooms, ROUND(AVG(sqft_living), 2) as average_sqft_living
FROM house_price_data
GROUP BY bedrooms
ORDER BY bedrooms ASC;

#What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.

SELECT DISTINCT waterfront  #To get a feel of what the distinct values are
FROM house_price_data;

SELECT CASE waterfront
    WHEN 0 THEN 'No'
    WHEN 1 THEN 'Yes'
  END AS waterfront_yes_no,
  CONCAT('$', ROUND(AVG(price), 2)) as average_price
FROM house_price_data
GROUP BY waterfront_yes_no;

#Observation : A house with a waterfront is on average $1,130,761.86 more expensive than a house without a waterfront.

#Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.

SELECT `condition`, AVG(grade) as average_grade
FROM house_price_data
GROUP BY `condition`
ORDER BY `condition` ASC;

#Observation: The better the condition, the higher the average grade. Therefore, condition and grade are positively correlated.

#11. One of the customers is only interested in the following houses:

#-Number of bedrooms either 3 or 4
#-Bathrooms more than 3
#-One Floor
#-No waterfront
#-Condition should be 3 at least
#-Grade should be 5 at least
#-Price less than 300000


SELECT *
FROM house_price_data
WHERE bedrooms IN (3,4)
AND CEILING(bathrooms) > 3
AND floors = 1
AND waterfront = 0
AND `condition` >= 3
AND grade >= 5
AND price < 300000;
#Observation: No such house fulfills all of the client's listed criteria, and this has been verified via Python. However, if there is no cap on the number of bedrooms, then there are 3 houses available of which are priced lower than $300000. We assume that this is because the number of bathrooms is correlated with the numebr of bedrooms (see below)
#This also has been cross verified using Python to confirm that this is not a result of data leakage

SELECT *
FROM house_price_data
WHERE CEILING(bathrooms) > 3
AND floors = 1
AND waterfront = 0
AND `condition` >= 3
AND grade >= 5
AND price < 300000;


#12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.

SELECT COUNT(*)
FROM house_price_data
WHERE price > 
(SELECT AVG(price) * 2 FROM house_price_data);  #There are a total of 1246 houses that fulfills the manager's requirement

SELECT * 
FROM house_price_data
WHERE price > 
(SELECT AVG(price) * 2 FROM house_price_data); #List of all houses that fulfills the manager's requirement 

#13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW expensive_houses AS
SELECT *
FROM house_price_data
WHERE price >
(SELECT AVG(price) * 2 FROM house_price_data);

SELECT *
FROM expensive_houses; #To confirm the view has been successfully created

#14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

SELECT bedrooms, CONCAT('$', ROUND(AVG(price))) as average_price
FROM house_price_data
WHERE bedrooms IN (3,4)
GROUP BY bedrooms; #To determine the average price of a 4 bedroom house and a 3 bedroom house, respectively.

SELECT
CONCAT('$', ROUND(AVG(CASE WHEN bedrooms = 4 
THEN price
END))) AS average_price_4_bedrooms,
CONCAT('$', ROUND(AVG(CASE WHEN bedrooms = 3
THEN price
END))) AS average_price_3_bedrooms,
CONCAT('$', ROUND(AVG(CASE WHEN bedrooms = 4 
THEN price
END) -
AVG(CASE WHEN bedrooms = 3
THEN price END)))
AS average_price_difference
FROM house_price_data;

### Observation: For an extra room, a client would have to pay an average of $169,288 more.

#15. What are the different locations where properties are available in your database? (distinct zip codes)

SELECT COUNT(DISTINCT zipcode) as number_of_locations
FROM house_price_data;

#Observation: There are a total of 70 distinct locations as per the number of distinct zipcodes.

SELECT DISTINCT zipcode as zipcode  #To produce a list of locations
FROM house_price_data;

#16. Show the list of all the properties that were renovated.

SELECT DISTINCT(yr_renovated) as year_of_renovation, COUNT(yr_renovated) AS number_of_houses
FROM house_price_data
GROUP BY yr_renovated;

#The datatype of the yr_renovated column was not converted from int to datetime because it is a composite of two types of data: 1. whether the house has been renovated or not (0 for no, x > 0 for yes) and if yes, the year of renovation. Converting the column to datetime would produce errors as Workbench does not know how to interpret the 0s.

CREATE VIEW renovated_houses AS
SELECT *
FROM house_price_data
WHERE yr_renovated > 0;

SELECT * 
FROM renovated_houses;

SELECT COUNT(*)
FROM renovated_houses;

#Observation: A total of 914 houses in the county have undergone renovation.

#17. Provide the details of the property that is the 11th most expensive property in your database.

SELECT *
FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;  #the first 10 rows are skipped, and since the output is limited to 1, only the 11th row will be displayed

SELECT price
FROM house_price_data
ORDER BY price DESC
LIMIT 1;

#Observation: The most expensive house is valued at $7,700,000.


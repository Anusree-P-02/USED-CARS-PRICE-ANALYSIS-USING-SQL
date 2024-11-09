create database used_cars;
use used_cars;
select * from used_cars;
 
# To check the size of the dataset. 
select count(*) as count from used_cars;  

# To get total number of unique records in the dataset.
select distinct count(*) as count  from used_cars;

describe used_cars;

# Identify the unique ownership categories.
select distinct Owner_Type from used_cars;

set sql_safe_updates=0;

# used to clean and standardize the Engine, Mileage, and Power columns, by removing units or additional text:
update used_cars set Engine=substring_index(Engine,"C",1);
update used_cars set Mileage=substring_index(Mileage,"kmpl",1);
update used_cars set Mileage=substring_index(Mileage,"km",1);
update used_cars set Power=substring_index(Power,"b",1);

#  modifies the Price column to an integer type.
alter table used_cars modify Price int;

# added a new column
alter table used_cars add column Company text; 
update used_cars set Company=substring_index(trim(name)," ",1);

alter table used_cars drop column SL_No;
delete from used_cars where mileage=0;
delete from used_cars where engine=0;

# ___________________Unvariate Analysis Queries____________________________

# 1. Mean and Standard Deviation of Engine and Power:
select Avg(Engine) as Avg_Engine,  # 1628.9250735421354
stddev(Engine) as STD_Engine,      # 599.1203297358786
Avg(Power) as Avg_Power,           # 113.69147603391501
stddev(Power) as STD_Power         # 53.829914817612384
from used_cars;

# 2. Distribution by price ranges  
select case
when price < 250000 then 'Under 250K' 
when price between 250000 and 500000 then '250K-500K'
when price between 500000 and 1000000 then '500K-1M'
else 'Over 1M'
end as Price_range,
count(*) as count from used_cars group by Price_range order by count desc;
# Most price are in the '250K-500K' range.
# Least price are in the 'Under 250k' range.

# 3.  Minimum and maximum price:
select min(price) as Min_price,            # 44000
max(price) as Max_price             # 16000000
from used_cars;  

# 4. Kilometers Driven:
Select max(Kilometers_Driven) as Max_kilometers_Driven,   # 6500000
min(Kilometers_Driven) as Min_Kilometers_Driven,          # 171
avg(Kilometers_Driven) as Avg_Kilometers_Driven           # 58359.2525
from  used_cars;

# 5. Distribution of Years:
Select Year, count(*) as count from used_cars group by Year order by Year desc limit 3 ;

# 6. Fuel Type Counts:
Select Fuel_Type, count(*) AS count from used_cars group by Fuel_Type;
#  Diesel has the highest count of cars with 3134, while petrol has 2645.
   
#7. Find the average price of cars based on transmission type:
select Transmission, avg(price) as Avg_price from used_cars group by transmission;
-- Transmission	    Avg_price
-- Manual	        543317.716
-- Automatic	    1980857.823

# 8. Transmission Types:
Select Transmission, count(*) AS count FROM used_cars group by Transmission;
#  Manual has the highest count of cars with 4098, while Automatic has 1681. 
   
# 9. Average Mileage:
select AVG(Mileage) as avg_mileage from used_cars;
# The Avegera  mileage is 18.292370652362063 so i rounded the mileage
SELECT round(18.292370652362063, 2) AS rounded_mileage;
# The rounded  mileage is 18.29

# 10. Top 3 most expensive cars based on Price Distribution:
Select Name,Price from used_cars group by Name,Price order by Price desc limit 3;
--             Name                                Price	   count
-- Land Rover Range Rover 3.0 Diesel LWB Vog      16000000	    1
-- Lamborghini Gallardo Coupe	                  12000000	    1
-- Jaguar F Type 5.0 V8 S	                      10000000	    1
# Top three highest car prices each appear only once.

# 11. Find the total number of cars available in each location:
select Location, count(*) as count from used_cars group by Location order by count desc;

# ________________Bivariate Analysis Queries_______________

# 1.  Price trends for Diesel fuel types over the years:
select Year, avg(Price) as Avg_price from used_cars where Fuel_Type='Diesel' group by Fuel_Type,Year order by Year desc;


# 2. Average Price vs. Kilometers Driven:
select Kilometers_Driven, avg(Price) as Avg_price from used_cars group by Kilometers_Driven order by Kilometers_Driven limit 5;
   
# 3. Price by Fuel Type:
select Fuel_Type, avg(Price) as avg_price from used_cars group by  Fuel_Type;
   
# 4. Transmission vs. Price:
select Transmission, Max(Price) as Max_price from used_cars group by Transmission;

# 5. Price vs. Engine and Power group by fuel type:
select Fuel_Type,Engine, Avg(Power) as Avg_power,Avg(Price) as Avg_Price from used_cars group by Fuel_Type, Engine  limit 5 ;
   
# 6. Location, First Owner Type,Transmission and mileage analysis:
select Location,Transmission, Max(Mileage) as Max_mileage  from used_cars where Owner_Type='First'group by Location,Transmission limit 5;

#7. Location-wise Price Comparison:
select Location, avg(Price) as Avg_price from used_cars group by Location order by location desc;

# ________________Multivariate Analysis Queries____________________

# 1. how the price of a car is influenced by the year of manufacture, the number of kilometers driven, and the fuel type.
select Name,year,kilometers_Driven, fuel_Type, avg(Price) as Avg_Price from used_cars group by Name,year, kilometers_Driven, Fuel_Type order by year, kilometers_Driven;

# 2. Analyzes how the car price varies based on engine size, power, and transmission type.
select Engine, Power, Transmission, max(Price) as max_price from used_cars group by Engine, Power, Transmission order by  Engine, Power;

# 3. Understand how Fuel_Type, Location, Owner_Type these three categorical variables impact the price.
select Fuel_Type, Location, Owner_Type, avg(Price) as Avg_price from used_cars group by Fuel_Type, Location, Owner_Type order by Fuel_Type, Location limit 10;

# __________________________sql queries_________________________________

# 1.  Retrieve all car listings with a price greater than 1,000,000
select * from used_cars where Price>1000000;

# 2. List all diesel cars with mileage greater than 20:
select Name,Engine, Price from used_cars where Fuel_type='Diesel' and mileage>=20;

# 3. Retrieve the top 5 most expensive cars:
 select * from used_cars order by price desc limit 5;
 
# 4. Calculate the average kilometers driven for cars manufactured after 2015:
select avg(kilometers_Driven) as avg_km from used_cars where year>=2015; 

# 5.  Get cars with more than 7 seats and first ownership:
select name,owner_type,seats from used_cars where seats>=7 limit 5;

# 6. List all cars with ‘Hyundai’ in their model name and priced below 500,000:
select name,price from used_cars where name like "Hy%" and price<500000;

# 7. List all diesel cars under 5 lakh with manual transmission:
select * from used_cars where fuel_Type='diesel' and transmission='manual' and price<500000;




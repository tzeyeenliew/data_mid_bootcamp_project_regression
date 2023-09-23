# Housing Price Regression Project

Team Name: Curry Wurst


Team Members: Natnael Fekade, Kirsty Gosling, and Nicole Liew-Jagtman.


## Executive Summary

We were tasked to build a model that will predict the price of a house based on features provided in the dataset (as described below). With the aid of Tableau and SQL, we were also able to explore property characteristics as well as factors that are responsible for higher property values of $650K and above. The RandomForestRegressor and StackingRegressor are models that performed particularly well in this context. 

Variables that were more influential in determining the property price , in descending order, are: the presence of a waterfront ('waterfront'), the size of the living area ('sqft_living'), the latitude and longitude ('lat', 'long'), the grade of the property ('grade'), history of renovation 'renovated'), the number of bathrooms ('bathrooms'), the view ('view'), the condition of the property ('condition'), the year of construction ('date_year'), the number of floors ('floors'), and the number of bedrooms ('bedrooms'). The text in parentheses indicates the actual name of the variable used in this study.


## Project Deliverables

1. *Python Script*

2. *SQL Script*

3. *Tableau*

4. *Presentation*

5. *Project Documentation (including readme file)*

All files can be located in our project GitHub repository.



## Study Variables

```python

**`id**: 21,420 listed houses --> Dropped this column

**date**: house sold between 02/05/14 - 27/05/15 --> Transformed it

**bedrooms**: number of bedrooms between 1 and 33

**bathrooms**: number of bathrooms between 0.5 and 8

**sqft_living**: size of living area between 370 and 13,540 sqft

**sqft_lot**: size of lot between 520 and 1,651,359 sqft

**floors**: number of floors between 1 and 3.5 floors

**waterfront**: house which has a view to a waterfront (1 = waterfront and 0 = no waterfront)

**view**: number of times the house has been viewed by potential buyers between 0 and 4 views

**condition**: how good the condition is overall (1 = worn out property and 5 = excellent)

**grade**: overall grade given to the housing unit (1 = poor and 13 = excellent) between 3 and 13

**sqft_above**: square footage of house apart from basement

**sqft_basement**: square footage of basement

**yr_built**: year the house was built between 1900 and 2015

**yr_renovated**: year the house was renovated (0 never) between 1934 and 2015 --> Added a new column called **"renovated"** involving 0 = not renovated and 1 = renovated

**zipcode**: zipcode of the location

**lat**: geographical latitude of the location

**long**: geographical longitude of the location

**sqft_living15**: living area in 2015 implies previous renovations and might have affected the lot size between 399 and 6,210

**sqft_lot15**: lot size in 2015 implies previous renovations between 651 and 871,200

**price**: price of the house between 78,000 and 7,700,000

```

## Models Attempted and Results

|    Model              | R-squared | Adjusted R-squared |          MSE          |       RMSE        |        MAE         |
|----------------------|-----------|--------------------|-----------------------|-------------------|--------------------|
| LinearRegression      |   0.71    |        0.71        | 38,637,975,778.84     |    196,565.45     |    122,050.39      |
| KNeighborsRegressor  |   0.50    |        0.50        | 66,453,810,211.71     |    257,786.37     |    152,036.85      |
| MLPRegressor         |   0.60    |        0.60        | 53,094,206,823.71     |    230,421.80     |    149,299.69      |
| Lasso                |   0.71    |        0.71        | 38,637,045,137.10     |    196,563.08     |    122,047.91      |
| Ridge                |   0.71    |        0.71        | 38,627,002,436.87     |    196,537.53     |    121,994.64      |
| ElasticNet           |   0.71    |        0.71        | 38,605,503,646.56     |    196,482.83     |    121,857.52      |
| BayesianRidge        |   0.71    |        0.71        | 38,629,059,939.74     |    196,542.77     |    122,005.50      |
| RandomForestRegressor|   0.87    |        0.87        | 16,854,254,875.93     |    129,823.94     |     69,962.53      |
| Weighted Average Model| 0.7463   |       0.7459       | 33,645,038,180.38     |    183,425.84     |    107,849.70      |
| StackingRegressor    |  0.8635   |       0.8629       | 18,104,780,717.39     |    134,554.01     |     76,277.79      |


## Best Hyperparameters and GridSearchCV

During the course of the project, we have managed to automate the process of finetuning the hyperparameters for our regression models using GridSearchCV.

For a given estimator (i.e a machine learning model), the GridSearchCV method in Scikit-Learn enables users to conduct an exhaustive search over a set of hyperparameters to identify the best hyperparameters that provide the best performance on a given evaluation metric (such as accuracy, precision, recall, etc.). The method evaluates all potential hyperparameter combinations supplied in a grid (hence the name "GridSearch") and chooses the combination that performs the best given the selected evaluation metric.

For instance, we wanted to adjust hyperparameters of our RandomForestRegressor Model -- such as the number of trees (n_estimators) and the maximum depth of the tree (max_depth). For each of these hyperparameters, GridSearchCV allowed us to input a grid of values, which it then used train and test a different model for each possible combination of these hyperparameters.  In other words, GridSearchCV allowed us to optimize our models given our selected evaluation metrics : R-Squared, Adjusted R-Squared, MSE, RMSE, and MAE.


| Model | Best Hyperparameters |
| --- | --- |
| LinearRegression | {} |
| KNeighborsRegressor | {'n_neighbors': 5, 'p': 1} |
| MLPRegressor | {'activation': 'relu', 'hidden_layer_sizes': (100, 100)} |
| Lasso | {'alpha': 1} |
| Ridge | {'alpha': 1} |
| ElasticNet | {'alpha': 0.001, 'l1_ratio': 0.75} |
| BayesianRidge | {} |
| RandomForestRegressor | {'max_depth': 15, 'n_estimators': 100} |



## Notes on SQL Script

The instructions provided did not work, and thus we imported house_price_data in different manner than specified:

1. We first ran the code 'SET GLOBAL local_infile = 1;' in SQL. This enables the workbench to read data from the local system.
2. Although we attempted to load the csv file as per project instructions, we failed to load it in such a way that everything was intact (missing headers, missing rows etc). After multiple attempts, we decided to convert the xsls file into csv to prevent data leakage, and then loaded into onto SQL Workbench after enabling Global Infile (see above).
3. The data was also loaded into Python to confirm that no data leakage has occured.






```python

```

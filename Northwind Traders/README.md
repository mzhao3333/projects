
# Northwind Traders

Dataset: [Northwind Traders Data from Maven Analytics](https://mavenanalytics.io/data-playground?search=northwind)

For a thorough understanding and a step-by-step guide through the analysis, including code and detailed visualizations, refer to the [full Jupyter notebook](./jupyter%20notebook/Northwind%20Traders%20Analysis.ipynb).

## Navigating This README

Welcome to the README for the Northwind Traders analysis project. This document is designed as a concise summary of the comprehensive analysis conducted in our Jupyter Notebook. It aims to provide quick insights and overviews for readers interested in the findings without diving deep into the code and detailed explorations.

### Purpose
The README serves as a bridge for those looking to understand the project's objectives, methodologies, key findings, and conclusions without the need to parse through the extensive Jupyter Notebook.

### How to Use the README
- **Overview of Sections**: Each section of the README, from the "Objective" to "Conclusions and Insights," is crafted to guide you through the analysis journey, highlighting the key takeaways and recommendations.
- **Navigation Tips**: For quick navigation, click on the hyperlinks in the Table of Contents which will lead you to that particular section. Hyperlinks are available in the beginning of every section to return you to the Table of Contents. You can also use the "Find" function (Ctrl+F or Command+F) to jump to specific sections or search for keywords of interest 

I encourage all readers to explore the Jupyter Notebook for a complete view of the analytical process, data explorations, and in-depth insights that are summarized in this README. Happy exploring!

## Objective

The primary objective of this project is to conduct a comprehensive analysis of the Northwind Traders dataset to uncover insights into sales patterns, customer behavior, and operational efficiency. The dataset contains sales & order data for Northwind Traders, a ficticious gourmet food supplier, including information on customers, products, shippers, and employees.

## Description of the Dataset

This dataset contains sales & order data for Northwind Traders, a ficticious gourmet food supplier, including information on customers, products, orders, shippers, and employees.


## Entity Relationship Diagram (ERD)

![Entity Relationship Diagram](./images/Entity%20Relationship%20Diagram%20(2).jpg)
(Made from miro.com)

This visualization allows us to grasp the data's complexity and will guide our exploratory and in-depth analysis.

## Tools

Python/Jupyter Notebook

### Libraries Used

- os, pandas, numpy, re, seaborn, matplotlib
- scipy, statsmodels, sklearn, pmdarima
- networkx, category_encoders, mlxtend

## Table of Contents

- [Setup](#Setup)
    - [Importing Libraries and Working Directory](#importing-libraries-and-working-directory)
- [Data Loading](#data-loading)
    - [Loading CSV Files and Dataframes Dictionary](#loading-csv-files-and-dataframes-dictionary)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
    - [Understanding the Dataset](#understanding-the-dataset)
    - [Data Quality Checks](#data-quality-checks)
    - [Descriptive Statistics](#descriptive-statistics)
    - [Visual Explorations](#visual-explorations)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
    - [Handling Missing Values](#handling-missing-values)
    - [Feature Engineering](#feature-engineering)
- [Merging Dataframes](#merging-dataframes)
    - [Renaming Columns](#renaming-columns)
    - [Joining Tables](#joining-tables)
- [In-depth Analysis and Insights](#in-depth-analysis-and-insights)
    - [Sales Revenue Analysis](#sales-revenue-analysis)
    - [Customer Insights](#customer-insights)
    - [Operational Insights](#operational-insights)
    - [Employee Performance Evaluation](#employee-performance-evaluation)
- [Time Series Analysis](#time-series-analysis)
    - [Sales Analysis Over Time](#sales-analysis-over-time)
    - [Forecasting](#forecasting)
- [Machine Learning Models](#machine-learning-models)
    - [Linear Regression](#linear-regression)
    - [Decision Trees and Random Forest](#decision-trees-and-random-forest)
- [Conclusions and Insights](#conclusions-and-insights)
    - [Summarizing Key Findings](#summarizing-key-findings)
    - [Recommendations based on analysis](#recommendations-based-on-analysis)
- [Appendicies](#appendicies)
    - [Data Dictionary](#data-dictionary)


## Setup
[Return to Table of Contents](#table-of-contents)

Preparing our Python environment with the necessary libraries and correct working directory is fundamental as it allows for data manipulation, analysis, visualization, and access to our resources.

### Importing Libraries and Working Directory

In this project, we utilize a variety of Python libraries, each serving a distinct purpose in the data analysis and modeling process.

- Pandas: Used for data manipulation and analysis. Provides data structures and operations for manipulating numerical tables and time series.
- NumPy: Used for scientific computing. Offers mathematical functions, random number generators, linear algebra routines, and more.
- Matplotlib & Seaborn: Used for creating static, interactive, and informative visualizations.
- Scipy: Used for statistical functions and hypothesis testing.
- Statsmodels: Provides classes and functions for estimating different statistical models and conducting statistical tests and data exploration.
- Scikit-learn: Used for machine learning and statistical modeling including classification, regression, clustering, and dimensionality reduction.
- NetworkX: Used for creating, manipulating, and study of the structure, dynamics, and functions of complex networks
- Pmdarima: Pyramid ARIMA, used for time series forecasting by automating ARIMA model selection
- Category Encoders: Used for feature encoding and converting categorical data into suitable numerical format for modeling.
- Mlxtend: Provides additional utilities for machine learning processes

To ensure that our code runs smoothly and accesses the correct files, we also check and set the working directory which allows our code to access data files and other resources without specifying absolute paths.

## Data Loading
[Return to Table of Contents](#table-of-contents)

In order to make the data accessible and ready for examination, we need to transform our raw data into a manageable and analyzable format.

### Loading CSV Files and Dataframes Dictionary

We create a variable to collect the filenames of all CSV files in our working directory. Then we create an empty dictionary in order to store the dataframes and create a for loop that loads each CSV file into a DataFrame and store them in our dictionary. One challenge that came up was that not all csv files were encoded the same way so we had to use try/except to account for other encodings.

![Dataframe Dictionary Keys](./images/Loading%20CSV%20Files%20and%20Dataframes%20Dictionary%201.png)

## Exploratory Data Analysis (EDA)
[Return to Table of Contents](#table-of-contents)

EDA is the first step in understanding our data and what it contains such as trends and patterns. This will help guide our next steps in analysis and help us ask the right questions.

### Understanding the Dataset

We delve into the dataset to grasp its structure, content, and the type of information it holds. This involves identifying the number of columns, rows, and the data type of each column. To do this, we first double check that our dataframe has correctly loaded in all of our csv files as dataframes. Then we use a for loop to display the information and the first couple of rows for each dataframe in our dictionary.

```Understanding the Dataset 1
All CSV files are accounted for in the dataframes dictionary.
Data for categories:
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 8 entries, 0 to 7
Data columns (total 3 columns):
 #   Column        Non-Null Count  Dtype 
---  ------        --------------  ----- 
 0   categoryID    8 non-null      int64 
 1   categoryName  8 non-null      object
 2   description   8 non-null      object
dtypes: int64(1), object(2)
memory usage: 324.0+ bytes
None
categoryID	categoryName	description
0	1	Beverages	Soft drinks, coffees, teas, beers, and ales
1	2	Condiments	Sweet and savory sauces, relishes, spreads, an...
2	3	Confections	Desserts, candies, and sweet breads
3	4	Dairy Products	Cheeses
4	5	Grains & Cereals	Breads, crackers, pasta, and cereal
```

### Data Quality Checks

We conducted thorough checks for missing values, duplicate entries, inconsistent date formats, and potential outliers. To do this, we used the .isnull() function to check for NaN values, the .duplicated() function to check for duplicates, created a function that checks our date columns for certain date formats, and created a bar graph for every categorical variable in our dataset.

![Data Quality Checks 1](./images/Data%20Quality%20Checks%201.png)

![Data Quality Checks 2](./images/Data%20Quality%20Checks%202.png)

![Data Quality Checks 3](./images/Data%20Quality%20Checks%203.png)

```
{'requiredDate': 'Single format detected: 2013-08-01',
 'shippedDate': "Formats detected: {'%Y-%m-%d': '2013-07-16'} and nulls",
 'orderDate': 'Single format detected: 2013-07-04'}
```

### Descriptive Statistics

We computed descriptive statistics to summarize the central tendency, dispersion, and shape of the dataset's numerical features such as mean, median, standard deviation, and range which gave us insight into the data's distribution and variability.

```
Descriptive statistics for order_details:

orderID	productID	unitPrice	quantity	discount
count	2155.000000	2155.000000	2155.000000	2155.000000	2155.000000
mean	10659.375870	40.793039	26.218520	23.812993	0.056167
std	241.378032	22.159019	29.827418	19.022047	0.083450
min	10248.000000	1.000000	2.000000	1.000000	0.000000
25%	10451.000000	22.000000	12.000000	10.000000	0.000000
50%	10657.000000	41.000000	18.400000	20.000000	0.000000
75%	10862.500000	60.000000	32.000000	30.000000	0.100000
max	11077.000000	77.000000	263.500000	130.000000	0.250000
```

### Visual Explorations

To uncover relationships between variables and detect patterns or anomalies, we created a correlation heatmap to illustrate the strength and direction of relationships between numerical features.

![Visual Explorations](./images/Visual%20Explorations.png)

![Visual Explorations2](./images/Visual%20Explorations%202.png)

## Data Cleaning and Preparation

Cleaning and preparation is crucial for optimizing the quality of our data and influences the accuracy and reliability of our analysis and modeling. This involves standardizing formats, correcting errors, dealing with missing or duplicate data.

### Handling Missing Values

We check for any missing values in our data and we can deal with them through imputation, removal, or retention. In our case, we have missing values that are not random or due to data collection errors but have logical explanations rooted in the real-world context of the dataset.

The shippedDates missing values represents the date on which an order has been shipped to the customer and towards the end of the dataset, there are placed orders that are not yet shipped which is common in order fulfillment processes where there's a lag between order and shipping date.

The reportsTo_emp column is a hierarchical reporting structure within the organization and the missing value indicates an individual at the top of the hierarchy who ddoes not report to anyone.

![Handling Missing Values 1](./images/Handling%20Missing%20Values.png)

### Feature Engineering

We created new features (variables/columns) or modified existing ones to improve our analysis and to prepare our dataset for modeling. We transformed existing date variables and standardized them to convert them into numerical values. We created a 'SalesRevenue' variable that was computed from existing features. We handled categorical variables by applying one-hot encoding during modeling. We aggregated information for Time Series Analysis.

```
#Total Sales revenue wasn't given to us so we have to calculate it on our own with given columns
final_df['SalesRevenue'] = final_df['unitPrice_od'] * (1 - final_df['discount_od']) * final_df['quantity_od']
final_df[['unitPrice_od','discount_od','quantity_od','SalesRevenue']]

unitPrice_od	discount_od	quantity_od	SalesRevenue
0	14.00	0.00	12	168.0000
1	21.00	0.25	5	78.7500
2	21.00	0.05	15	299.2500
3	21.00	0.00	2	42.0000
4	21.00	0.00	15	315.0000
5	21.00	0.05	15	299.2500
...
```

## Merging Dataframes
[Return to Table of Contents](#table-of-contents)

Merging dataframes is fundamental in data analysis and preprocessing and enables us to combine information from different sources into a single dataset. This allows us to have a comprehensive view of the data, more in-depth analysis, and having more features for modeling. Merging helps us avoid redundancy and simplifies the data manipulation flow.

### Renaming Columns

Before merging the dataframes, it is crucial for us to rename the columns to ensure clarity and avoid conflicts. We created a function to append a suffix of their table name to their column name. This will tell us the table that the column came from. If this step is not performed before merging, Python will automatically append x's and y's to prevent duplicate column names. 

We also create a list of column names that won't be appended with a suffix because we will use these columns for merging and it is simpler for the merge function to merge on a single column instead of 2 separate ones.

```
def rename_columns(dataframes, suffixes, exclude_columns=None):
    """
    Renames columns in each dataframe by adding a suffix to avoid duplicate column names after merging,
    except for the columns in the exclude_columns list.
    Suffixes is a dictionary where the key is the dataframe name and the value is the suffix to add.
    """
    if exclude_columns is None:
        exclude_columns = []

    renamed_dataframes = {}
    for df_name, df in dataframes.items():
        # Add suffix to each column except those in exclude_columns and the index
        df_renamed = df.rename(columns=lambda x: f"{x}{suffixes[df_name]}" if x not in exclude_columns and x not in df.index.names else x)
        renamed_dataframes[df_name] = df_renamed
    return renamed_dataframes

# Dictionary with the suffixes for each dataframe
df_suffixes = {
    'orders': '_o',
    'order_details': '_od',
    'customers': '_cust',
    'employees': '_emp',
    'shippers': '_ship',
    'products': '_prod',
    'categories': '_cat'
}

# List of columns to exclude from renaming
exclude_cols = ['categoryID', 'employeeID', 'orderID', 'shipperID', 'productID','customerID']  # Update this list with the appropriate column names

# Rename the dataframes
renamed_dataframes = rename_columns(dataframes, df_suffixes, exclude_columns=exclude_cols)
```

### Joining Dataframes

We joined all the individual dataframes in our dataframe dictionary in order to consolidate related data into a single unified dataframe. The join operation was guided by the relationships between tables and using common identifiers or keys such as their IDs.

```
final_df = (
    renamed_dataframes['orders']
    .merge(renamed_dataframes['order_details'], on='orderID', how='inner')
    .merge(renamed_dataframes['customers'], on='customerID', how='inner')
    .merge(renamed_dataframes['employees'], on='employeeID', how='inner')
    .merge(renamed_dataframes['shippers'], on='shipperID', how='inner')
    .merge(renamed_dataframes['products'], on='productID', how='inner')
    .merge(renamed_dataframes['categories'], on='categoryID', how='inner')
)
```

## In-depth Analysis and Insights
[Return to Table of Contents](#table-of-contents)

This section takes a deeper look into the dataset and illuminates key findings in sales trends, customer behaviors, operational efficiencies, and employee performance. 

### Sales Revenue Analysis

We took a look at our categories by sales revenue and the top 20% of products by sales revenue. Wine and Cheese generated a lot of revenue which makes sense as the tradition and practice of pairing wine and cheese dates back to hundreds of years ago. 

![Sales Revenue Analysis 1](./images/Sales%20Revenue%20Analysis%201.png)

Plotting Côte de Blaye, our most popular wine, on a sales over time plot shows that it is most popular during the start and end of years as it coincides with popular holidays.

![Sales Revenue Analysis 2](./images/Sales%20Revenue%20Analysis%202.png)

Performing an independent samples statistical t-test between the sales revenue of discounted and non-discounted groups checks if the differences between them are statistically different. In our case, our p-value is less than 0.05 which means that any observed difference could occur by random chance and we can't conclude that discounts impact revenue significantly.

![Sales Revenue Analysis 3](./images/Sales%20Revenue%20Analysis%203.png)

We utilized Apriori to conduct a market basket analysis in order to identify frequent itemsets and generating association rules among products in customer orders. By grouping by orderID and aggregating productName_prod, we were able to create baskets of products purhcased together within the same transaction. 

One of our rules state that the frequency of Sirop d'érable and Sir Rodney's Scones appearing together is 7 times higher than if they were alone and 33% of people who buy Sirop also buy Sir Rodeny.

![Sales Revenue Analysis 4](./images/Sales%20Revenue%20Analysis%204.png)

### Customer Insights 

We used clustering to segment customers based on their order frequency, average order value, and country. To perform this, we aggregated these features by customerID, one-hot encode country names, normalized our data with StandardScaler (Z-score normalization), found our elbow point of optimal clusters, and used K-Means Clustering to create our clusters.

![Customer Insights 1](./images/Customer%20Insights%201.png)

After creating our clusters, we aggregated our data and included only numerical columns.

```
OrderFrequency	AverageOrderValue	Cluster
Cluster			
0	11.500000	455.436927	0.0
1	9.384615	490.614392	1.0
2	5.600000	255.943438	2.0
3	7.700000	405.062709	3.0
4	9.222222	477.170618	4.0
5	8.000000	381.532032	5.0
6	11.090909	517.020853	6.0
7	10.000000	520.633289	7.0
8	5.750000	338.778386	8.0
9	6.500000	412.932563	9.0
10	5.333333	238.851263	10.0
11	11.000000	304.449835	11.0
12	9.000000	603.052680	12.0
13	20.000000	1016.894336	13.0
```

Taking a look at Cluster 13 with the highest order frequency and average order value, we can see that they are ERNSH and PICCO from Austria. We can possibly designate these customers as VIP and assign them a personal manager or support line.

![Customer Insights 2](./images/Customer%20Insights%202.png)

### Operational Insights

We assessed operational efficiency by analyzing the time between order placement and shipping as well as orders shipped after the required date which provided insights into the shipping processes and delays in order fulfilment. We delve into determining whether or not shipping company influences late orders as well as the quantity sold over time for our most sold products. We took a look at the sales revenue generated by the top 10 cities.

Generally, it takes less than 2 weeks for an order to be shipped from their order placement date.

![Operational Insights 1](./images/Operational%20Insights%201.png)

There are only 3 distinct durations between order placement and the required dates between all orders. This suggests that the company is aligning its delivery schedule with a weekly cycle and only allowing the customer to select from 3 required date options from their order date (2 weeks, 4 weeks, or 6 weeks).

![Operational Insights 2](./images/Operational%20Insights%202.png)

We can see that most of our orders have a positive value between required - shipped date meaning that a majority of our orders are shipped way before their required date.

![Operational Insights 3](./images/Operational%20Insights%203.png)

We compared the ratio of late orders for each shipping company and found that there wasn't a huge discrepancy which suggests that the shipping company is not a huge factor in determining whether or not the order will be late.

![Operational Insights 4](./images/Operational%20Insights%204.png)

There doesn't seem to be a strong pattern or seasonality of the quantity of popular products sold throughout the years.

![Operational Insights 5](./images/Operational%20Insights%205.png)

Exploring the top 10 cities by sales revenue tells us that Graz from Austria is tied with Boise from US for second place with Cunewalde from Germany being first.

![Operational Insights 6](./images/Operational%20Insights%206.png)

### Employee Performance Evaluation

We visualized sales data to rank employees by performance. Unsurprisingly, the number of orders handled by employees is proportional to the amount of sales revenue generated. Margaret Peakcock has the most orders and revenue generated followed by Janet and Nancy.

![Employee Performance Evaluation 1](./images/Employee%20Performance%20Evaluation%201.png)

We explored whether or not supervision had an impact on Sales performance by running an ANOVA test to compare the means of the aggregate sales figures per employee across different supervisors. Our result tells us that the difference in sales performance across different supervisors' groups are statistically significant and suggests that supervision does impact an employee's total sales revenue.

```
ANOVA F-statistic: 14.837005439048912
ANOVA P-value: 0.00789613942259892
```

## Time Series Analysis
[Return to Table of Contents](#table-of-contents)

This section focuses on analyzing sales trends and forecasting future sales using statistical models. We explore how sales revenue changed over time, identify patterns, and predict future sales based on historical data.

### Sales Analysis Over Time

We visualized our sales revenue over time aggregated with different time periods to explore trends and seasonal patterns. Our monthly plot shows that the business was growing slowly, then stagnating, and had a meteoric rise from 2014-11 to 2015-04 then had a sharp drop due to data collection ending.

![Sales Analysis Over Time 1](./images/Sales%20Analysis%20Over%20Time%201.png)

### Forecasting

Our goal will be to forecast future sales revenue using the ARIMA model. The ARIMA model requires that our time series be stationary as well as parameters that we need to acquire through ACF and PACF values.

In order to perform forcasting, our time series must be stationary (mean, variance, autocorrelation are constant over time) in order to have good model predictability and forecasting. We use the ADF statistical test to check for stationarity.

To make our time series stationary, we apply various transformations to have a low ADF statistic and p-value. Our best transformation was detrending by subtracting a 4 week moving average and gave us the lowest numbers compared to differencing, transforming via logs,sqrts,powers, and seasonal adjustments.
```
ADF Statistic: -11.796148080742677
p-value: 9.568809996164918e-22
(-11.796148080742677,
 9.568809996164918e-22,
 0,
 93,
 {'1%': -3.502704609582561,
  '5%': -2.8931578098779522,
  '10%': -2.583636712914788},
 1621.3779694647828)
```

To grab the parameters for our ARIMA model, we look at the lags from the ACF and PACF functions which reveals the relationship between a data point and its lags. In our case, it tells us if the sales revenue in the current week has any correlation with sales revenue X weeks before.

![Forecasting 1](./images/Forecasting%201.png)

We graphed several sales over time plots for different periods to see if our ACF and PACF values are true. By exploring ACF lags 3 and 8, it does seem that the values are correct since there are negative and positive correlations.

![Forecasting 2](./images/Forecasting%202.png)

AutoRegressive Integrated Moving Average (ARIMA) Model is a popular statistical approach for forecasting time series data. To start our forecasting, we cap our dataset at our last full week and do train test split which allows our model to be trained on training data in preparation for predicting future data.

For our ARIMA model parameters, we use our PACF, differencing, and ACF values. We experimented with different parameters, using auto_arima which performs a stepwise search to minimize aic, and using the SARIMAX model which also considers seasonality and exogenous factors.

The SARIMAX model was our best model by far when we compared their root mean squared error values. The next step is to apply the model to our original dataset by first applying detrending, fitting the SARIMAX model, forecast the future values, and then inverse the detrending process. 

![Forecasting 3](./images/Forecasting%203.png)

Due to the fact that our dataset has less than 2 years of data, our SARIMAX model that forecasts the next 2 years is probably inaccurate and unreliable. I would expect a steady overall increase in sales revenue over time.

## Machine Learning Models
[Return to Table of Contents](#table-of-contents)

This section presents the applications of Linear Regression and Decision Trees and Random Forest to have deeper insights into the data. The models aim to uncover patterns, predict future trends, and provide recommendations for decisions.

### Linear Regression

Our goal will be to create a linear regression model that allows us to understand the relationships between our features and our target variable and be able to quantify the strength and direction of these relationships.

The first step is to choose features that are suited for linear regression and would affect our target variable of sales revenue. These features should not be highly correlated with each other to prevent multicollinearity where one feature is super helpful in predicting our target.
```
feature_columns = [col for col in final_df.columns if 'year' in col or 'month' in col or 'day' in col or 'weekday' in col]
feature_columns += ['freight_o','categoryName_cat', 'productName_prod']

df_features = final_df[feature_columns]
df_features = pd.get_dummies(df_features, columns = ['categoryName_cat','productName_prod'], drop_first=True)

for col in df_features.columns:
    if df_features[col].dtype == 'bool':
        df_features[col] = df_features[col].astype(int)
        
df_features.head(5)
```

Then we perform our train test split once again in order to train our model. We use OLS from statsmodels as it gives us a detailed summary. Our Adj. R-squared tells us how well the model fits the data. 55.7% of the variance in sales revenue can be explained by our model's predictors.
```
OLS Regression Results                            
==============================================================================
Dep. Variable:           SalesRevenue   R-squared:                       0.576
Model:                            OLS   Adj. R-squared:                  0.557
Method:                 Least Squares   F-statistic:                     30.72
Date:                Fri, 22 Mar 2024   Prob (F-statistic):          2.01e-305
Time:                        15:15:36   Log-Likelihood:                -16396.
No. Observations:                2082   AIC:                         3.297e+04
Df Residuals:                    1993   BIC:                         3.347e+04
Df Model:                          88                                         
Covariance Type:            nonrobust                                         
===============================================================================
coef    std err          t      P>|t|      [0.025      0.975]
-------------------------------------------------------------------------------
...
==============================================================================
Omnibus:                     2017.083   Durbin-Watson:                   2.091
Prob(Omnibus):                  0.000   Jarque-Bera (JB):           385503.779
Skew:                           4.071   Prob(JB):                         0.00
Kurtosis:                      69.163   Cond. No.                     4.87e+17
==============================================================================

Notes:
[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
[2] The smallest eigenvalue is 1.07e-25. This might indicate that there are
strong multicollinearity problems or that the design matrix is singular.                   
```

However, all of the diagnostic results and the notes indicate that our model lacks linearity between features and the target and is not adequate. This means that our model is unreliable and inaccurate. We created plots such as Actual vs Predicted values, Residuals vs Predicted Values, Histogram of Residuals, and Q-Q plots to check the assumptions of the OLS model.

Along with this, we also looked at and performed tests such as linearity, homoscedasticity, Breusch-Pagan, Omnibus, Shapiro-Wilk, Durbin-Watson, Jarque-Bera, Skew, Kurtosis, and Cond. No.

![Linear Regression 1](./images/Linear%20Regression%201.png)

We redid this model by choosing new features, used VIF and a correlation matrix to deal with multicollinearity, and standardized our continuous variables using StandardScaler(). This resulted in a model that has 18% Adj. R-squared but more reliable since it passes the OLS assumptions.
```
OLS Regression Results                            
==============================================================================
Dep. Variable:           SalesRevenue   R-squared:                       0.191
Model:                            OLS   Adj. R-squared:                  0.180
Method:                 Least Squares   F-statistic:                     17.33
Date:                Fri, 22 Mar 2024   Prob (F-statistic):           7.60e-78
Time:                        15:15:40   Log-Likelihood:                -17647.
No. Observations:                2155   AIC:                         3.535e+04
Df Residuals:                    2125   BIC:                         3.553e+04
Df Model:                          29                                         
Covariance Type:            nonrobust                                         
===============================================================================
coef    std err          t      P>|t|      [0.025      0.975]
-------------------------------------------------------------------------------
...
==============================================================================
Omnibus:                     2817.433   Durbin-Watson:                   1.154
Prob(Omnibus):                  0.000   Jarque-Bera (JB):           726102.556
Skew:                           7.026   Prob(JB):                         0.00
Kurtosis:                      91.820   Cond. No.                         72.5
==============================================================================

Notes:
[1] Standard Errors assume that the covariance matrix of the errors is correctly specified.
```

### Decision Trees and Random Forest

One of the advantages of trees and random forests is their ability to automatically select features most important for predicting the target variable. While these models can handle both numeric and categorical, scikit-learn requires all data to be numeric. All we need to do is give it all the variables and encode the categoricals.

To begin, we choose our target variable and our features while dropping time variables (trees can't handle time variables) and removing direct derivation columns of our target variable. We do train test split again and use a Column Transformer to apply OneHotEncoding to categorical columns. Tree-based models inherently handle multicollinearity so we don't need to drop any columns to prevent the multicollinearity.

We apply this transformation to our training and test data and initialize and fit our decision tree model. We evaluate the tree model by looking at the training and test Mean Squared Error values. Having 0 training MSE and a high test MSE indicates that the tree model is overfitting on the training data and performs poorly on new, unseen data.
```
Decision Tree Training MSE: 0.0
Decision Tree Test MSE: 2194549.6086294535
```

We repeat the same steps above but for a random forest model and evaluate the model again. Our forest model is overfitting less than the tree model but having high MSE on both training and test indicates that the model shows poor learning even on training data and is underfitting.
```
Random Forest Training MSE: 50183.42819086702
Random Forest Test MSE: 765452.701145029
```

We can also take a look at our forest model's feature importance which allows us to see a quantitative measure of the impact each feature has on the model's prediction. It ranks features based on how useful they are at predicting the target variable.

![Decision Trees and Random Forest 1](./images/Decision%20Trees%20and%20Random%20Forest%201.png)

Upon reflection, our dataset presents certain challenges for predictive machine learning primarily due to limitations in the predictive power of the available features. However, our tree-based models can be further refined through pruning, adjusting parameters, enforcing constraints, cross-validation, better feature selection and dimensionality reduction, and/or stacking and boosting.


## Conclusions and Insights
[Return to Table of Contents](#table-of-contents)

This section synthesizes the project's findings, outlines actionable recommendations based on the analysis, and proposes directions for future research.

### Summarizing Key Findings

Our random forest model's feature importance shows that Côte de Blaye, unit price, and freight had a strong influence on sales revenue. We used SARIMAX to forecast 2 years in the future for our sales revenue and did not see a general upward trend in sales revenue over time. 

We compared the aggregate sales figures per employee across different supervisors and saw that supervision does impact an employee's total sales revenue.

We clustered our customers based on order frequency and average order value which allows us to perform different business strategies for different groups of customers. We used Apriori to conduct market basket analysis and saw that Sirop d'érable and Sir Rodney's Scones were most bought together. 

### Recommendations based on analysis

Based on our findings, I recommend concentrating on product categories such as wine and cheese as these are significant sales drivers by increasing inventory or marketing efforts.

We should tailor discounts more effectively by giving them to high valued customers based on our cluster analysis to encourage them to buy more.

We should evaluate the supervision strategies for our managers and apply their techniques for the rest of our managers.

## Appendicies
[Return to Table of Contents](#table-of-contents)

### Data Dictionary
| Table         | Field          | Description                                                                 | Data Type |
|---------------|----------------|-----------------------------------------------------------------------------|-----------|
| orders        | orderID        | Unique identifier for each order                                            | `int64`   |
| orders        | customerID     | The customer who placed the order                                           | `object`  |
| orders        | employeeID     | The employee who processed the order                                        | `int64`   |
| orders        | orderDate      | The date when the order was placed                                          | `object`  |
| orders        | requiredDate   | The date when the customer requested the order to be delivered              | `object`  |
| orders        | shippedDate    | The date when the order was shipped                                         | `object`  |
| orders        | shipperID      | The ID of the shipping company used for the order                           | `int64`   |
| orders        | freight        | The shipping cost for the order (USD)                                       | `float64` |
| order_details | orderID        | The ID of the order this detail belongs to                                  | `int64`   |
| order_details | productID      | The ID of the product being ordered                                         | `int64`   |
| order_details | unitPrice      | The price per unit of the product at the time the order was placed (USD - discount not included) | `float64` |
| order_details | quantity       | The number of units being ordered                                           | `int64`   |
| order_details | discount       | The discount percentage applied to the price per unit                       | `float64` |
| customers     | customerID     | Unique identifier for each customer                                         | `object`  |
| customers     | companyName    | The name of the customer's company                                          | `object`  |
| customers     | contactName    | The name of the primary contact for the customer                            | `object`  |
| customers     | contactTitle   | The job title of the primary contact for the customer                       | `object`  |
| customers     | city           | The city where the customer is located                                      | `object`  |
| customers     | country        | The country where the customer is located                                   | `object`  |
| products      | productID      | Unique identifier for each product                                          | `int64`   |
| products      | productName    | The name of the product                                                     | `object`  |
| products      | quantityPerUnit| The quantity of the product per package                                     | `object`  |
| products      | unitPrice      | The current price per unit of the product (USD)                             | `float64` |
| products      | discontinued   | Indicates with a 1 if the product has been discontinued                     | `int64`   |
| products      | categoryID     | The ID of the category the product belongs to                               | `int64`   |
| categories    | categoryID     | Unique identifier for each product category                                 | `int64`   |
| categories    | categoryName   | The name of the category                                                    | `object`  |
| categories    | description    | A description of the category and its products                              | `object`  |
| employees     | employeeID     | Unique identifier for each employee                                         | `int64`   |
| employees     | employeeName   | Full name of the employee                                                   | `object`  |
| employees     | title          | The employee's job title                                                    | `object`  |
| employees     | city           | The city where the employee works                                           | `object`  |
| employees     | country        | The country where the employee works                                        | `object`  |
| employees     | reportsTo      | The ID of the employee's manager                                            | `float64` |
| shippers      | shipperID      | Unique identifier for each shipper                                          | `int64`   |
| shippers      | companyName    | The name of the company that provides shipping services                     | `object`  |




## 🔗 Links
[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://michaelkzhao.wixsite.com/portfolio)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/michaelkzhao/)
[![Tableau](https://img.shields.io/badge/Tableau-ff7043?style=for-the-badge&logo=Tableau&logoColor=white)](https://public.tableau.com/app/profile/michaelkzhao/vizzes)
Email: zhaomichael33@gmail.com



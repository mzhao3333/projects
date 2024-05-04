# Preview of Dashboard

##

![Sales Dashboard](./imgs/Sales%20Dashboard.png)

![Sales Dashboard Context](./imgs/Sales%20Dashboard%20Context.png)

![Sales Dashboard Filter](./imgs/Sales%20Dashboard%20Filters.png)

![Sales Dashboard Contact](./imgs/Sales%20Dashboard%20Contact.png)


# Introduction

The purpose of this PowerBI dashboard is to provide a comprehensive overview of sales performance across various dimensions such as time periods, product categories, and geographic regions. This dashboard is designed to empower the sales teams, management, and stakeholders with actionable insights that drive strategic decision-making and optimize sales processes.

Key objectives of the dashboard include:

- **Trend Analysis**: Enable users to identify sales trends over time, helping to forecast future sales and adjust strategies accordingly.
- **Performance Tracking**: Offer a clear view of sales metrics such as total sales revenue year to date, month over month growth, year over year growth, and average order value.
- **Market Analysis**: Analyze sales data by region, category, and products to identify regions or products with growth potential.
- **Operational Efficieny**: Reduce the time and effort required to generate sales reports and analysis, allowing the sales teams to focus more on sales activities and less on administrative tasks.

The dashboard is built with a user-friendly interface, offering interactive elements such as filters, slicers, drill-through capabilities that allow the users to customize the views according to their specific needs. This ensures that users can navigate through complex data and enhance their ability to make well-informed decisions quickly.

# Data Sources

Dataset: [Northwind Traders Data from Maven Analytics](https://mavenanalytics.io/data-playground?search=northwind)

To prepare the data for use, several preprocessing steps are usually undertaken:

- **Cleaning**: Remove duplicates, correct errors, handle missing values to ensure accuracy in reporting and analysis.
- **Transformation**: Things like converting date fields to a consistent format, categorizing things into broarder groups, and normalizing numbers.
- **Integration**: Data from various sources is integrated into a unified schema in PowerBI through relationships based on common fields.

However, since we have already explored this data from our python/jupyter notebook section, we only need to work on the **Integration** part.

# Data Modeling

## **Key Components of the Data Model**

**Fact Tables**: center of the star schema, contains quantitative data of the business process
- **order_details**: records every sales transaction details, including productID, orderID, quantity, discount, and unit price.
- **orders**: records every sales transaction, including customerID, employeeID, dates for order, required, and shipped, and shipping ID.

**Dimension Tables**: connected to fact tables and contain descriptive attributes related to the dimensions of the measures in the fact tables
- **categories**: contains information regarding the category that a product belongs in.
- **customers**: includes customer information such as city, company, contact name and title, and country.
- **employees**: includes employee information such as city, country, name, who they report to, and their title.
- **products**: contains information of what the product name is.
- **shippers**: contains name of the shipping company.

## Relationships

The data model uses star schema architecture which organizes data into one or more fact tables referencing any number of dimension tables to help simplify queries and improve performance. Relationships are defined as follows:
- The **orders** table is linked to all dimension tables through their respective keys (e.g., orderID, customerID, employeeID)
- A one-to-many relationship exists from most dimension table to the fact tables with 'Both' cross filter direction reflects that each entry in the dimension table can be associated with multiple entries in the fact table and allows filtering to work for both sides of the relationship.

## Key DAX Measures, Calculated Columns, and Tables

**DAX Measures** (Formulas Table)
- Average Order Value = DIVIDE([Total Sales], [Total Orders])
- MoM Growth = DIVIDE([Sales Current Month] - [Sales Previous Month], [Sales Previous Month])
- Order Size Bin = 
CALCULATE(
    DISTINCTCOUNT('order_details'[orderID]),
    ALLEXCEPT('order_details', 'order_details'[orderID])
)
- Top 10 Products = 
RANKX(
    ALL('products'[productName]), 
    [Total Quantity Sold], 
    , DESC, Dense
)
- Total Orders = DISTINCTCOUNT('orders'[OrderID])
- Total Quantity Sold = SUMX(
    RELATEDTABLE('order_details'),
    'order_details'[quantity]
)
- Total Sales = SUM(order_details[Sales Revenue])
- YoY Growth = DIVIDE([Sales Current Year] - [Sales Previous Year], [Sales Previous Year])

**Calculated Columns**
- = Table.AddColumn(#"Changed Type", "Sales Revenue", each (1 - [discount]) * [quantity] * [unitPrice])

        Added a new column to calculates Sales Revenue for each order in Power Query Editor

**Tables**
- 1.Formulas Table = ROW("DummyColumn", BLANK())

        Created a formula table to hold DAX measures
- Created a duplicated 'employees' table to act as a 'managers' table when referencing the original 'employees' table
- Utilized [Bravo](https://www.sqlbi.com/tools/bravo-for-power-bi/) to create a Date table since our data doesn't have values for every date


Here is an image of how my tables and relationships look in PowerBI's model view:
![PowerBI Model View](./imgs/PowerBI%20Model%20View.png)

# Reports and Visualizations

**KPI Cards**
- **Total Sales Revenue YTD**: An aggregate sum of sales revenue earned for all time
- **Month over Month Growth**: Percentage change of current month's sales revenue compared to the previous month
- **Year over Year Growth**: Percentage change of current year's sales revenue compared to the previous year
- **Average Order Value**: The average amount of sales revenue per order placed

**Visualizations**
- **Sales Revenue Over Time**: A line chart that shows sales revenue earned per time period
- **Top 10 Categories by Sales Revenue**: A bar chart that shows the amount of sales revenue earned by the top 10 categories
- **Sales Revenue by Country**: A world wide map that compares the amount of sales revenue generated from each customer's country
- **Top 10 Products by Quantity**: A bar chart that shows the amount of quantity ordered for the top 10 products

# Interactivity and User Experience

  **Features**
  - Context pane that displays a tooltip for each visualization with a short summary of what it is
  - Filter pane that displays slicers for Year, Month, Country, Category, and Shipping Company
  - Contact pane to allow users to look at my links
  - Page navigator to allow users to switch to different dashboards
  - Drill-through capabilities on the line chart to allow users to look at year, quarter, month, or date time periods

# Challenges and Solutions
1. PowerBI allows you to import and **combine** multiple files by selecting the folder. If you have multiple csv files that are supposed to be **individual** tables, you have to import them one at a time.
2. PowerBI has M expressions (PowerQuery) and DAX expressions; M expressions are used for data preparation, transformation, and cleaning before loading into PowerBI models and is used in the Power Query Editor. DAX is used for creating calculated columns, measures, and tables in the data model after the data has been loaded into PowerBI.
3. Data Modeling can be difficult with a large number of related tables since you have to check each tables' cardinality as well as cross-filter direction.
4. PowerBI has basic aesthetics which can make the dashboard look bland; Many people create their own colored/gradient containers and backgrounds in PowerPoint
5. Changing the font/color/size for each element can be tedious; Use a theme to consistently apply the same format
6. Prevent things from looking misaligned by using the align function as well as gridlines and snap to grid
7. Use the selection pane and name each element to stay organized and know exactly what you're clicking
8. Bookmarks allow you to change the state of the dashboard, create pop-up panes/windows to give off an app-like feel
9. Time functions do not work well if your data doesn't contain values for each date. Create a calendar through DAX or Bravo and relate your data to it
10. Unlike Tableau's page shelf, PowerBI's play axis only filters the visualizations to the specific time period and increases sequentially without showing history or cumulativeness

# Work In Progress
Employee Performance and Customer Insights dashboards are currently a WIP as of 5/4/2024.

## 🔗 Links
[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://michaelkzhao.wixsite.com/portfolio)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/michaelkzhao/)
[![Tableau](https://img.shields.io/badge/Tableau-ff7043?style=for-the-badge&logo=Tableau&logoColor=white)](https://public.tableau.com/app/profile/michaelkzhao/vizzes)
Email: zhaomichael33@gmail.com


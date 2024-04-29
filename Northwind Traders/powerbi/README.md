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

        Added a new column to calculates Sales Revenue for each order in **Power Query Editor**

**Tables**
- 1.Formulas Table = ROW("DummyColumn", BLANK())

        Created a formula table to hold DAX measures
- Created a duplicated 'employees' table to act as a 'managers' table when referencing the original 'employees' table
- Utilized [Bravo](https://www.sqlbi.com/tools/bravo-for-power-bi/) to create a Date table since our data doesn't have values for every date


Here is an image of how my tables and relationships look in PowerBI's model view:
![image of powerbi model view](./images/Loading%20CSV%20Files%20and%20Dataframes%20Dictionary%201.png)

# Reports and Visualizations
Description of the reports and dashboards created.
Key visualizations and their purposes.
Insights or trends highlighted by the visualizations.

# Interactivity and User Experience
Features like slicers, drill-throughs, or tooltips.
How these features enhance user interaction and data exploration.

# Challenges and Solutions
Any significant challenges faced during the PowerBI development.
How you addressed these challenges.

## 🔗 Links
[![portfolio](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://michaelkzhao.wixsite.com/portfolio)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/michaelkzhao/)
[![Tableau](https://img.shields.io/badge/Tableau-ff7043?style=for-the-badge&logo=Tableau&logoColor=white)](https://public.tableau.com/app/profile/michaelkzhao/vizzes)



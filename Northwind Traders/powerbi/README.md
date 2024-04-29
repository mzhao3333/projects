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

  ## DAX Measures and Calculated Columns

  Several DAX measures are implemented to enhance the model's analytical capabilities
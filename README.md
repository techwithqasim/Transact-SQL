# Transact-SQL or T-SQL
- Learning SQL

## **Bike Store Database**

![BikeStoreDatabase](./images/bikstore-database.png)

This repository contains the schema for a Bike Store Database, designed to manage sales and production workflows. The database is organized into two main sections: Sales and Production, with interconnected tables to efficiently handle customer orders, inventory, and product information.

### **Schema Overview**
##### **Sales Section:**
- Customers: Stores customer details like name, contact information, and address.
- Staffs: Tracks staff details, including their assigned store and managers.
- Stores: Contains store information such as name, address, and contact.
- Orders: Manages customer orders with status, dates, and staff assignments.
- Order Items: Details the products in each order, including quantity, price, and discounts.
##### **Production Section:**
- Categories: Defines product categories.
- Products: Stores product details like name, brand, category, price, and model year.
- Stocks: Tracks product inventory at different store locations.
- Brands: Maintains information about product brands.
##### **Relationships:**
- Customers place Orders, which include multiple Order Items linked to Products.
- Products belong to specific Categories and Brands.
- Stocks tracks the quantity of Products available in each Store.
- Staffs manage Orders and are linked to specific Stores.
This schema ensures seamless integration between sales and inventory management, offering a comprehensive solution for bike store operations.
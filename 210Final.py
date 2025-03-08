# -*- coding: utf-8 -*-
"""
Created on Thu May  9 10:56:53 2024

@author: jtkod
"""

import pandas as pd
import matplotlib.pyplot as plt

# Load data
data = pd.read_csv('expenditures.csv')

# 1. Horizontal bar chart for the year 2008
year_2008 = data[data['year'] == 2008]
plt.figure(figsize=(8, 6))
plt.barh(year_2008['category'], year_2008['expenditure'], height=0.8, color='red')
plt.xlabel('Expenditure')
plt.ylabel('Category')
plt.title('Expenditure Distribution for the Year 2008')
plt.savefig('chart1.png')
plt.show()


# 2. Grouped horizontal bar chart for years 2001 and 2008
years2001_2008 = data[data['year'].isin([2001, 2008])]
pivot_years = years2001_2008.pivot_table(index='category', columns='year', values='expenditure')
pivot_years.plot(kind='barh', figsize=(10, 8))
plt.xlabel('Expenditure')
plt.ylabel('Category')
plt.title('Expenditure Distribution for the Years 2001 and 2008')
plt.legend(title='Year')
plt.savefig('chart2.png')
plt.show()


# 3. Line plot for food expenditure from 1990 to 2008
food_expenditure = data[data['category'] == 'Food']
plt.figure(figsize=(10, 6))
plt.plot(food_expenditure['year'], food_expenditure['expenditure'], marker='*', color='green', linestyle='--')
plt.xlabel('Year')
plt.ylabel('Expenditure')
plt.title('Trend of Food Expenditure from 1990 to 2008')
plt.grid(True)
plt.savefig('chart3.png')
plt.show()


# 4. Pie chart for all categories for year 2000
year_2000 = data[data['year'] == 2000]
explode = [0.1 if cat in ['Food', 'Entertainment'] else 0 for cat in year_2000['category']]
plt.figure(figsize=(10, 8))
plt.pie(year_2000['expenditure'], labels=None, explode=explode, autopct='%1.1f%%', startangle=140, shadow=True)
plt.title('Expenditure Distribution for the Year 2000')
plt.legend(year_2000['category'], loc='center left', bbox_to_anchor=(1, 0.5))
plt.savefig('chart4.png', bbox_inches='tight')
plt.show()

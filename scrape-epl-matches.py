### Setup ###

# Load libraries
import requests as r
from bs4 import BeautifulSoup
import pandas as pd
import os

# Specify working directory
#os.chdir("/Users/nickboyd/Desktop/Projects/football-analysis")

### Scrape EPL Data from website ###

# Define baseline URL for football UK
base_url = "https://www.football-data.co.uk/"
england_ext = "englandm.php"
home_url = base_url + england_ext

# Make get request
response = r.get(home_url)

# Get HTML document from link
html = response.text

# Convert HTML document into bs4 object
soup = BeautifulSoup(html, 'lxml')

# Empty list to store links
season_files = []

# Find all links for datasets
for a in soup.find_all('a', href=True):

    # If it end with the code indicating it's a csv file for EPL
    if a['href'].endswith('E0.csv'):
    
        # Append to list of links
        season_files.append(base_url + a['href'])
        
        
### Read in CSVs and combine data
# Create empty list to store dataframes
epl_list = []

# Iterate through list of urls
for file in season_files:
    
    # Download data from url and read as CSV
    df = pd.read_csv(file, index_col=None, header=0, 
                     usecols=["Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR"],
                     encoding= 'unicode_escape')
    
    # Add column for season
    df["season"] = file[-11:-9] + "-" + file[-9:-7]
    
    # Append to list
    epl_list.append(df)
    
# Concatenate dataframes together
epl_df = pd.concat(epl_list)

# Write to CSV
epl_df.to_csv("epl_scores.csv", index = False)
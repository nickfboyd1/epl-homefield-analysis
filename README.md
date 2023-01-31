## Overview

The goal of this project is to seek out supporting evidence for an interesting, much-discussed and widely accepted phenomenon: home field advantage. Analysts, commentators, and players each reference this effect with such regularity that it is hardly even questioned as to what degree it may actually play. Often times when two teams play each other, the home team is judged more critically while the away team is given more leniency for their errors.

My assumption is that playing at home does have a positive relationship with metrics like goals scored, goal difference, and games won. However, I am interested in investigating this question further to determine a more precise understanding of these relationships.

This repository contains the following files related to this analysis
- scrape-epl-matches.py -- Python script utilizing webscraping techniques to extract and combine historical data from the EPL (dating back to 1992)
- epl_scores.csv -- Output of the python script mentioned above
- transform-data.R -- R script used to transform epl_scores.csv data in preparation for data visualizations and analysis
- epl_summary_all_seasons.csv -- Output of the R script mentioned above
- goal-analysis.twb -- Tableau workbook analyzing home and away goals throughout the Premier League's history (utilizes CSV mentioned above)

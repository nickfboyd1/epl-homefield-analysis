
#### Setup ####
# Load libraries
library(tidyverse)
library(DataExplorer)

# Import data
df = read_csv("epl_scores.csv")

#### Data Cleaning ####
# Remove rows with missing values
df = df %>%
    drop_na() %>%
    rename(Season = "season")

# Update data types
df$Date = as.Date(df$Date, "%d/%m/%Y")

#### Build function to transform data with date filter ####
    
# summarize_epl takes 3 arguments:
# df (required): dataframe to summarize
# start_date (optional): 10-character string formatted as 'YYYY-MM-DD'
# end_date (optional): 10-character string formatted as 'YYYY-MM-DD'

summarize_epl = function(df, start_date, end_date) {
    
    # Handling for optional date filter arguments
    if(missing(start_date)) {
        start_filter = min(df$Date)
    } else {
        start_filter = start_date
    }
    
    if(missing(end_date)) {
        end_filter = max(df$Date) 
    } else {
        end_filter = end_date
    }
    
    # Filter EPL dataframe according to start and end date
    df = df %>%
        filter(Date >= start_filter,
               Date <= end_filter) 
    
    # Home statistics
    df_home = df %>%
        
        # Group by home team
        group_by(HomeTeam) %>%
        
        # Summarize for the home team - total goals scored, total goals conceded, avg goals scored, avg goals conceded
        summarise(hg_scored = sum(FTHG),
                  hg_conceded= sum(FTAG),
                  avg_hgs = hg_scored/n(),
                  avg_hgc = hg_conceded/n(), 
                  home_matches = n(),
                  seasons = n_distinct(Season)) %>%
        
        # Rename column
        rename(Team = "HomeTeam")
    
    # Away statistics
    df_away = df %>%
        
        # Group by away team
        group_by(AwayTeam) %>%
        
        # Summarize for the away team - total goals scored, total goals conceded, avg goals scored, avg goals conceded
        summarise(ag_scored = sum(FTAG),
                  ag_conceded= sum(FTHG),
                  avg_ags = ag_scored/n(),
                  avg_agc = ag_conceded/n(), 
                  away_matches = n()) %>%
        
        # Rename column
        rename(Team = "AwayTeam")
    
    # Merge together into combined dataframe
    df_combined = merge(df_home, df_away, by="Team") %>%
        mutate(total_scored = hg_scored + ag_scored,
               total_conceded = hg_conceded + ag_conceded,
               total_matches = home_matches + away_matches,
               avg_scored = total_scored / total_matches,
               avg_conceded = total_conceded / total_matches,
               goal_difference = total_scored - total_conceded)
    
    
    # Create filename
    #sd_filename = str_replace_all(start_filter, '-', '')
    #ed_filename = str_replace_all(end_filter, '-', '')
    
    # Write combined df to CSV
    #write_csv(df_combined, paste0("epl_summary_", sd_filename, "_", ed_filename,".csv"))
    
    # Return dataframe
    return(df_combined)
}

# Use function and write to CSV for further analysis in data viz tool 
df_summary_all_seasons = summarize_epl(df)
write_csv(df_summary_all_seasons, "epl_summary_all_seasons.csv")


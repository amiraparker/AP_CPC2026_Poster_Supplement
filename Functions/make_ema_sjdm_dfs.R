# for use with make_ema_sjdm_dfs.Rmd


#-----------------------------------------------------------------------------#
### Participant Cleaning Fucntions ###

# Remove testers
  # remove ids with test or my intitials in it 
remove_test_ids <- function(df) {
  df <- df %>% filter(!grepl("test", pt_id, ignore.case = TRUE))
  df <- df %>% filter(!grepl("^AP", pt_id, ignore.case = TRUE))
  return(df)
}
  # remove instances with no PUNS ids (these are also testing instances)
remove_R_ids <- function(df) {
  df <- df %>% filter(!grepl("^R$|^R_", pt_id))
  return(df)
}
  # remove fabla dev team testers
remove_fabla_dev_testers <- function(df) {
  df <- df %>% filter(!(pt_id %in% c("9000", "9001", "9002", "9003", "9005",
                                     "9006", "9008", "9009", "9010",
                                     "9998", "9999")))
  return(df)
}
# remove other amira test instances (ids used after study was launched and wanted to test ids for pts who had initialized in Fabla but had not decided to enroll in study) 
remove_amira_postlaunch_tests <- function(df) {
  df <- df %>% filter(!(pt_id %in% c("1001", "1002", "1003", "1004", "1005",
                                     "1006", "1007", "1008", "1010", "1012")))
  return(df)
}

# remove pts with "severe" task issues (like couldnt take task bc was during first week or so of study launch)
  # 1003 had android and couldnt take task at all 
  # 1013 and 1014 actually had pretty good compliance and could take task... but since they were first 3 pts who had to deal with the Fabla setup issue...
  # they had to reset their study in the Fabla app a few times which caused for some duplicate task instances... it is possible to clean their data but will take a bit longer for me to 
  # figure out exact timestamp mapping.... so am going to remove them for sake of grant prelim analysis stuff 
remove_pts_with_severe_task_issues <- function(df) {
  df <- df %>% filter(!(pt_id %in% c("1003", "1013", "1014")))
  return(df)
}

# remove pts in progress (last updated 5.19)
# remove_pts_in_progress <- function(df) {
#   df <- df %>% filter(!(pt_id %in% c(
#     "1086",
#     "1096",
#     "1093",
#     "1065"
#   )))
#   return(df)
# }

# remove pts whose pre_end_date is not before todays date
# remove_pts_with_pre_in_progress <- function(df) {
#   today <- Sys.Date()
#   
#   pts_to_drop <- df %>%
#     group_by(PUNS_ID) %>%
#     summarise(
#       ema_start_date = as.Date(first(na.omit(ema_start_date))),
#       .groups = "drop"
#     ) %>%
#     mutate(pre_end_date = ema_start_date + 9) %>%
#     filter(!is.na(pre_end_date) & pre_end_date >= today) %>%
#     pull(PUNS_ID) %>%
#     as.character()
#   
#   df <- df %>% filter(!(as.character(PUNS_ID) %in% pts_to_drop))
#   return(df)
# }

#-----------------------------------------------------------------------------#
### Individual File Cleaning Fucntions ###

# clean old files (amira accidently tested under ID of an actual pt well b4 study launch)
# for pt 1013 2-SRET-PUNS-EMA_1013_SESSION_2025-10-08_18h19.29.858.csv and 2-SRET-PUNS-EMA_1013_SESSION_2025-10-14_18h55.45.451.csv
remove_old_files <- function(df) {
  df <- df %>% filter(!(file %in% c(
    "2-SRET-PUNS-EMA_1013_SESSION_2025-10-08_18h19.29.858.csv",
    "2-SRET-PUNS-EMA_1013_SESSION_2025-10-14_18h55.45.451.csv"
  )))
  return(df)
}


# remove aborted sjdm sessions (emas where pt opened the link but quit before starting task or reloded)
  # identified by data structure label as aborted_ema_session_no_trials (each file has only 6 of the basic avlovia cols, no PUNS id col and no data)
remove_aborted_sessions <- function(df) {
  df <- df %>% filter(full_structure_label != "aborted_ema_session_no_trials")
  return(df)
}

# 1015 was enrolled and then had to be renrolled on 4-07 bc they pushed back their trip date so have to drop files befor then
remove_1015_prereenrollment <- function(df) {
  reenroll_date <- as.Date("2026-04-07")
  df %>%
    filter(!(pt_id == "1015" & file_date < reenroll_date))
}

# 1086 pushed their trip date back one day so had to push their ema start date to 5/12 (drop all files from 5/11) 
remove_1086_may11_files <- function(df) {
  drop_date <- as.Date("2026-05-11")
  df %>%
    filter(!(pt_id == "1086" & file_date == drop_date))
}

# 1027 took some EMAs before their start_date (which was 2026-03-23) since they pushed back their trip date
remove_1027_march22_files <- function(df) {
  drop_date <- as.Date("2026-03-22")
  df %>%
    filter(!(pt_id == "1027" & file_date == drop_date))
}

# 1027 reset their trip date on 3.31 and ended up taking an extra session on that day 


# Clean pts still in progress (not in individual files but works on combined df)
clean_pts_still_in_pre_trip <- function(df) {
  today <- Sys.Date()
  
  pts_to_drop <- df %>%
    group_by(PUNS_ID) %>%
    summarise(
      ema_start_date = as.Date(first(na.omit(ema_start_date))),
      .groups = "drop"
    ) %>%
    mutate(pre_end_date = ema_start_date + 9) %>%
    filter(!is.na(pre_end_date) & pre_end_date >= today) %>%
    pull(PUNS_ID)
  
  df %>% filter(!(PUNS_ID %in% pts_to_drop))
}

# remove pts with rly low compliance or who were withdrawn (removing 40% or below)
remove_low_compliance_pts <- function(df) {
  df %>% filter(!(PUNS_ID %in% c(1079, 1093, 1098,
                                 # 1045, 1092, 1106)))
                                 1092, 1106)))
                                 
}
#-----------------------------------------------------------------------------#
### Individual Trial Cleaning Fucntions ###

# filters for only pairings trials (no pavlovia init, instructions, fixation etc.
keep_only_pairing_trials <- function(df) {
  df <- df %>% filter(trial_type == "html-button-response",
                      which_experiment_phase == "pairing")
  return(df)
}

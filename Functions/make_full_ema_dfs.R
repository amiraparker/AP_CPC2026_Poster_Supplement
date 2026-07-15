# for use with make_full_ema_dfs.Rmd

#-----------------------------------------------------------------------------#
### Helpers ###

# use before and after every processing stell to see n rows and N pts and n sessions
  # id_col is one unique task session varies by df 


check_N_tibble <- function(df, label) {
  tibble(
    step   = label,
    n_rows = nrow(df),
    n_pts  = dplyr::n_distinct(df$PUNS_ID)
  )
}


#-----------------------------------------------------------------------------#
### Fabla Affect Cleaning ###
# keeps only the affect slider question
keep_affect_question <- function(df) {
  df %>% filter(QuestionTitle == "How do you feel emotionally right now?")
}
# rename id col and make sure affect is numeric
clean_affect <- function(df) {
  df %>% mutate(
    PUNS_ID = as.character(ParticipantID),
    affect  = as.numeric(Response)
  )
}
# drops rows with no affect value
drop_na_affect <- function(df) {
  df %>% filter(!is.na(affect))
}
# keeps only pts who actually did the sjdm task
# need to have run the chunk that defines sjdm_pt_ids in the run script
keep_task_pts <- function(df) {
  df %>% filter(PUNS_ID %in% sjdm_pt_ids)
}
# tons of Fabla duplicates for same diaryID.. keep first instance
remove_duplicate_diaryid <- function(df) {
  df %>%
    arrange(PUNS_ID, DiaryID, RespondedAt) %>%
    group_by(PUNS_ID, DiaryID) %>%
    slice(1) %>%
    ungroup()
}



#-----------------------------------------------------------------------------#
### Correct dates for pts who started early or missed dtaes etc.###

# combined version of what was in make_ema_sjdm_dfs.R
drop_pre_enrollment_affect <- function(df) {
  df %>%
    filter(!(PUNS_ID == "1015" & affect_responded_at_date < as.Date("2026-04-07"))) %>%
    filter(!(PUNS_ID == "1027" & affect_responded_at_date < as.Date("2026-03-23"))) %>%
    filter(!(PUNS_ID == "1086" & affect_responded_at_date < as.Date("2026-05-12")))
}

#-----------------------------------------------------------------------------#

### Match by AWS server time (UTC) if needed

# (should only be in very few cases. when the pavlovia web time and device time dnt match 
# up incase someone was on airplane mode and their time didnt sync)
# this logic is strict bc we can only use the Date col (AWS server upload time)
# if there was not a big lag btwn when pt responded and when the response was uploaded to the fabla aws server 
# ( so basically am doing this by looking at gap btwn pavlovia task submission time and 
# fabla Data col (should be less than 15 mins) )

match_utc_fallback <- function(unmatched_df, affect_df) {
  unmatched_df %>%
    select(-affect, -Date, -RespondedAt, -ResponseID,
           -window_start, -window_end, -time_diff, -match_method) %>%
    left_join(
      affect_df %>%
        mutate(window_start = Date - minutes(15),
               window_end   = Date + minutes(15)) %>%
        select(PUNS_ID, affect, Date, RespondedAt, ResponseID, window_start, window_end),
      by = join_by(PUNS_ID,
                   experiment_start >= window_start,
                   experiment_start <= window_end)
    ) %>%
    mutate(time_diff = abs(as.numeric(difftime(experiment_start, Date, units = "mins"))),
           match_method = if_else(is.na(time_diff), NA_character_, "utc_fallback")) %>%
    group_by(.row) %>%
    slice_min(time_diff, n = 1, with_ties = FALSE) %>%
    ungroup()
}


# AP_CPC2026_Poster_Supplement
This repo contains data, processing and analysis code, and supplementary materials for the poster titled: Computational Correlates of Self-Schema Accessibility in Daily Life (presented at the 2026 Computational Psychiatry Conference.)
Parker, A., Pandey, S., Kessler, N., Pozzo, N., Banerjee, T., Arconada Alvarez, S., Palitsky, R., Kaplan, D. M., & Hitchcock, P. (July, 2026). Computational correlates of self-schema accessibility in daily life.  Fourth Annual Computational Psychiatry Conference, New Haven, CT.

Acknowledgements: I would like to thank the Translational Lab, HEAT Lab, and PUNS study team for extensive time and support dedicated to this project. 

Data + (prelim) Processing/Analysis Pipeline 


**Processing Pipeline Architecture** (raw data —> hssm ready df) click the links to walk through the html files in order: 
* 1. [script1_processing_make_ema_sjdm_dfs.html](https://htmlpreview.github.io/?https://github.com/amiraparker/AP_CPC2026_Poster_Supplement/blob/main/htmls/script1_processing_make_ema_sjdm_dfs.html)
* 2. [script2_processing_make_full_ema_dfs.html](https://htmlpreview.github.io/?https://github.com/amiraparker/AP_CPC2026_Poster_Supplement/blob/main/htmls/script2_processing_make_full_ema_dfs.html)
* 3. [script3_prep_for_hssm.html](https://htmlpreview.github.io/?https://github.com/amiraparker/AP_CPC2026_Poster_Supplement/blob/main/htmls/script3_prep_for_hssm.html)

Input and Output for each part of processing pipeline: 
* script1_processing_make_ema_sjdm_dfs.Rmd
    *  Input: raw task data from Pavlovia (separate csv for each EMA)  (location: sjdm_raw-data_5.29/)
    * Output: compiled df (all study phases) of all sjdm ema sessions for N=22 pts completed pre-trip EMAs (location: pre-processed_ema-sjdm_data/pre-processed_ema-sjdm_data.csv)
* script2_processing_make_full_ema_dfs.Rmd
    * Input: EMA SJDM df (location: pre-processed_ema-sjdm_data/pre-processed_ema-sjdm_data.csv) Fabla PUNS df (location: fabla_raw-data_date/MERGED-PUNS-fabla_data_date.csv) and Fabla GRINS df (location: fabla_raw-data_5.29/MERGED-GRINS-fabla_data_05-29-2026.csv)
    * Output: cleaned df (only pre-trip trials) for N=22 pts with task and affect sessions combined for each EMA (location: pre-processed_full-ema_data/full_ema_pre-trip.csv)
* script3_script3_prep_for_hssm.Rmd
    * Input:  pre-trip df  (location: pre-processed_full-ema_data/full_ema_pre-trip.csv)
    * Output: processed pre-trip df prepped for cluster and with final QC checks needed for plotting (sequential sampling plots and regression model plots/outputs in html) 


If you want to run the .Rmds refer to folder ‘processing_scripts’ and select ‘Run All’ for each .rmd (these are the same files that are the rendered html)(starting with script1, then go to script2, then script 3) 


**Analysis Scripts** click the links to walk look through the html files with the key analyses used in the poster: 

* 1. [post-run_cpc_model.html](https://htmlpreview.github.io/?https://github.com/amiraparker/AP_CPC2026_Poster_Supplement/blob/main/htmls/post-run_cpc_model.html)
* 2. [key_plots.html](https://htmlpreview.github.io/?https://github.com/amiraparker/AP_CPC2026_Poster_Supplement/blob/main/htmls/key_plots.html)
 
Input and Output for each part of analysis pipeline: 
* post-run_cpc_model.Rmd (NOTE: If you want to run this script you will need to change directories to your 
    * Input: observed data used to run models and nc file from model 
    * Outputs: observed vs. predicted plots and posterior plots
 
* key_plots.Rmd 
    * Input: processed simulated data, processed empirical data, and data simulated from model posteriors 
    * Outputs: key plots used in posters
 
If you want to run the .Rmds refer to folder ‘analysis_scripts’ and select ‘Run All’ for each .rmd (these are the same files that are the rendered html)(starting with post-run_cpc_model.ipynb, then key_plots.Rmd). 
NOTE: you will be unable to run post-run_cpc_model.ipynb unless you run the HSSM model (you will need a cluster or similar HPC setup). Refer to this folder to run the model 'stuff_for_07.09_model_fitting'

**If you want to replicate this analysis**
1. git clone this repo to your desktop (or location of your choice)
2. conda env create -f environment.yml
3. run the .Rmds in above order 

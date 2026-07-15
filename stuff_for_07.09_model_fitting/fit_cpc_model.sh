#!/bin/bash
#SBATCH --account=default
#SBATCH --time=24:00:00
#SBATCH --output /home/apar355/PUNS-Models_Cluster/slurm_logs/log_%x-%A-%a.out
#SBATCH --error /home/apar355/PUNS-Models_Cluster/slurm_logs/log_%x-%A-%a.err
#SBATCH --export=ALL
#SBATCH --partition=day-long
#SBATCH --mail-user=apar355@emory.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4

export TMPDIR=/home/apar355
cd /home/apar355/PUNS-Models_Cluster/stuff_for_07.09_model_fitting

# Initialize Conda
eval "$(/usr/local/anaconda3/bin/conda shell.bash hook)"

conda activate hssm_env
export PATH=/usr/bin:$PATH

# Create directories if needed
mkdir -p ./model_outputs_07.09_cpc
#mkdir -p ./models
#mkdir -p ./slurm_logs

# Run the notebook
papermill fit_cpc_model.ipynb output_fit_cpc_model.ipynb -k hssm_env


echo "Job completed at $(date)"
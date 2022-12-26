#!/bin/bash

### Example usage ######################################
### $ ./aflow_categorize.sh dir_w_cifs/ 

### CONSTANTS ##########################################
match=1.0 # misfit threshold
nprocs=15 # number of parallel processes to use 
########################################################

echo "Match misfit level = $match"
options="-D $1 --np=$nprocs --primitive --ignore_decorations --misfit_match=$match --misfit_family=$match --ignore_local_geometry --add_aflow_prototype_designation --print_mapping"

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. This script requires one argument: the path to a directory containing CIFs."
        exit
fi

datetime=`date +"%Y-%m-%d-%T"`

outdir=comparison-output_"$match"_"$datetime"
logfile=log_compare.log

start=$(date +%s)

echo -e "OPTIONS:" > $logfile
echo $options >> $logfile
echo -e "\nOUTPUT:" >> $logfile
aflow --compare_structures $options >> $logfile
end=$(date +%s)
elapsed=$(( end - start ))
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')" >> $logfile

mkdir $outdir
cp "$1"/structure_* $outdir
cp $logfile $outdir

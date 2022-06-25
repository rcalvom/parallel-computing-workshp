#!/bin/bash

# Text colors 
green="\e[32m"
blue="\e[34m"
end_color="\e[0m"

# Image sizes
sizes=("4k" "1080p" "720p")

# processes counts
processes=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)

# filter intensity
filter_intensity=1.0

# Script start
echo -e "Execute test script"
echo -e

# Compile border detection program
echo -e "${blue}Compiling program...${end_color}"
make build
echo -e "${green}Done${end_color}"
echo -e

# Create the output images folder if it does not exit
echo -e "${blue}Creating output_images folder...${end_color}"
mkdir -p output_images 
echo -e "${green}Done${end_color}"
echo -e

# Create folder with the outputs of executions
echo -e "${blue}Creating output execution folder...${end_color}"
mkdir -p report/out
echo -e "${green}Done${end_color}"
echo -e

# Create folder for plot generation
echo -e "${blue}Creating plots folder...${end_color}"
mkdir -p report/plots
echo -e "${green}Done${end_color}"
echo -e

# Execute all test cases and save their results in the output folder
for size in "${sizes[@]}"
do
    for process in "${processes[@]}"
    do
        echo -e "${blue}Size: $size, Processes: $process ${end_color}"
        echo -e "${blue}Executing test...${end_color}"
        OUTPUT=$(mpirun -np $process --hostfile mpi-hosts ./border_detection input_images/$size.jpg output_images/$size.jpg $filter_intensity $process)
        echo -e ${OUTPUT}
        echo -e ${OUTPUT} >> report/out/"border_detection_${size}_${process}.out"
        echo -e "${green}Done${end_color}"
        echo -e
    done
done

# Execute Python script that generate plots
echo -e "${blue}Creating plots...${end_color}"
python3 report/report.py
echo -e "${green}Done${end_color}"
echo -e

# Compile LaTeX project
echo -e "${blue}Compiling pdf report...${end_color}"
: $(cd report/template && pdflatex --jobname=report main.tex)
echo -e "${green}Done${end_color}"
echo -e
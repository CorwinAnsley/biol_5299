#!/bin/bash -l

############# SLURM SETTINGS #############

#SBATCH --account=project0026 # the project account - don't change this
#SBATCH --job-name=process_data # give your job a name!
#SBATCH --partition=nodes # we are using CPU nodes - don't change this
#SBATCH --time=0-04:00:00 # how long do we expect this job to run?
#SBATCH --mem=4G # how much memory do we want?
#SBATCH --nodes=1 # how many nodes do we want?
#SBATCH --ntasks=1 # how many tasks are we submitting?
#SBATCH --cpus-per-task=1 # how many CPUs do we want for each task?
#SBATCH --ntasks-per-node=1 # how many tasks do we want to run on each node?
#SBATCH --mail-user=2266643a@student.gla.ac.uk # email address for notifications
#SBATCH --mail-type=END # mail me when my jobs ends
#SBATCH --mail-type=FAIL # mail me if my jobs fails
#SBATCH --reservation=bioinf_course #NOTE: this will only work between 14th and 19th April - remove this line after 19th April!


############# CODE #############
raw_data=/mnt/data/project0026/student_data/2266643a/pathogenPolyomicsData
data=/mnt/data/project0026/student_data/2266643a/biol_5299/data


wt_sorted_bam="${data}/LmexWT.sort.bam"	 # path to write/read  samtools-sorted BAM file
ampb_sorted_bam="${data}/LmexAmpB.sort.bam"	 # path to write/read  samtools-sorted BAM file
vcf=${data}/Lmex_variants_2.vcf
reference=${raw_data}/Reference/TriTrypDB-25_LmexicanaMHOMGT2001U1103.fa

bamaddrg -b $wt_sorted_bam -s WT -b $ampb_sorted_bam -s AmpB | freebayes --fasta-reference $reference --vcf $vcf --ploidy 4 --stdin




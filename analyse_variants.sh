#!/bin/bash -l

############# SLURM SETTINGS #############

#SBATCH --account=project0026 # the project account - don't change this
#SBATCH --job-name=analyse_variants # give your job a name!
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


vcf=${data}/Lmex_variants_2.vcf
filtered_vcf=${data}/filtered_Lmex_variants.vcf
reference=${raw_data}/Reference/TriTrypDB-25_LmexicanaMHOMGT2001U1103.fa
annotated_vcf=${data}/AmpB_annotated_Lmex_variants.vcf

vcffilter -f "QUAL > 20 " -f "TYPE = snp" $vcf > $filtered_vcf

for sample in AmpB WT
    do
    sample_vcf="${data}/${sample}Lmex_variants.vcf.gz"
    bcftools view -l 2 -c 1 -s $sample -o $sample_vcf $filtered_vcf

    bcftools index $sample_vcf

    done

bcftools isec ${data}/AmpBLmex_variants.vcf.gz ${data}/WTLmex_variants.vcf.gz -p ${data}/Comps_

snpEff build -c SnpEff.config -gff3 -noCheckCds -noCheckProtein -v Lmex

snpEff -c SnpEff.config -Xmx4g -no-intron Lmex ${data}/Comps_/0000.vcf > $annotated_vcf  


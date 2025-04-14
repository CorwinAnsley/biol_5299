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
outputs=./outputs
fastqc_output=$outputs/fastqc
reference=./data/reference/reference

# Index the reference genome
bowtie2-build ${raw_data}/Reference/TriTrypDB-25_LmexicanaMHOMGT2001U1103.fa $reference

for sample in LmexWT LmexAmpB 

do
    for pair in 1 2
    do
        # Define filepaths
        fastq="${raw_data}/DNAseq/${sample}_${pair}.fastq.gz"

        # Generate fastqc report
        fastqc -o $fastqc_output --svg  -f fastq $fastq
    done

    trimmed_reads_pair1=${data}/${sample}_val_1.fq.gz
    trimmed_reads_pair2=${data}/${sample}_val_2.fq.gz

    sam="${data}/${sample}.sam"  # path to write/read bowtie2 SAM file
    bam="${data}/${sample}.bam"  # path to write/read  samtools-converted BAM file 
    sorted_bam="${data}/${sample}.sort.bam"	 # path to write/read  samtools-sorted BAM file
    bai="${data}/${sample}.bai"

    # Carry out trimming
    trim_galore --phred64 --illumina --paired -q 20 -o ${data}/ --basename $sample fastq="${raw_data}/DNAseq/${sample}_1.fastq.gz" fastq="${raw_data}/DNAseq/${sample}_2.fastq.gz"

    # Carry out alignment to reference with bowtie2
    bowtie2 --phred64  -x $reference -1 $trimmed_reads_pair1 -2 $trimmed_reads_pair2 -S $sam

    # Convert sam to bam with samtools
    samtools view -b -o ${bam} ${sam}

    # With samtools, sort bam
    samtools sort -o ${sorted_bam} ${bam}

    # Index alignment file with samtools
    samtools index --bai -o $bai $sorted_bam

done 



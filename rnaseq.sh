# letting shell know where the program for rnaseq analysis are.
cp -R /home/manager/linux Desktop/.
cd Desktop/linux/advanced/rnaseq/
fastqc fastq/*.fastq

# Step_1: Run FASTQC for our input files: We will running fastqc on all the fastq files,
fastqc fastq/*.fastq

# To view any file in the browser use the following command
# firefox fastq/myoblast_del_fastqc.html
# firefox fastq/myoblast_wt_fastqc.html

#Step_2: build index
cd index  # go from rnaseq directory to index directory
bowtie-build mm9_chr1.fa mm9_chr1

# Step_3: Align fastq: Run tophat2 with the following command
cd .. # go back to /rnaseq directory
tophat2  -G mm9_chr1.gtf -o  tophat_wt/  index/mm9_chr1 fastq/myoblast_wt.fastq
tophat2  -G mm9_chr1.gtf -o  tophat_del/  index/mm9_chr1 fastq/myoblast_del.fastq

# Step_4: Check if the tophat_wt and tophat_del are found: You should find accepted_hits.bam file which is the alignment file
ls
ls tophat_del
ls tophat_wt
cat tophat_del/align_summary.txt
cat tophat_del/align_summary.txt

# Step_5: Bam Indexing
samtools index tophat_wt/accepted_hits.bam
samtools index tophat_del/accepted_hits.bam

# Step_6: Differential Expression: Run CuffDiff with the following command, to calculate the differential expression between the wt and the del samples
cuffdiff --no-update-check -o cuffdiff_out -L wt,del mm9_chr1.gtf tophat_wt/accepted_hits.bam tophat_del/accepted_hits.bam

ls -lh cuffdiff_out

# Step_7: state RNASEQ processing is complete
echo "RNASEQ is Complete."

# Step_7: Open the gene_exp.diff file in a spreadsheet. This file contains the list of genes with differential expression and associated metrics.




# GuideRNA design using CHOPCHOP for Bacteria

Welcome! This guide helps you use CHOPCHOP's command line tools for designing guideRNAs for bacteria. It's perfect for big projects where you have lots of genes (like around 2500) and need to design guideRNAs for all of them.

I noticed that the instructions over at Bitbucket were a bit tricky to follow, especially for installing the software and figuring out how to use it for bacteria, not just human genes. Consequently, this lack of detailed guidance for microbial datasets prompted the creation of this repository, aiming to document the entire process comprehensively.


## Installation

- First install the software, I created a environment yml file, The installation process is based on instructions available at the [CHOPCHOP Bitbucket repository](https://bitbucket.org/valenlab/chopchop/src/master/). 
	
	`conda env create -f environment.yml`

## Preparing the Required Files

### Download bowtie formated and .2bit genome for bacteria

Please go to this [website](https://chopchop.cbu.uib.no/genomes/) to download the bowtie formatted bacteria, as indicated by instuctions. 

### Edit the config.jason File

The config.json file's directories have been edited to point to the correct folders and was renamed to config_local.json as instructed by the chopchop readme. They were changed as follows:
```
{
  "PATH": {
    "PRIMER3": "./primer3_core",  # unchanged
    "BOWTIE": "bowtie/bowtie",    # unchanged
    "TWOBITTOFA": "./twoBitToFa", # unchanged
       
    "TWOBIT_INDEX_DIR": "/data1/database/chopchop/EF",	# CHANGE
    "BOWTIE_INDEX_DIR": "/data1/database/chopchop/EF",	# CHANGE
    "ISOFORMS_INDEX_DIR": "/data1/database/chopchop/isoforms", # CHANGE, for bacteria no isoforms, just create and keep this folder, inside could be empty
    "ISOFORMS_MT_DIR": "/data1/database/chopchop/isoforms/ vienna_mt", # CHANGE, for bacteria no isoforms, just create and keep this folder, inside could be empty
    "GENE_TABLE_INDEX_DIR": "/data1/database/chopchop/EF"
  }, # CHANGE
  "THREADS": 1
}
```

### Generating the Gene Feature Table
- Unlike other organisms, acquiring the Gene Feature Table for microbial genomes requires direct download of the GTF format from the NCBI website, as the links provided on the official website are not applicable for bacteria. For example, using the NCBI accession ID NC_017316:

GTF download link: https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000172575.2/
Accession ID link: https://www.ncbi.nlm.nih.gov/nuccore/NC_017316

So below is the codes for converting gtf format (Genebank version) to genePred Table

```
gtfToGenePred -genePredExt -ignoreGroupsWithoutExons genomic.gtf gene.genePred 
awk 'BEGIN { FS = OFS = "\t" } { gsub(/\.[^.]*$/, "", $1) }1' gene.genePred > gene.v1.genePred
echo -e "name\tchrom\tstrand\ttxStart\ttxEnd\tcdsStart\tcdsEnd\texonCount\texonStarts\texonEnds\tscore\tname2\tcdsStartStat\tcdsEndStat\texonFrames" | cat - gene1.genePred > gene.v1.genePred

```
Finally move your `gene Pred table` into the same folder as bowtie indexed and 2bit formatted folder. 


## Running the Chopchop for a list of Genes in Bacteria Efaecalis_OG1RF
The scripts to run for a list of genes for bacteria Efaecalis_OG1RF is hosted in this repo. You need to change your input and output folder path. You also need to provide a list of gene txt file. 

In order to get the same results with the online version, please add one flag, `--scoringMethod DOENCH_2016` as this will give you the same efficiency comparable to the online version. If this flag is not included, most likely you will get either 1 or 0 value in your `efficiency` column.

```
./chopchop.py --scoringMethod DOENCH_2016 -G Efaecalis_OG1RF -T 1 -o temp/ -Target "${variable}" > EF_chopchop_output/"${variable}.txt
```

If you want to get the output for around ~2500 genes, please use this bash script archived in the `scripts` folder.
```
bash get_chopchop.sh 
```


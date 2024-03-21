# guideRNA design for bacteria using chopchop


This repository documents the process of utilizing the command-line version of CHOPCHOP for microbial guideRNA design, aimed at facilitating batch processing (e.g., if you have ~3000 genes and wants to get the guideRNA design) and dataset generation.  I found the instructions on bitbucket is harder to follow, in both installation and usage side. The usage manual is more meant for the human genome, but did not find too much information on microbial datasets. so I decided to record all the process.

## Installation

- First install the software, I created a environment yml file, The installation process is based on instructions available at the [CHOPCHOP Bitbucket repository](https://bitbucket.org/valenlab/chopchop/src/master/). 
	
	`conda env create -f environment.yml`

## Preparing the Required Files

### Download bowtie formated and .2bit genome for bacteria

Please go to this [website](https://chopchop.cbu.uib.no/genomes/) to download the bowtie formatted bacteria, as indicated by instuctions. 

#### Edit the config.jason File

The config.json file's directories have been edited to point to the correct folders and was renamed to config_local.json as instructed by the chopchop readme. They were changed as follows:
```
{
  "PATH": {
    "PRIMER3": "./primer3_core",  # unchanged
    "BOWTIE": "bowtie/bowtie",    # unchanged
    "TWOBITTOFA": "./twoBitToFa", # unchanged
       
    "TWOBIT_INDEX_DIR": "/data1/database/chopchop/hg38",	# CHANGE
    "BOWTIE_INDEX_DIR": "/data1/database/chopchop/hg38",	# CHANGE
    "ISOFORMS_INDEX_DIR": "/data1/database/chopchop/isoforms", # CHANGE, for bacteria no isoforms, just keep this folder
    "ISOFORMS_MT_DIR": "/data1/database/chopchop/isoforms/ vienna_mt", # CHANGE, for bacteria no isoforms, just keep this folder
    "GENE_TABLE_INDEX_DIR": "/data1/database/chopchop/hg38"
  }, # CHANGE
  "THREADS": 1
}
```

#### Generating the Gene Feature Table
- Unlike other organisms, acquiring the Gene Feature Table for microbial genomes requires direct download of the GTF format from the NCBI website, as the links provided on the official website are not applicable for bacteria. For example, using the NCBI accession ID NC_017316:

GTF download link: https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000172575.2/
Accession ID link: https://www.ncbi.nlm.nih.gov/nuccore/NC_017316

So below is the codes for converting gtf to genePred Table

```
gtfToGenePred -genePredExt -ignoreGroupsWithoutExons genomic.gtf gene.genePred 
awk 'BEGIN { FS = OFS = "\t" } { gsub(/\.[^.]*$/, "", $1) }1' gene.genePred > gene.v1.genePred
echo -e "name\tchrom\tstrand\ttxStart\ttxEnd\tcdsStart\tcdsEnd\texonCount\texonStarts\texonEnds\tscore\tname2\tcdsStartStat\tcdsEndStat\texonFrames" | cat - gene1.genePred > gene.v1.genePred

```

## Running the Chopchop for a list of Genes in Bacteria A
The scripts to run for a list of genes for bacteria A is hosted in this repo. You need to change your input and output folder path. You also need to provide a list of gene txt file. 

```
bash get_chopchop.sh
```


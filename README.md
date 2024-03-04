# nf-macs


Create the test directory:
```
mkdir -p ~/nf_atacseq_test/
```

Download the demo data:
```
cd ~/nf_atacseq_test/raw_data
curl -J -O https://datashare.mpcdf.mpg.de/s/nzO5RFUXK3kyhuw/download
unzip bowtie2_output.zip 

```

Download the paramaters file:
```
cd ~/nf_atacseq_test
curl -J -O https://raw.githubusercontent.com/mpg-age-bioinformatics/nf-macs/main/params.slurm.json
```

Change the parameters in params.json accordingly, e.g. change "project_folder" : "/raven/u/wangy/nf_atacseq_test/" to "project_folder" : Users/YOURNAME/nf-flexbar-test/"


Run the workflow:

```
PROFILE=studio
nextflow run nf-macs -params-file ~/nf_atacseq_test/params.slurm.json -entry images -profile ${PROFILE}  && \
nextflow run nf-diffbind -params-file ~/nf_atacseq_test/params.slurm.json -entry samplesheet -profile ${PROFILE}  && \
nextflow run nf-macs -params-file ~/nf_atacseq_test/params.slurm.json -profile ${PROFILE}
```

## Contributing

Make a commit, check the last tag, add a new one, push it and make a release:
```
git add -A . && git commit -m "<message>" && git push
git describe --abbrev=0 --tags
git tag -e -a <tag> HEAD
git push origin --tags
gh release create <tag> 
```

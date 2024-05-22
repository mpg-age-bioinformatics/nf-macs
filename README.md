# nf-macs


Create the test directory:
```
mkdir -p /tmp/nextflow_atac_local_test/macs_test
```

Download the demo data:
```
mkdir -p /tmp/nextflow_atac_local_test/macs_test/raw_data
cd /tmp/nextflow_atac_local_test/macs_test/raw_data
curl -J -O https://datashare.mpcdf.mpg.de/s/nzO5RFUXK3kyhuw/download
unzip bowtie2_output.zip 

```

Download the paramaters file:
```
cd /tmp/nextflow_atac_local_test/macs_test/
PARAMS=params.local.json
curl -J -O https://raw.githubusercontent.com/mpg-age-bioinformatics/nf-macs/main${PARAMS}
```

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

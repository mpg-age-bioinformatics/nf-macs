# nf-macs


Create the test directory:
```
mkdir -p /tmp/nextflow_atac_local_test/macs_test
```

Download the demo data:
```
cd /tmp/nextflow_atac_local_test/macs_test/
curl -J -O https://datashare.mpcdf.mpg.de/s/nzO5RFUXK3kyhuw/download
unzip bowtie2_output.zip 

```

Download the paramaters file:
```
cd /tmp/nextflow_atac_local_test/macs_test/
PARAMS=params.local.json
curl -J -O https://raw.githubusercontent.com/mpg-age-bioinformatics/nf-macs/main/${PARAMS}
```

Prepare the required sample sheet, either create a csv file in this format:
```
curl -J -O https://raw.githubusercontent.com/mpg-age-bioinformatics/nf-macs/main/diffbind_sample_sheet.csv
```

or following this [repo](https://github.com/mpg-age-bioinformatics/nf-diffbind) and do command `nextflow run nf-diffbind -params-file ${PARAMS} -entry samplesheet --user "$(id -u):$(id -g)"`

Get the latest repo:
```
cd /tmp/nextflow_atac_local_test/
git clone https://github.com/mpg-age-bioinformatics/nf-macs.git
```

Run the workflow:

```
nextflow run nf-macs -params-file macs_test/${PARAMS} -entry images --user "$(id -u):$(id -g)" && \
nextflow run nf-macs -params-file macs_test/${PARAMS} --user "$(id -u):$(id -g)"
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

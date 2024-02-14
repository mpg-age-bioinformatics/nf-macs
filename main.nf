#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process get_images {
  stageInMode 'symlink'
  stageOutMode 'move'

  script:
    """

    if [[ "${params.run_type}" == "r2d2" ]] || [[ "${params.run_type}" == "raven" ]] || [[ "${params.run_type}" == "studio" ]]; 
      then
        cd ${params.image_folder}
        if [[ ! -f macs-2.2.9.1.sif ]] ;
          then
            singularity pull macs-2.2.9.1.sif docker://index.docker.io/mpgagebioinformatics/macs:2.2.9.1
        fi
    fi


    if [[ "${params.run_type}" == "local" ]] ; 
      then
        docker pull mpgagebioinformatics/macs:2.2.9.1
    fi

    """

}

process macs2 {
  stageInMode 'symlink'
  stageOutMode 'move'

  when:

  input:
    val sample
    val treatment_file
    val control_file
    val peak_type

    script:
    """
mkdir -p /workdir/macs2_output
mkdir -p /workdir/tmp

cd /workdir/bowtie2_output
if [[ ${params.seq} == "paired" ]] && [[ ${params.input} == 'no' ]] ; then
  echo "macs2 callpeak -t ${treatment_file} -f BAMPE -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}"
  macs2 callpeak -t ${treatment_file} -f BAMPE -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}
elif [[ ${params.seq} == "single" ]] && [[ ${params.input} == 'no' ]] ; then
  echo "macs2 callpeak -t ${treatment_file} -f BAM -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}"
  macs2 callpeak -t ${treatment_file} -f BAM -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}
elif [[ ${params.seq} == "paired" ]] && [[ ${params.input} == 'yes' ]] ; then
  echo "macs2 callpeak -t ${treatment_file} -c ${control_file} -f BAMPE -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}"
  macs2 callpeak -t ${treatment_file} -c ${control_file} -f BAMPE -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}
elif [[ ${params.seq} == "single" ]] && [[ ${params.input} == 'yes' ]] ; then
  echo "macs2 callpeak -t ${treatment_file} -c ${control_file} -f BAM -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}"
  macs2 callpeak -t ${treatment_file} -c ${control_file} -f BAM -q 0.05 --keep-dup all --gsize ${params.GeTAG} --outdir /workdir/macs2_output -n ${sample} -B --tempdir=/workdir/tmp ${peak_type}
fi

    """

}

workflow images {
  main:
    get_images()
}

workflow{
    if ( params.peak_type == "none" ) {
        peak_type=""
    } else {
      peak_type=params.peak_type
    }

    if ( params.input == "yes" ) {
      file_ending=".chip.md.bam"
    } else {
      file_ending=".md.bam"
    }

  rows=Channel.fromPath("${params.samples_csv}", checkIfExists:true).splitCsv(sep:',', skip: 1)
  rows=rows.filter{ ! file( "${params.project_folder}/macs2_output/${it[0]}_peaks.xls" ).exists() }
  sample=rows.flatMap { n -> n[0] }
  treatment_file=rows.flatMap { n -> n[3] }
  control_file=rows.flatMap { n -> n[5] }
  macs2(sample,treatment_file,control_file,peak_type)
}

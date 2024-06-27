#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

params.GLDS_accession = "GLDS-487"
params.target_region = "16S"

process GET_RUNSHEET {

    beforeScript "chmod +x ${baseDir}/bin/create_runsheet.py"

    output:
        path("*_runsheet.csv"), emit: runsheet
        path("*.zip"), emit: zip
        path("GLparams_file.csv"), emit: params_file
        path("GLfile.csv"), emit: input_file
        path("versions.txt"), emit: version

    script:
        """
        create_runsheet.py --OSD ${params.GLDS_accession} --target ${params.target_region}
        GL-version | grep "GeneLab utils"| sed -E 's/^\\s+//' > versions.txt
        echo "dptools v1.3.4" >> versions.txt
        python --version >> versions.txt 
        """
}


workflow {

    GET_RUNSHEET()
    file_ch = GET_RUNSHEET.out.input_file
                     .splitCsv(header:true)

     params_ch = GET_RUNSHEET.out.params_file
                     .splitCsv(header:true)

}
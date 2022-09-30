from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
S3 = S3RemoteProvider(
    access_key_id=config["key"], 
    secret_access_key=config["secret"],
    host=config["host"],
    stay_on_remote=False
)
prefix = config["prefix"]
filename = config["filename"]

rule get_SummarizedExp:
    input:
        S3.remote(prefix + 'download/dataset.zip')
    output:
        S3.remote(prefix + filename)
    resources:
        mem_mb=6000,
        disk_mb=6000
    shell:
        """
        Rscript scripts/get_multiplexed.R \
        {prefix} \
        {filename}
        """

rule download_data:
    output:
        S3.remote(prefix + 'download/dataset.zip')
    shell:
        """
        Rscript scripts/download_multiplexed.R \
        {prefix} 
        """
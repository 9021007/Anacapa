# Using the Anacapa Pipeline

There are some important files that you should take a look at before starting anything else:

File | Description
--- | ---
`Anacapa_db/scripts/anacapa_vars.sh` | File containing default variables used in the Anacapa pipeline. You can modify this file to change default settings.
`Anacapa_db/metabarcode_loci_min_merge_length.txt` | Configuation file for dada2, to configure overlap lengths.
`Anacapa_db/forward_primers.txt` | Default forward primers used for trimming and sorting.
`Anacapa_db/reverse_primers.txt` | Default reverse primers used for trimming and sorting.

You can edit these files using the terminal with the `nano` command. For example:

```bash
nano Anacapa_db/scripts/anacapa_vars.sh
```
Once you've made your changes, exit with `^X` (Control + X), then press `Y` to save, and `Enter` to confirm the filename.

## First Half - QC and DADA2

The first half of the Anacapa pipeline can be run with `Anacapa_db/anacapa_QC_dada2.sh`.

Example:

```bash
Anacapa_db/anacapa_QC_dada2.sh -i Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data -o out -d Anacapa_db -f Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/forward.txt -r Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/reverse.txt -e Anacapa_db/metabarcode_loci_min_merge_length.txt -a nextera -t MiSeq -l
```

Breakdown of the example command:

Command Argument | Description
--- | ---
`-i [filepath]` | Path to folder with .fastq.gz files
`-o out` | Path to output directory. If it doesn't exist, it will be created.
`-d Anacapa_db` | Path to Anacapa_db. This doesn't really change.
`-f [filepath]` | Path to file with forward primers
`-r [filepath]` | Path to file with reverse primers
`-e [filepath]` | File path to a list of minimum length(s) required for paired F and R reads to overlap
`-a nextera` | Illumina adapter type
`-t MiSeq` | Illumina platform
`-l` | Indicates running locally. This is always needed, because the original Anacapa was designed for use on the UCLA HPC.

Other arguments not used in the example:

Command Argument | Description
--- | ---
`-g` | If .fastq read are not compressed
`-c` | To modify the allowed cutadapt error for 3' adapter and 5' primer adapter trimming: 0.0 to 1.0 (default 0.3)
`-p` | To modify the allowed cutadapt error 3' primer sorting and trimming: 0.0 to 1.0 (default 0.3)
`-q` | To modify the minimum quality score allowed: 0 - 40 (default 35)
`-m` | To modify the minimum length after quality trimming: 0 - 300 (default 100)
`-x` | To modify the additional 5' trimming of forward reads: 0 - 300 (default HiSeq 10, default MiSeq 20)
`-y` | To modify the additional 5' trimming of reverse reads: 0 - 300 (default HiSeq 25, default MiSeq 50)
`-b` | To modify the number of occurrences required to keep an ASV: 0 - any integer (default 0)

## Second Half - Classification

The second half of the Anacapa pipeline can be run with `Anacapa_db/anacapa_classifier.sh`.

Example:

```bash
Anacapa_db/anacapa_classifier.sh -d Anacapa_db -o out -l
```

Breakdown of the example command:

Command Argument | Description
--- | ---
`-d Anacapa_db` | Path to Anacapa_db. This doesn't really change.
`-o out` | Path to output directory generated in the Sequence QC and ASV Parsing script. Yes, the output is the input. I don't know either. It does modify the input in-place, though, so it does become the output, in a way.
`-l` | Indicates running locally. This is always needed, because the original Anacapa was designed for use on the UCLA HPC.

Other arguments not used in the example:

Command Argument   | Description
--- | ---
`-b`|      Percent of missmatch allowed between the qury and subject for BLCA: 0.0 to 1.0 (default 0.8)
`-p`|      Minimum percent of length of the subject reltive to the query for BLCA: 0.0 to 1.0 (default 0.8)
`-c`|     A list of BCC cut-off values to report taxonomy: "0 to 100", quotes required (default "40 50 60 70 80 90 95"). The file must contain the following format: PERCENT="40 50 60 70 80 90 95 100", Where the value may differ but the PERCENT="values" is required. see `Anacapa_db/scripts/BCC_default_cut_off.sh` as an example.
`-n`|      BLCA number of times to bootstrap: integer value (default 100)
`-m`|      Muscle alignment match score: default 1
`-f`|      Muscle alignment mismatch score: default -2.5
`-g`|      Muscle alignment gap penalty: default -2

## Complete

Once both halves have been run, your output files will be in the output directory you specified in both commands. Copy or move it to the `/data` directory to access it from your host machine, if that's not where it already is.
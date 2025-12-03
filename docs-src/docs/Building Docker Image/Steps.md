# Steps


**You do not need to build the docker image yourself to run Anacapa, as pre-built images are already available.** This tutorial assumes that you have all prerequisites installed.

### Download Large Files

Some files are too large to be stored on GitHub, and because this is a public fork of the original Anacapa, GitHub does not support Git LFS. You'll need to get these files yourself.

- Download the file at `https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`, rename it to `miniconda.sh`, and place it in the `Packages` folder.
- There is a file called `16S_.fasta`, which can be found here `https://datadryad.org/downloads/file_stream/94240`. It belongs at `Anacapa_db/16S/16S_fasta_and_taxonomy/16S_.fasta`

### Create Rlibs

The first time you run each half of the Anacapa pipeline, it will pause for an extended period of time as it compiles the R libraries. You can compile these once, and re-use them between runs. To do this, make a folder called "`Rlibs`", and inside that, create 2 subfolders, "`RLibsUser`" and "`RenvUser`".

### Build Docker Image

To build the Docker image, run the following command in the root of the repository:

```bash
docker image build . --platform=linux/amd64 -t anacapa
```

This will build the Docker image and tag it with the name "`anacapa`". The build process may take some time, depending on your internet speed and computer performance.

### First Run

To make compile the R libraries, run the container with the following command:

```bash
docker run -ti --volume ./Rlibs:/Rlibs --platform linux/amd64 anacapa bash
```

Once inside the container, run the following commands to use the included example data:

First Half:
```bash
Anacapa_db/anacapa_QC_dada2.sh -i Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data -o out -d Anacapa_db -f Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/forward.txt -r Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/reverse.txt -e Anacapa_db/metabarcode_loci_min_merge_length.txt -a nextera -t MiSeq -l
```
Second Half:
```bash
Anacapa_db/anacapa_classifier.sh -d Anacapa_db -o out -l
```

You will then see that the `Rlibs/RLibsUser` folder has been populated with the compiled R libraries. The next time that you build the docker image, those should get copied into the image. You will then no longer need to mount the `Rlibs` folder when running the container.
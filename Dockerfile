FROM --platform=linux/amd64 ubuntu:24.04

# Miniconda Install
RUN mkdir ~/miniconda3
RUN apt-get update && apt-get install -y wget bzip2
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm ~/miniconda3/miniconda.sh
RUN . ~/miniconda3/bin/activate
RUN ~/miniconda3/bin/conda init --all

# Bioconda
RUN ~/miniconda3/bin/conda config --add channels bioconda
RUN ~/miniconda3/bin/conda config --add channels conda-forge
RUN ~/miniconda3/bin/conda config --set channel_priority strict
RUN ~/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN ~/miniconda3/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
RUN ~/miniconda3/bin/conda create -n cutadapt cutadapt
# RUN CONDA_SUBDIR=osx-64 conda create -n cutadapt cutadapt


# fastxtoolkit Install
RUN mkdir ~/fastxtoolkit
RUN wget "http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2" -O ~/fastxtoolkit/fastxtoolkit.tar.bz2
RUN tar -xvjf ~/fastxtoolkit/fastxtoolkit.tar.bz2 -C ~/fastxtoolkit
RUN rm ~/fastxtoolkit/fastxtoolkit.tar.bz2
ENV PATH="/root/fastxtoolkit/bin:${PATH}"
# RUN fastx_clipper -h
RUN ~/miniconda3/bin/conda install -c conda-forge biopython


# R installation

# adding to /etc/apt/sources.list
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" >> /etc/apt/sources.list
RUN apt-get install -y gnupg && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9 && apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev

# Cran Packages
#     ggplot2
#     plyr
#     dplyr
#     seqRFLP
#     reshape2
#     tibble
#     devtools
#     Matrix
#     mgcv
#     readr
#     stringr 
#     vegan
#     plotly
#     optparse
#     ggrepel
#     cluster
RUN R -e "install.packages(c('ggplot2', 'plyr', 'dplyr', 'seqRFLP', 'reshape2', 'tibble', 'devtools', 'Matrix', 'mgcv', 'readr', 'stringr', 'vegan', 'plotly', 'optparse', 'ggrepel', 'cluster'), repos='https://cloud.r-project.org/')"
# BIOCLITE Packages http://bioconductor.org/biocLite.R
#     phyloseq
#     genefilter
#     impute
#     Biostrings
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos='https://cloud.r-project.org/'); BiocManager::install(c('phyloseq', 'genefilter', 'impute', 'Biostrings'))"
# dada2 (Version 1.6) https://github.com/benjjneb/dada2
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos='https://cloud.r-project.org/'); BiocManager::install('dada2', version = '3.21')"

#insall bowtie2
RUN ~/miniconda3/bin/conda install -c bioconda bowtie2

RUN mkdir /app
COPY . /app
WORKDIR /app

# muscle3.8.31 into /app/Anacapa_db
RUN wget "https://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_i86linux64.tar.gz" -O /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz
RUN tar -xvzf /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz -C /app/Anacapa_db
RUN rm /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz
# make muscle executable
RUN chmod +x /app/Anacapa_db/muscle3.8.31_i86linux64

# SHELL ["/bin/bash", "-c", "source ~/miniconda3/bin/activate cutadapt && conda activate cutadapt"]

# i need openssl and curl for one of the packages
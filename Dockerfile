FROM --platform=linux/amd64 ubuntu:24.04

# Miniconda Install
RUN mkdir ~/miniconda3
RUN apt-get update && apt-get install -y wget bzip2 gnupg environment-modules nano libfreetype-dev libfontconfig1-dev libcurl4-openssl-dev libssl-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libwebp-dev libxml2 libopenblas-dev
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
COPY Packages/miniconda.sh /root/miniconda3/miniconda.sh
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
RUN ~/miniconda3/bin/conda create -n cutadapt cutadapt==1.18

# fastxtoolkit Install
RUN mkdir ~/fastxtoolkit
# RUN wget "http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2" -O ~/fastxtoolkit/fastxtoolkit.tar.bz2
COPY Packages/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2 /root/fastxtoolkit/fastxtoolkit.tar.bz2
RUN tar -xvjf ~/fastxtoolkit/fastxtoolkit.tar.bz2 -C ~/fastxtoolkit
RUN rm ~/fastxtoolkit/fastxtoolkit.tar.bz2
ENV PATH="/root/fastxtoolkit/bin:${PATH}"
# RUN fastx_clipper -h
RUN ~/miniconda3/bin/conda install -c conda-forge biopython

# R Install
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9 && apt-get update && apt-get install -y --no-install-recommends r-base r-base-dev

COPY Rlibs /Rlibs
ENV R_LIBS_USER="/Rlibs/RLibsUser"
ENV R_ENVIRON_USER="/Rlibs/RenvUser"

#insall bowtie2
RUN ~/miniconda3/bin/conda install -c bioconda bowtie2
RUN /root/miniconda3/bin/python -m pip install pandas

RUN mkdir /app
COPY Anacapa_db /app/Anacapa_db
COPY Example_data /app/Example_data
COPY Benchmarking_with_TAXXI /app/Benchmarking_with_TAXXI
WORKDIR /app

# muscle3.8.31 into /app/Anacapa_db
# RUN wget "https://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_i86linux64.tar.gz" -O /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz
COPY Packages/muscle3.8.31_i86linux64.tar.gz /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz
RUN tar -xvzf /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz -C /app/Anacapa_db
RUN rm /app/Anacapa_db/muscle3.8.31_i86linux64.tar.gz
RUN mv /app/Anacapa_db/muscle3.8.31_i86linux64 /app/Anacapa_db/muscle
# make muscle executable
RUN chmod +x /app/Anacapa_db/muscle

RUN echo 'if ! shopt -q login_shell; then' >> ~/.bashrc
RUN echo '    . /usr/share/modules/init/bash' >> ~/.bashrc
RUN echo 'fi' >> ~/.bashrc

ENV FASTX_TOOLKIT="/root/fastxtoolkit"
ENV ANACONDA_PYTHON="/root/miniconda3"

# SHELL ["/bin/bash", "-c", "source ~/miniconda3/bin/activate cutadapt && conda activate cutadapt"]

# Anacapa_db/anacapa_QC_dada2.sh -i Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/ -o out -d Anacapa_db/ -a nextera -t MiSeq -l
COPY Packages/info.txt /root/info.txt
SHELL ["/bin/bash"]
CMD ["cat", "/root/info.txt"]
# R version 3.4.2 maybe?    
# install.packages('plyr', repos = "http://cran.us.r-project.org")


# Anacapa_db/anacapa_QC_dada2.sh -i Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/ -o out -d Anacapa_db/ -a nextera -t MiSeq -l

# Anacapa_db/anacapa_QC_dada2.sh -i Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data -o out -d Anacapa_db -f Example_data/12S_test_data/forward.txt -r Example_data/12S_test_data/reverse.txt -e Anacapa_db/metabarcode_loci_min_merge_length.txt -a nextera -t MiSeq -l


# Anacapa_db/anacapa_QC_dada2.sh -i Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data -o out -d Anacapa_db -f Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/forward.txt -r Example_data/12S_example_anacapa_QC_dada2_and_BLCA_classifier/12S_test_data/reverse.txt -e Anacapa_db/metabarcode_loci_min_merge_length.txt -a nextera -t MiSeq -l

# Anacapa_db/anacapa_classifier.sh -d Anacapa_db -o out -l
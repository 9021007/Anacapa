# Developed and written by Emily Curd (eecurd@g.ucla.edu), Jesse Gomer (jessegomer@gmail.com),Baochen Shi (biosbc@gmail.com), Gaurav Kandlikar (gkandlikar@ucla.edu), Zack Gold (zack.j.gold@gmail.com)
# Developed at UCLA for the University of California Conservation Consortium's CALeDNA Program
# Last Updated 11-02-2018


#Local mode
#Uncomment the following line (delete the #) if you are NOT running on a cluster (e.g. Hoffman2)
LOCALMODE=TRUE

#############################
# Paths to programs / load programs
#############################

MODULE_SOURCE="source /usr/share/modules/init/bash" 	#if none, leave empty <- for HPC

### if not loading modules, need a way to not run lines ~65 - 70 (module load bit...) and a way to run programs from load names not paths...

#defines what program should launch the run scripts inside the submitted jobs. can change to e.g. singularity if running in a container
RUNNER="bash"

#load cutadapt
CUTADAPT="/root/miniconda3/envs/cutadapt/bin/cutadapt" 		#version 1.16 path to cutadapt binary. See documentation for how to obtain this script

#load fastx_toolkit
FASTX_TOOLKIT="/root/fastxtoolkit"				#version 0.0.13.2 or what ever code is used to load fastx_toolkit in a bash shell, or path to fastx_toolkit

#load anaconda/python2-4.2
ANACONDA_PYTHON="/root/miniconda3/bin/python3 --version"				#or whatever code is used to load anaconda/python2-4.2 in a bash shell, or path to anaconda/python2-4.2

#load bowtie2
BOWTIE2="/root/miniconda3/bin/bowtie2"							# version 2.3.4 or what ever code is used to load bowtie2 in a bash shell, or path to bowtie2

#load ATS
ATS="module load ATS"									#or what ever code is used to load ATS in a bash shell, or path to ATS.  ATS is a Hoffman2 module that allows the user to submit a job on the HPC from within a shell script

#load R
R="module load R/3.4.2"

#load python with numpy
PYTHONWNUMPY="module load python/2.7.3"

MUSCLE="${DB}/muscle3.8.31_i86linux64"

#load GCC
GCC="module load gcc/6.3.0"

# modify job run / submit Parameters
RUNNER="/bin/bash"

QUEUESUBMIT="qsub"

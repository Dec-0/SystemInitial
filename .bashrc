# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

WorkDir="/biobiggen/data/headQuarter/user/xiezhangdong"
SoftDir="${WorkDir}/Softs"
DBDir="${WorkDir}/DB"
ScriptDir="${WorkDir}/Script"
PS1='\[\e[33;1m\]\u\[\e[0m\] \[\e[31;1m\]\t\[\e[0m\] \[\e[33;1m\]\w\[\e[0m\]\n\[\e[31;1m\]\$ \[\e[0m\]'

alias le="less -S"
alias l="ls"
alias ll="ls -lh"
alias la="ls -a"
alias lla="ll -a"
alias c="cd .."
alias pwork='cd $WorkDir'
alias unix="dos2unix"
alias myps="ps -ef | grep ^xiezh"
alias bc="awk 'BEGIN{SUM = 0}{SUM += \$3 - \$2}END{print SUM}'"
alias 38to19="${SoftDir}/Python-2.7.16/bin/python ${SoftDir}/Python-2.7.16/bin/CrossMap.py bed ${DBDir}/Chain/hg38ToHg19.over.chain.gz /dev/stdin"
alias 19to38="${SoftDir}/Python-2.7.16/bin/python ${SoftDir}/Python-2.7.16/bin/CrossMap.py bed ${DBDir}/Chain/hg19ToHg38.over.chain.gz /dev/stdin"
alias getfa="${SoftDir}/bedtools-2.26/bin/bedtools getfasta -fi ${DBDir}/Reference/hg38/ucsc.hg38.fasta -bed -"
alias samv='${SoftDir}/samtools-0.1.19/samtools view -X'
alias e_q="echo 'qsub -V -cwd -q all.q -l vf=4g,h_vmem=4g,p=1 -b y -N Test \"CommandLine\"'"
alias e_rpm="echo 'rpm2cpio xxxx.rpm | cpio -idvm'"
alias sjmdel="awk 'BEGIN{flag = 0}{if(/status running/ || /status pending/){flag = 1};if(/ id / && flag){print \$0;flag = 0;}}' | cut -d ' ' -f 6 | xargs qdel -j "
alias sedA="echo \"sed ':a;N;s/\n//g;ba'\""

export PATH=${SoftDir}/gcc-9.3.0/bin:$PATH
export PATH=${SoftDir}/screen-4.8.0/bin:$PATH
export PATH=${SoftDir}/aspera-cli-3.9.6/cli/bin:$PATH
export PATH=${SoftDir}/perl-5.26.3/bin:$PATH
export PATH=${SoftDir}/Python-3.7.7/bin:$PATH
export PATH=${SoftDir}/Python-2.7.16/bin:$PATH
export PATH=${SoftDir}/R-3.6.3/bin:$PATH
export PATH=${SoftDir}/dos2unix-7.4.2/bin:$PATH
export PATH=${SoftDir}/sjm-1.2.0/bin:$PATH
export PATH=${SoftDir}/Fastp-0.20.0:$PATH
export PATH=${SoftDir}/bwa-0.7.17:$PATH
export PATH=${SoftDir}/samtools-1.11/bin:$PATH
export PATH=${SoftDir}/bedtools-2.26/bin:$PATH
export PATH=${SoftDir}/bcftools-1.11/bin:$PATH
export PATH=${SoftDir}/ncbi-blast-2.10.0/bin:$PATH

export LD_LIBRARY_PATH=${SoftDir}/gmp-6.2.0/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${SoftDir}/mpfr-4.1.0/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${SoftDir}/mpc-1.1.0/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${SoftDir}/gcc-9.3.0/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${SoftDir}/openssl-1.1.1/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${SoftDir}/libffi-devel-3.0.13/lib64:$LD_LIBRARY_PATH

export CC=${SoftDir}/gcc-9.3.0/bin/gcc
export CXX=${SoftDir}/gcc-9.3.0/bin/g++

export MANPATH=${SoftDir}/aspera-cli-3.9.6/cli/share/man:$MANPATH
export PERL5LIB=${SoftDir}/biomart-perl/lib:$PERL5LIB
export PYTHONPATH=${ScriptDir}/.ModuleOfPy:$PYTHONPATH

LANG="zh_CN.utf8"
LANGUAGE="zh_CN.utf8"

umask 027
cd ${WorkDir}

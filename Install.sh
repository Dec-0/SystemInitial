# This script for soft installation
Dir4Work=$(pwd)
Flag4gcc=true
Flag4Perl=true
Flag4Python2=true
Flag4Python3=true
Flag4R=true
Flag4bwa=true
Flag4Samtools=true
Flag4Bedtools=true
Flag4Aspera=true
Flag4Blast=true
Flag4fastp=true
Flag4CrossMap=true
Flag4Unix=true
Flag4Screen=true
Flag4sjm=true

# Install gmp
if ${Flag4gcc} && [ ! -s ${Dir4Work}/gmp-6.2.0/lib/libgmp.a ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://gmplib.org/download/gmp/gmp-6.2.0.tar.xz' -O gmp-6.2.0.tar.xz
	xz -d gmp-6.2.0.tar.xz && tar xvf gmp-6.2.0.tar
	cd gmp-6.2.0 && ./configure --prefix=${Dir4Work}/gmp-6.2.0
	make && make install
	rm ${Dir4Work}/SourcePackages/gmp-6.2.0.tar && rm -r ${Dir4Work}/SourcePackages/gmp-6.2.0
fi
# Install mpfr
if ${Flag4gcc} && [ ! -s ${Dir4Work}/mpfr-4.1.0/lib/libmpfr.a ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.gz' -O mpfr-4.1.0.tar.gz
	tar xzvf mpfr-4.1.0.tar.gz
	cd mpfr-4.1.0 && ./configure --prefix=${Dir4Work}/mpfr-4.1.0 --with-gmp-include=${Dir4Work}/gmp-6.2.0/include --with-gmp-lib=${Dir4Work}/gmp-6.2.0/lib
	make && make install
	rm ${Dir4Work}/SourcePackages/mpfr-4.1.0.tar.gz && rm -r ${Dir4Work}/SourcePackages/mpfr-4.1.0
fi
# Install mpc
if ${Flag4gcc} && [ ! -s ${Dir4Work}/mpc-1.1.0/lib/libmpc.a ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz' -O mpc-1.1.0.tar.gz
	tar xzvf mpc-1.1.0.tar.gz
	cd mpc-1.1.0 && ./configure --prefix=${Dir4Work}/mpc-1.1.0 --with-gmp-include=${Dir4Work}/gmp-6.2.0/include --with-gmp-lib=${Dir4Work}/gmp-6.2.0/lib --with-mpfr-include=${Dir4Work}/mpfr-4.1.0/include --with-mpfr-lib=${Dir4Work}/mpfr-4.1.0/lib
	make && make install
	rm ${Dir4Work}/SourcePackages/mpc-1.1.0.tar.gz && rm -rf ${Dir4Work}/SourcePackages/mpc-1.1.0
fi
# Install makeinfo
if ${Flag4gcc} && [ ! -s ${Dir4Work}/texinfo-6.5/bin/makeinfo ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.gz' -O texinfo-6.5.tar.gz
	tar xzvf texinfo-6.5.tar.gz
	cd texinfo-6.5 && ./configure --prefix=${Dir4Work}/texinfo-6.5
	make && make install
	rm ${Dir4Work}/SourcePackages/texinfo-6.5.tar.gz && rm -rf ${Dir4Work}/SourcePackages/texinfo-6.5
fi
############ gcc ( ~2h )
if ${Flag4gcc} && [ ! -s ${Dir4Work}/gcc-9.3.0/bin/gcc ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.gz' -O gcc-9.3.0.tar.gz
	tar xzvf gcc-9.3.0.tar.gz
	# export for gcc
	if [ -s ${Dir4Work}/texinfo-6.5/bin/makeinfo ] && [ -d ${Dir4Work}/gmp-6.2.0/lib ] && [ -d ${Dir4Work}/mpfr-4.1.0/lib ] && [ -d ${Dir4Work}/mpc-1.1.0/lib ] ; then
		export PATH=${Dir4Work}/texinfo-6.5/bin:$PATH
		# LD_LIBRARY_PATH for gcc of lower version
		export LD_LIBRARY_PATH=${Dir4Work}/gmp-6.2.0/lib:$LD_LIBRARY_PATH
		export LD_LIBRARY_PATH=${Dir4Work}/mpfr-4.1.0/lib:$LD_LIBRARY_PATH
		export LD_LIBRARY_PATH=${Dir4Work}/mpc-1.1.0/lib:$LD_LIBRARY_PATH
	fi
	cd gcc-9.3.0 && ./configure --prefix=${Dir4Work}/gcc-9.3.0 --with-gmp=${Dir4Work}/gmp-6.2.0 --with-mpfr=${Dir4Work}/mpfr-4.1.0 --with-mpc=${Dir4Work}/mpc-1.1.0 --disable-multilib
	make && make install
	rm ${Dir4Work}/SourcePackages/gcc-9.3.0.tar.gz && rm -rf ${Dir4Work}/SourcePackages/gcc-9.3.0
fi
# arguments for gcc
if [ -s ${Dir4Work}/gcc-9.3.0/bin/gcc ] ; then
	export PATH=${Dir4Work}/gcc-9.3.0/bin:$PATH
	export CC=${Dir4Work}/gcc-9.3.0/bin/gcc
	export CXX=${Dir4Work}/gcc-9.3.0/bin/g++
	export LD_LIBRARY_PATH=${Dir4Work}/gmp-6.2.0/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=${Dir4Work}/mpfr-4.1.0/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=${Dir4Work}/mpc-1.1.0/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=${Dir4Work}/gcc-9.3.0/lib64:$LD_LIBRARY_PATH
fi

############ perl download may fail need retry
# Need LD_LIBRARY_PATH: mpfr-4.1.0/lib/libmpfr.so.6;
if ${Flag4Perl} && [ ! -s ${Dir4Work}/perl-5.26.3/bin/perl ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	i=1
	while [[ $i -lt 20 ]] && [ ! -s ${Dir4Work}/SourcePackages/perl-5.26.3.tar.bz2 ]
	do
		wget 'http://www.cpan.org/src/5.0/perl-5.26.3.tar.bz2' -O perl-5.26.3.tar.bz2
		let i++
		sleep 10
	done
	tar -jxvf perl-5.26.3.tar.bz2
	# Perl doesnot suppport multi threads by default after 5.8, compile with '-Dusethreads' if need;
	cd perl-5.26.3 && ./Configure -des -Dprefix=${Dir4Work}/perl-5.26.3 -Dusethreads
	make && make install
	rm ${Dir4Work}/SourcePackages/perl-5.26.3.tar.bz2 && rm -rf ${Dir4Work}/SourcePackages/perl-5.26.3
fi

############ python2
if ${Flag4Python2} && [ ! -s ${Dir4Work}/Python-2.7.16/bin/python ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz' -O Python-2.7.16.tgz
	tar xzvf Python-2.7.16.tgz
	cd Python-2.7.16 && ./configure --prefix=${Dir4Work}/Python-2.7.16 --enable-optimizations
	make && make install
	rm ${Dir4Work}/SourcePackages/Python-2.7.16.tgz && rm -rf ${Dir4Work}/SourcePackages/Python-2.7.16
fi
# pip
if ${Flag4Python2} && [ ! -s ${Dir4Work}/Python-2.7.16/bin/pip ] && [ -s ${Dir4Work}/Python-2.7.16/bin/python ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://files.pythonhosted.org/packages/66/6d/dad0d39ce1cfa98ef3634463926e7324e342c956aecb066968e2e3696300/setuptools-30.0.0.tar.gz' -O setuptools-30.0.0.tar.gz
	tar xzvf setuptools-30.0.0.tar.gz
	cd setuptools-30.0.0 && ${Dir4Work}/Python-2.7.16/bin/python ./setup.py install
	rm ${Dir4Work}/SourcePackages/setuptools-30.0.0.tar.gz && rm -r ${Dir4Work}/SourcePackages/setuptools-30.0.0
	cd ${Dir4Work}/SourcePackages
	wget 'https://files.pythonhosted.org/packages/53/7f/55721ad0501a9076dbc354cc8c63ffc2d6f1ef360f49ad0fbcce19d68538/pip-20.3.4.tar.gz' -O pip-20.3.4.tar.gz
	tar xzvf pip-20.3.4.tar.gz
	cd pip-20.3.4 && ${Dir4Work}/Python-2.7.16/bin/python ./setup.py install
	rm ${Dir4Work}/SourcePackages/pip-20.3.4.tar.gz && rm -r ${Dir4Work}/SourcePackages/pip-20.3.4
fi
# Install openssl
if ${Flag4Python3} && [ ! -s ${Dir4Work}/openssl-1.1.1/bin/openssl ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://www.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz' --no-check-certificate -O openssl-1.1.1.tar.gz
	tar xzvf openssl-1.1.1.tar.gz
	cd openssl-1.1.1 && ./config --prefix=${Dir4Work}/openssl-1.1.1
	make && make install
	rm ${Dir4Work}/SourcePackages/openssl-1.1.1.tar.gz && rm -rf ${Dir4Work}/SourcePackages/openssl-1.1.1
fi
# Install libffi
if ${Flag4Python3} && [ ! -s ${Dir4Work}/libffi-3.0.13/lib64/libffi.so.6.0.1 ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://codeload.github.com/libffi/libffi/tar.gz/refs/tags/v3.0.13' --no-check-certificate -O libffi-3.0.13.tar.gz
	tar xzvf libffi-3.0.13.tar.gz
	cd libffi-3.0.13 && ./configure --prefix=${Dir4Work}/libffi-3.0.13 --enable-debug
	make && make install
	rm ${Dir4Work}/SourcePackages/libffi-3.0.13.tar.gz && rm -rf ${Dir4Work}/SourcePackages/libffi-3.0.13
fi
# install libffi-devel  download may fail need retry
if ${Flag4Python3} && [ ! -s ${Dir4Work}/libffi-devel-3.0.13/lib64/libffi.so ] && [ -s ${Dir4Work}/libffi-3.0.13/lib64/libffi.so.6.0.1 ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	i=1
	while [[ $i -lt 20 ]] && [ ! -s ${Dir4Work}/SourcePackages/libffi-devel-3.0.13-19.el7.x86_64.rpm ]
	do
		wget 'http://mirror.centos.org/centos/7/os/x86_64/Packages/libffi-devel-3.0.13-19.el7.x86_64.rpm' -O libffi-devel-3.0.13-19.el7.x86_64.rpm
		let i++
		sleep 10
	done
	rpm2cpio libffi-devel-3.0.13-19.el7.x86_64.rpm | cpio -idvm
	mv usr ../libffi-devel-3.0.13
	rm ${Dir4Work}/SourcePackages/libffi-devel-3.0.13-19.el7.x86_64.rpm
	cd ${Dir4Work}/libffi-devel-3.0.13/lib64/
	# symbolic link exit but invalid, construct a new symbolic link
	if [ -L ./libffi.so ] && [ ! -s ./libffi.so ] ; then
		rm ./libffi.so && ln -s ${Dir4Work}/libffi-3.0.13/lib64/libffi.so.6.0.1 ./libffi.so
	fi
fi
# arguments for python3 compile
if [ -s ${Dir4Work}/openssl-1.1.1/bin/openssl ] && [ -s ${Dir4Work}/libffi-devel-3.0.13/lib64/libffi.so ] ; then
	export LD_LIBRARY_PATH=${Dir4Work}/openssl-1.1.1/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=${Dir4Work}/libffi-devel-3.0.13/lib64:$LD_LIBRARY_PATH
fi
############ python3
if ${Flag4Python3} && [ ! -s ${Dir4Work}/Python-3.7.7/bin/python3 ] && [ -s ${Dir4Work}/libffi-devel-3.0.13/lib64/libffi.so ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://www.python.org/ftp/python/3.7.7/Python-3.7.7.tgz' -O Python-3.7.7.tgz
	tar xzvf Python-3.7.7.tgz
	cd Python-3.7.7 && ./configure --prefix=${Dir4Work}/Python-3.7.7 --with-openssl=${Dir4Work}/openssl-1.1.1 PKG_CONFIG_PATH="${Dir4Work}/openssl-1.1.1/lib/pkgconfig" --with-system-ffi LDFLAGS="-L ${Dir4Work}/libffi-devel-3.0.13/lib64" CPPFLAGS="-I ${Dir4Work}/libffi-devel-3.0.13/include"
	make && make install
	rm ${Dir4Work}/SourcePackages/Python-3.7.7.tgz && rm -rf ${Dir4Work}/SourcePackages/Python-3.7.7
fi

# R-3.6.3 needs bzip2 lib and header
# bzip2
if ${Flag4R} && [ ! -s ${Dir4Work}/bzip2-1.0.6/bin/bzip2 ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://jaist.dl.sourceforge.net/project/bzip2/bzip2-1.0.6.tar.gz' --no-check-certificate -O bzip2-1.0.6.tar.gz
	tar xzvf bzip2-1.0.6.tar.gz
	cd bzip2-1.0.6 && make -f Makefile-libbz2_so && make clean && make && make install PREFIX=${Dir4Work}/bzip2-1.0.6
	rm ${Dir4Work}/SourcePackages/bzip2-1.0.6.tar.gz && rm -rf ${Dir4Work}/SourcePackages/bzip2-1.0.6
fi
############ R
if ${Flag4R} && [ ! -s ${Dir4Work}/R-3.6.3/bin/R ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-3/R-3.6.3.tar.gz' --no-check-certificate -O R-3.6.3.tar.gz
	tar xzvf R-3.6.3.tar.gz
	export PATH=${Dir4Work}/bzip2-1.0.6/bin:$PATH
	cd R-3.6.3 && ./configure --prefix=${Dir4Work}/R-3.6.3 CFLAGS="-I${Dir4Work}/bzip2-1.0.6/include" LDFLAGS="-L${Dir4Work}/bzip2-1.0.6/lib"
	make && make install
	rm ${Dir4Work}/SourcePackages/R-3.6.3.tar.gz && rm -rf ${Dir4Work}/SourcePackages/R-3.6.3
fi

############ bwa
if ${Flag4bwa} && [ ! -s ${Dir4Work}/bwa-0.7.17/bwa ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://jaist.dl.sourceforge.net/project/bio-bwa/bwa-0.7.17.tar.bz2' -O bwa-0.7.17.tar.bz2
	tar -jxvf bwa-0.7.17.tar.bz2
	cd bwa-0.7.17
	make
	[ ! -d ${Dir4Work}/bwa-0.7.17 ] && mkdir -p ${Dir4Work}/bwa-0.7.17
	cp ${Dir4Work}/SourcePackages/bwa-0.7.17/bwa ${Dir4Work}/bwa-0.7.17
	rm ${Dir4Work}/SourcePackages/bwa-0.7.17.tar.bz2 && rm -r ${Dir4Work}/SourcePackages/bwa-0.7.17
fi

############ samtools
# for -X mode
if ${Flag4Samtools} && [ ! -s ${Dir4Work}/samtools-0.1.19/samtools ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://jaist.dl.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2' -O samtools-0.1.19.tar.bz2
	tar -jxvf samtools-0.1.19.tar.bz2
	cd samtools-0.1.19
	make
	[ ! -d ${Dir4Work}/samtools-0.1.19 ] && mkdir -p ${Dir4Work}/samtools-0.1.19
	cp ${Dir4Work}/SourcePackages/samtools-0.1.19/samtools* ${Dir4Work}/samtools-0.1.19
	cp -r ${Dir4Work}/SourcePackages/samtools-0.1.19/bcftools ${Dir4Work}/samtools-0.1.19
	cp -r ${Dir4Work}/SourcePackages/samtools-0.1.19/misc ${Dir4Work}/samtools-0.1.19
	rm ${Dir4Work}/SourcePackages/samtools-0.1.19.tar.bz2 && rm -r ${Dir4Work}/SourcePackages/samtools-0.1.19
fi
# for latest release
if ${Flag4Samtools} && [ ! -s ${Dir4Work}/samtools-1.14/bin/samtools ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'http://jaist.dl.sourceforge.net/project/samtools/samtools/1.14/samtools-1.14.tar.bz2' -O samtools-1.14.tar.bz2
	tar -jxvf samtools-1.14.tar.bz2
	cd samtools-1.14
	./configure --prefix=${Dir4Work}/samtools-1.14
	# If ERROR reported, check htslib version in '-I'
	make all all-htslib
	make install install-htslib
	rm ${Dir4Work}/SourcePackages/samtools-1.14.tar.bz2 && rm -r ${Dir4Work}/SourcePackages/samtools-1.14
fi

############ bedtools
if ${Flag4Bedtools} && [ ! -s ${Dir4Work}/bedtools2-2.26.0/bin/bedtools ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://codeload.github.com/arq5x/bedtools2/tar.gz/refs/tags/v2.26.0' -O bedtools-2.26.0.tar.gz
	tar xzvf bedtools-2.26.0.tar.gz
	cd bedtools2-2.26.0 && make
	mv ${Dir4Work}/SourcePackages/bedtools2-2.26.0 ${Dir4Work}
	rm ${Dir4Work}/SourcePackages/bedtools-2.26.0.tar.gz
fi

############ aspera-cli-3.9.6
if ${Flag4Aspera} && [ ! -s ${Dir4Work}/aspera-cli-3.9.6/cli/bin/ascp ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://ak-delivery04-mul.dhe.ibm.com/sar/CMA/OSA/08q6g/0/ibm-aspera-cli-3.9.6.1467.159c5b1-linux-64-release.sh' -O ibm-aspera-cli-3.9.6.1467.159c5b1-linux-64-release.sh
	chmod 750 ibm-aspera-cli-3.9.6.1467.159c5b1-linux-64-release.sh
	sh ibm-aspera-cli-3.9.6.1467.159c5b1-linux-64-release.sh
	mv ~/.aspera ${Dir4Work}/aspera-cli-3.9.6
	rm ibm-aspera-cli-3.9.6.1467.159c5b1-linux-64-release.sh
fi

############ blast
# should download with ascp
if ${Flag4Blast} && [ ! -s ${Dir4Work}/ncbi-blast-2.10.0/bin/blastn ] && [ -s ${Dir4Work}/aspera-cli-3.9.6/cli/bin/ascp ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	${Dir4Work}/aspera-cli-3.9.6/cli/bin/ascp -i ${Dir4Work}/aspera-cli-3.9.6/cli/etc/asperaweb_id_dsa.openssh -l 100M -k 1 -T anonftp@ftp.ncbi.nlm.nih.gov:/blast/executables/blast+/2.10.0/ncbi-blast-2.10.0+-x64-linux.tar.gz ./
	tar xzvf ncbi-blast-2.10.0+-x64-linux.tar.gz
	mv ncbi-blast-2.10.0+ ${Dir4Work}/ncbi-blast-2.10.0
	rm ncbi-blast-2.10.0+-x64-linux.tar.gz
fi

############ fastp
if ${Flag4fastp} && [ ! -s ${Dir4Work}/fastp-0.20.0/fastp ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://codeload.github.com/OpenGene/fastp/tar.gz/refs/tags/v0.20.0' -O fastp-0.20.0.tar.gz
	tar xzvf fastp-0.20.0.tar.gz
	cd fastp-0.20.0 && make
	mv ${Dir4Work}/SourcePackages/fastp-0.20.0 ${Dir4Work}
	rm ${Dir4Work}/SourcePackages/fastp-0.20.0.tar.gz
fi

############ CrossMap
# encoding: utf-8
if ${Flag4CrossMap} && [ ! -s ${Dir4Work}/Python-2.7.16/bin/CrossMap.py ] && [ -s ${Dir4Work}/Python-2.7.16/bin/pip ] ; then
	${Dir4Work}/Python-2.7.16/bin/pip install CrossMap
fi

############ Dos2Unix
if ${Flag4Unix} && [ ! -s ${Dir4Work}/dos2unix-7.4.2/bin/dos2unix ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.2.tar.gz' --no-check-certificate -O dos2unix-7.4.2.tar.gz
	tar xzvf dos2unix-7.4.2.tar.gz
	cd dos2unix-7.4.2 && make prefix=${Dir4Work}/dos2unix-7.4.2 clean all && make prefix=${Dir4Work}/dos2unix-7.4.2 install
	rm ${Dir4Work}/SourcePackages/dos2unix-7.4.2.tar.gz && rm -r ${Dir4Work}/SourcePackages/dos2unix-7.4.2
fi

############ screen
if ${Flag4Screen} && [ ! -s ${Dir4Work}/screen-4.8.0/bin/screen ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://ftp.gnu.org/gnu/screen/screen-4.8.0.tar.gz' --no-check-certificate -O screen-4.8.0.tar.gz
	tar xzvf screen-4.8.0.tar.gz
	cd screen-4.8.0 && ./configure --prefix=${Dir4Work}/screen-4.8.0
	make && make install
	rm ${Dir4Work}/SourcePackages/screen-4.8.0.tar.gz && rm -r ${Dir4Work}/SourcePackages/screen-4.8.0
fi


# tclap
if ${Flag4sjm} && [ ! -s ${Dir4Work}/tclap-1.2.2/include/tclap/CmdLine.h ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://jaist.dl.sourceforge.net/project/tclap/tclap-1.2.2.tar.gz' --no-check-certificate -O tclap-1.2.2.tar.gz
	tar xzvf tclap-1.2.2.tar.gz
	cd tclap-1.2.2 && ./configure --prefix=${Dir4Work}/tclap-1.2.2
	make && make install
	rm ${Dir4Work}/SourcePackages/tclap-1.2.2.tar.gz && rm -r ${Dir4Work}/SourcePackages/tclap-1.2.2
fi
# boost_1_73_0
if ${Flag4sjm} && [ ! -s ${Dir4Work}/boost_1_73_0/include/boost/regex.hpp ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://jaist.dl.sourceforge.net/project/boost/boost/1.73.0/boost_1_73_0.tar.gz' --no-check-certificate -O boost_1_73_0.tar.gz
	tar xzvf boost_1_73_0.tar.gz
	cd boost_1_73_0 && sh ./bootstrap.sh --prefix=${Dir4Work}/boost_1_73_0
	./b2 install --without-python --prefix=${Dir4Work}/boost_1_73_0
	rm ${Dir4Work}/SourcePackages/boost_1_73_0.tar.gz && rm -r ${Dir4Work}/SourcePackages/boost_1_73_0
fi
############ sjm
if ${Flag4sjm} && [ ! -s ${Dir4Work}/sjm-1.2.0/bin/sjm ] && [ -s ${Dir4Work}/tclap-1.2.2/include/tclap/CmdLine.h ] ; then
	[[ ! -d ${Dir4Work}/SourcePackages ]] && mkdir -p ${Dir4Work}/SourcePackages
	cd ${Dir4Work}/SourcePackages
	wget 'https://master.dl.sourceforge.net/project/hpcsjm/sjm-1.2.0.tar.gz?viasf=1' --no-check-certificate -O sjm-1.2.0.tar.gz
	tar xzvf sjm-1.2.0.tar.gz
	cd sjm-1.2.0 && ./configure --prefix=${Dir4Work}/sjm-1.2.0 CPPFLAGS="-I${Dir4Work}/tclap-1.2.2/include -I${Dir4Work}/boost_1_73_0/include" LDFLAGS="-L${Dir4Work}/tclap-1.2.2/lib -L${Dir4Work}/boost_1_73_0/lib"
	make && make install
	rm ${Dir4Work}/SourcePackages/sjm-1.2.0.tar.gz && rm -r ${Dir4Work}/SourcePackages/sjm-1.2.0
fi




# final clean
if [[ -d ${Dir4Work}/SourcePackages ]] ; then
	rm -rf ${Dir4Work}/SourcePackages
	echo 'Done'
fi
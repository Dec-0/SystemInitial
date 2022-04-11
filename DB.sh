# This script for ordinary database files
# Executable files and related
Dir4Script="./Scripts"
Dir4Soft="./Softs"
Perl="${Dir4Soft}/perl-5.26.3/bin/perl"
Dir4Annovar="${Dir4Script}/Annotation/Annovar"
Ascp="${Dir4Soft}/aspera-cli-3.9.6/cli/bin/ascp"
Key410KGP="${Dir4Soft}/aspera-cli-3.9.6/cli/etc/asperaweb_id_dsa.openssh"
# Other
Dir4Work=$(pwd)
Flag4RefHg38=false
Flag4LiftOverChain=false
Flag4NMAndAA=false
Flag4Annotation=false
# MAF
Flag410KGP=false
Flag4dbsnp=false
Flag4gnomAD=false
# NA12878
Flag4NA12878=false

# Reference ucsc.hg38.fasta
if ${Flag4RefHg38} ; then
	if [ -s ${Dir4Work}/Reference/hg38/ucsc.hg38.fasta ] ; then
		echo "File exit (${Dir4Work}/Reference/hg38/ucsc.hg38.fasta)"
	else
		[ ! -d ${Dir4Work}/Reference/hg38/tmpDir4Hg38 ] && mkdir -p ${Dir4Work}/Reference/hg38/tmpDir4Hg38
		
		cd ${Dir4Work}/Reference/hg38/tmpDir4Hg38
		Midfix=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y")
		for z in ${Midfix[@]}
		do
			wget "ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/chromosomes/chr${z}.fa.gz" -O chr${z}.fa.gz
		done
		
		gunzip chr*.fa.gz
		cat chr1.fa chr2.fa chr3.fa chr4.fa chr5.fa \
			chr6.fa chr7.fa chr8.fa chr9.fa chr10.fa \
			chr11.fa chr12.fa chr13.fa chr14.fa chr15.fa \
			chr16.fa chr17.fa chr18.fa chr19.fa chr20.fa \
			chr21.fa chr22.fa chrX.fa chrY.fa > ucsc.hg38.fasta
		mv ucsc.hg38.fasta ${Dir4Work}/Reference/hg38
		
		cd ${Dir4Work}/Reference/hg38
		rm -r ${Dir4Work}/Reference/hg38/tmpDir4Hg38
		[ -s ${Dir4Work}/Reference/hg38/ucsc.hg38.fasta ] && echo '[ Info ] Done for reference fasta of hg38'
	fi
fi

# liftover chain file
if ${Flag4LiftOverChain} ; then
	if [ -s ${Dir4Work}/ChainOfLiftOver/hg19ToHg38.over.chain.gz && -s ${Dir4Work}/ChainOfLiftOver/hg38ToHg19.over.chain.gz ] ; then
		echo "File exit (${Dir4Work}/ChainOfLiftOver/hg38/hg19ToHg38.over.chain.gz and ${Dir4Work}/ChainOfLiftOver/hg38/hg38ToHg19.over.chain.gz)"
	else
		[ ! -d ${Dir4Work}/ChainOfLiftOver ] && mkdir -p ${Dir4Work}/ChainOfLiftOver
		
		cd ${Dir4Work}/ChainOfLiftOver
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/liftOver/hg38ToHg19.over.chain.gz' -O hg38ToHg19.over.chain.gz
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz' -O hg19ToHg38.over.chain.gz
		echo '[ Info ] Done for liftover chain files'
	fi
fi

# nucleotides and amino acid
if ${Flag4NMAndAA} ; then
	if [ -s ${Dir4Work}/NMAndAA/hg38/refGene.txt.gz && -s ${Dir4Work}/NMAndAA/hg38/cytoBand.txt.gz ] ; then
		echo "File exit (${Dir4Work}/NMAndAA/hg38/refGene.txt.gz and ${Dir4Work}/NMAndAA/hg38/cytoBand.txt.gz)"
	else
		[ ! -d ${Dir4Work}/NMAndAA/hg38 ] && mkdir -p ${Dir4Work}/NMAndAA/hg38
		
		cd ${Dir4Work}/NMAndAA/hg38
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/cytoBand.txt.gz' -O cytoBand.txt.gz
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/refGene.txt.gz' -O refGene.txt.gz
		echo '[ Info ] Done for files of nucleotides and amino acids'
	fi
fi

# Annotation
if ${Flag4Annotation} ; then
	if [ -s ${Dir4Work}/Annotation/hg38/hg38_refGeneMrna.fa ] ; then
		echo "File exit (${Dir4Work}/Annotation/hg38/hg38_refGeneMrna.fa)"
	else
		[ ! -d ${Dir4Work}/Annotation/hg38 ] && mkdir -p ${Dir4Work}/Annotation/hg38
		
		cd ${Dir4Work}/Annotation/hg38
		#### 基因注释相关
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb refGene ${Dir4Work}/Annotation/hg38
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/refGene.txt.gz' -O hg38_refGene.txt.gz
		gunzip -f hg38_refGene.txt.gz
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb seq ${Dir4Work}/Annotation/hg38/hg38_seq
		[ ! -d ${Dir4Work}/Annotation/hg38/hg38_seq ] && mkdir ${Dir4Work}/Annotation/hg38/hg38_seq
		cd ${Dir4Work}/Annotation/hg38/hg38_seq
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz' -O hg38.chromFa.tar.gz
		wget 'ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz' -O hg38.fa.gz
		tar -xzf hg38.chromFa.tar.gz
		gunzip -f hg38.fa.gz
		${Perl} ${Dir4Annovar}/retrieve_seq_from_fasta.pl ${Dir4Work}/Annotation/hg38/hg38_refGene.txt -seqdir ${Dir4Work}/Annotation/hg38/hg38_seq/chroms -format refGene -outfile ${Dir4Work}/Annotation/hg38/hg38_refGeneMrna.fa
		[ -d ${Dir4Work}/Annotation/hg38/hg38_seq ] && rm -r ${Dir4Work}/Annotation/hg38/hg38_seq
		cd ${Dir4Work}/Annotation/hg38
		
		#### 人群频率相关
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb 1000g2015aug ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_1000g2015aug.zip' -O hg38_1000g2015aug.zip
		unzip -o hg38_1000g2015aug.zip
		[ -s ${Dir4Work}/Annotation/hg38/hg38_1000g2015aug.zip ] && rm ${Dir4Work}/Annotation/hg38/hg38_1000g2015aug.zip
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb gnomad211_exome -webfrom annovar ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_gnomad211_exome.txt.gz' -O hg38_gnomad211_exome.txt.gz
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_gnomad211_exome.txt.idx.gz' -O hg38_gnomad211_exome.txt.idx.gz
		gunzip -f hg38_gnomad211_exome.txt.gz
		gunzip -f hg38_gnomad211_exome.txt.idx.gz
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb esp6500siv2_all -webfrom annovar ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_esp6500siv2_all.txt.gz' -O hg38_esp6500siv2_all.txt.gz
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_esp6500siv2_all.txt.idx.gz' -O hg38_esp6500siv2_all.txt.idx.gz
		gunzip -f hg38_esp6500siv2_all.txt.gz
		gunzip -f hg38_esp6500siv2_all.txt.idx.gz
		
		#### 功能预测（cosmic、clinvar、ljb26、dbnsfp30a）
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb cosmic70 -webfrom annovar ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_cosmic70.txt.gz' -O hg38_cosmic70.txt.gz
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_cosmic70.txt.idx.gz' -O hg38_cosmic70.txt.idx.gz
		gunzip -f hg38_cosmic70.txt.gz
		gunzip -f hg38_cosmic70.txt.idx.gz
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb clinvar_20210501 -webfrom annovar ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_clinvar_20210501.txt.gz' -O hg38_clinvar_20210501.txt.gz
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_clinvar_20210501.txt.idx.gz' -O hg38_clinvar_20210501.txt.idx.gz
		gunzip -f hg38_clinvar_20210501.txt.gz
		gunzip -f hg38_clinvar_20210501.txt.idx.gz
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb ljb26_all -webfrom annovar ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_ljb26_all.txt.gz' -O hg38_ljb26_all.txt.gz
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_ljb26_all.txt.idx.gz' -O hg38_ljb26_all.txt.idx.gz
		gunzip -f hg38_ljb26_all.txt.gz
		gunzip -f hg38_ljb26_all.txt.idx.gz
		# ${Perl} ${Dir4Annovar}/annotate_variation.pl -buildver hg38 -downdb dbnsfp30a -webfrom annovar ${Dir4Work}/Annotation/hg38
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_dbnsfp30a.txt.gz' -O hg38_dbnsfp30a.txt.gz
		wget 'http://www.openbioinformatics.org/annovar/download/hg38_dbnsfp30a.txt.idx.gz' -O hg38_dbnsfp30a.txt.idx.gz
		gunzip -f hg38_dbnsfp30a.txt.gz
		gunzip -f hg38_dbnsfp30a.txt.idx.gz
		
		echo '[ Info ] Done for annotation files'
	fi
fi

# MAF
# 10KGP
if ${Flag410KGP} && [ ! -s ${Dir4Work}/MAF/10KGP/ALL.chr1.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz ] ; then
	[ ! -d ${Dir4Work}/MAF/10KGP ] && mkdir -p ${Dir4Work}/MAF/10KGP
	Midfix=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y")
	for z in ${Midfix[@]}
	do
		${Ascp} -i ${Key410KGP} -Tr -Q -l 100M -P33001 -L- fasp-g1k@fasp.1000genomes.ebi.ac.uk:vol1/ftp/release/20110521/ALL.chr${z}.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz ${Dir4Work}/MAF/10KGP
		${Ascp} -i ${Key410KGP} -Tr -Q -l 100M -P33001 -L- fasp-g1k@fasp.1000genomes.ebi.ac.uk:vol1/ftp/release/20110521/ALL.chr${z}.phase1_release_v3.20101123.snps_indels_svs.genotypes.vcf.gz.tbi ${Dir4Work}/MAF/10KGP
	done
fi
# dbsnp
if ${Flag4dbsnp} && [ ! -s ${Dir4Work}/MAF/dbsnp/freq.GRCh38.vcf.gz ] ; then
	[ ! -d ${Dir4Work}/MAF/dbsnp ] && mkdir -p ${Dir4Work}/MAF/dbsnp
	
	cd ${Dir4Work}/MAF/dbsnp
	wget 'ftp://ftp.ncbi.nih.gov/snp/population_frequency/latest_release/freq.vcf.gz' -O freq.vcf.gz
	wget 'ftp://ftp.ncbi.nih.gov/snp/population_frequency/latest_release/freq.vcf.gz.tbi' -O freq.vcf.gz.tbi
	wget 'ftp://ftp-trace.ncbi.nih.gov/genomes/refseq/vertebrate_mammalian/Homo_sapiens/latest_assembly_versions/GCF_000001405.39_GRCh38.p13/GCF_000001405.39_GRCh38.p13_assembly_report.txt' -O GCF_000001405.39_GRCh38.p13_assembly_report.txt
fi
# gnomAD
if ${Flag4gnomAD} && [ ! -s ${Dir4Work}/MAF/gnomAD/gnomad.exomes.r2.1.1.sites.1.vcf.bgz ] ; then
	[ ! -d ${Dir4Work}/MAF/gnomAD ] && mkdir -p ${Dir4Work}/MAF/gnomAD
	cd ${Dir4Work}/MAF/gnomAD
	Midfix=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y")
	for z in ${Midfix[@]}
	do
		wget "ftp://datasetgnomad.blob.core.windows.net/dataset/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.${z}.vcf.bgz" -O gnomad.exomes.r2.1.1.sites.${z}.vcf.bgz
		wget "ftp://datasetgnomad.blob.core.windows.net/dataset/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.${z}.vcf.bgz.tbi" -O gnomad.exomes.r2.1.1.sites.${z}.vcf.bgz
	done
fi

# Ensembl

# TruthSet for NA12878
# GiAB
if ${Flag4NA12878} && [ ! -s ${Dir4Work}/TruthSet/NA12878/GiAB/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.bed ] ; then
	[ ! -d ${Dir4Work}/TruthSet/NA12878/GiAB/GRCh38 ] && mkdir -p ${Dir4Work}/TruthSet/NA12878/GiAB/GRCh38
	cd ${Dir4Work}/TruthSet/NA12878/GiAB/GRCh38
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.bed" -O HG001_GRCh38_1_22_v4.2.1_benchmark.bed
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz" -O HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz.tbi" -O HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz.tbi
fi
# Illumina Platinum Genomes
if ${Flag4NA12878} && [ ! -s ${Dir4Work}/TruthSet/NA12878/PlatinumGenomes/GRCh38/ConfidentRegions.bed.gz ] ; then
	[ ! -d ${Dir4Work}/TruthSet/NA12878/PlatinumGenomes/GRCh38 ] && mkdir -p ${Dir4Work}/TruthSet/NA12878/PlatinumGenomes/GRCh38
	cd ${Dir4Work}/TruthSet/NA12878/PlatinumGenomes/GRCh38
	wget ftp://platgene_ro:''@ussd-ftp.illumina.com/2017-1.0/hg38/small_variants/ConfidentRegions.bed.gz -O ConfidentRegions.bed.gz
	wget ftp://platgene_ro:''@ussd-ftp.illumina.com/2017-1.0/hg38/small_variants/ConfidentRegions.bed.gz.tbi -O ConfidentRegions.bed.gz.tbi
	wget ftp://platgene_ro:''@ussd-ftp.illumina.com/2017-1.0/hg38/small_variants/NA12878/NA12878.vcf.gz -O NA12878.vcf.gz
	wget ftp://platgene_ro:''@ussd-ftp.illumina.com/2017-1.0/hg38/small_variants/NA12878/NA12878.vcf.gz.tbi -O NA12878.vcf.gz.tbi
	wget ftp://platgene_ro:''@ussd-ftp.illumina.com/2017-1.0/hg38/hybrid/README.md -O README.md
fi
# Fastq for NA12878 (GiAB)
if ${Flag4NA12878} && [ ! -s ${Dir4Work}/Fastq/NA12878/GiAB/HiSeqExome/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz ] ; then
	[ ! -d ${Dir4Work}/Fastq/NA12878/GiAB/HiSeqExome ] && mkdir -p ${Dir4Work}/Fastq/NA12878/GiAB/HiSeqExome
	cd ${Dir4Work}/Fastq/NA12878/GiAB/HiSeqExome
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R1_001.fastq.gz" -O NIST7035_TAAGGCGA_L001_R1_001.fastq.gz
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L001_R2_001.fastq.gz" -O NIST7035_TAAGGCGA_L001_R2_001.fastq.gz
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L002_R1_001.fastq.gz" -O NIST7035_TAAGGCGA_L002_R1_001.fastq.gz
	wget "ftp://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/NA12878/Garvan_NA12878_HG001_HiSeq_Exome/NIST7035_TAAGGCGA_L002_R2_001.fastq.gz" -O NIST7035_TAAGGCGA_L002_R2_001.fastq.gz
fi
# Fastq for NA12878 (Platinum)
:<<!
if ${Flag4NA12878} && [ ! -s ${Dir4Work}/Fastq/NA12878/PlatinumGenomes/HiSeqWGS/ERR194147_1.fastq.gz ] ; then
	[ ! -d ${Dir4Work}/Fastq/NA12878/PlatinumGenomes/HiSeqWGS ] && mkdir -p ${Dir4Work}/Fastq/NA12878/PlatinumGenomes/HiSeqWGS
	cd ${Dir4Work}/Fastq/NA12878/PlatinumGenomes/HiSeqWGS
	wget "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194147/ERR194147_1.fastq.gz" -O ERR194147_1.fastq.gz
	wget "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR194/ERR194147/ERR194147_2.fastq.gz" -O ERR194147_2.fastq.gz
fi
!

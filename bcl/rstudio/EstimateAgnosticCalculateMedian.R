rm(list=ls(all=TRUE))
library(pscl)
library(foreign)

setwd("ReplicationFiles")


rc <- readKH("PooledMatrixCivilRightsAgnostic.dat", desc="Pooled Matrix, Civil Rights - Agnostic")

rc.issue<-dropRollCall(rc,dropList=list(lop=4,legisMin=4))

rc.ideal<-ideal(rc.issue,d=1, maxiter=30000,thin=30,burnin=3000,
		impute=FALSE,normalize=TRUE,store.item=TRUE,verbose=TRUE)

xposterior<-rc.ideal$x	
posteriorsd<-apply(xposterior,2,sd)
legdata.mean<-rc.ideal$xbar
legdata.sd<-as.data.frame(posteriorsd)
posteriorHDR<-apply(xposterior,2,quantile, probs = c(.025, .975))
post_vec<-t(posteriorHDR)
legdata.HDR<-as.data.frame(post_vec)

new.i <- data.frame(rownames(legdata.mean), legdata.mean, legdata.sd, legdata.HDR)
leg.info<-rc.issue$legis
all.info<-cbind(leg.info, new.i )
beta.info<-as.data.frame(rc.ideal$betabar)
beta.info$midpoint = beta.info$Difficulty / beta.info$Discrimination
voteTab<-summary(rc.issue,verbose=TRUE)$voteTab
vote.info<-cbind(voteTab, beta.info)

estimates1<-all.info
estimates2<-vote.info
estimates2$vote<-rownames(estimates2)

outfile1<-paste("PooledIdealCivilRightsAgnostic.dta")

outfile2<-paste("PooledVotesCivilRightsAgnostic.dta")

write.dta(estimates1, file = outfile1)
write.dta(estimates2, file = outfile2)

wrkspace<-paste("PooledIdealCivilRightsAgnostic.RData")

save.image(file = wrkspace) 	
###########################################################################
### GET CONGRESS LEVEL MEDIANS 
###########################################################################

### RANGE OF CONGRESSES
firstcong <-45
lastcong <-110

### HOW MANY SAMPLES TO DRAW FROM
sampsize<-800

cong<-c(firstcong:lastcong)
output1<-list()
newfinal <-data.frame()
infile <- paste("PooledIdealCivilRightsAgnostic.RData", sep="")
load(infile)

for(i in cong) {
	
	all.info$i <-i
	
	#rc.ideal<-rc.i
	#rm(rc.i)

	### MATCH MEMBERS FOR EACH CONGRESS 
	members <- read.delim(file="MembersBothChambers.txt",header=TRUE)

	congress<-members[members$congress==i & members$chamber==1,]

	names(congress)[2]<-"icpsrLegis"

	### Median
	total <-merge(all.info, congress, by="icpsrLegis")
	names(total)[names(total)=="rownames.legdata.mean."] <- "name"
	row.names(total)<-total$name
	
	median<-as.integer(nrow(total)/2)

	names<-total$name
	x<-rc.ideal$x
	ncol(x[,names,1])
	x1<-x[,colnames(x)%in%names,1]

	xposterior<-x1
	post_vec<-t(xposterior)
	
	### IDENTIFY THE MEDIAN MEMBER FOR SET NUMBER OF SAMPLES
	### AND THEIR IDEAL POINT FOR THAT SAMPLE
	sample1<-post_vec[,sample(1:ncol(post_vec),sampsize,replace=FALSE)]
	sample2<-data.frame(sample1, (apply(-sample1, 2, rank, ties.method='min')))

	pivot1<-matrix(, sampsize,1)
	for(j in 1:sampsize) {
		k<-j+sampsize
		pivot1[j,]<-subset(sample2[,j], sample2[,k]==median)
	}

	pivotmean<-apply(pivot1,2,mean)	
	pivotHDR<-apply(pivot1,2,quantile, probs = c(.025, .975))	
	pivotsd<-apply(pivot1,2,sd)

	### DO THE SAME FOR DIFFERENT CATEGORIES
	### Southern Democratic Median

	sdemcongress<-members[members$congress==i & members$chamber==1 & members$party2==100 & members$south==1,]
	names(sdemcongress)[2]<-"icpsrLegis"

	sdemTotal <-merge(all.info, sdemcongress, by="icpsrLegis")
	names(sdemTotal)[names(sdemTotal)=="rownames.legdata.mean."] <- "name"
	row.names(sdemTotal)<-sdemTotal$name
	
	medianSDem<-as.integer(nrow(sdemTotal)/2)

	names<-sdemTotal$name
	x<-rc.ideal$x
	ncol(x[,names,1])
	x1<-x[,colnames(x)%in%names,1]

	xposterior<-x1

	post_vec<-t(xposterior)

	sample1<-post_vec[,sample(1:ncol(post_vec),sampsize,replace=FALSE)]
	sample2<-data.frame(sample1, (apply(-sample1, 2, rank, ties.method='min')))

	pivot1<-matrix(, sampsize,1)
	for(j in 1:sampsize) {
		k<-j+sampsize
		pivot1[j,]<-subset(sample2[,j], sample2[,k]==medianSDem)
	}

	sdemPivotMean<-apply(pivot1,2,mean)	
	sdemPivotHDR<-apply(pivot1,2,quantile, probs = c(.025, .975))	
	sdemPivotsd<-apply(pivot1,2,sd)

	########################################################

	### Republican Median
	gopcongress<-members[members$congress==i & members$chamber==1 & members$party2==200,]
	names(gopcongress)[2]<-"icpsrLegis"

	gopTotal <-merge(all.info, gopcongress, by="icpsrLegis")
	names(gopTotal)[names(gopTotal)=="rownames.legdata.mean."] <- "name"
	row.names(gopTotal)<-gopTotal$name
	
	medianGOP<-as.integer(nrow(gopTotal)/2)

	names<-gopTotal$name
	x<-rc.ideal$x
	ncol(x[,names,1])
	x1<-x[,colnames(x)%in%names,1]

	xposterior<-x1

	post_vec<-t(xposterior)

	sample3<-post_vec[,sample(1:ncol(post_vec),sampsize,replace=FALSE)]
	sample4<-data.frame(sample3, (apply(-sample3, 2, rank, ties.method='min')))

	pivot1<-matrix(, sampsize,1)
	for(j in 1:sampsize) {
		k<-j+sampsize
		pivot1[j,]<-subset(sample4[,j], sample4[,k]==medianGOP)
	}

	gopPivotMean<-apply(pivot1,2,mean)	
	gopPivotHDR<-apply(pivot1,2,quantile, probs = c(.025, .975))	
	gopPivotsd<-apply(pivot1,2,sd)

	########################################################

	### Democratic Median
	demcongress<-members[members$congress==i & members$chamber==1 & members$party2==100,]
	names(demcongress)[2]<-"icpsrLegis"

	demTotal <-merge(all.info, demcongress, by="icpsrLegis")
	names(demTotal)[names(demTotal)=="rownames.legdata.mean."] <- "name"
	row.names(demTotal)<-demTotal$name
	
	medianDem<-as.integer(nrow(demTotal)/2)

	names<-demTotal$name
	x<-rc.ideal$x
	ncol(x[,names,1])
	x1<-x[,colnames(x)%in%names,1]

	xposterior<-x1

	post_vec<-t(xposterior)

	sample5<-post_vec[,sample(1:ncol(post_vec),sampsize,replace=FALSE)]
	sample6<-data.frame(sample5, (apply(-sample5, 2, rank, ties.method='min')))

	pivot1<-matrix(, sampsize,1)
	pivot2<-matrix(, sampsize,1)
	polar <-matrix(, sampsize,1)
	for(j in 1:sampsize) {
		k<-j+sampsize
		pivot1[j,]<-subset(sample6[,j], sample6[,k]==medianDem)
		pivot2[j,]<-subset(sample4[,j], sample4[,k]==medianGOP)
		polar[j,] <-abs(pivot1[j,]-pivot2[j,])
	}

	demPivotMean<-apply(pivot1,2,mean)	
	demPivotHDR<-apply(pivot1,2,quantile, probs = c(.025, .975))	
	demPivotsd<-apply(pivot1,2,sd)

	polarMean<-apply(polar,2,mean)	
	polarHDR<-apply(polar,2,quantile, probs = c(.025, .975))	
	polarsd<-apply(polar,2,sd)	
	
	########################################################
	### Northern Democratic Median
	ndemcongress<-members[members$congress==i & members$chamber==1 & members$party2==100 & members$south==0,]
	names(ndemcongress)[2]<-"icpsrLegis"

	ndemTotal <-merge(all.info, ndemcongress, by="icpsrLegis")
	if(nrow(ndemTotal )==0L) {
		next
	} else {
		names(ndemTotal)[names(ndemTotal)=="rownames.legdata.mean."] <- "name"
		row.names(ndemTotal)<-ndemTotal$name
	
		medianNDem<-as.integer(nrow(ndemTotal)/2)

		names<-ndemTotal$name
		x<-rc.ideal$x
		ncol(x[,names,1])
		x1<-x[,colnames(x)%in%names,1]	

		xposterior<-x1


		post_vec<-t(xposterior)

		sample7<-post_vec[,sample(1:ncol(post_vec),sampsize,replace=FALSE)]
		sample8<-data.frame(sample7, (apply(-sample7, 2, rank, ties.method='min')))
	

		pivot1<-matrix(, sampsize,1)
		for(j in 1:sampsize) {
			k<-j+sampsize
			pivot1[j,]<-subset(sample8[,j], sample8[,k]==medianNDem)
		}
	
		ndemPivotMean<-apply(pivot1,2,mean)	
		ndemPivotHDR<-apply(pivot1,2,quantile, probs = c(.025, .975))	
		ndemPivotsd<-apply(pivot1,2,sd)

	}
	########################################################

	final<-as.data.frame(i)

 	final$pivot<-pivotmean
	final$pivotci25<-pivotHDR[1,]
	final$pivotci975<-pivotHDR[2,]
  	final$sdemPivot<-sdemPivotMean
	final$sdemPivotci25<-sdemPivotHDR[1,]
	final$sdemPivotci975<-sdemPivotHDR[2,]
  	final$gopPivot<-gopPivotMean
	final$gopPivotci25<-gopPivotHDR[1,]
	final$gopPivotci975<-gopPivotHDR[2,]
  	final$demPivot<-demPivotMean
	final$demPivotci25<-demPivotHDR[1,]
	final$demPivotci975<-demPivotHDR[2,]
  	final$ndemPivot<-ndemPivotMean
	final$ndemPivotci25<-ndemPivotHDR[1,]
	final$ndemPivotci975<-ndemPivotHDR[2,]
	final$polar<-polarMean
	final$polarci25<-polarHDR[1,]
	final$polarci975<-polarHDR[2,]
	final$obs<-sampsize
	names(final)[1]<-"congress"
	newfinal <-rbind(newfinal, final)
	
}

outfile1<-paste("HouseCongressLevelAgnosticMedians", firstcong, "to", lastcong, ".dta", sep="")
attr(newfinal, "var.labels") <- c("Congress", "Location of Median Member","Median, CI 2.5",
	"Median Location, CI 97.5", "Location of Southern Democratic Median","Southern Democratic Median, CI 2.5",
	"Southern Democratic Median Location, CI 97.5", "Location of Republican Median","Republican Median, CI 2.5",
	"Republican Median Location, CI 97.5", "Location of Democratic Median","Democratic Median, CI 2.5",
	"Democratic Median Location, CI 97.5", "Location of Northern Democratic Median","Northern Democratic Median, CI 2.5",
	"Northern Democratic Median Location, CI 97.5", "Polarization: Distance between Democratic and GOP medians","Polarization, CI 2.5",
	"Polarization, CI 97.5", "Sample Size for Calculating CI")
write.dta(newfinal, outfile1, convert.factor=c("label"))

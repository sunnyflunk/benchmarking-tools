#!/usr/bin/env bash

cat << EOF > /tmp/summarise.R
# Import data results
testName <- "$1"
dataResults <- read.csv('~/BT-Results/results.csv', header = FALSE)
colnames(dataResults) <- c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Result", "Validation", "Instructions", "Cycles", "ContextSwitches","L1Misses", "CacheRefs", "CacheMisses", "Branches", "BranchMisses")

Merged <- paste(dataResults\$Benchmark, dataResults\$Label, dataResults\$Distro, dataResults\$Kernel, dataResults\$Date, dataResults\$Test)
dataResults <- cbind(dataResults, Merged)

dataUnique <- unique(dataResults\$Merged)
for( index in 1:length(dataUnique) )
{
    tmp <- subset(dataResults, Merged == dataUnique[index])
    tmpSubset <- tmp[1,c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Merged")]
    tmpSubset\$Result <- round(mean(tmp\$Result),3)
    tmpSubset\$RSD <- round(sd(tmp\$Result),3)

    tmpSubset\$Instructions <- round(mean(tmp\$Instructions))
    tmpSubset\$ISD <- round(sd(tmp\$Instructions))
    tmpSubset\$Cycles <- round(mean(tmp\$Cycles))
    tmpSubset\$ContextSwitches <- round(mean(tmp\$ContextSwitches))
    tmpSubset\$L1Misses <- round(mean(tmp\$L1Misses))
    tmpSubset\$CacheRefs <- round(mean(tmp\$CacheRefs))
    tmpSubset\$CacheMisses <- round(mean(tmp\$CacheMisses))
    tmpSubset\$Branches <- round(mean(tmp\$Branches))
    tmpSubset\$BranchMisses <- round(mean(tmp\$BranchMisses))

    if ( length(unique(tmp\$Validation)) == 1 ){
        tmpSubset\$Valid <- unique(tmp\$Validation)
    } else {
        tmpSubset\$Valid <- NA
    }

    Variables <- c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Result", "RSD", "Instructions", "ISD", "Cycles", "ContextSwitches", "L1Misses", "CacheRefs", "CacheMisses", "Branches", "BranchMisses", "Valid")
    if( exists("dataCombined") ) {
        dataCombined <- rbind(dataCombined, tmpSubset[, Variables])
    } else {
        dataCombined <- tmpSubset[, Variables]
    }
}

if ( testName != "" )
{
    dataCombined <- subset(dataCombined, Benchmark == testName)
}

write.csv(dataCombined[order(dataCombined\$Benchmark, dataCombined\$Test),], '/tmp/summarise.csv', row.names = FALSE)
options(width=1000)
print(dataCombined[order(dataCombined\$Benchmark, dataCombined\$Test),])
EOF
Rscript /tmp/summarise.R
echo ""
echo ""
echo ""
cat /tmp/summarise.csv

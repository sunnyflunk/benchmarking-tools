#!/usr/bin/env bash

testName=${1}

cat << EOF > /tmp/summarise.R
# Import data results
testName <- "$testName"
dataResults <- read.csv('~/BT-Results/$testName.csv', header = FALSE)
colnames(dataResults) <- c("Label", "Distro", "Kernel", "Date", "Test", "Note", "Result", "Validation", "Instructions", "Cycles", "L1Misses", "CacheRefs", "CacheMisses", "Branches", "BranchMisses")

Merged <- paste(dataResults\$Label, dataResults\$Distro, dataResults\$Kernel, dataResults\$Date, dataResults\$Test, dataResults\$Note)
dataResults <- cbind(dataResults, Merged)

dataUnique <- unique(dataResults\$Merged)
for( index in 1:length(dataUnique) )
{
    tmp <- subset(dataResults, Merged == dataUnique[index])
    tmpSubset <- tmp[1,c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Merged")]
    tmpSubset\$Result <- mean(tmp\$Result)
    tmpSubset\$RSD <- sd(tmp\$Result)

    tmpSubset\$Instructions <- round(mean(tmp\$Instructions))
    tmpSubset\$ISD <- round(sd(tmp\$Instructions))
    tmpSubset\$Cycles <- round(mean(tmp\$Cycles))
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

    Variables <- c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Result", "RSD", "Instructions", "ISD", "Cycles", "L1Misses", "CacheRefs", "CacheMisses", "Branches", "BranchMisses", "Valid")
    if( exists("dataCombined") ) {
        dataCombined <- rbind(dataCombined, tmpSubset[, Variables])
    } else {
        dataCombined <- tmpSubset[, Variables]
    }
}

write.csv(dataCombined[order(dataCombined\$Test),], '/tmp/summarise.csv', row.names = FALSE)
options(width=1000)
print(dataCombined[order(dataCombined\$Test),])
EOF
Rscript /tmp/summarise.R
echo ""
echo ""
echo ""
cat /tmp/summarise.csv

#!/usr/bin/env bash

testName=${1}

cat << EOF > /tmp/summarise.R
# Import data results
testName <- "$testName"
dataResults <- read.csv('~/BT-Results/$testName.csv', header = FALSE)
colnames(dataResults) <- c("Label", "Distro", "Kernel", "Date", "Test", "Note", "Result", "Validation")

Merged <- paste(dataResults\$Label, dataResults\$Distro, dataResults\$Kernel, dataResults\$Date, dataResults\$Test, dataResults\$Note)
dataResults <- cbind(dataResults, Merged)

dataUnique <- unique(dataResults\$Merged)
for( index in 1:length(dataUnique) )
{
    tmp <- subset(dataResults, Merged == dataUnique[index])
    tmpSubset <- tmp[1,c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Merged")]
    tmpSubset\$Mean <- mean(tmp\$Result)
    tmpSubset\$SD <- sd(tmp\$Result)
    if ( length(unique(tmp\$Validation)) == 1 ){
        tmpSubset\$Valid <- unique(tmp\$Validation)
    } else {
        tmpSubset\$Valid <- NA
    }

    if( exists("dataCombined") ) {
        dataCombined <- rbind(dataCombined, tmpSubset[,c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Mean", "SD", "Valid")])
    } else {
        dataCombined <- tmpSubset[,c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Mean", "SD", "Valid")]
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

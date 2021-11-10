#!/usr/bin/env bash

testName=${1}

cat << EOF > /tmp/summarise.R
# Import data results
testName <- "$testName"
dataResults <- read.csv('~/BT-Results/results-power.csv', header = FALSE)
colnames(dataResults) <- c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Note", "Time", "Validation", "EPsys", "EPkg", "ECores", "EGPU", "ERam")

dataResults <- subset(dataResults, Benchmark == testName)

Merged <- paste(dataResults\$Label, dataResults\$Distro, dataResults\$Kernel, dataResults\$Date, dataResults\$Test, dataResults\$Note)
dataResults <- cbind(dataResults, Merged)

dataUnique <- unique(dataResults\$Merged)
for( index in 1:length(dataUnique) )
{
    tmp <- subset(dataResults, Merged == dataUnique[index])
    tmpSubset <- tmp[1,c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Merged")]
    tmpSubset\$Time <- mean(tmp\$Time)

    tmpSubset\$EPsys <- round(mean(tmp\$EPsys), digits=2)
    tmpSubset\$EPkg <- round(mean(tmp\$EPkg), digits=2)
    tmpSubset\$ECores <- round(mean(tmp\$ECores), digits=2)
    tmpSubset\$EGPU <- round(mean(tmp\$EGPU), digits=2)
    tmpSubset\$ERam <- round(mean(tmp\$ERam), digits=2)

    if ( length(unique(tmp\$Validation)) == 1 ){
        tmpSubset\$Valid <- unique(tmp\$Validation)
    } else {
        tmpSubset\$Valid <- NA
    }

    Variables <- c("Label", "Distro", "Kernel", "Date", "Note", "Test", "Time", "EPsys", "EPkg", "ECores", "EGPU", "ERam", "Valid")
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

#!/usr/bin/env bash

cat << EOF > /tmp/summarise.R
# Import data results
testName <- "$1"
dataResults <- read.csv('~/BT-Results/results-power.csv', header = FALSE)
colnames(dataResults) <- c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Time", "Validation", "EPsys", "EPkg", "ECores", "EGPU", "ERam")

Merged <- paste(dataResults\$Benchmark, dataResults\$Label, dataResults\$Distro, dataResults\$Kernel, dataResults\$Date, dataResults\$Test)
dataResults <- cbind(dataResults, Merged)

dataUnique <- unique(dataResults\$Merged)
for( index in 1:length(dataUnique) )
{
    tmp <- subset(dataResults, Merged == dataUnique[index])
    tmpSubset <- tmp[1,c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Merged")]
    tmpSubset\$Time <- round(mean(tmp\$Time), digits=2)

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

    Variables <- c("Benchmark", "Label", "Distro", "Kernel", "Date", "Test", "Time", "EPsys", "EPkg", "ECores", "EGPU", "ERam", "Valid")
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

write.csv(dataCombined[order(dataCombined\$Benchmark, dataCombined\$Test, dataCombined\$Label),], '/tmp/summarise.csv', row.names = FALSE)
options(width=1000)
print(dataCombined[order(dataCombined\$Benchmark, dataCombined\$Test, dataCombined\$Label),])
EOF
Rscript /tmp/summarise.R
echo ""
echo ""
echo ""
cat /tmp/summarise.csv

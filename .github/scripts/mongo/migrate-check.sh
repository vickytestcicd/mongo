#!/bin/bash

for line in .source/mongo/*; do 
   echo $line
	if [[ ! -d $line ]]; then
		echo "mongo folder 下 不能存在文件" $line
		exit 1
	fi
	lastName='000000000000'
	for fileName in $(cat $line/migration-js.list); do
		file=${fileName%%-*}
		count=$(echo $file |awk '{print length($0)}')
    	res=$(echo $file |awk '{print($0~/^[-]?([0-9])+[.]?([0-9])+$/)?"0":"1"}')
    	if [[ $count -ne  14 ]]; then
    		echo $fileName "’s length need to be 14"
       	 	exit 1
    	elif [[ res -ne 0 ]]; then
       	 	echo $fileName "should consist of numbers before the first -"
       	 	exit 1
       	elif [[ $file -le $lastName ]]; then
       	 	echo "The file name in migration-js.txt needs to be incremented"
       	 	exit 1
       	elif [[ "${fileName##*.}" != "js" ]]; then
       		echo $fileName "needs to be a js file"
       		exit 1
       	else
       		lastName=$file
    	fi

    	if [ ! -e $line/migrations/$fileName ];then 
    		echo $fileName "in" $line  "文件不存在"
    		exit 1
    	fi
	done
done

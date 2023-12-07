#!/bin/bash

pushd $(dirname "$0") > /dev/null

## Pull in configuration
source ./config

## If being created interactively
if [ -z "${1}" ]; then
	echo "Please type your name"
	read var_name

	echo "Please a comment about this silence"
	read var_comment

	echo "Please Enter the label to filter with, the operator, and value"
	echo "Example1: host =  headnode1.ncsa.illinois.edu"
	echo "Example2: host != headnode1.ncsa.illinois.edu"
	echo "Example3: url =~ headnode1.*"
	echo "Example4: url !~ headnode1.*"
	read var_type var_operator var_value

	echo "Enter start time of silence, example format: 2023-06-16 14:00:00"
	read var_start_raw

	echo "Enter end time of silence, same format as above or: +2 hour"
	read var_end_raw

## If they're asking for help
elif [ "${1}" == "-h" ]; then
	echo "Syntax: ./silence.sh your_name comment label value start_time end_time"
	echo ""
	echo "Example1: ./silence.sh \"Bob Smith\" \"Scheduled Maintenance\" host = foo-bar.bob.com \"2023-06-17 14:00:00\" \"2023-06-18 14:00:00\""
	echo "Example2: ./silence.sh \"Peter Piper\" \"Playing around\" url =~ \"test-site.*\" now \"2023-06-18 14:00:00\""
	echo "Example3: ./silence.sh \"Peter Piper\" \"Playing around\" url != test-site.piper.com now \"+2 hour\""
	exit 0
## If being exectued as a one line script with arguments
else
	var_name=$1
	var_comment=$2
	var_type=$3
	var_operator=$4
	var_value=$5
	var_start_raw=$6
	var_end_raw=$7
fi

## If the start time is just "now" or if a time is specified
if [ "${var_start_raw}" == "now" ]; then
	var_start=$(TZ=UTC date -d now +"%Y-%m-%dT%H:%M:%S.000Z")
else
	zone=$(date +%Z)
	var_start=$(TZ=UTC date -d "${var_start_raw} ${zone}" +"%Y-%m-%dT%H:%M:%S.000Z")
fi

## If end_time starts with + convert the time as a duration, otherwise use it literal
if [ "${var_end_raw:0:1}" == "+" ]; then 
	var_end=$(TZ=UTC date -d "${var_end_raw}" +"%Y-%m-%dT%H:%M:%S.000Z")
else
	var_end=$(TZ=UTC date -d "${var_end_raw} ${zone}" +"%Y-%m-%dT%H:%M:%S.000Z")
fi

# Convert var_operator to values for silence.json.template
case "${var_operator}" in
		"=")
			var_isEqual="true"
			var_isRegex="false"
			;;
		"!=")
			var_isEqual="false"
			var_isRegex="false"
			;;
		"=~")
			var_isEqual="true"
			var_isRegex="true"
			;;
		"!~")
			var_isEqual="false"
			var_isRegex="true"
			;;
		*)
			echo "Error unknown operator given: ${var_operator}  (valid options are = != =~ !~)"
			exit 1
			;;
esac

## Build the JSON file for the API
cp ./silence.json.template ./silence.json.$$
sed -i "s/var_comment/${var_comment}/" ./silence.json.$$
sed -i "s/var_name/${var_name}/" ./silence.json.$$
sed -i "s/var_type/${var_type}/" ./silence.json.$$
sed -i "s/var_value/${var_value}/" ./silence.json.$$
sed -i "s/var_start/${var_start}/" ./silence.json.$$
sed -i "s/var_end/${var_end}/" ./silence.json.$$
sed -i "s/var_isEqual/${var_isEqual}/" ./silence.json.$$
sed -i "s/var_isRegex/${var_isRegex}/" ./silence.json.$$

## Create silence and check to ensure it was created successfully
response=$(curl -w "%{http_code}\\n" -XPOST -u "${user}":"${pass}" -i http://localhost:3000/api/alertmanager/grafana/api/v2/silences --data-binary @./silence.json.$$  -H "Content-Type: application/json" -s -o /dev/null)
if [ "${response}" -eq 202 ]; then
	echo "**Silence Created Successfully**"
else
	echo "!!Failed to Create Silence!!"
fi

## Clean up
rm -rf ./silence.json.$$

popd > /dev/null

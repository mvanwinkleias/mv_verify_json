#!/bin/bash

verify_json_verbose=${verify_json_verbose:-0}

verify_json_exit_status=0

function verify_json_verbose
{
	if [[ ! "$verify_json_verbose" == "1" ]]
	then
		return
	fi

	printf "$@"
}

function verify_json_error
{
	>&2 printf "$@"
}

function verify_json
{
	local filename
	filename="$1"; shift
	if jq -e . "$filename" >/dev/null 
	then
		verify_json_verbose "$filename has good json.\n"
	else
		verify_json_error "$filename has bad json.\n"
		verify_json_exit_status=2
	fi
}

first_arg="$1"

if [[ -z "$first_arg" ]]
then
	>&2 printf "ERROR: arguments are files to check.\n"
	exit 1
fi

for file_to_check in "$@"
do
	verify_json "$file_to_check"
done

exit "$verify_json_exit_status"

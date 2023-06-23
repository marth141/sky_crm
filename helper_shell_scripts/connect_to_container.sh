#!/bin/bash
helpFunction()
{
   echo ""
   echo "Usage: $0 -c container_id"
   echo -e "\t-c Container to attach to"
   exit 1 # Exit script after printing help
}

while getopts "c:" opt
do
   case "$opt" in
      c ) container="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$container" ]
then
   echo "No container given";
   helpFunction
fi

docker exec -it $container /bin/bash
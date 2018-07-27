#!/bin/bash

# Defaults
CONCURRENCY=4
REQUESTS=600
URL="https://simple.default.project-serverless.com/"

shift $((OPTIND-1))

# run
for i in `seq 1 $CONCURRENCY`; do
  curl --silent --output /dev/null -s "$URL?[1-$REQUESTS]" & pidlist="$pidlist $!"
done

# run and wait
FAIL=0
for job in $pidlist; do
  # echo $job
  wait $job || let "FAIL += 1"
done

# results
if [ "$FAIL" -eq 0 ]; then
  echo "DONE"
else
  echo "Failed Requests: ($FAIL)"
fi

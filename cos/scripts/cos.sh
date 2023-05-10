#!/usr/bin/env sh
####################
set -e

IAM_TOKEN=$(curl -X POST "${IBMCLOUD_IAM_ENDPOINT}" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode 'grant_type=urn:ibm:params:oauth:grant-type:apikey' \
    --data-urlencode "apikey=${APIKEY}" | jq -r .access_token)

curl -X PUT "${S3_ENDPOINT}"/"${BUCKET_NAME}"?website \
    -H "Authorization: Bearer ${IAM_TOKEN}" \
    -H "ibm-service-instance-id: ${INSTANCE_ID}" \
    -H "Content-Type: text/xml" \
    -d '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><WebsiteConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><IndexDocument><Suffix>index.html</Suffix></IndexDocument></WebsiteConfiguration>'

curl -X PUT "${S3_ENDPOINT}"/"${BUCKET_NAME}"/index.html \
    -H "Authorization: Bearer ${IAM_TOKEN}" \
    -H "ibm-service-instance-id: ${INSTANCE_ID}" \
    -H "Content-Type: text/html; charset=utf-8" \
    --data-binary @"$INDEX_FILE"

#!/usr/bin/env bash

clear

if ! oc whoami >> /dev/null 2>&1; then
  printf "\nPlease ensure you are logged into the cluster, so that this script can run.\n"
  exit 1
fi

# Will need to set these correctly for the labs
pipelinens="pipelines"
frontendns="full-bc"
backendns="tools"
imagens=tools-images"
b64url="aHR0cHM6Ly9ob29rcy5zbGFjay5jb20vc2VydmljZXMvVDAxN0w2U0JLNjIvQjAySFhTN05GVU4vZlVZb0NTVlJOQ29JUHZoSnNlcFc2V3Ny"

printf "Creating json file...\n"
cat <<EOF > ./test.json
{
"channel": "C123456",
"blocks": [
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get frontend pods:* $(oc get pod -n $frontendns | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get frontend svc:* $(oc get svc -n $frontendns | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get backend pods:* $(oc get pod -n $backendns | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get backend svc:* $(oc get svc -n $backendns | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get tools images:* $(oc get is -n $imagens | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get build images:* $(oc get is -n $pipelinens | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get pr:* $(oc get pr -n $pipelinens | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get pipeline configMaps:* $(oc get cm -n $pipelinens | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) oc get pipeline secrets:* $(oc get secret -n $pipelinens | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) helm list tools:* $(helm list -n tools | awk '{print $1}' | grep -v "NAME"))"
			}
		},
		{
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": "*$(echo -n $(oc whoami) $(date +%d-%m-%Y) helm list stackrox:* $(helm list -n stackrox | awk '{print $1}' | grep -v "NAME"))"
			}
		}
	]
}
EOF

RC=$?

# Check if file creation failed or not.
if [ $RC != 0 ]; then
  printf "\nERROR! The payload json was not successfully created. Please investigate\n"
  exit 1
else
  printf "\nFile creation completed successfully.\n"
fi

printf "\nAttempting curl...\n"
response=$(curl -s --write-out '%{http_code}' -H "Content-type: application/json" --data @test.json -X POST $(echo -n $b64url | base64 -d))

if [ "$response" = "ok200" ]; then
  printf "\nCurl completed successfully.\n"
else
  printf "\nERROR! The curl command failed to complete properly. Please investigate.\n"
  exit 1
fi

printf "\nScript complete, goodbye.\n"

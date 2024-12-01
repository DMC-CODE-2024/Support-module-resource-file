#!/bin/bash
#set -x
# Configuration
API_KEY="458d675f3a3390c89a36629ed587a9ae741dffd4"
API_BASE="http://10.100.1.135:3000"
RESOLVED_STATUS_ID=3  # Status ID for 'Resolved'
CLOSED_STATUS_ID=5    # Status ID for 'Closed'

# Calculate date-time for 48 hours ago in the format YYYY-MM-DDTHH:MM:SSZ
date_48_hours_ago=$(date -u -d "1 hours ago" +"%Y-%m-%dT%H:%M:%SZ")

# Fetch all tickets in the 'Resolved' state for the project that were created in the last 48 hours
response=$(curl --silent --location "$API_BASE/issues.json?status_id=$RESOLVED_STATUS_ID&project_id=8&created_on=%3C%3D$date_48_hours_ago" \
--header "X-Redmine-API-Key: $API_KEY")

# Use jq to extract ticket IDs
ticket_ids=$(echo "$response" | jq '.issues[].id')

# Iterate over each ticket ID
for ticket_id in $ticket_ids; do
  echo "Processing ticket ID: $ticket_id"

  # Payload to close the ticket and add a comment
  data="{\"issue\": {\"status_id\": $CLOSED_STATUS_ID, \"notes\": \"System detected no activity in last 48 hours on this ticket. So, Ticket is updated with status CLOSED\"}}"

  # Update the ticket status and add the comment
  response=$(curl --silent --write-out "%{http_code}" --output /dev/null --location --request PUT "$API_BASE/issues/$ticket_id.json" \
  --header "X-Redmine-API-Key: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "$data")

  # Check if the HTTP status code is 204
  if [ "$response" -eq 204 ]; then
    echo "Ticket ID: $ticket_id has been updated to CLOSED."
  else
    echo "Failed to update Ticket ID: $ticket_id to CLOSED."
  fi
done

echo "All resolved tickets have been processed."


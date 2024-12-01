#!/bin/bash
set -x
# Configuration
API_KEY="458d675f3a3390c89a36629ed587a9ae741dffd4"
API_BASE="https://lab-ticket.eirs.gov.kh"
IN_PROGRESS_STATUS_ID=2 # Make this configurable as needed
DEFAULT_ASSIGNEE_ID=22
# Fetch all tickets in the 'New' state for project with id=11
#for i in 1 10	
#do

# Fetch all tickets in the 'New' state for project with id=11
response=$(curl --silent --location "$API_BASE/issues.json?status_id=1&project_id=8" \
--header "X-Redmine-API-Key: $API_KEY")

# Extract ticket IDs using grep and awk (no jq)
ticket_ids=$(echo "$response" | jq '.issues[].id')

# Iterate over each ticket ID
for ticket_id in $ticket_ids; do
  echo "Processing ticket ID: $ticket_id"

  # Payload to update the ticket status to 'In Progress' and add a comment
  data="{\"issue\": {\"status_id\": $IN_PROGRESS_STATUS_ID, \"assigned_to_id\": $DEFAULT_ASSIGNEE_ID, \"notes\": \"Thank you for raising a ticket. Our team is working on to resolve it. You will soon receive an update on this from our side.\"}}"

  # Update the ticket status and add the comment
  response=$(curl --silent --write-out "%{http_code}" --output /dev/null --location --request PUT "$API_BASE/issues/$ticket_id.json" \
  --header "X-Redmine-API-Key: $API_KEY" \
  --header "Content-Type: application/json" \
  --data "$data")

  # Check if the HTTP status code is 204
  if [ "$response" -eq 204 ]; then
    echo "Ticket ID: $ticket_id has been updated."
  else
    echo "Failed to update Ticket ID: $ticket_id"
  fi
done

echo "All new tickets have been processed."


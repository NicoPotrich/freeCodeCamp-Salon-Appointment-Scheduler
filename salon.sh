#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -q -t --no-align -c"

SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services")

# Display available services
echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

# Function to show the list of services
MAIN_MENU() {
  echo "$SERVICE_LIST" | while IFS="|" read SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
}

# Show the list of services
MAIN_MENU

# Read the user's selection
read SERVICE_ID_SELECTED

# Check if the selected service is valid
SERVICE_NAME=$(echo "$SERVICE_LIST" | grep "^$SERVICE_ID_SELECTED|" | cut -d '|' -f2)

# While the selection is not valid, repeat the process
while [[ -z $SERVICE_NAME ]]
do
  echo -e "\nI could not find that service. What would you like today?"
  MAIN_MENU
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$(echo "$SERVICE_LIST" | grep "^$SERVICE_ID_SELECTED|" | cut -d '|' -f2)
done

# Ask for the customer's phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# Check if the customer already exists
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  # If the customer doesn't exist, ask for their name and add the customer to the database
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  psql --username=freecodecamp --dbname=salon -c "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
fi

# Ask for the service time
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

# Get the customer_id of the customer
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

# Add the appointment to the database
psql --username=freecodecamp --dbname=salon -c "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"

# Confirm the appointment to the customer
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


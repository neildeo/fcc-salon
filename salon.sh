#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~~~~ FABIO'S SALON ~~~~~\n"

MAIN_MENU () {
  # Display services
  echo -e "Welcome to our salon. Which of our services would you like to book today?\n"
  SERVICES=$($PSQL "select * from services;")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done

  # Read service input
  read SERVICE_ID_SELECTED
  TEST_SERVICE_ID_SELECTED=$($PSQL "select service_id from services where service_id = $SERVICE_ID_SELECTED;")
  if [[ -z $TEST_SERVICE_ID_SELECTED ]]; then
    echo -e "\nPlease enter a valid service\n"
    MAIN_MENU
  else
    echo "Thank you for selecting service $SERVICE_ID_SELECTED."
  fi
}

# Display options and get a valid service
MAIN_MENU
# Get phone
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE
# Get name from database, based on phone
CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE';")
# If name doesn't exist in database
if [[ -z $CUSTOMER_NAME ]]; then
  # Get name
  echo -e "\nWelcome new customer! What is your name?"
  read CUSTOMER_NAME
  # Insert record into customers
  INSERT_CUSTOMER_RECORD=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
else
  echo -e "\nWelcome back, $CUSTOMER_NAME!"
fi
# Get time
echo -e "\nWhat time would you like for your appointment?"
read SERVICE_TIME
# Get customer_id
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")
# Insert record into appointments
INSERT_APPOINTMENT_RECORD=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
# Get service name
SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED;")
# Output message to customer
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
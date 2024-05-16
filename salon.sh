#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"


MAIN_MENU() {
echo -e "\nWelcome to My Salon, how can I help you?"
ALL_SERVICES=$($PSQL "SELECT * FROM services")
echo "$ALL_SERVICES" | while read SERVICE_ID BAR NAME
do 
echo "$SERVICE_ID) $NAME"
done
SELECT_SERVICE
}

SELECT_SERVICE() {
read SERVICE_ID_SELECTED
AVAILABLE_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $AVAILABLE_SERVICE ]] 
then 
MAIN_MENU "Please choose available service."
else
echo -e "\nPlease enter your phone number."
read CUSTOMER_PHONE
VALID_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $VALID_CUSTOMER ]] 
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME 
INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
VALID_CUSTOMER=$CUSTOMER_NAME
fi
echo -e "What time would you like your cut, $VALID_CUSTOMER?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME') ")
fi
echo -e "I have put you down for a $AVAILABLE_SERVICE at $SERVICE_TIME, $VALID_CUSTOMER."
}


MAIN_MENU

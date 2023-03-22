#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ BARBERALEX ~~~~"
echo -e "\nBenvenuto nel salon BARBERALEX, come possiamo aiutarti?\n"

SERVIZIO=$($PSQL "SELECT service_id, name FROM services")

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nEcco la lista dei nostri servizi\n"

  echo "$SERVIZIO" | while read SERVICE_ID BAR NAME
     do
     echo "$SERVICE_ID) $NAME"
     done

  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
MAIN_MENU "Inserisci un numero valido e riprova.\n"
else
SELEZIONE_SERVIZIO_DISPONIBILE=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SELEZIONE_SERVIZIO_DISPONIBILE ]]
then
MAIN_MENU "Il servizio selezionato non esiste. Riprova"
else
echo -e "\nDigita il tuo numero di telefono per favore"
read CUSTOMER_PHONE
RICERCA_CUSTOMER_PHONE=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $RICERCA_CUSTOMER_PHONE ]]
then
echo -e "\nIl tuo numero non è salvato nel nostro database, per favore digita il tuo nome"
read CUSTOMER_NAME
INSERIMENTO_NUOVO_UTENTE=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
NOME_CLIENTE_SALVATO=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nA che ora vuoi prenotare il tuo servizio $NOME_CLIENTE_SALVATO?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
INS_APPUNTAMENTO=$($PSQL "INSERT INTO appointments(service_id, time, customer_id) VALUES($SERVICE_ID_SELECTED, '$SERVICE_TIME', $CUSTOMER_ID)")
NOME_SERVIZIO=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
ORARIO_SERVIZIO=$($PSQL "SELECT time FROM appointments WHERE customer_id=$CUSTOMER_ID")

echo -e "\nI have put you down for a$NOME_SERVIZIO at$ORARIO_SERVIZIO,$NOME_CLIENTE_SALVATO."
fi
fi
}

MAIN_MENU

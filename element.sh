#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
echo -e "Please provide an element as an argument."
else 


ELEMENTO_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'");
ELEMENTO_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'");

if [[ $1 =~ ^[0-9]+$ ]]
then
ELEMENTO_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1");

if [[ $1 = $ELEMENTO_ID ]]
then
#ELEMENTI_PROPRIETA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$1") 
#echo "$ELEMENTI_PROPRIETA" | while read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
IFS="|" read ATOMIC_NUMBER_ID SYMBOL NAME <<< $($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID <<< $($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$1")
IFS="|" read TYPE_ID_2 TYPE <<< $($PSQL "SELECT type_id, type FROM types WHERE type_id=$TYPE_ID")
#do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
#done

else
echo "I could not find that element in the database."
fi

elif [[ "$1" = "$ELEMENTO_SYMBOL" ]]
then
IFS="|" read ATOMIC_NUMBER_ID SYMBOL NAME <<< $($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1'")
IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID <<< $($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER_ID")
IFS="|" read TYPE_ID_2 TYPE <<< $($PSQL "SELECT type_id, type FROM types WHERE type_id=$TYPE_ID")

echo "The element with atomic number $ATOMIC_NUMBER_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

elif [[ "$1" = "$ELEMENTO_NAME" ]]
then
IFS="|" read ATOMIC_NUMBER_ID SYMBOL NAME <<< $($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name='$1'")
IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID <<< $($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER_ID")
IFS="|" read TYPE_ID_2 TYPE <<< $($PSQL "SELECT type_id, type FROM types WHERE type_id=$TYPE_ID")

echo "The element with atomic number $ATOMIC_NUMBER_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else
echo "I could not find that element in the database."
fi
fi



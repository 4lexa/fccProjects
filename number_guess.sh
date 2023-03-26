#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
#Gioco indovina il numero segreto
echo -e "\nEnter your username:"
read USERNAME
RICERCA_UTENTE=$($PSQL "SELECT username FROM user_story WHERE username='$USERNAME'")

if [[ -z $RICERCA_UTENTE ]]
then
INSERIMENTO_NUOVO_UTENTE=$($PSQL "INSERT INTO user_story(username, games_played) VALUES('$USERNAME', 1)")
echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
IFS="|" read USERNAME GAMES_PLAYED BEST_GAME <<< $($PSQL "SELECT username, games_played, best_game FROM user_story WHERE username='$USERNAME'")
echo -e "\nWelcome back, $RICERCA_UTENTE! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
UPDATE_GAMES_PLAYED=$($PSQL "UPDATE user_story SET games_played = games_played + 1 WHERE username='$RICERCA_UTENTE'")
fi

declare -i COUNT=0
NUMERO_SEGRETO=$(( RANDOM % 1000 + 1 ))
echo "$NUMERO_SEGRETO"
echo -e "\nGuess the secret number between 1 and 1000:"

#Quattro casi possibili

INDOVINA_FUNC() {
((COUNT++))
read GUESS_NUMBER
#Se il numero inserito non è un numero
if [[ ! $GUESS_NUMBER =~ ^[0-9]+$ ]]
then
echo "That is not an integer, guess again:"
INDOVINA_FUNC
#Se il numero è maggiore
elif [[ $GUESS_NUMBER > $NUMERO_SEGRETO ]]
then
echo "It's higher than that, guess again:"
INDOVINA_FUNC
#Se il numero è minore
elif [[ $GUESS_NUMBER < $NUMERO_SEGRETO ]]
then
echo "It's lower than that, guess again:"
INDOVINA_FUNC
#Se hai indovinato
elif [[ $GUESS_NUMBER = $NUMERO_SEGRETO ]]
then
echo "You guessed it in $COUNT tries. The secret number was $NUMERO_SEGRETO. Nice job!"
AGGIORNAMENTO_MIGLIOR_PUNTEGGIO=$($PSQL "UPDATE user_story SET best_game = $COUNT WHERE username='$USERNAME' AND (best_game > $COUNT OR best_game IS NULL)")
fi
}

INDOVINA_FUNC

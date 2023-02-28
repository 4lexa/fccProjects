#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
#INSERIMENTO VINCITORI-------

#identifico i titoli delle colonne
 if [[ $WINNER != "winner" ]]
 then
 #cerco se esiste già un id per la squadra da inserire
 TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

 #se non esiste un id associato alla squadra da inserire
 if [[ -z $TEAM_ID ]]
 then
 #inserisco nella tabella la squadra
 INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
 if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
 then 
 echo Inserito nella tabella teams il vincitore: $WINNER
fi
# get new major_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
fi

#INSERIMENTO AVVERSARI------
#identifico i titoli delle colonne
 if [[ $OPPONENT != "opponent" ]]
 then
 #cerco se esiste già un id per la squadra da inserire
 TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

 #se non esiste un id associato alla squadra da inserire
 if [[ -z $TEAM_ID ]]
 then
 #inserisco nella tabella la squadra
 INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
 if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
 then 
 echo Inserito nella tabella teams l\'avversario: $OPPONENT
fi
# get new major_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
fi
done


#INSERIMENTO NELLA TABELLA GAMES
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
if [[ $YEAR != "year" ]]
 then
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
 INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$YEAR', '$ROUND', '$WGOALS', '$OGOALS', '$WINNER_ID', '$OPPONENT_ID')")
 if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
 then 
 echo Inserito nella tabella games: $YEAR, $ROUND, $WGOALS, $OGOALS.
fi
fi

done

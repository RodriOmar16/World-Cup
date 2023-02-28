#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
  echo $($PSQL "truncate teams, games;")

else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo $($PSQL "truncate teams, games;")
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $WINNER != winner ]]
    then
      # get team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

      # if not found
      if [[ -z $WINNER_ID ]]
      then
        # insert into teams
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $WINNER
        fi
        # get new winner_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
    fi
  done
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $OPPONENT != opponent ]]
    then
      # get team_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      # if not found
      if [[ -z $OPPONENT_ID ]]
      then
        # insert opponent
        INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into teams, $OPPONENT
        fi
        # get new opponent_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      fi
    fi
  done
  
  # RELLENAR LA OTRA TABLA 
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != year ]]
    then
      #get major_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      #insert student
      INSERT_GAMES_RESULT=$($PSQL "insert into games(year,round,winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into GAMES, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
      fi
    fi
  done
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

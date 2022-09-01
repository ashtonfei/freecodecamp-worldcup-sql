#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo -e "\n$($PSQL "TRUNCATE teams, games;")"

echo -e "\nInsert into table teams ..."
cat games.csv |  while IFS="," read YEAR ROUND WINNER OPP WINNER_GOALS OPP_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_FOUND=$($PSQL "SELECT * FROM teams WHERE name='$WINNER';")
    if [[ -z $WINNER_FOUND ]]
    then
      RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams for $WINNER."
      fi
    fi

    OPP_FOUND=$($PSQL "SELECT * FROM teams WHERE name='$OPP';")
    if [[ -z $OPP_FOUND ]]
    then
      RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPP');")
      if [[ $RESULT == "INSERT 0 1" ]]
      then
        echo "Inserted into teams for $OPP."
      fi
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP';")

    RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPP_ID, $WINNER_GOALS, $OPP_GOALS);")"
    if [[ $RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games for $WINNER($WINNER_GOALS) vs $OPP($OPP_GOALS)."
    fi
  fi
done

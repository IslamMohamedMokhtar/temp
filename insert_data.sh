#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    winnerId=$($PSQL "select team_id from teams where name = '$winner'") 
    if [[ -z $winnerId ]]
    then 
      #insert team
      echo "insert winner $winner"
      $PSQL "insert into teams(name) values('$winner')"
      winnerId=$($PSQL "select team_id from teams where name = '$winner'") 
      echo $winnerId
    fi
    opponentId=$($PSQL "select team_id from teams where name = '$opponent'") 
    if [[ -z $opponentId ]]
    then 
      #insert opponent team
      echo "insert opponent $opponent"
      $PSQL "insert into teams(name) values('$opponent')"
      opponentId=$($PSQL "select team_id from teams where name = '$opponent'") 
      echo $opponentId
    fi
    echo $($PSQL "insert into games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) values($year, $winnerId, $opponentId, $winner_goals, $opponent_goals, '$round')")
  fi
done
  echo "$($PSQL "SELECT count(*) FROM teams")"

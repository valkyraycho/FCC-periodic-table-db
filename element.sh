#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [ $# -eq 0 ]
then
  echo Please provide an element as an argument.
else
  #if input is not a number
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    # if input is greater than two letters
    if [[ ${#1} > 2 ]]
    then
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
    else
    # input is a symbol
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")
    fi
  #input is a number
  else
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  fi

  if [[ -z $DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo $DATA | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MP BAR BP BAR METAL
    do
      echo  "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $METAL, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done 
  fi 
fi


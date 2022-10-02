# add PSQL variable
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# make a function to display element info
ECHO_ELEMENT_INFO() {
  if [[ $1 ]]
  then
    echo "$ELEMENT_INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
}

# check if an argument is provided
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check if the argument is an integer
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get element info
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1")
    # if not found
    if [[ -z $ELEMENT_INFO ]]
    then
      echo "I could not find that element in the database."
    else
      # display the element info
      ECHO_ELEMENT_INFO $ELEMENT_INFO
    fi
  # else, it's varchar
  else
    # try to get element info using the symbol of atom
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$1'")
    # if not found
    if [[ -z $ELEMENT_INFO ]]
    then
      # try to get element info using the name of atom
      ELEMENT_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$1'")
      # if still not found
      if [[ -z $ELEMENT_INFO ]]
      then
        echo "I could not find that element in the database."
      else
        # display the element info
        ECHO_ELEMENT_INFO $ELEMENT_INFO
      fi
    else
      # display the element info
      ECHO_ELEMENT_INFO $ELEMENT_INFO
    fi
  fi
fi

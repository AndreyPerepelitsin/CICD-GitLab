#!/ bin / bash

COUNTER_SUCCESS=0
COUNTER_FAIL=0
DIFF_RES=""
touch log.txt

for var in -v -c -l -n -h -o
do
  TEST1="for s21_grep.c s21_grep.h Makefile $var"
  echo "$TEST1"
  ./s21_grep $TEST1 > s21_grep.txt
  grep $TEST1 > grep.txt
  DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
  if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
    then
      (( COUNTER_SUCCESS++ ))
    else
      echo "$var T1________________________________________FAIL"
      echo "$var T1" >> log.txt
      (( COUNTER_FAIL++ ))
  fi
  rm s21_grep.txt grep.txt

  TEST2="for s21_grep.c $var"
  echo "$TEST2"
  ./s21_grep $TEST2 > s21_grep.txt
  grep $TEST2 > grep.txt
  DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
  if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
    then
      (( COUNTER_SUCCESS++ ))
    else
      echo "$var T2________________________________________FAIL"
      echo "$var T2" >> log.txt
      (( COUNTER_FAIL++ ))
  fi
  rm s21_grep.txt grep.txt

  TEST3="-e for -e ^int s21_grep.c s21_grep.h Makefile $var"
  echo "$TEST3"
  ./s21_grep $TEST3 > s21_grep.txt
  grep $TEST3 > grep.txt
  DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
  if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
    then
      (( COUNTER_SUCCESS++ ))
    else
      echo "$var T3________________________________________FAIL"
      echo "$var T3" >> log.txt
      (( COUNTER_FAIL++ ))
  fi
  rm s21_grep.txt grep.txt

  TEST4="-e for -e ^int s21_grep.c $var"
  echo "$TEST4"
  ./s21_grep $TEST4 > s21_grep.txt
  grep $TEST4 > grep.txt
  DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
  if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
    then
      (( COUNTER_SUCCESS++ ))
    else
      echo "$var T4_________________________________________FAIL"
      echo "$var T4" >> log.txt
      (( COUNTER_FAIL++ ))
  fi
  rm s21_grep.txt grep.txt

  TEST5="-e regex -e ^print s21_grep.c $var -f patterns.txt"
  echo "$TEST5"
  ./s21_grep $TEST5 > s21_grep.txt
  grep $TEST5 > grep.txt
  DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
  if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
    then
      (( COUNTER_SUCCESS++ ))
    else
      echo "$var T5________________________________________FAIL"
      echo "$var T5" >> log.txt
      (( COUNTER_FAIL++ ))
  fi
  rm s21_grep.txt grep.txt

  TEST6="-e while -e void s21_grep.c Makefile $var -f patterns.txt"
  echo "$TEST6"
  ./s21_grep $TEST6 > s21_grep.txt
  grep $TEST6 > grep.txt
  DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
  if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
    then
      (( COUNTER_SUCCESS++ ))
    else
      echo "$var T6_______________________________________FAIL"
      echo "$var T6" >> log.txt
      (( COUNTER_FAIL++ ))
  fi
  rm s21_grep.txt grep.txt
done

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  for var in -v -c -l -n -h -o
  do
    for var2 in -n -h
    do
      if [ $var != $var2 ]
      then
        TEST1="for s21_grep.c s21_grep.h Makefile $var $var2"
        echo "$TEST1"
        ./s21_grep $TEST1 > s21_grep.txt
        grep $TEST1 > grep.txt
        DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
        if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( COUNTER_SUCCESS++ ))
          else
            echo "$var $var2 T1________________________________________FAIL"
            echo "$var $var2 T1" >> log.txt
            (( COUNTER_FAIL++ ))
        fi
        rm s21_grep.txt grep.txt

        TEST2="for s21_grep.c $var $var2"
        echo "$TEST2"
        ./s21_grep $TEST2 > s21_grep.txt
        grep $TEST2 > grep.txt
        DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
        if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( COUNTER_SUCCESS++ ))
          else
            echo "$var $var2 T2________________________________________FAIL"
            echo "$var $var2 T2" >> log.txt
            (( COUNTER_FAIL++ ))
        fi
        rm s21_grep.txt grep.txt

        TEST3="-e for -e ^int s21_grep.c s21_grep.h Makefile $var $var2"
        echo "$TEST3"
        ./s21_grep $TEST3 > s21_grep.txt
        grep $TEST3 > grep.txt
        DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
        if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( COUNTER_SUCCESS++ ))
          else
            echo "$var $var2 T3________________________________________FAIL"
            echo "$var $var2 T3" >> log.txt
            (( COUNTER_FAIL++ ))
        fi
        rm s21_grep.txt grep.txt

        TEST4="-e for -e ^int s21_grep.c $var $var2"
        echo "$TEST4"
        ./s21_grep $TEST4 > s21_grep.txt
        grep $TEST4 > grep.txt
        DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
        if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( COUNTER_SUCCESS++ ))
          else
            echo "$var $var2 T4_________________________________________FAIL"
            echo "$var $var2 T4" >> log.txt
            (( COUNTER_FAIL++ ))
        fi
        rm s21_grep.txt grep.txt

        TEST5="-e regex -e ^print s21_grep.c $var $var2 -f patterns.txt"
        echo "$TEST5"
        ./s21_grep $TEST5 > s21_grep.txt
        grep $TEST5 > grep.txt
        DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
        if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( COUNTER_SUCCESS++ ))
          else
            echo "$var $var2 T5________________________________________FAIL"
            echo "$var $var2 T5" >> log.txt
            (( COUNTER_FAIL++ ))
        fi
        rm s21_grep.txt grep.txt

        TEST6="-e while -e void s21_grep.c Makefile $var $var2 -f patterns.txt"
        echo "$TEST6"
        ./s21_grep $TEST6 > s21_grep.txt
        grep $TEST6 > grep.txt
        DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
        if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
          then
            (( COUNTER_SUCCESS++ ))
          else
            echo "$var $var2 T6_______________________________________FAIL"
            echo "$var $var2 T6" >> log.txt
            (( COUNTER_FAIL++ ))
        fi
        rm s21_grep.txt grep.txt
      fi
    done
  done
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  for var in -v -c -l -n -h -o
  do
    for var2 in -v -c -l -n -h -o
    do
        for var3 in -v -c -l -n -h -o
        do
          if [ $var != $var2 ] && [ $var2 != $var3 ] && [ $var != $var3 ]
          then
            TEST1="for s21_grep.c s21_grep.h Makefile $var $var2 $var3"
            echo "$TEST1"
            ./s21_grep $TEST1 > s21_grep.txt
            grep $TEST1 > grep.txt
            DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
            if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( COUNTER_SUCCESS++ ))
              else
                echo "$var $var2 $var3 T1________________________________________FAIL"
                echo "$var $var2 $var3 T1" >> log.txt
                (( COUNTER_FAIL++ ))
            fi
            rm s21_grep.txt grep.txt

            TEST2="for s21_grep.c $var $var2 $var3"
            echo "$TEST2"
            ./s21_grep $TEST2 > s21_grep.txt
            grep $TEST2 > grep.txt
            DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
            if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( COUNTER_SUCCESS++ ))
              else
                echo "$var $var2 $var3 T2________________________________________FAIL"
                echo "$var $var2 $var3 T2" >> log.txt
                (( COUNTER_FAIL++ ))
            fi
            rm s21_grep.txt grep.txt

            TEST3="-e for -e ^int s21_grep.c s21_grep.h Makefile $var $var2 $var3"
            echo "$TEST3"
            ./s21_grep $TEST3 > s21_grep.txt
            grep $TEST3 > grep.txt
            DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
            if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( COUNTER_SUCCESS++ ))
              else
                echo "$var $var2 $var3 T3________________________________________FAIL"
                echo "$var $var2 $var3 T3" >> log.txt
                (( COUNTER_FAIL++ ))
            fi
            rm s21_grep.txt grep.txt

            TEST4="-e for -e ^int s21_grep.c $var $var2 $var3"
            echo "$TEST4"
            ./s21_grep $TEST4 > s21_grep.txt
            grep $TEST4 > grep.txt
            DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
            if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( COUNTER_SUCCESS++ ))
              else
                echo "$var $var2 $var3 T4_________________________________________FAIL"
                echo "$var $var2 $var3 T4" >> log.txt
                (( COUNTER_FAIL++ ))
            fi
            rm s21_grep.txt grep.txt

            TEST5="-e regex -e ^print s21_grep.c $var $var2 $var3 -f patterns.txt"
            echo "$TEST5"
            ./s21_grep $TEST5 > s21_grep.txt
            grep $TEST5 > grep.txt
            DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
            if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( COUNTER_SUCCESS++ ))
              else
                echo "$var $var2 $var3 T5________________________________________FAIL"
                echo "$var $var2 $var3 T5" >> log.txt
                (( COUNTER_FAIL++ ))
            fi
            rm s21_grep.txt grep.txt

            TEST6="-e while -e void s21_grep.c Makefile $var $var2 $var3 -f patterns.txt"
            echo "$TEST6"
            ./s21_grep $TEST6 > s21_grep.txt
            grep $TEST6 > grep.txt
            DIFF_RES="$(diff -s s21_grep.txt grep.txt)"
            if [ "$DIFF_RES" == "Files s21_grep.txt and grep.txt are identical" ]
              then
                (( COUNTER_SUCCESS++ ))
              else
                echo "$var $var2 $var3 T6_______________________________________FAIL"
                echo "$var $var2 $var3 T6" >> log.txt
                (( COUNTER_FAIL++ ))
            fi
            rm s21_grep.txt grep.txt

          fi
        done
    done
  done
fi

echo "SUCCESS: $COUNTER_SUCCESS"
echo "FAIL: $COUNTER_FAIL"
rm -rf log.txt
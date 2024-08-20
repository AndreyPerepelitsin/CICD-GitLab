#!/bin/bash
# -b -e -n -s -t -v -E -T --number-nonblank --number --squeeze-blank
rm -f test_results.txt

flags=("b" "e" "n" "s" "t" "v")
flags_2=("n" "s" "t" "v")
flags_gnu=("E" "T" "-number-nonblank" "-number" "-squeeze-blank")

txts=("Makefile" "s21_cat.c" "test.txt" "s21_cat.h")

echo "____________________ -Test simple flags- ____________________"
# для всех файлов и сравнения одинаковых флагов в ./s21_cat и cat
for txt in "${txts[@]}"
do
    for flag in "${flags[@]}"
    do

    ./s21_cat -"$flag" $txt > "s21_cat_output_$flag.txt"
    cat -"$flag" $txt > "cat_output_$flag.txt"

    if cmp "s21_cat_output_$flag.txt" "cat_output_$flag.txt"
    then
        echo "Flag -$flag: SUCCESS" >> test_results.txt
    else
        ./s21_cat -"$flag" "$txt" > "simple_error_$txt_$flag.txt"
        echo "---------------------- $flag $txt ------------------------- FAIL -----"
        echo "Flag -$flag: FAIL" >> test_results.txt
    fi
    done
done
echo "1 flag and 1 txt: DONE"

if [[ "$OSTYPE" == "darwin"* ]]; then
for txt1 in "${txts[@]}"
do
    for txt2 in "${txts[@]}"
    do
        for flag in "${flags[@]}"
        do

        ./s21_cat -"$flag" $txt1 $txt2 > "s21_cat_output_$flag.txt"
        cat -"$flag" $txt1 $txt2 > "cat_output_$flag.txt"

        if cmp "s21_cat_output_$flag.txt" "cat_output_$flag.txt"
        then
            echo "Flag -$flag: SUCCESS" >> test_results.txt
        else
            ./s21_cat -"$flag" "$txt1" "$txt2" > "simple_error_$txt_$flag.txt"
            echo "---------------------- $flag $txt1 $txt2 ------------------------- FAIL -----"
            echo "Flag -$flag: FAIL" >> test_results.txt
        fi
        done
    done
done
echo "1 flag and 2 txts: DONE"
fi

for flag1 in "${flags[@]}"
do
    for flag2 in "${flags_2[@]}"
    do
        for txt in "${txts[@]}"
        do

        ./s21_cat -"$flag1" -"$flag2" $txt > "s21_cat_output_$txt_$flag1_$flag2.txt"
        cat -"$flag1" -"$flag2" $txt > "cat_output_$txt_$flag1_$flag2.txt"

        if cmp "s21_cat_output_$txt_$flag1_$flag2.txt" "cat_output_$txt_$flag1_$flag2.txt"
        then
            echo "Flag -$flag1 -$flag2: SUCCESS" >> test_results.txt
        else
            ./s21_cat -"$flag1" -"$flag2" "$txt" > "simple_error_$txt_$flag1_$flag2.txt"
            echo "---------------------- $flag1 $flag2 $txt ------------------------- FAIL -----"
            echo "Flag -$flag1 -$flag2: FAIL" >> test_results.txt
        fi
        done
    done
done
echo "2 flag and 1 txt: DONE"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
echo "_____________________ -Test flags_gnu- ______________________"
echo "       E  T  -number-nonblank  -number  -squeeze-blank       "
for txt in "${txts[@]}"
do
    for ((i=0; i<${#flags_gnu[@]}; i++))
    do
        flag="${flags_gnu[i]}"

        ./s21_cat -"$flag" "$txt" > "s21_cat_output_$flag.txt"
        cat -"$flag" "$txt" > "cat_output_$flag.txt"

        if cmp "s21_cat_output_$flag.txt" "cat_output_$flag.txt"
        then
            echo "Flag -$flag: SUCCESS" >> test_results.txt
        else
            ./s21_cat -"$flag" "$txt" > "gnu_error_$txt_$flag.txt"
            echo "------------------- -$flag $txt ---------------------- FAIL -----"
            echo "Flag -$flag: FAIL" >> test_results.txt
        fi
    done
done
echo "GNU flags: DONE"
fi
echo

success_count=$(grep -c "SUCCESS" test_results.txt)
fail_count=$(grep -c "FAIL" test_results.txt)
total_count=$((success_count + fail_count))

echo "Total test cases: $total_count"
echo "Success: $success_count"
echo "Fail: $fail_count"

rm -f s21_cat_output_*.txt cat_output_*.txt test_results.txt

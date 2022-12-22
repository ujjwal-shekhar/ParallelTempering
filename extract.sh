#!/bin/bash

# number of replicas
repls=10

# number of production steps when doing the swapping thing.
prodss=10

mkdir data

for ((i = 1; i <= $repls; i++)); do
    touch ./data/data_$i
    echo "[" >>./data/data_$i
done

find_energy_2() {
    count=$(grep -o ENERGY ./main/output_$1/prod_$2/energy_out.log | wc -l)
    for ((pp = 11; pp <= $count; pp++)); do
        line=$(awk "/ENERGY/{++n; if (n==$pp) { print NR; exit}}" ./main/output_$1/prod_$2/energy_out.log)
        temp=$(awk "NR==$line{ print; exit }" ./main/output_$1/prod_$2/energy_out.log)
        value=(${temp})
        energy=${value[11]}
        echo $energy"," >>./data/data_$1
    done

}

for ((i = 1; i <= $repls; i++)); do
    for ((j = 0; j <= $prodss; j++)); do
        find_energy_2 $i $j
    done
    echo "]" >>./data/data_$i
done

#!/bin/bash
pwd
name="avoid_rnd_4d"
VAR=0.05
Name_walk="Walk"

for i in {1..12}
do
    rm -r entrada.dat
    echo $((i))>>entrada.dat # introduzco valor del bloque

    g++ -std=c++17 -Wall -g -fsanitize=address -fsanitize=leak -fsanitize=undefined  -O3 $name.cpp -o $name.x
    #/usr/bin/time ./$name.x > $name.txt
    ./$name.x > $name.txt



    cat <<EOF> $name.gp



set term pdf
set output "Mean_Rand_walk_vs_steps.pdf"
set xlabel "Steps"
set ylabel "<x^2>"
set grid
#set xtics 50
#set ytics 250
#set mxtics 2
#set mytics 2
#set logscale x 
#set logscale y
set key right bottom box
g(x)=x
plot [][] "$name.txt" u 1:2 w lp ps $VAR lt rgb "red" pointtype 7, g(x) w lp ps $VAR lt rgb "blue" pointtype 7


#f(x) = m*x + b
#fit f(x) "$name.txt" using (log(\$1)):(log(\$2)) via m,b

set term pdf
set output "ajuste.pdf
set xlabel "log(Steps)"
set ylabel "log(<x^2>)"
set fit quiet #Evita imprimir ajuste en consola
f(x) = a*x + b
a=1
b=1
fit f(x) "$name.txt" using (log(\$1)):(log(\$2)) via a,b
#set fit logfile '/dev/null' #no crear un archivo fit.log
print "pendiente of a is: ", a
#set label "a=%6.2f", a, "+/- %6.2f", a_err
save fit "datos_ajuste.txt
plot "$name.txt" using (log(\$1)):(log(\$2)), f(x) title sprintf("y=m*x+b, m=%.4f; b=%.4f", a, b)


EOF
gnuplot $name.gp

#okular Rand_walk_vs_steps.pdf &
#okular Mean_Rand_walk_vs_steps.pdf &
#okular ajuste.pdf &
done

#for i in {1..12}
#do
    # echo $((N))
  #  rm -r entrada.dat
 #   echo $((i))>>entrada.dat # introduzco valor del bloque
   
  #  N=$((i*2))
  #  rm -r entrada.dat
#done

#kate entrada.dat &

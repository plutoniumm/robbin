all:
	ocamlc -I +unix -o ./battery unix.cma ./scripts/battery.ml;
	gcc -o ./beep ./scripts/beep.c;

# Makefile 예제
MODULES = rk4_module.mod
OBJECTS = rk4_module.o main.o
FC = gfortran
FLAGS = -Wall -Wextra -O2

all: runge_kutta

%.o: %.f90
	$(FC) -c $< $(FLAGS)

runge_kutta: $(OBJECTS)
	$(FC) -o runge_kutta $(OBJECTS)

clean:
	rm -f *.o *.mod runge_kutta

rebuild: clean all
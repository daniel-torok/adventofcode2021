
include ../make.inc

LINKS = \
-I$(OBJ_DIRECTORY) \
-I$(LIB_DIRECTORY)

EXECUTABLE = ./solution

type_Node.o: \
type_Node.f90
	$(FC) $(FFLAGS) -c type_Node.f90 $(LINKS) \
	 -o $(OBJ_DIRECTORY)/$@ -J$(LIB_DIRECTORY)

type_Stack.o: \
type_Node.o\
type_Stack.f90
	$(FC) $(FFLAGS) -c type_Stack.f90 $(LINKS) \
	 -o $(OBJ_DIRECTORY)/$@ -J$(LIB_DIRECTORY)

solution.o: \
type_Stack.o \
solution.f90
	$(FC) $(FFLAGS) -c solution.f90 $(LINKS) \
	-o $(OBJ_DIRECTORY)/$@

exec: $(OBJ)
	$(FC) $(FFLAGS) -o ../build/$(EXECUTABLE) $(OBJS) $(LINKS)

run:
	$(MAKE) clean
	$(MAKE) exec; ../build/$(EXECUTABLE)

clean:
	rm -f $(OBJS) $(EXECUTABLE) $(LIB_DIRECTORY)/*.mod
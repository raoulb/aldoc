#
#  Copyright (c)1995, 2001 by ETH Zuerich
#
#  Author: Niklaus Mannhart (mannhart@inf.ethz.ch)
#
#  last update: 8/7/01 - added aldoc2html
#
# ---------------------------------------------------------------------
#  This file is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
#  by the Free Software Foundation version 2 of the license.
#
#  This file is distributed in the hope that it will be usefull,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#  General Public License for more details.
# ---------------------------------------------------------------------

# Customization
#

# which C compiler (it must be an ANSI C compiler!)
#CC=acc
CC=gcc

# LATEX must be a LaTeX2e version!
LATEX=pdflatex

# MAKEINDEX - usually you don't have to change the name.
MAKEINDEX=makeindex

# End of Customization.


# --- Below this line on your own risk! ---

all:	aldoc.cls aldoc.pdf extract aldoc2html example

extract:	extract.c flags.o
	$(CC) -o extract extract.c flags.o

aldoc2html: flags.o aldoc2html.c
	$(CC) -o aldoc2html aldoc2html.c flags.o

flags.o:	flags.c flags.h
	$(CC) -c flags.c

aldoc.pdf:	aldoc.dtx
	$(LATEX) aldoc.dtx
	$(MAKEINDEX) -s gind.ist aldoc
	$(MAKEINDEX) -s gglo.ist -o aldoc.gls aldoc.glo
	$(LATEX) aldoc.dtx

aldoc.cls:	aldoc.dtx
	$(LATEX) aldoc.ins

example:	extract aldoc.cls
	./extract -m ALDOC -o example/example.tex example/example.as
	$(LATEX) -output-directory example manual.tex
	$(LATEX) -output-directory example manual.tex

clean:
	${RM} *.aux *.cls *.dvi *.glo *.gls *.idx *.ilg *.ind *.log *.ps *.pdf *.out *.o *~ extract aldoc2html
	${RM} example/*.log example/*.aux example/*.idx example/*.out example/*.pdf example/example.tex

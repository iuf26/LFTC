bison -d -v bison-parser.y
lex parser.l
gcc lex.yy.c bison-parser.tab.c
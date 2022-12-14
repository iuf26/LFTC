compilare bison:  bison -d -v bison-parser.y

compilare lex:
lex parser.l
gcc lex.yy.c bison-parser.tab.c
./a.out in.txt

%type < type > nonterminal … Here nonterminal is the name of a nonterminal symbol, 
and type is the name given in the %union to the alternative that you want (see The Union Declaration). 
You can give any number of nonterminal symbols in the same %type declaration, if they have the same value type.


%union declaration specifies the entire collection of possible data types for semantic values. 
The keyword %union is followed by braced code containing the same thing that goes inside a union in C. 
For example: %union { double val; symrec *tptr; } This says that the two alternative types are double and symrec *


int main (){
	float c[2];
    float r;
    float PI; 
    PI = 3.1415; 
    cin>>r;
    a = a-2;
    a = -a;
    b = 4*4/4-2+5;
     while (a<10){
      
    }
    return 0;

   
   
}



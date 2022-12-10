compilare bison:  bison -d -v bison-parser.y

compilare lex:
lex parser.l
gcc lex.yy.c 
./a.out in.txt

%type < type > nonterminal … Here nonterminal is the name of a nonterminal symbol, 
and type is the name given in the %union to the alternative that you want (see The Union Declaration). 
You can give any number of nonterminal symbols in the same %type declaration, if they have the same value type.


%union declaration specifies the entire collection of possible data types for semantic values. 
The keyword %union is followed by braced code containing the same thing that goes inside a union in C. 
For example: %union { double val; symrec *tptr; } This says that the two alternative types are double and symrec *


int main(){
int n;
int x;
int suma;
cin >> n;
suma =454;
varmo = 432ul;
int l =54;

while (n>0){
			 cin >> x;
			suma=suma + x;
            n = n - 10;
			
		}
cout << suma;
	return 0;
}



%{
#include <stdio.h>
#include <string.h>

#include <stdio.h>  
#include <math.h>  
#include <stdlib.h> 
int yylex();
char* yytext;
int yyerror(char *s);
extern FILE *yyin;
%}

%token OUTOPF INOPF RETURN MAIN LEFT_PAR RIGHT_PAR LEFT_BR RIGHT_BR PLUS MINUS DIV MUL MOD INOP OUTOP IFSTMT WHILESTMT INTDECL FLOATDECL EQUALS INTEGER FLOAT OTHER SEMICOLON ID IDVECTOR RELATION
%left <operator> EQUALS
%type <id> ID
%type <int_number> INTEGER
%type <float_number> FLOAT

%union{
	  char id[250];
      char id_vector[250];
      int int_number;
      float float_number;
}

%%

prog:
  | header lista_decl lista_isntr final
;

header: INTDECL MAIN LEFT_PAR RIGHT_PAR LEFT_BR

lista_decl: decl SEMICOLON
            | decl SEMICOLON lista_decl

decl: tip variabila 
tip: INTDECL | FLOATDECL


lista_isntr: 
    | instr SEMICOLON lista_isntr

instr: | attr | inout | if_exp | while_exp

attr: ID EQUALS exp

const: INTEGER 
    | FLOAT

variabila: ID
    | IDVECTOR

exp: 
    | exp MINUS const
    | exp PLUS const
    | exp DIV const
    | exp MUL const
    | const
    | variabila
    | exp PLUS variabila
    | exp MINUS variabila
    | exp DIV variabila
    | exp MOD variabila
    | exp MUL variabila


inout: INOP INOPF variabila | OUTOP OUTOPF exp
if_exp: IFSTMT LEFT_PAR condition RIGHT_PAR LEFT_BR lista_isntr RIGHT_BR
while_exp: WHILESTMT LEFT_PAR condition RIGHT_PAR LEFT_BR lista_isntr RIGHT_BR
condition: exp RELATION exp

final: RETURN INTEGER SEMICOLON RIGHT_BR {printf("Program respects the grammar rules!\n"); return 0;}
;


%%


#define CAPACITY 200 // Size of the Hash Table

unsigned long hash_function(char* str) {
    unsigned long i = 0;
    for (int j=0; str[j]; j++)
        i += str[j];
    return i % CAPACITY;
}

typedef struct Ht_item Ht_item;

// Define the Hash Table Item here
struct Ht_item {
    char* key;
    int value;
};


typedef struct LinkedList LinkedList;

// Define the Linkedlist here
struct LinkedList {
    Ht_item* item; 
    LinkedList* next;
};


typedef struct HashTable HashTable;

// Define the Hash Table here
struct HashTable {
    // Contains an array of pointers
    // to items
    Ht_item** items;
    LinkedList** overflow_buckets;
    int size;
    int count;
};


static LinkedList* allocate_list () {
    // Allocates memory for a Linkedlist pointer
    LinkedList* list = (LinkedList*) malloc (sizeof(LinkedList));
    return list;
}

static LinkedList* linkedlist_insert(LinkedList* list, Ht_item* item) {
    // Inserts the item onto the Linked List
    if (!list) {
        LinkedList* head = allocate_list();
        head->item = item;
        head->next = NULL;
        list = head;
        return list;
    } 
    
    else if (list->next == NULL) {
        LinkedList* node = allocate_list();
        node->item = item;
        node->next = NULL;
        list->next = node;
        return list;
    }

    LinkedList* temp = list;
    while (temp->next->next) {
        temp = temp->next;
    }
    
    LinkedList* node = allocate_list();
    node->item = item;
    node->next = NULL;
    temp->next = node;
    
    return list;
}

static Ht_item* linkedlist_remove(LinkedList* list) {
    // Removes the head from the linked list
    // and returns the item of the popped element
    if (!list)
        return NULL;
    if (!list->next)
        return NULL;
    LinkedList* node = list->next;
    LinkedList* temp = list;
    temp->next = NULL;
    list = node;
    Ht_item* it = NULL;
    memcpy(temp->item, it, sizeof(Ht_item));
    free(temp->item->key);
    //free(temp->item->value);
    free(temp->item);
    free(temp);
    return it;
}

static void free_linkedlist(LinkedList* list) {
    LinkedList* temp = list;
    while (list) {
        temp = list;
        list = list->next;
        free(temp->item->key);
      //  free(temp->item->value);
        free(temp->item);
        free(temp);
    }
}

static LinkedList** create_overflow_buckets(HashTable* table) {
    // Create the overflow buckets; an array of linkedlists
    LinkedList** buckets = (LinkedList**) calloc (table->size, sizeof(LinkedList*));
    for (int i=0; i<table->size; i++)
        buckets[i] = NULL;
    return buckets;
}

static void free_overflow_buckets(HashTable* table) {
    // Free all the overflow bucket lists
    LinkedList** buckets = table->overflow_buckets;
    for (int i=0; i<table->size; i++)
        free_linkedlist(buckets[i]);
    free(buckets);
}


Ht_item* create_item(char* key, int value) {
    // Creates a pointer to a new hash table item
    Ht_item* item = (Ht_item*) malloc (sizeof(Ht_item));
    item->key = (char*) malloc (strlen(key) + 1);
    //item->value = (char*) malloc (strlen(value) + 1);
    
    strcpy(item->key, key);
    //strcpy(item->value, value);
	item->value = value;	
    return item;
}

HashTable* create_table(int size) {
    // Creates a new HashTable
    HashTable* table = (HashTable*) malloc (sizeof(HashTable));
    table->size = size;
    table->count = 0;
    table->items = (Ht_item**) calloc (table->size, sizeof(Ht_item*));
    for (int i=0; i<table->size; i++)
        table->items[i] = NULL;
    table->overflow_buckets = create_overflow_buckets(table);

    return table;
}

void free_item(Ht_item* item) {
    // Frees an item
    free(item->key);
    //free(item->value);
    free(item);
}

void free_table(HashTable* table) {
    // Frees the table
    for (int i=0; i<table->size; i++) {
        Ht_item* item = table->items[i];
        if (item != NULL)
            free_item(item);
    }

    free_overflow_buckets(table);
    free(table->items);
    free(table);
}

void handle_collision(HashTable* table, unsigned long index, Ht_item* item) {
    LinkedList* head = table->overflow_buckets[index];

    if (head == NULL) {
        // We need to create the list
        head = allocate_list();
        head->item = item;
        table->overflow_buckets[index] = head;
        return;
    }
    else {
        // Insert to the list
        table->overflow_buckets[index] = linkedlist_insert(head, item);
        return;
    }
 }

int ht_insert(HashTable* table, char* key, int value) {
    // Create the item
    Ht_item* item = create_item(key, value);

    // Compute the index
    unsigned long index = hash_function(key);

    Ht_item* current_item = table->items[index];
    
    if (current_item == NULL) {
        // Key does not exist.
        if (table->count == table->size) {
            // Hash Table Full
            printf("Insert Error: Hash Table is full\n");
            // Remove the create item
            free_item(item);
            return 3;
        }
        
        // Insert directly
        table->items[index] = item; 
        table->count++;
    }

    else {
            // Scenario 1: We only need to update value
            if (strcmp(current_item->key, key) == 0) {
                //strcpy(table->items[index]->value, value);
               			//do nothing
		 return 2; 
            }
    
        else {
            // Scenario 2: Collision
            handle_collision(table, index, item);
            return 1;
        }
    }
    return 80;
}

int ht_search(HashTable* table, char* key) {
    // Searches the key in the hashtable
    // and returns NULL if it doesn't exist
    int index = hash_function(key);
    Ht_item* item = table->items[index];
    LinkedList* head = table->overflow_buckets[index];

    // Ensure that we move to items which are not NULL
    while (item != NULL) {
        if (strcmp(item->key, key) == 0)
            return item->value;
        if (head == NULL)
            return -1;
        item = head->item;
        head = head->next;
    }
    return -1;
}


void print_search(HashTable* table, char* key) {
    int val;
    if ((val = ht_search(table, key)) == -1) {
        printf("%s does not exist\n", key);
        return;
    }
    else {
        printf("Key:%s, Value:%d\n", key, val);
    }
}

void print_table(HashTable* table) {
    printf("\n---------TS----------\n");
    for (int i=0; i<table->size; i++) {
        if (table->items[i]) {
            printf("Index:%d, Key:%s, Value:%d", i, table->items[i]->key, table->items[i]->value);
            if (table->overflow_buckets[i]) {
                printf(" => Overflow Bucket => ");
                LinkedList* head = table->overflow_buckets[i];
                while (head) {
                    printf("Key:%s, Value:%d ", head->item->key, head->item->value);
                    head = head->next;
                }
            }
            printf("\n");
        }
    }
    printf("-------------------\n");
}

void printFIP(int fip[][2],int size){

	printf("------------FIP TABLE-----------\n");
		for(int i = 0;i<size;i++) {
			if(fip[i][1] > 0)
			{printf("Atom code: %d ,position in TS: %d\n",fip[i][0],fip[i][1]);}
			else{
				printf("Atom code: %d\n",fip[i][0]);

			}	

		}

 printf("-------------------\n");
	}



int main(int argc, char** argv) {
	
 

	int atomsNr = 0;
	FILE *fp,*fp2;
	fp = fopen(argv[1], "r");
	
	/* yyin - takes the file pointer which contains the input*/
	yyin = fp;

	/* yylex() - this is the main flex function which runs the Rule Section*/ 
		
	 int ntoken = yylex();
		
	
	while(ntoken){
		atomsNr++;
		ntoken=yylex();
		if(ntoken == -1){
			fclose(fp);return 0;
		}
	
	}
	fclose(fp);
	fp2 = fopen(argv[1],"r");
	yyin = fp2;
	 ntoken = yylex();
         const int ATOMS_NR = atomsNr;
	int FIP[ATOMS_NR][2];
	int fipCnt = 0;
	int cnt = 1;
	HashTable* TS = create_table(CAPACITY);
          while(ntoken){
		FIP[fipCnt][1] = 0;
        if(ntoken == ID || ntoken == INTEGER || ntoken == FLOAT || ntoken == IDVECTOR)	
		{int res = ht_insert(TS,yytext,cnt);

			if(res != 2)
			cnt++;
			int positionInTs = ht_search(TS,yytext);
			if(positionInTs > -1)
			FIP[fipCnt][1] = positionInTs;
		}
    			              
		FIP[fipCnt][0] = ntoken;		
                  ntoken=yylex();
		fipCnt++;
 
         }
 		
	print_table(TS);
	free_table(TS);
	fclose(fp2);
	printFIP(FIP,ATOMS_NR);

        if (argc == 2) {
        yyin = fopen(argv[1], "r");
        yyparse();
    }

    
	return 0;
}
int yyerror(char *s)
{
	printf("Syntax Error on line %s\n", s);
	return 0;
}






#include "ConversionString.h"

void revert(const char *src, char *output) {
    
    int len=(int)strlen(src);
    char *dest = (char *)malloc(len+1);
    const char *a=&src[len-1];
    char *b=dest;
    while(len-- != 0) {
        *b++ = *a--;
    }
    *(b++)='\0';
    sprintf(output,"%s",dest);
    free(dest);
    dest = NULL;
}

//Initializing 'char *' with an expression of type 'const char *' discards qualifiers

























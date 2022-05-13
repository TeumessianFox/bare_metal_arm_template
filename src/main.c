#include <stdbool.h>

int main(void);
int main(void){
    int volatile counter = 0;
    while(true){
        counter++;
    }
    return 0;
}

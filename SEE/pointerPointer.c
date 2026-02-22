#include <stdlib.h>
#include <stdio.h>

void allocate_int(int **pointer_pointer, int value) {
    printf("RUNNING:\n");
    printf("int *ptr = (int *)malloc(sizeof(int));\n");

    int *ptr = (int *)malloc(sizeof(int));

    printf("ptr: %p\n\n", ptr);

    *pointer_pointer = ptr;
    **pointer_pointer = value;
}

int main() {
    int *pointer = NULL;

    printf("original value for pointer will point to NULL: %p\n", pointer);
    printf("allocated address for original NULL pointer on the stack: %p\n\n", &pointer);

    allocate_int(&pointer, 10);

    printf("updated allocated value: %d\n", *pointer);
    printf("updated allocated address: %p\n\n", pointer);

    free(pointer);
}

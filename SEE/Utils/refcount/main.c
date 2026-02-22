#include <stdio.h>

#include "snekobject.h"

int main() {
    snek_object_t *obj = new_snek_integer(10);
    printf("%d\n", obj->data.v_int);
    printf("%p\n", obj);
}

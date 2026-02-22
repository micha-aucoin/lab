#include "sneknew.h"
#include <stdlib.h>
#include <string.h>

#include "snekobject.h"
#include "vm.h"

snek_object_t *_new_snek_object(vm_t *vm) {
    snek_object_t *obj = calloc(1, sizeof(snek_object_t));
    if (obj == NULL) { return NULL; }
    //vm_track_object(vm, obj);
    stack_push(vm->objects, obj);
    return obj;
}

snek_object_t *new_snek_array(vm_t *vm, size_t size) {
    snek_object_t *obj = _new_snek_object(vm);
    if (obj == NULL) { return NULL; }

    obj->kind = ARRAY;
    obj->data.v_array.size = size;
    obj->data.v_array.elements = calloc(size, sizeof(snek_object_t *));
    if (obj->data.v_array.elements == NULL) { free(obj); return NULL; }

    return obj;
}

snek_object_t *new_snek_vector3(
    vm_t *vm, snek_object_t *x, snek_object_t *y, snek_object_t *z
) {
    if (x == NULL || y == NULL || z == NULL) { return NULL; }

    snek_object_t *obj = _new_snek_object(vm);
    if (obj == NULL) { return NULL; }

    obj->kind = VECTOR3;
    obj->data.v_vector3 = (snek_vector_t){.x = x, .y = y, .z = z};
    return obj;
}

snek_object_t *new_snek_integer(vm_t *vm, int value) {
    snek_object_t *obj = _new_snek_object(vm);
    if (obj == NULL) { return NULL; }

    obj->kind = INTEGER;
    obj->data.v_int = value;
    return obj;
}

snek_object_t *new_snek_float(vm_t *vm, float value) {
    snek_object_t *obj = _new_snek_object(vm);
    if (obj == NULL) { return NULL; }

    obj->kind = FLOAT;
    obj->data.v_float = value;
    return obj;
}

snek_object_t *new_snek_string(vm_t *vm, char *value) {
    snek_object_t *obj = _new_snek_object(vm);
    if (obj == NULL) { return NULL; }

    obj->kind = STRING;
    obj->data.v_string = malloc(strlen(value) + 1);
    if (obj->data.v_string == NULL) { free(obj); return NULL; }
    strcpy(obj->data.v_string, value);

    return obj;
}

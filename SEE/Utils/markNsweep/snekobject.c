#include "snekobject.h"

void snek_object_free(snek_object_t *obj) {
    switch (obj->kind) {
        case INTEGER:
        case FLOAT:
            break;
        case STRING:
            free(obj->data.v_string);
            break;
        case VECTOR3:
            break;
        case ARRAY:
            break;
        default:
            free(obj->data.v_array.elements);
            break;
    }
    free(obj);
}


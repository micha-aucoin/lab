#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "snekobject.h"

snek_object_t *snek_add(snek_object_t *a, snek_object_t *b) {
    if (a == NULL || b == NULL) { return NULL; }
    if (a->kind == INTEGER) {
        if (b->kind == INTEGER) { return new_snek_integer(a->data.v_int + b->data.v_int); }
        if (b->kind == FLOAT) { return new_snek_float(a->data.v_int + b->data.v_float); }
        return NULL;
    }
    if (a->kind == FLOAT) {
        if (b->kind == INTEGER) { return new_snek_float(a->data.v_float + b->data.v_int); }
        if (b->kind == FLOAT) { return new_snek_float(a->data.v_float + b->data.v_float); }
        return NULL;
    }
    if (a->kind == STRING) {
        if (b->kind != STRING) { return NULL; }
        int new_len = strlen(a->data.v_string) + strlen(b->data.v_string) + 1;
        char *tempstr = calloc(new_len, sizeof(char));
        strcat(tempstr, a->data.v_string);
        strcat(tempstr, b->data.v_string);
        snek_object_t *obj = new_snek_string(tempstr);
        free(tempstr);
       return obj;
    }
    if (a->kind == VECTOR3) {
        if (b->kind != VECTOR3) { return NULL; }
        snek_object_t *x = snek_add(a->data.v_vector3.x, b->data.v_vector3.x);
        snek_object_t *y = snek_add(a->data.v_vector3.y, b->data.v_vector3.y);
        snek_object_t *z = snek_add(a->data.v_vector3.z, b->data.v_vector3.z);
        return new_snek_vector3(x, y, z);
    }
    if (a->kind == ARRAY) {
        if (b->kind != ARRAY) { return NULL; }
        int a_size = a->data.v_array.size;
        int size = a->data.v_array.size + b->data.v_array.size;
        snek_object_t *arr = new_snek_array(size);
        for (int i = 0; i < a_size; i++) {
            snek_array_set(arr, i, snek_array_get(a, i));
        }
        for (int i = a_size; i < size; i++) {
            snek_array_set(arr, i, snek_array_get(b, i));
        }
        return arr;
    }
    return NULL;
}

int snek_length(snek_object_t *obj) {
    if (obj == NULL) { return -1; }
    if (obj->kind == INTEGER) { return 1; }
    if (obj->kind == FLOAT) { return 1; }
    if (obj->kind == VECTOR3) { return 3; }
    if (obj->kind == STRING) { return strlen(obj->data.v_string); }
    if (obj->kind == ARRAY) { return obj->data.v_array.size; }
    return -1;
}

snek_object_t *_new_snek_object(void) {
    snek_object_t *obj = calloc(1, sizeof(snek_object_t));
    if (obj == NULL) { return NULL; }
    obj->refcount = 1;
    return obj;
}

void refcount_free(snek_object_t *obj) {
    switch (obj->kind) {
        case INTEGER:
        case FLOAT:
            break;
        case STRING:
            free(obj->data.v_string);
            break;
        case VECTOR3:
            refcount_dec(obj->data.v_vector3.x);
            refcount_dec(obj->data.v_vector3.y);
            refcount_dec(obj->data.v_vector3.z);
            break;
        case ARRAY:
            for(size_t i = 0; i < obj->data.v_array.size; i++) {
                refcount_dec(obj->data.v_array.elements[i]);
            }
            free(obj->data.v_array.elements);
            break;
        default:
            printf("from refcount_free func - the object kind is unknown\n");
            break;
    }
    free(obj);
}

void refcount_inc(snek_object_t *obj) {
    if (obj == NULL) { return; }
    obj->refcount++;
}

void refcount_dec(snek_object_t *obj) {
    if (obj == NULL) { return; }
    obj->refcount--;
    if (obj->refcount == 0) { refcount_free(obj); }
}

snek_object_t *new_snek_array(size_t size) {
    snek_object_t *obj = _new_snek_object();
    if (obj == NULL) { return NULL; }

    obj->kind = ARRAY;
    obj->data.v_array.size = size;
    obj->data.v_array.elements = calloc(size, sizeof(snek_object_t *));
    if (obj->data.v_array.elements == NULL) { free(obj); return NULL; }

    return obj;
}

bool snek_array_set(snek_object_t *array, size_t index, snek_object_t *value) {
    if (array == NULL || value == NULL) { return false; }
    if (array->kind != ARRAY) { return false; }
    if (index >= array->data.v_array.size || index < 0) { return false; }
    refcount_inc(value);
    if (array->data.v_array.elements[index] != NULL) {
        refcount_dec(array->data.v_array.elements[index]);
    }
    array->data.v_array.elements[index] = value;
    return true;
}

snek_object_t *snek_array_get(snek_object_t *array, size_t index) {
    if (array == NULL) { return NULL; }
    if (array->kind != ARRAY) { return NULL; }
    if (index >= array->data.v_array.size || index < 0) { return false; }
    return array->data.v_array.elements[index];
}

snek_object_t *new_snek_vector3(
    snek_object_t *x, snek_object_t *y, snek_object_t *z
) {
    if (x == NULL || y == NULL || z == NULL) { return NULL; }

    snek_object_t *obj = _new_snek_object();
    if (obj == NULL) { return NULL; }

    obj->kind = VECTOR3;
    obj->data.v_vector3 = (snek_vector_t){.x = x, .y = y, .z = z};

    refcount_inc(obj->data.v_vector3.x);
    refcount_inc(obj->data.v_vector3.y);
    refcount_inc(obj->data.v_vector3.z);

    return obj;
}

snek_object_t *new_snek_integer(int value) {
    snek_object_t *obj = _new_snek_object();
    if (obj == NULL) { return NULL; }

    obj->kind = INTEGER;
    obj->data.v_int = value;
    return obj;
}

snek_object_t *new_snek_float(float value) {
    snek_object_t *obj = _new_snek_object();
    if (obj == NULL) { return NULL; }

    obj->kind = FLOAT;
    obj->data.v_float = value;
    return obj;
}

snek_object_t *new_snek_string(char *value) {
    snek_object_t *obj = _new_snek_object();
    if (obj == NULL) { return NULL; }

    obj->kind = STRING;
    obj->data.v_string = malloc(strlen(value) + 1);
    if (obj->data.v_string == NULL) { free(obj); return NULL; }
    strcpy(obj->data.v_string, value);

    return obj;
}


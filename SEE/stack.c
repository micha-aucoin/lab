#include "stack.h"
#include <stdlib.h>
#include <stdio.h>


void stack_push(stack_t *stack, void *obj) {
    if (stack->count == stack->capacity) {
        stack->capacity *= 2;
        stack->data = realloc(stack->data, stack->capacity * sizeof(void *));
        if (stack->data == NULL) {
            stack->capacity /= 2;
            return;
        }
    }
    stack->data[stack->count] = obj;
    stack->count++;
    return;
}

stack_t *stack_new(size_t capacity) {
    stack_t *new_stack = malloc(sizeof(stack_t));
    if (new_stack == NULL) {
        return NULL;
    }
    new_stack->count = 0;
    new_stack->capacity = capacity;
    new_stack->data = malloc(new_stack->capacity * sizeof(void *));
    if (new_stack->data == NULL) {
        free(new_stack);
        return NULL;
    }
    return new_stack;
}

int main() {
    stack_t *s = stack_new(2);
    printf("stack->count    = %zu\n", s->count);
    printf("stack->capacity = %zu\n\n", s->capacity);

    char *a = "Hello";
    char *b = "World";
    char *c = "Goodbye";

    // After first push
    stack_push(s, a);
    printf("stack->count    = %zu\n", s->count);
    printf("stack->capacity = %zu\n", s->capacity);
    printf("s->data[0]      = %s\n\n", (char *)s->data[0]);

    // After second push
    stack_push(s, b);
    printf("stack->count    = %zu\n", s->count);
    printf("stack->capacity = %zu\n", s->capacity);
    printf("s->data[0]      = %s\n", (char *)s->data[0]);
    printf("s->data[1]      = %s\n\n", (char *)s->data[1]);

    // After third push (causes reallocation)
    stack_push(s, c);
    printf("stack->count    = %zu\n", s->count);
    printf("stack->capacity = %zu\n", s->capacity);
    printf("s->data[0]      = %s\n", (char *)s->data[0]);
    printf("s->data[1]      = %s\n", (char *)s->data[1]);
    printf("s->data[2]      = %s\n\n", (char *)s->data[2]);

    free(s->data);
    free(s);
    return 0;
}


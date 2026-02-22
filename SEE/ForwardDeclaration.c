#include <stdio.h>
#include <string.h>

#include "ForwardDeclaration.h"


node_t new_node(char *name) {
    node_t node = {
        .name = name,
        .child = NULL
    };
    return node;
}

int main() {
    node_t gramps = new_node("gramps");
    node_t parent = new_node("parent");
    node_t child = new_node("child");
    node_t small = new_node("small");

    gramps.child = &parent;
    parent.child = &child;
    child.child = &small;

    printf("gramps.name                       = %s\n", gramps.name);
    printf("gramps.child                      = %p\n", gramps.child);
    printf("gramps.child->name                = %s\n", gramps.child->name);
    printf("gramps.child->child               = %p\n", gramps.child->child);
    printf("gramps.child->child->name         = %s\n", gramps.child->child->name);
    printf("gramps.child->child->child        = %p\n", gramps.child->child->child);
    printf("gramps.child->child->child->name  = %s\n", gramps.child->child->child->name);
    printf("gramps.child->child->child->child = %p\n", gramps.child->child->child->child);

    return 0;
}

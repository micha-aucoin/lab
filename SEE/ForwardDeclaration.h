typedef struct Node node_t;

typedef struct Node {
    char *name;
    node_t *child;
} node_t;

node_t new_node(char *name);

class Node:
    def __init__(self, val):
        self.val = val
        self.next: Node | None = None

    def __repr__(self):
        return self.val


class LinkedListQueue:
    def __init__(self):
        self.head: Node | None = None
        self.tail: Node | None = None

    def __iter__(self):
        node = self.head
        while node is not None:
            yield node
            node = node.next

    def __repr__(self):
        nodes = []
        current = self.head
        while current and hasattr(current, "val"):
            nodes.append(current.val)
            current = current.next
        return " -> ".join(nodes)

    def push(self, node: Node):
        if self.head is None:
            self.head = node
            self.tail = node
            return
        self.tail.next = node
        self.tail = node

    def pop(self):
        if self.head is None:
            return None
        if self.head.next:
            popped_item = self.head
            self.head = self.head.next
            return popped_item
        popped_item = self.head
        self.head = None
        self.tail = None
        return popped_item


ll = LinkedListQueue()
ll.push(Node("first"))
ll.push(Node("second"))
ll.push(Node("third"))

print("for loop:")
for node in ll:
    print(node)

print()
print(f"linked_list = {ll}")
print(f"popping {ll.pop()}")
print(f"linked_list = {ll}")

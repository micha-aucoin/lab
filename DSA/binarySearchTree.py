import random


class User:
    def __init__(self, id):
        self.id = id
        user_names = [
            "Blake",
            "Ricky",
            "Shelley",
            "Dave",
            "George",
            "John",
            "James",
            "Mitch",
            "Williamson",
            "Burry",
            "Vennett",
            "Shipley",
            "Geller",
            "Rickert",
            "Carrell",
            "Baum",
            "Brownfield",
            "Lippmann",
            "Moses",
        ]
        self.user_name = f"{user_names[id % len(user_names)]}#{id}"

    def __eq__(self, other):
        return isinstance(other, User) and self.id == other.id

    def __lt__(self, other):
        return isinstance(other, User) and self.id < other.id

    def __gt__(self, other):
        return isinstance(other, User) and self.id > other.id

    def __repr__(self):
        return "".join(self.user_name)


def get_users(num):
    random.seed(1)
    users = []
    ids = []
    for i in range(num * 3):
        ids.append(i)
    random.shuffle(ids)
    ids = ids[:num]
    for id in ids:
        user = User(id)
        users.append(user)
    return users


class BSTNode:
    def __init__(self, val=None):
        self.left = None
        self.right = None
        self.val = val

    def delete(self, val):
        if val is None:
            return None
        if val < self.val and self.left:
            self.left = self.left.delete(val)
            return self
        if val > self.val and self.right:
            self.right = self.right.delete(val)
            return self
        if self.right is None:
            return self.left
        if self.left is None:
            return self.right
        current = self.right
        while current.left is not None:
            current = current.left
        self.val = current.val
        self.right = self.right.delete(current.val)
        return self

    def insert(self, val):
        if self.val is None:
            self.val = val
            return
        if self.val == val:
            return
        if val < self.val and self.left is None:
            self.left = BSTNode(val)
            return
        if val < self.val and self.left:
            self.left.insert(val)
            return
        if self.right is None:
            self.right = BSTNode(val)
            return
        if self.right:
            self.right.insert(val)
            return

    def get_min(self):
        current = self
        while current.left is not None:
            current = current.left
        return current.val

    def get_max(self):
        current = self
        while current.right is not None:
            current = current.right
        return current.val

    def inorder(self, visited):
        if self.left:
            self.left.inorder(visited)
        if self.val:
            visited.append(self.val)
        if self.right:
            self.right.inorder(visited)
        return visited

    def exists(self, val):
        if self.val == val:
            return True
        if val < self.val and self.left:
            return self.left.exists(val)
        if val > self.val and self.right:
            return self.right.exists(val)
        return False

    def height(self):
        if self.val is None:
            return 0

        left_height = self.left.height() if self.left else 0
        right_height = self.right.height() if self.right else 0

        return 1 + max(left_height, right_height)


users = get_users(10)
bst = BSTNode()
for user in users:
    bst.insert(user)

print(f"left: {bst.left}")
print(f"right: {bst.right}")
print(f"value: {bst.val}")

user = users[-5]
bst = bst.delete(user)

print(bst.inorder([]))
print(bst.exists(users[-4]))
print(bst.height())

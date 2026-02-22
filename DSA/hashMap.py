class HashMap:
    def __init__(self, size):
        self.hashmap = [None for i in range(size)]

    def __repr__(self):
        final = ""
        for i, v in enumerate(self.hashmap):
            if v != None:
                final += f" - {str(v)}\n"
        return final

    def insert(self, key, value):
        self.resize()
        index = self.key_to_index(key)
        original_index = index
        first_iteration = True
        while self.hashmap[index] is not None and self.hashmap[index][0] != key:
            if not first_iteration and index == original_index:
                raise Exception("hashmap is full")
            index = (index + 1) % len(self.hashmap)
            first_iteration = False
        self.hashmap[index] = (key, value)

    def get(self, key):
        index = self.key_to_index(key)
        original_index = index
        first_iteration = True
        while self.hashmap[index] is not None:
            if self.hashmap[index][0] == key:
                return self.hashmap[index][1]
            if not first_iteration and index == original_index:
                raise Exception("sorry, key not found")
            index = (index + 1) % len(self.hashmap)
            first_iteration = False
        raise Exception("sorry, this aint suppose to happen")

    def resize(self):
        if len(self.hashmap) == 0:
            self.hashmap.append(None)
        if self.current_load() < 0.05:
            return
        else:
            hashmap_snapshot = self.hashmap
            new_size = len(hashmap_snapshot) * 10
            self.hashmap = [None for i in range(new_size)]
            for key, value in filter(bool, hashmap_snapshot):
                self.insert(key, value)

    def current_load(self):
        num = len(list(filter(bool, self.hashmap)))
        if len(self.hashmap) == 0:
            return 1
        else:
            return num / len(self.hashmap)

    def key_to_index(self, key):
        sum = 0
        for c in key:
            sum += ord(c)
        return sum % len(self.hashmap)


hm = HashMap(0)

print(hm.hashmap)
print("\n\n\n\n")
hm.insert("Billy Beane", 1)
print(hm.hashmap)
print("\n\n\n\n")
hm.insert("Peter Brand", 2)
print(hm.hashmap)
print("\n\n\n\n")
hm.insert("Art Howe", 3)
print(hm.hashmap)
print("\n\n\n\n")
hm.insert("Scott Hatteberg", 4)
print(hm.hashmap)
print("\n\n\n\n")
hm.insert("David Justice", 5)
print(hm.hashmap)
print("\n\n\n\n")
hm.insert("Ron Washington", 6)
print(hm.hashmap)
print("\n\n\n\n")
hm.insert("Paul DePodesta", 7)
print(hm.hashmap)
print("\n\n\n\n")

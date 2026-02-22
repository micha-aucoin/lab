class Trie:
    def __init__(self):
        self.root = {}
        self.end_symbol = "*"

    def add(self, word):
        current = self.root
        for char in word:
            if char not in current:
                current[char] = {}
            current = current[char]
        current[self.end_symbol] = True

    def exists(self, word):
        current = self.root
        for char in word:
            if char not in current:
                return False
            current = current[char]
        return self.end_symbol in current

    def search_level(self, current_level, current_prefix, words):
        """from this prefix, give all matching words"""
        childs = sorted(current_level.keys())
        for char in childs:
            if char != self.end_symbol:
                self.search_level(
                    current_level=current_level[char],
                    current_prefix=current_prefix + char,
                    words=words,
                )
            else:
                words.append(current_prefix)
        return words

    def words_with_prefix(self, prefix):
        """from this prefix, give all matching words"""
        matching = []
        current = self.root
        for char in prefix:
            if char not in current:
                return []
            current = current[char]
        return self.search_level(
            current_level=current,
            current_prefix=prefix,
            words=matching,
        )

    def find_matches(self, document):
        # matches = set()
        # for word in document.split(" "):
        #     current = self.root
        #     for char in word:
        #         char = char.lower()
        #         if char not in current:
        #             break
        #         current = current[char]
        #         if self.end_symbol in current:
        #             matches.add(word)
        # return matches

        matches = set()
        doclen = len(document)
        for i in range(doclen):
            current = self.root
            for j in range(i, doclen):
                char = document[j]
                if char not in current:
                    break
                current = current[char]
                if self.end_symbol in current:
                    matches.add(document[i : j + 1])
        return matches

    def advanced_find_matches(self, document, variations):
        matches = set()
        for i in range(len(document)):
            current = self.root
            for j in range(i, len(document)):
                char = document[j]
                if char in variations:
                    char = variations[char]
                if char not in current:
                    break
                current = current[char]
                if self.end_symbol in current:
                    matches.add(document[i : j + 1])
        return matches

    def longest_common_prefix(self):
        current = self.root
        prefix = ""
        while True:
            childs = sorted(current.keys())
            if self.end_symbol in current:
                break
            if len(childs) == 1:
                prefix = prefix + childs[0]
                current = current[childs[0]]
            else:
                break
        return prefix


trie = Trie()
trie.add("bone")
trie.add("bonner")
# trie.add("trombone")
print(trie.exists("bone"))
print(trie.words_with_prefix("bo"))
print(trie.find_matches(document="trombone bo begins"))
print(
    trie.advanced_find_matches(
        document="tromb0ne bo begins",
        variations={"0": "o"},
    )
)
print(trie.longest_common_prefix())

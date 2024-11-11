def main():
    book_path = 'books/frankenstein.txt'
    text = get_text(book_path)
    num_words = get_word_count(text)
    sorted_char_count = sorted(
        get_char_count(text).items(), 
        key=lambda tuple: tuple[1], 
        reverse=True,)

    # print()
    # print(get_char_count(text))
    # print()
    # print(get_char_count(text).items())
    # print()
    # for tuple in sorted_char_count:
    #     print(tuple)
    print()
    print(f"--- Begin report of {book_path} ---")
    print(f"{num_words} words found in the document")
    print()
    for char, count in sorted_char_count:
        if char.isalpha():
            print(f"The '{char}' character was found {count} times")
    print("--- End report ---")
    print()


def get_text(path:str):
    with open(path) as f:
        return f.read()

def get_word_count(txt:str):
    return len(txt.split())

def get_char_count(txt:str):
    char_dict = {}
    for char in txt:
        lower_char = char.lower()
        if lower_char not in char_dict:
            char_dict[lower_char] = 1
        else:
            char_dict[lower_char] += 1
    return char_dict

main()

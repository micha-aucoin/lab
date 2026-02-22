def power_set(input_set):
    if input_set == []:
        return [[]]
    result = []
    head = input_set[0]
    tail = input_set[1:]
    remaining = power_set(tail)
    for item in remaining:
        result.append([head] + item)
        result.append(item)
    return result

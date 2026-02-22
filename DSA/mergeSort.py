def merge_sort(arr):
    if len(arr) < 2:
        return arr

    mid = len(arr) // 2
    left = arr[mid:]
    right = arr[:mid]

    return merge(
        merge_sort(left),
        merge_sort(right),
    )


def merge(left, right):
    result = []
    i = 0
    j = 0

    while i < len(left) and j < len(right):
        # print(result)
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
            continue
        result.append(right[j])
        j += 1
    while i < len(left):
        result.append(left[i])
        i += 1
    while j < len(right):
        result.append(right[j])
        j += 1

    return result

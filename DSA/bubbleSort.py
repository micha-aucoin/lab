def bubble_sort(arr):
    swapping = True
    end = len(arr)

    while swapping:
        # print(arr)
        swapping = False
        for i in range(1, end):
            if arr[i - 1] > arr[i]:
                arr[i], arr[i - 1] = arr[i - 1], arr[i]
                swapping = True
        end -= 1

    return arr

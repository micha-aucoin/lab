import random
import time


def quicksort_2(nums, low, high):
    if low < high:
        middle = partition(nums, low, high)
        quicksort_2(nums, low, middle - 1)
        quicksort_2(nums, middle + 1, high)


def partition(nums, low, high):
    pivot = nums[high]
    i = low
    for j in range(low, high):
        if nums[j] < pivot:
            nums[i], nums[j] = nums[j], nums[i]
            i += 1
    nums[i], nums[high] = nums[high], nums[i]
    return i


def quicksort_1(arr):
    if len(arr) <= 1:
        return arr

    pivot = arr[0]
    less = [x for x in arr[1:] if x <= pivot]
    greater = [x for x in arr[1:] if x > pivot]

    return quicksort_1(less) + [pivot] + quicksort_1(greater)


# print(f"[] + [1] = {[] + [1]}")
# new_list = [[]]
# new_list.extend([[1]])
# print(f"[[]].extend([[1]]) = {new_list}")


arr_1 = [random.randint(1, 10000) for _ in range(100000)]

print()
print(f"before sort: {arr_1}")
start = time.time()
result = quicksort_1(arr_1)
end = time.time()
print()
print(f"after sort: {result}")
print()
print(f"Took: {end-start:.8f} s")

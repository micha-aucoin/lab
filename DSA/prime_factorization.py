import math


def prime_factors(n):
    prime_factor_list = []
    while (n % 2) == 0:
        n = n // 2
        prime_factor_list.append(2)

    the_square_of_n = int(math.sqrt(n)) + 1
    for i in range(3, the_square_of_n, 2):
        if (n % i) == 0:
            n = n // i
            prime_factor_list.append(i)

    if n > 2:
        prime_factor_list.append(n)

    return sorted(prime_factor_list)


print(prime_factors(73222563173))

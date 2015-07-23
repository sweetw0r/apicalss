from random import randint


def sum_of(n, num_giv):
    l = []  # generated list
    for v in range(n):
        l.append(randint(1, 20))
    print l

    for i in range(n):  # range(n)
        for j in range(i + 1, n):
            if l[i] + l[j] == num_giv:
                print l[i], 'plus', l[j], 'equal', num_giv
    return l
print(sum_of(20, 30))

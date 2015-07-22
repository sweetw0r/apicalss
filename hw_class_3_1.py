from random import randint


def gen(n, x, y):
    l = []
    for v in range(n):
        l.append(randint(x, y))
    return l


run = gen(4, 5, 6)
print run
import random
i = []
while len(i) < 30:
    i.append(random.randint(0, 100))
print i

for x in i:
    if x % 2 == 0:
        print x

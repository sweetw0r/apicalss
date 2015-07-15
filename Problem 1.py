import random
i = []
while len(i) < 30:
    i.append(random.randint(0, 100))
#print i #rows out of tasks should be commented
for x in i:
    if x is 0:
        pass
    elif x % 2 == 0:
        print x

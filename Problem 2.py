import random
while True:
    try:
        i = []
        while len(i) < 30:
            i.append(random.randint(0, 100))
        # print i #rows out of tasks should be commented
        # print i[0] #rows out of tasks should be commented
        max_val = i[0]
        min_val = i[0]
        for x in i:
            #if x is 0:
                #pass
            if x > max_val:
                max_val = x
        for x in i:
            if x is 0:
                pass
            elif x < min_val:
                min_val = x
        print max_val % min_val
    except ZeroDivisionError:
        print "Stop"
        break

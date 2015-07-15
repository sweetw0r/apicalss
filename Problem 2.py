import random
while True:
    try:
        i = []
        while len(i) < 30:
            i.append(random.randint(0, 100))
        print i  #rows out of tasks should be commented
        # print i[0]  #rows out of tasks should be commented
        max_val = i[0]
        min_val = i[0]
        for x in i:
            if x > max_val:
                max_val = x
        print 'Max is', max_val
        for x in i:
            if x == 0:
                pass
            elif x < min_val:
                if x != 0:
                    min_val = x
        print 'Min is', min_val
        print max_val % min_val
    except ZeroDivisionError:
        print "Stop"
    

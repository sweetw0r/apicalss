# l = [0, 4, 5, 12, 255,40]
# n = 12
# temp = 0
# for i in l:
#   if n - i < = n and 


# def func(val):
#     d = dict()
#     for v in val:
#         if v not in d:
#             d[v] = 1
#         else:
#             d[v] += 1
#     for x in d:
#         if d[x] == 1: # if d[x] % 2 == 0:
#             print(x)

# print func([1, 2, 45, 12, 0])


# def func(val):
#     d = dict()
#     for v in val:
#         if v not in d:
#             d[v] = 1
#         else:
#             del d[v]
#     return d.keys()

# print func([1, 2, 45, 12, 12, 0, 0])
        
# val = "abbcde"

# def func(val):
#     d = dict()
#     char = ''
#     max = 0
#     for i in val:
#         if i not in d:
#             d[i] = 1
#         else:
#             d[i] += 1
#     for k in d:
#         if d[k] > max:
#             max = d[k]
#             char = k
# print 'The most using character is %d - %d times' % (char, max)

# d = {"a":2, "b":5, "c":2}

# char = ''
# max = 0

# for i in d:
#     if d[i] > max:
#         max = d[i]
#         char = i

# print "The character is %s - %s times" % (char, max)
#val = [1, 3, 10, 100, 5]

def func(val):
    flag = True
    #i = 1
    while flag:
        flag = False
        for k in range(len(val) - 1):
            if val[k] > val[k + 1]:
                temp = val[k]
                val[k] = val[k + 1]
                val[k + 1] = temp
                flag = True
        # i += 1
        print(val)
print func([1, 3, 10, 11, 45, 5, 56, 4, 100])





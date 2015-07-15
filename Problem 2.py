import random

list = []
while len(list) < 30:
    list.append(random.randint(0, 100))
# print list  #rows out of tasks should be commented
# print i[0]  #rows out of tasks should be commented
max_val = list[0]

for i in list:
    # print 'i value = ' + str(i)
    if i == 0:
        pass
    else:
        min_val = i
        break
# print 'Min val setup = ' + str(min_val)

for x in list:
    if x > max_val:
        max_val = x
# print 'Max is', max_val #Tested (working)

for x in list:
    if x < min_val and x != 0:
        min_val = x
# print 'Min is', min_val
diff = max_val - min_val
# print 'The result of computing is', diff



# def create_list():
#     i = []
#     while len(i) < 30:
#         i.append(random.randint(0, 100))
#     print i  #rows out of tasks should be commented
#     # print i[0]  #rows out of tasks should be commented
#     max_val = i[0]
#     min_val = i[0]
#     return i


# def sorting():
#     list =  create_list()
#     filter(lambda a: a != 0, list)
#     sorted_list =  sorted(list)
#     return sorted_list[0] % sorted_list[len(sorted_list) - 1]
# print sorting()

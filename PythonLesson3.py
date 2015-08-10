# str = 'I love milk'
# x = str.split(' ')
# y = []
# for i in reversed(x):
#     y.append(i)
# new = ' '.join(y)
# print new

# str = 'I love milk'
# x = ' '.join(reversed(str.split()))
# print x

# str = 'I love milk'
# y = str.split()
# x = []
# for v in range(len(y)):
#     x.insert(0, y[v])
# print ' '.join(x)

# l = [4, 8, 0, 5, 12, 20]
# min = l[0]
# max = l[0]

# for i in range(1, len(l)):
#   if min > l[i]:
#       min = l[i]
#   if max < l[i]:
#       max = l[i]:

# print("Min is %s") % (min)
# print('Max is %s') % (max)
# print('Sum is %s') % (max + min)


# import random


# def x():
#     s = ''
#     for i in range(4):
#         s += str(random.randint(0, 9))
#     return s
# print x()


# def z():
#     y = x()
#     bull = 0
#     cow = 0
#     user = raw_input("Enter 4 digits: ")
#     for i in range(len(user)):
#         if user[i] == y[i]:
#             bull += 1
#         elif user[i] in y:
#             cow +=1
#     return cow, bull

# print('Cows: %s, Bulls: %s' % z())


# def fact(x):
#   if x < 2:
#       return 1

#   res = 1
#   for i in range(2, x+1):
#       res *= i
#   return res
# z = fact(7)
# print z

def arifpr(start, end, step):
<<<<<<< HEAD
  l = []
  temp = start
  for i in range(end):
      l.append(temp)
      temp += step
  return l
=======
	l = []
	temp = start
	for i in range(end):
		l.append(temp)
		temp += step
	return l
>>>>>>> a90b1bdfaae1561e846bd60895caaba433d00bbf

print arifpr(0, 20, 4)


# def x(l, jump):
#   if l % jump:
#       return l/jump
#   else:
#       return(l/jump) + 1

# print x(10, 4)

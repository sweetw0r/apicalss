import random

i = []
while len(i) < 200:
    i.append(random.randint(0, 100))
# print i

while True:
    try:
        x = int(raw_input('Please enter a number from 0 to 99: '))
    except ValueError:
        print 'Oops!  That was not a valid number. Please, try again...'
    else:
        if x in range(0, 100):
            break
        else:
            print 'The number is out of range. Pleas try again...'

y = []
for index, value in enumerate(i):
    if value == x:
        y.append(index)

if x in i:
    print 'The amount are', i.count(x)
    print 'The indexes are', (", ".join(repr(e) for e in y))
else:
    print 'Sorry. Nothing found!'

"""I want you to write me a function with 3 parameters
where I provide the first initial 2 numbers form this
pattern along with a number and you return what the element would be."""

# 0, -1, -1, 0, 1, 1, 0, -1, -1, 0, 1 , 1, 0

# test cases
# 0, -1, 5 = 1
# 0, -1, 13 = 0


def seqance(a, b, x):
    for i in range(x):
        b, a = a, a - b
    print -b
seqance(0, -1, 13)


# A function to reverse a word and print first three character of a word


def string(word):
    print word[::-1]
    print word[:3]

string("apple")

from random import randint

def sum_of(n, num_giv):
    # num_giv = 30 # def sum_of(n, num_giv):
    # n = 10 # def sum_of(n, num_giv): 
    l = []  # generated list 
    for v in range(n):
        l.append(randint(1, 20))
    print l
    
    L = len(l)  # L = 10
    
    
    # found = 0
    for i in range(L): # range(L)
        for j in range(i + 1, L):
            if l[i] + l[j] == num_giv:
                
                print l[i], 'plus', l[j], 'equal', num_giv
    return l
print(sum_of(20, 30))
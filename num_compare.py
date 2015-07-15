def num_compare():
    print "Good evening, Stan! Do you want to compare numbers?"
    while True:
        try:
            x = int(raw_input("Please enter 1st number: "))
            print "Great!"
        except ValueError:
            print "Oops!  That was not a valid number. Please, try again..."
        else:
            print "Thank you! The 1st number is", x
            break
    while True:
        try:
            y = int(raw_input("Please enter 2nd number: "))
            print "Great!"
        except ValueError:
            print "Oops!  That was not a valid number. Please, try again..."
        else:
            print "Thank you! The 2nd number is", y
            break
    if x > y:
        print "First number is bigger then second one."
    elif x < y:
        print "Second number is bigger then first one."
    elif x == y:
        print "Numbers are equal."
    print "Total of your numbers is", sum([x, y])
    pass
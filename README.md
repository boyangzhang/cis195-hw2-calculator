CIS195-HW2-Calculator
By: Boyang Zhang

I used the Stanford slide deck as the basis for my calculator which is why the naming and GUI is similar, since I had no idea what proper design or style for iOS development is.  However, I implemented infix to postfix conversion algorithm on my own using this as the source:

http://www.lawrence.edu/fast/greggj/CMSC270/Infix.html

I also want to take 1 late day to fix some corner cases!

Also divide by 0 returns 0 in that part of the operator because I don't wanna deal with NaNs

Finally, I was attempting to resize large inputs, but XCode kept crashing when I tried autoshrink the text and I don't have time to do many inputs!

Added backspace and expression features, but not enough time (and see note above about autoshrink) to make it handle a huge expression gracefully. (sadface)
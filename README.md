CIS195-HW2-Calculator
By: Boyang Zhang

I used the Stanford slide deck as the basis for my calculator which is why the naming and GUI is similar.  I had no idea what was the proper way to design and build iOS apps so using the Stanford slide deck as a base was helpful.  However my code still largely differs from the stanford slide deck since I implemented the infix to postfix conversion algorithm as detailed in this link:

http://www.lawrence.edu/fast/greggj/CMSC270/Infix.html

Also divide by 0 returns 0 in that part of the operator because I don't wanna deal with NaNs

Finally, I was attempting to resize large inputs, but XCode kept crashing when I tried autoshrink the text and I don't have time to do many inputs!

Added backspace and expression features, but not enough time (and see note above about autoshrink) to make it handle a huge expression gracefully. (sadface)
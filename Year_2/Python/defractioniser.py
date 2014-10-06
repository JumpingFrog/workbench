import math

print "Enter the binary fraction to convert:"
inp = str(raw_input())

result = 0.0
for c in range(len(inp)):
    if (inp[c] == '1'):
        result += 1/math.pow(2, c+1)

print result

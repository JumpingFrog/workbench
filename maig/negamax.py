class Node:
	def __init__(self, value):
		self.children = list()
		self.value = value

	def addChild(self, child):
		self.children.append(child)

	def getChildren(self):
		return self.children

	def getValue(self):
		return self.value


def negamax(root):
	if root.getValue() != None:
		return root.getValue()
	else:
		best = -1000;
		for c in root.getChildren():
			val = -negamax(c)
			if (val > best):
				best = val
		return best

def negamaxAlphaBeta(root, alpha, beta, depth):
	if root.getValue() != None:
		print " "*depth + "T("+str(root.getValue())+") ["+str(alpha)+","+str(beta)+"]"
		return root.getValue()
	else:
		print " "*depth + "IN ["+str(alpha)+","+str(beta)+"]"
		best = -1000
		for c in root.getChildren():
			val = -negamaxAlphaBeta(c, -beta, -alpha, depth + 1)
			best = max(best, val)
			alpha = max(alpha, val)
			print " "*depth + "("+str(best)+") ["+str(alpha)+","+str(beta)+"]"
			if (alpha >= beta):
				print "cut"
				break
		return best



'''# Build a tree with maximum ugliness
root = Node(None)

aa = Node(None)
ab = Node(None)

ba = Node(None)
bb = Node(None)
bc = Node(None)
bd = Node(None)

neg1 = Node(-1)
neg3 = Node(-3)

root.addChild(aa)
root.addChild(ab)

aa.addChild(ba)
aa.addChild(bb)

ab.addChild(bc)
ab.addChild(bd)

ba.addChild(neg1)
ba.addChild(neg1)
ba.addChild(neg3)

bb.addChild(neg1)
bb.addChild(neg1)
bb.addChild(neg1)

bc.addChild(neg1)
bc.addChild(neg1)
bc.addChild(neg1)

bd.addChild(neg1)
bd.addChild(neg1)
bd.addChild(neg3)'''
root = Node(None)

a1 = Node(None)
a2 = Node(None)
a3 = Node(None)

b1 = Node(None)
b2 = Node(None)
b3 = Node(None)
b4 = Node(None)
b5 = Node(None)
b6 = Node(None)

root.addChild(a1)
root.addChild(a2)
root.addChild(a3)

a1.addChild(b1)
a1.addChild(b2)

a2.addChild(b3)
a2.addChild(b4)

a3.addChild(b5)
a3.addChild(b5)

b1.addChild(Node(-2))
b1.addChild(Node(-3))

b2.addChild(Node(-5))
b2.addChild(Node(-9))

b3.addChild(Node(0))
b4.addChild(Node(-7))
b4.addChild(Node(-4))

b5.addChild(Node(-2))
b5.addChild(Node(-1))

b6.addChild(Node(-5))
b6.addChild(Node(-6))


print "STD negamax"
print negamax(root)
print "AB pruning"
print negamaxAlphaBeta(root, -1000, 1000, 0)

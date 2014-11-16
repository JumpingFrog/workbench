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

def negamaxAlphaBeta(root, alpha, beta):
	if root.getValue() != None:
		print "T("+str(root.getValue())+") ["+str(alpha)+","+str(beta)+"]"
		return root.getValue()
	else:
		best = -1000
		for c in root.getChildren():
			val = -negamaxAlphaBeta(c, -beta, -alpha)
			best = max(best, val)
			alpha = max(alpha, val)
			if (alpha >= beta):
				print "cut"
				break
			print "("+str(best)+") ["+str(alpha)+","+str(beta)+"]"
		return best



# Build a tree with maximum ugliness
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
bd.addChild(neg3)
print "STD negamax"
print negamax(root)
print "AB pruning"
print negamaxAlphaBeta(root, -1000, 1000)

class Node:
    def __init__(self, value):
        self._value = value
        self._right = None
        self._left = None

    def getRight(self):
        return self._right

    def getLeft(self):
        return self._left

    def setRight(self, right):
        self._right = right

    def setLeft(self, left):
        self._left = left
    
    def __repr__(self):
        print '<Object=Node, value = ' + self._value + '/>'

class Tree:
    def __init__(self, root):
        self._root = root
        self._size = 1

    def getDepth(self):
        return _depth(self._root)
        
    def _depth(self, snode):
        if (snode.getRight() == None && snode.getLeft() == None):
            return 1
        else:
            return 1 + _depth(self, snode.getRight())
        if (snode.getLeft() == None):
            return 1
        
    def printTree(self):
        print ""        

class AVLTree(Tree):
    def __init__(self, root):
        Tree.__init__(self, root)

import copy, sys

class Vertex:
	def __init__(self, name, val):
		self.partition = val
		self.name = name
		self.swapable = True

	def setPartition(self, val):
		self.partition = val

	def __repr__(self):
		return '<Vertex name=' + self.name + ' partition=' + self.partition + '>\n'
class Edge:
	def __init__(self, start, end, weight):
		self.start = start
		self.end = end
		self.weight = weight

	def __repr__(self):
		return '<Edge start=' + self.start.name + ' end=' + self.end.name + ' weight=' + str(self.weight) + '>\n'


vertices = [
			Vertex('A', '1'), #0

			Vertex('J', '1'), #1

			Vertex('K', '1'), #2

			Vertex('B', '1'), #3

			Vertex('G', '1'), #4

			Vertex('L', '1'), #5

			Vertex('C', '2'), #6

			Vertex('H', '2'), #7

			Vertex('I', '2'), #8

			Vertex('D', '2'), #9

			Vertex('E', '2'), #10

			Vertex('F', '2')  #11
		]

edges = [
			Edge(vertices[0], vertices[6], 64), 	#c1  - A -> C

			Edge(vertices[3], vertices[6], 64), 	#c2  - B -> C

			Edge(vertices[0], vertices[11], 8), 	#c3  - A -> F

			Edge(vertices[6], vertices[9], 128), 	#c4  - C -> D

			Edge(vertices[9], vertices[3], 16), 	#c5  - D -> B

			Edge(vertices[11], vertices[0], 16), 	#c6  - F -> A

			Edge(vertices[11], vertices[4], 16), 	#c7  - F -> G

			Edge(vertices[9], vertices[10], 48), 	#c8  - D -> E

			Edge(vertices[9], vertices[7], 48), 	#c9  - D -> H

			Edge(vertices[7], vertices[8], 48), 	#c10 - H -> I

			Edge(vertices[8], vertices[2], 12), 	#c11 - I -> K

			Edge(vertices[1], vertices[2], 48), 	#c12 - J -> K

			Edge(vertices[2], vertices[5], 24), 	#c13 - K -> L

			Edge(vertices[10], vertices[4], 16), 	#c14 - E -> G

			Edge(vertices[4], vertices[5], 8)  	#c15 - G -> L
		]

#Calculate differences for vertices in set
def calcDiffs(v, e):
	results = list()
	for vertex in v:
		external = reduce(lambda x, y:  x + y.weight if ((y.start == vertex or y.end == vertex) and (y.start.partition != y.end.partition)) else x, e, 0)
		internal = reduce(lambda x, y:  x + y.weight if ((y.start == vertex or y.end == vertex) and (y.start.partition == y.end.partition)) else x, e, 0)
		results.append(external - internal)
	return results

def extCost(v, e):
        res = 0
        for edge in e:
                if edge.start.partition != edge.end.partition:
                        res += edge.weight
        return res

def calcDeltas(v, e):
        lstA = filter(lambda x: x.partition == '1', v)
        lstB = filter(lambda x: x.partition == '2', v)
        diffsA = calcDiffs(lstA, e)
        diffsB = calcDiffs(lstB, e)
        res = list() #list of possible swap tuples with deltas.
        for a in range(0, len(lstA)):
                for b in range(0, len(lstB)):
                        if (lstA[a].swapable and lstB[b].swapable):
                                #find connections between candidates
                                conns = filter(lambda x: (x.start == lstA[a] and x.end == lstB[b]) or (x.start == lstB[b] and x.end == lstA[a]), e)
                                #append tuple to result
                                delta = diffsA[a] + diffsB[b] - (2 * reduce(lambda x, y: x + y.weight, conns, 0))
                                res.append((delta , lstA[a], lstB[b]))
        return res

def swap(a, b):
       temp = a.partition
       a.partition =  b.partition
       b.partition = temp
       a.swapable =  False
       b.swapable =  False
        

def kernighan(v, e):
        n = len(vertices) / 2
        partitions = list() # list for backtrack
        #print calcDeltas(v, e)
        print 'Ext cost: ' + str(extCost(v, e)) + '\n'
        for i in range(0, n):
                #init best value
                best = -sys.maxint - 1
                #pointer to best item
                bptr = None
                deltas = calcDeltas(v, e)
                #find max delta
                for d in deltas:
                        if (d[0] > best):
                                best = d[0]
                                bptr = d
                swap(bptr[1], bptr[2])
                print '1: \n'
                print filter(lambda x: x.partition == '1', v)
                print '2: \n'
                print filter(lambda x: x.partition == '2', v)
                print 'Ext cost: ' + str(extCost(v, e)) + '\n'

print vertices

kernighan(vertices, edges)

print vertices

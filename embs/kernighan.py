class Vertex:
	def __init__(self, name, val):
		self.partition = val
		self.name = name

	def setPartition(self, val):
		self.partition = val

	def __repr__(self):
		return '<Vertex name=' + self.name + ' partition=' + self.partition + '>'

class Edge:
	def __init__(self, start, end, weight):
		self.start = start
		self.end = end
		self.weight = weight

	def __repr__(self):
		return '<Edge start=' + self.start.name + ' end=' + self.end.name + ' weight=' + str(self.weight) + '>'


vertices = [
			Vertex('A', '1'), #0

			Vertex('J', '1'), #1

			Vertex('K', '1'), #2

			Vertex('B', '2'), #3

			Vertex('G', '2'), #4

			Vertex('L', '2'), #5

			Vertex('C', '3'), #6

			Vertex('H', '3'), #7

			Vertex('I', '3'), #8

			Vertex('D', '4'), #9

			Vertex('E', '4'), #10

			Vertex('F', '4')  #11
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

			Edge(vertices[4], vertices[5], 8)  		#c15 - G -> L
		]

def calcDiff(v, e):
	results = list()
	for vertex in v:
		external = reduce(lambda x, y:  x + y.weight if ((y.start == vertex or y.end == vertex) and (y.start.partition != y.end.partition)) else x, e, 0)
		internal = 0
		results.append(external - internal)
	return results

def calcDelta(v, e):
	diffs = calcDiff(v, e)


def kernighan(v, e):
	calculateD(v, e);
	return None

print vertices
print edges

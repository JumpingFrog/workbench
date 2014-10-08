import csv, io, sys, os, numpy as np, matplotlib.pyplot as plt

#Configuration...
fname = "training.csv" # raw_input("Enter filename:\r\n")
dimen = 0
weights = np.mat([1]*3).T
max_itr = 200
eta = 0.1
#list of training examples/data
data = []
#list of classes corresponding to data
classes = []

#Some methods

# Attempt to classify a data point
def classify(xs):
	x =  np.mat(xs)
	return np.asscalar(np.dot(x, weights)) > 0

#Adjust weights, d is the index of failing data item
def adjust_weights(d):
	global weights
	if classes[d]:
		weights = np.add(weights.T, np.dot(np.mat(data[d]), eta)).T
	else:
		weights = np.subtract(weights.T, np.dot(np.mat(data[d]), eta)).T

# Train using data
def train():
	correct = True
	for n in range(0, max_itr):
		print "Iteration: " + str(n)
		correct = True
		for d in range(0, len(data)):
			if not (classify(data[d]) == classes[d]):
				correct = False
				adjust_weights(d)
		#plt.plot(0,0)
		#We're still correct? We've found or line.
		if correct:
			break
	if not correct:
		print "Training failed."
	else:
		print "Training complete."
		print weights


#-------------------------------------------------------------------------------
if not os.path.isfile(os.getcwd()+ "/" + fname):
	print "Error, no such file: " + os.getcwd() + "/" + fname
	sys.exit()
#read in out data
tfile = open(os.getcwd() + "/" + fname, "rb")
treader = csv.reader(tfile)
for r in treader:
	temp = [1] #prepend the 1
	temp.extend(map(float, r[1:]))
	plt.plot(temp[1], temp[2], "r." if r[0] == 't' else "b.")
	data.append(temp)
	classes.append(r[0] == 't')

train()

print weights
x = np.array(map(float, range(0, 10)))
plt.plot(x, x*(np.asscalar(weights[1])/np.asscalar(weights[2])) + np.asscalar(weights[0]) )
plt.grid()
plt.show()
#plt.plot(x, x*(np.asscalar(weights[1])/np.asscalar(weights[2])) + np.asscalar(weights[0]), "r-")
#plt.show()
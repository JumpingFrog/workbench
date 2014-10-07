import csv, io, sys, os

fname = "training.csv" # raw_input("Enter filename:\r\n")
dimen = 0

weights = [] # weights

if not os.path.isfile(os.getcwd()+ "/" + fname):
	print "Error, no such file: " + os.getcwd() + "/" + fname
	sys.exit()

tfile = open(os.getcwd() + "/" + fname, "rb")
treader = csv.reader(tfile)

for r in treader:


def clasify(x):
	return True
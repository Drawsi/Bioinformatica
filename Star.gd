extends Tabs

onready var s1 = get_node("../../SidePanel/S1")
onready var s2 = get_node("../../SidePanel/S2")
onready var pot = get_node("../../SidePanel/P")
onready var nepot = get_node("../../SidePanel/N")
onready var gap = get_node("../../SidePanel/G")
var block = load("res://Nr_Block.tscn")
var matrix = []
var seq1 = ""
var seq2 = ""
var seq_max

var s1_txt
var s2_txt
var height = 0
var width = 3
var p 
var n
var g

var performance = false
var s = ["CGT",
		 "ACT",
		 "CCG",
		 "TCA",
		 "AGT"]
	
	
func png_test(x,y):
	#				Rewrite in order for the gap to work
	var score = 0
	for a in 3:
		if x[a]!=y[a]:
			score=score+p
		elif x[a]==y[a]:
			score=score+n
		else:
			score=score+g
	return -score
	
func _ready():
	p = int(pot.get_text())
	n = int(nepot.get_text())
	g = int(gap.get_text())
	
	
	#					Making the matrix
	for i in s.size():
		matrix.append([0])
		for j in s.size():
			matrix[i].append(0)
	
	
	#					Creating the values
	#			:We can make this more performant by combining A with B and removing
	#			the range(i+1), although this will make things a tad ugly:
	#A
	for i in s.size():
		for j in range(i+1,s.size()):
			if i!=j:
				var t = png_test(s[i],s[j])
				matrix[i][j] = t
				matrix[j][i] = t
	
	
	#					Making the T line
	#B
	for i in s.size():
		var sum = 0
		for j in s.size():
			var t =  matrix[i][j]
			sum = sum + t
			matrix[i][s.size()] = sum
	
	
	for i in s.size():
		print(matrix[i])
	
	
	
	
	
	
#	S1	S2	S3	S4	S5		 T
#S1	 0	-2	-2	-6	 2		-8
#S2	-2	 0	-2	-2	 2		-4
#S3	-2	-2	 0	-2	-6		-12
#S4	-6	-2	-2	 0	-6		-16
#S5	 2	 2	-6	-6	 0		-8

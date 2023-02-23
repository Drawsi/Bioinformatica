extends Tabs
onready var s1 = get_node("../../SidePanel/S1").get_text()
onready var s2 = get_node("../../SidePanel/S2").get_text()
onready var p = int(get_node("../../SidePanel/P").get_text())
onready var n = int(get_node("../../SidePanel/N").get_text())
onready var g = int(get_node("../../SidePanel/G").get_text())
onready var show = get_node("Show")
var block = load("res://Nr_Block.tscn")
var matrix = []
var seq1 = ""
var seq2 = ""
var seq_max
#S3	-2	-2	 0	-2	-6		-12
#S4	-6	-2	-2	 0	-6		-16
#S5	 2	 2	-6	-6	 0		-8
var s=[ "CGT",
		"ACT",
		"CCG",
		"TCA",
		"AGT"]

var height = 0
var width = 0

var performance = false

func _png_test(x,y):
	var sum = 0 
	for i in 3:
		if x[i]==y[i]:
			sum = sum + p
		elif x[i]!=y[i]:
			sum = sum + n
		else:
			sum = sum + g
	return sum

func first_table():
	#			Making the matrix
	for x in s.size():
		matrix.append([])
		for y in s.size()+1:
			matrix[x].append(0)
	
	#			Calculating half the values
	for i in s.size():
		for j in range(i, s.size()):
			if i!=j:
				matrix[i][j] = _png_test(s[i],s[j])
				matrix[j][i] = matrix[i][j]

	
	#			Summing the total of each row
	for i in s.size():
		var t = 0
		for j in s.size():
			t = t + matrix[i][j]
		matrix[i][s.size()] = t
	
	#			Printing it
	#for x in s.size():
	#	print(matrix[x])

#		Example
#	S1	S2	S3	S4	S5	T
#S1	0	-2	-2	-6	2	-8
#S2	-2	0	-2	-2	2	-4
#S3	-2	-2	0	-2	-6	-12
#S4	-6	-2	-2	0	-6	-16
#S5	2	2	-6	-6	0	-8

func _show():
	var all = 'T'
	for x in s.size():
		all = all + "\n"
		all = all + str((matrix[x][s.size()]))
	show.text = all

func _on_Calc_pressed():
	first_table()
	_show()

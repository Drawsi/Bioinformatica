extends TabBar
@onready var s1 = get_node("../../SidePanel/S1").get_text()
@onready var s2 = get_node("../../SidePanel/S2").get_text()
@onready var p = int(get_node("../../SidePanel/P").get_text())
@onready var n = int(get_node("../../SidePanel/N").get_text())
@onready var g = int(get_node("../../SidePanel/G").get_text())
@onready var show = get_node("Show")
@onready var list = get_node("ItemList")
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
var test_s=[ "S1",
		"S2",
		"S3",
		"S4",
		"S5"]

var memory = []

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

#		Example
#	S1	S2	S3	S4	S5	T
#S1	0	-2	-2	-6	2	-8
#S2	-2	0	-2	-2	2	-4
#S3	-2	-2	0	-2	-6	-12
#S4	-6	-2	-2	0	-6	-16
#S5	2	2	-6	-6	0	-8

func _show_fin():
	var all = 'T'
	for x in s.size():
		all = all + "\n"
		all = all + str((matrix[x][s.size()]))
	show.text = all

func _show_all():
	list.max_columns = s.size()
	for i in s.size():
		for j in s.size():
			list.add_item(str(matrix[i][j]),null,true)

func _on_Calc_pressed():
	first_table()
	_show_fin()
	#In the second table there's S1,S2,S3 -> k=3
	#Where as S1,S2,S3,S4,S5 -> n=5
	#So the factorial would be _factorial(5,3) = 10
	#Tested and it works
	_factorial(5,5)
	for i in test_s.size():
		for j in test_s.size():
			memory.append(i)
			if test_s[i]!=test_s[j]:
				memory[i][j] = test_s[j]
				print(test_s[i],' ',test_s[j])
	print(memory)
func _factorial(nr,sample):	
	"""We need to calculate the minimum nr of combinations per table
	as to not recalculate values, thus cutting down on time and power needed"""
	var comb = _fac(nr)/(_fac(sample)*_fac(nr-sample))
	return(comb)

func _fac(r):
	var aux=1
	for i in range(1,r+1):
		aux=aux*i
	return aux

extends Tabs

onready var s1 = get_node("../../SidePanel/S1").get_text()
onready var s2 = get_node("../../SidePanel/S2").get_text()
onready var p = int(get_node("../../SidePanel/P").get_text())
onready var n = int(get_node("../../SidePanel/N").get_text())
onready var g = int(get_node("../../SidePanel/G").get_text())
onready var list = get_node("ItemList")
onready var show = get_node("Show")
var block = load("res://Nr_Block.tscn")
var matrix = []
var seq1 = ""
var seq2 = ""
var seq_max

var height = 0
var width = 0

var performance = false

func Smith_Waterman():
	#						Smith_Waterman method
	
	#						Making the blank matrix
	for x in height+2:
		matrix.append([])
		for y in width+2:
			matrix[x].append('')# will be set to null after testing
		
	#						Giving it starter values
	matrix[1][1] = 0
	matrix[1][2] = 0
	matrix[2][1] = 0
	#						Making the first collumn and line
	for x in height+2:
		if x>1:
			matrix[x][1] = 0
			matrix[x][0] = s2[x-2]
	for y in width+2:
		if y>1:
			matrix[1][y] = 0
			matrix[0][y] = s1[y-2]
			
	#						Calculating the matrix
	var i = 1
	var j = 1
	var maxi
	for x in height+2:
		for y in width+2:
			if x>1 and y>1:
	#						Getting into the main part
	#						Diagonal line
				if x==y:
					matrix[x][y]=matrix[x-1][y-1] + png_test(x,y)
	#						The rest
				else:
					maxi=[matrix[x-1][y],matrix[x][y-1],matrix[x-1][y-1]].max()
					matrix[x][y]=maxi + png_test(x,y)
				#		If the value < 0 it becomes 0
				if matrix[x][y]<0:
					matrix[x][y]=0
	for x in height+2:
		for y in width+2:
			if x>1 and y>1:
				#		Calculates the highest value for backtrack
				if matrix[x][y]>matrix[i][j]:
					i = x
					j = y
	#Starts the backtrack sequences
	seq1 = str(matrix[i][0])
	seq2 = str(matrix[0][j])
				#		Checks wheather or not there are multiple values
	for x in range(1, height+2):
		for y in range(1, width+2):
			if matrix[x][y]==matrix[i][j]:
				backtrack(i,j)

func show_matrix():
	if performance:
		show.visible = true
		list.visible = false
		var all = ''
		for x in height+2:
			all = all + "\n"
			for y in width+2:
				all = all + str((matrix[x][y]))
		show.text=all
	else:
		show.visible = false
		list.visible = true
		for x in height+2:
			for y in width+2:
				list.add_item(str(matrix[x][y]),null,true)
	$Seq1.text = seq1
	$Seq2.text = seq2

func dl_dh():
	#						Shows the 'score' of the matrix
	var line_min = [height,width].min()
	var line_max = [height,width].max()
	var dh = 0
	var dl = 0
	var nn = 0
	for x in line_min:
		if s1[x-1]==s2[x-1]:
			dh += 1
		else:
			nn += 1
	dl = dh*p + nn*n + (line_max-line_min)*g
	$DL.set_text("DL="+str(dl))
	$DH.set_text("DH="+str(dh))

func png_test(x,y):
	x=x-2
	y=y-2
	
	if s1[y]==s2[x]:
		return p
	elif x==y:
		return n
	else:
		return g

func backtrack(x,y):
	while seq_max>0:
		#		Defining the closest neighbours
		var a = int(matrix[x-1][y])
		var b = int(matrix[x][y-1])
		var c = int(matrix[x-1][y-1])
		var highest = [a,b,c].max()
		#		Checking differences between highs
		if a!=b || a!=c || b!=c:
			match highest:
				a:
					seq1 = " " + seq1
					seq2 = str(matrix[x-1][0]) + seq2
					x = x-1
				b:
					seq1 = str(matrix[0][y-1]) + seq1
					seq2 = " " + seq2
					y = y-1
				c:
					seq1 = str(matrix[0][y-1]) + seq1
					seq2 = str(matrix[x-1][0]) + seq2
					x = x-1
					y = y-1
		else:
			if a==b:
				seq_max -= 1
				backtrack(x-1,y)#a
				backtrack(x,y-1)#b
			elif a==c:
				seq_max -= 1
				backtrack(x-1,y)#a
				backtrack(x-1,y-1)#c
			else:#a==c
				seq_max -= 1
				backtrack(x-1,y)#a
				backtrack(x-1,y-1)#c
		seq_max -= 1

func _on_Calc_pressed():
	if get_parent().get_current_tab() == 1:
	#						Initialising the basic vars
<<<<<<< Updated upstream:Algorithms/Smith.gd
		p = int(pot.get_text())
		n = int(nepot.get_text())
		g = int(gap.get_text())
		s1_txt = s1.get_text()
		s2_txt = s2.get_text()
		if s1_txt and s2_txt:
			width = s1_txt.length()
			height = s2_txt.length()
			seq_max = [height, width].max()
		#						Erases any previous values
		list.clear()
		matrix = []
		seq1 = ""
		seq2 = ""
		#						Starts processes
		list.max_columns = width+2
		Smith_Waterman()
		dl_dh()
		show_matrix()
=======
	if s1 and s2:
		width = s1.length()
		height = s2.length()
		seq_max = [height, width].max()
	#						Erases any previous values
	list.clear()
	matrix = []
	seq1 = ""
	seq2 = ""
	#						Starts processes
	list.max_columns = width+2
	Smith_Waterman()
	dl_dh()
	show_matrix()
>>>>>>> Stashed changes:Smith.gd

func _on_CheckButton_pressed():
	performance = !performance


extends Node2D

var height
var width
var matrix = []
onready var s1 = get_node("SidePanel/Seq1")
onready var s2 = get_node("SidePanel/Seq2")
onready var pot = get_node("SidePanel/P")
onready var nepot = get_node("SidePanel/N")
onready var gap = get_node("SidePanel/G")
onready var grid = get_node("Content/Matrix_Table/CenterContainer/GridContainer")
var block = load("res://Nr_Block.tscn")
var s1_txt
var s2_txt
var p
var n
var g

func make_matrix():
	#						Making the blank matrix
	for x in height:
		matrix.append([])
		for y in width:
			matrix[x].append(0)
	
	#						Giving it starter values
	matrix[0][0] = 0
	matrix[0][1] = g
	matrix[1][0] = g
	#						Making the first collumn and line
	for x in height:
		if x>1:
			matrix[x][0] = matrix[x-1][0] + g
	for y in width:
		if y>1:
			matrix[0][y] = matrix[0][y-1] + g

func calculate_matrix():
	#						Makes the principal diagonal line
	var maxi
	for x in height:
		for y in width:
			if x>0 and y>0:
				if x==y:
					matrix[x][y]=matrix[x-1][y-1] + png_test(x,y)
				else:
	#						Makes the rest of the matrix
					maxi=[matrix[x-1][y],matrix[x][y-1],matrix[x-1][y-1]].max()
					matrix[x][y]=maxi + png_test(x,y)

func show_matrix():
	matrix.resize([height,width].max()+1)
	for x in height+1:
		for y in width+1:
	#						Making the borders
	
			var b = block.instance()
			grid.columns = width+1
			grid.add_child(b)
			if x==0:
				b.set_text(s1_txt[y-2])
			if y==0:
				b.set_text(s2_txt[x-2])
			if x<2 and y<2:
				b.set_text("")
				if x==1 and y==1:
					b.set_text("0")
			elif x>=1 and y>=1:
				b.set_text(str(matrix[x-1][y-1]))


func png_test(x,y):
	x=x-1
	y=y-1
	#						Checks if the x,y are the same value(diagonal line)
	if x>width or y>height:
		return g
	elif x==y:
		if s1_txt[x]==s2_txt[y]:
			return p
		else:
			return n
	else:
		if s1_txt[y]==s2_txt[x]:
			return p
		else:
			return g

func dl_dh():
	var line_min = [height,width].min()
	var line_max = [height,width].max()
	var dh = 0
	var dl = 0
	var nn = 0
	for x in line_min:
		if s1_txt[x-1]==s2_txt[x-1]:
			dh += 1
		else:
			nn += 1
	dl = dh*p + nn*n + (line_max-line_min)*g
	$Content/Others/DL.set_text("DL="+str(dl))
	$Content/Others/DH.set_text("DH="+str(dh))

func _on_Calc_pressed():
	#							Getting basic information
	s1_txt = s1.get_text()
	s2_txt = s2.get_text()
	p = int(pot.get_text())
	n = int(nepot.get_text())
	g = int(gap.get_text())
	matrix=[]
	if s1_txt and s2_txt:
		width = s1_txt.length() + 1
		height = s2_txt.length() + 1
	$Content/Others/C2/Txt1.set_text(s1_txt)
	$Content/Others/C2/Txt2.set_text(s2_txt)
	#							Delete last matrix
	for c in grid.get_children():
		grid.remove_child(c)
		c.queue_free()
	#							Initiate all procedures
	make_matrix()
	calculate_matrix()
	show_matrix()
	dl_dh()

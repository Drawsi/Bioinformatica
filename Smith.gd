extends Tabs

onready var s1 = get_node("../../SidePanel/Seq1")
onready var s2 = get_node("../../SidePanel/Seq2")
onready var pot = get_node("../../SidePanel/P")
onready var nepot = get_node("../../SidePanel/N")
onready var gap = get_node("../../SidePanel/G")
onready var grid = get_node("GridContainer2")
var block = load("res://Nr_Block.tscn")
var matrix = []

var s1_txt
var s2_txt
var height = 0
var width = 0
var p 
var n
var g

func Smith_Waterman():
	#						Needleman–Wunsch method
	
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
			matrix[x][0] = s2_txt[x-2]
	for y in width+2:
		if y>1:
			matrix[1][y] = 0
			matrix[0][y] = s1_txt[y-2]
			
	#						Calculating the matrix
	var maxi
	for x in height+2:
		for y in width+2:
			if x>1 and y>1:#Getting into the main part
	#						Diagonal line
				if x==y:
					matrix[x][y]=matrix[x-1][y-1] + png_test(x,y)
	#						The rest
				else:
					maxi=[matrix[x-1][y],matrix[x][y-1],matrix[x-1][y-1]].max()
					matrix[x][y]=maxi + png_test(x,y)
					
				if matrix[x][y]<0:
					matrix[x][y]=0

func show_matrix():
	for x in height+2:
		for y in width+2:
	#						Making the borders
			var b = block.instance()
			grid.columns = width+2
			grid.add_child(b)
			b.set_text(str(matrix[x][y]))

func dl_dh():
	#						Shows the 'score' of the matrix
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
	$DL2.set_text("DL="+str(dl))
	$DH2.set_text("DH="+str(dh))

func png_test(x,y):
	x=x-2
	y=y-2
	
	if s1_txt[y]==s2_txt[x]:
		return p
	elif x==y:
		return n
	else:
		return g

func _on_Calc_pressed():
	#						Initialising the basic vars
	p = int(pot.get_text())
	n = int(nepot.get_text())
	g = int(gap.get_text())
	s1_txt = s1.get_text()
	s2_txt = s2.get_text()
	if s1_txt and s2_txt:
		width = s1_txt.length()
		height = s2_txt.length()
	#						Erases any previous values
	for c in grid.get_children():
		grid.remove_child(c)
		c.queue_free()
	matrix = []
	#						Starts processes
	Smith_Waterman()
#	show_matrix()
	dl_dh()

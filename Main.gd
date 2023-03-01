extends Node2D

onready var s1 = get_node("../../SidePanel/S1")
onready var s2 = get_node("../../SidePanel/S2")
onready var pot = get_node("../../SidePanel/P")
onready var nepot = get_node("../../SidePanel/N")
onready var gap = get_node("../../SidePanel/G")
onready var list = get_node("ItemList")
onready var show = get_node("Show")
var block = load("res://Nr_Block.tscn")
var matrix = []
var seq1 = ""
var seq2 = ""
var seq_max

var s1_txt
var s2_txt
var height = 0
var width = 0
var p 
var n
var g

var performance = false

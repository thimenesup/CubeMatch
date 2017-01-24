extends Node

var CubeMid
var MatchCubes = []

var Score = 0
var Time = 30
var TimeLabel

var Highscore = 0

func _ready():
	randomize()
	if not savegame.file_exists(save_path):
		create_save()
	Highscore = read_savegame()
	TimeLabel = get_node("TimeLabel")
	var HighscoreLabel = get_node("HighscoreLabel").set_text("Highscore: " + str(Highscore))
	set_process(true)
	NewRound()
	pass

func _process(delta):
	Time -= 1 * delta
	TimeLabel.set_text("Time: " + str(int(Time)))
	if Time < 0:
		if Score > Highscore:
			save(Score)
		get_tree().reload_current_scene()
	pass

func NewRound():
	var Cubes = [preload("res://Cubes/CubeRed.tscn"),preload("res://Cubes/CubePink.tscn"),preload("res://Cubes/CubeBlue.tscn"),preload("res://Cubes/CubeOrange.tscn"),preload("res://Cubes/CubeGreen.tscn")]
	var HolderArray = [get_node("../Holder/CubeHolder1"),get_node("../Holder/CubeHolder2"),get_node("../Holder/CubeHolder3"),get_node("../Holder/CubeHolder4"),get_node("../Holder/CubeHolder5"),get_node("../Holder/CubeHolder6")]
	
	var i = 0
	while(i < 6):
		var MatchCube = Cubes[randi()%Cubes.size()].instance()
		add_child(MatchCube)
		MatchCubes.insert(i,MatchCube)
		MatchCube.get_node("Position2D").set_pos(HolderArray[i - 1].get_node("Position2D").get_pos())
		i += 1
	
	CubeMid = Cubes[randi()%Cubes.size()].instance()
	add_child(CubeMid)
	CubeMid.get_node("Position2D").set_pos(Vector2(0,0))
	CubeMid.get_node("Position2D").set_scale(Vector2(1.3,1.3))

#Save region

var savegame = File.new()
var save_path = "res://Savegame.save"
var save_data = {"Highscore": 0}

func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func save(Highscore):
	save_data["Highscore"] = Highscore
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func read_savegame():
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()
	return save_data["Highscore"]
extends Area2D

var GameManager

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		GameManager = get_tree().get_root().get_node("Game/GameManagerNode")
		print("This color:" + get_node("../..").CubeColor)
		print("Mid color:" + GameManager.CubeMid.CubeColor)
		if GameManager.CubeMid.CubeColor == get_node("../..").CubeColor:
			if GameManager.CubeMid != get_node("../.."):
				print("CUBE MATCH!")
				GameManager.Score += 1
				GameManager.get_node("ScoreLabel").set_text("Score: " + str(GameManager.Score))
				GameManager.get_node("Sound").play("Correct")
				ScrambleColors()
			else:
				print("Hit the middle one")
				CheckIfCouldMatch()
		else:
			print("Wrong color")
			GameManager.Score -= 1
			GameManager.get_node("ScoreLabel").set_text("Score: " + str(GameManager.Score))
			GameManager.get_node("Sound").play("Wrong")
			ScrambleColors()

func CheckIfCouldMatch():
	var i = 0
	for Cube in GameManager.MatchCubes:
		if not Cube.CubeColor == GameManager.CubeMid.CubeColor:
			i += 1
			if i == 6:
				print("No match, FeelsBadMan")
				GameManager.Score += 1
				GameManager.get_node("ScoreLabel").set_text("Score: " + str(GameManager.Score))
				GameManager.get_node("Sound").play("Correct")
				ScrambleColors()
		else:
			print("You could've match! FeelsBadMan missed oportunity")
			GameManager.Score -= 1
			GameManager.get_node("ScoreLabel").set_text("Score: " + str(GameManager.Score))
			GameManager.get_node("Sound").play("Wrong")
			ScrambleColors()

func ScrambleColors():
	GameManager = get_tree().get_root().get_node("Game/GameManagerNode")
	GameManager.CubeMid.queue_free()
	for EachGMCube in GameManager.MatchCubes:
		EachGMCube.queue_free()
	GameManager.MatchCubes.clear()
	GameManager.NewRound()
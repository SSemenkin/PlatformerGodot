extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_child_count():
		if "Money" in get_child(i).name:
			counter += 1

func _process(_delta):
	$Stats/CanvasLayer/Label.text = str($Player.money)  + "/" + str(counter)

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0


var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	
	for i in $Push_Platforms.get_child_count():
		$Push_Platforms.get_child(i).connect("push", player, "push_reaction")

	counter = $Money.get_child_count()
		
	


	

func _process(_delta):
	$Stats/CanvasLayer/Label.text = str($Player.money)  + "/" + str(counter)

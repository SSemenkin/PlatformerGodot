class_name Enemy
extends Base_Actor

onready var left_detector = $LeftDetector
onready var right_detector = $RightDetector
onready var player_detector = $PlayerDetector


func _ready():
	_velocity.x = speed.x
	
func _physics_process(_delta):
	$Area2D/CollisionShape2D.transform = $CollisionShape2D2.transform
	if !right_detector.is_colliding() or !left_detector.is_colliding() or is_on_wall():
		_velocity.x *= -1
		$CollisionShape2D2.transform.x *= -1

		$PlayerDetector.transform.x *= -1
		if is_on_floor():
			$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	
		
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
	if player_detector.is_colliding():
		if  player_detector.get_collider().get_class() == "KinematicBody2D":
			$AnimatedSprite.play("Attack")

				


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		$AnimatedSprite.play("Walk")


func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.name == 'KinematicBody2D':
			body.destroy()

extends Area2D


const speed = 400
var count = -15

export var direction  = 1
var velocity = Vector2()

func _physics_process(delta):
	velocity.x = speed * delta * direction
	if (sign(count)) == 1:
		velocity.y = delta * gravity 
	count = count + 1

	if !direction:
		$Sprite.flip_h = true
	translate(velocity)
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_KinematicBody2D_body_entered(body):
	queue_free()

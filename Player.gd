class_name Player
extends KinematicBody2D

enum State {
	Alive,
	Hurt,
	Dead
}

var _state = State.Alive

const gravity = 900
const jump_power = 500
const floor_ = Vector2(0, -1)
const speed = 100

var counter = 100

const rock = preload("res://Rock.tscn")

var is_throwing = false
var is_pushed = false

var money = 0

var velocity  = Vector2()

func if_transporter_under_player_add_x_velocity():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Transporter" in collision.collider.name :
			velocity.x += 50
		

func addMoney():
	money += 1

func _physics_process(delta):
	if is_on_floor() && is_pushed:
		is_pushed = !is_pushed
	
	if is_throwing:
		counter -= 1
		if counter == 0:
			counter = 100
			is_throwing = false
	
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && !is_throwing:
		is_throwing = true
		$AnimatedSprite.play("throw")
	
	if is_throwing:
		return
	
	if is_on_floor() :
		$RunDust.show() 
	else :
		$RunDust.hide()
		
	
	if Input.is_action_pressed("ui_up")  && is_on_floor():
		velocity.y = -jump_power

		$JumpDust.show()
		$AnimatedSprite.frame = 0
		$JumpDust.frame = 0
		$JumpDust.play()
		$AnimatedSprite.play("jump")
	if Input.is_action_pressed("run_left"):
		$Position2D.position.x = abs($Position2D.position.x) * -1
		$AnimatedSprite.flip_h = true
		velocity.x = -2 * speed
		$AnimatedSprite.play("run")
		$RunDust.play("run")
		$RunDust.flip_h = true
		$RunDust.position.x = 15
	elif Input.is_action_pressed("run_right"):
		$Position2D.position.x = abs($Position2D.position.x)
		$AnimatedSprite.flip_h = false
		velocity.x = 2 * speed
		$AnimatedSprite.play("run")
		$RunDust.play("run")
		$RunDust.flip_h = false
		$RunDust.position.x = -15
	elif Input.is_action_pressed("ui_left") :
		$Position2D.position.x = abs($Position2D.position.x) * -1
		velocity.x = -speed
		$AnimatedSprite.flip_h = true
		if is_on_floor():
			$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_right") :
		$Position2D.position.x = abs($Position2D.position.x)
		velocity.x = speed
		$AnimatedSprite.flip_h = false
		if is_on_floor() :
			$AnimatedSprite.play("walk")
			
	elif _state == State.Alive:
		velocity.x = 0
		$AnimatedSprite.play("idle")
		$RunDust.hide()
		$RunDust.stop()
		$RunDust.frame = 0
		
	if_transporter_under_player_add_x_velocity()
	velocity.y += (gravity * delta)
	velocity = move_and_slide(velocity, floor_)

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "throw" && $AnimatedSprite.frame == 2:
		var r = rock.instance()
		r.global_position = $Position2D.global_position
		r.direction = sign($Position2D.position.x)
		r.set_as_toplevel(true)
		get_parent().add_child(r)
		is_throwing = false
		
func push_reaction():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if "Platform" in collision.collider.name && !is_on_wall()  && !is_pushed:
			velocity.y -= 2 * jump_power
			is_pushed = !is_pushed

func destroy():
	print("player hurt")
	$AnimatedSprite.play("hurt")
	_state = State.Hurt

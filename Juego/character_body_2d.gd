extends CharacterBody2D

const SPEED = 100

@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var chat_salida: Label = $Label
@onready var chat_entrada: LineEdit = $CanvasLayer/Control/LineEdit
@onready var chat_text_timer: Timer = $CanvasLayer/Control/LineEdit/Timer

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	if !is_multiplayer_authority():
		chat_entrada.hide() 

func _physics_process(_delta):
	if !is_multiplayer_authority(): return
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction.normalized() * SPEED
	move_and_slide()

func _process(_delta):
	if !is_multiplayer_authority(): return
	if velocity != Vector2.ZERO:
		anims.play("walk")
	else:
		anims.play("idle")

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func _on_line_edit_text_submitted(new_text: String) -> void:
	rpc("_set_chat_salida_text", new_text)
	chat_entrada.release_focus()
	chat_text_timer.start(3)
	

@rpc("authority", "call_local")
func _set_chat_salida_text(text: String):
	chat_salida.text = text

func _input(event):
	if event.is_action_pressed("Reset"):
		print("Reseteado")
		get_tree().change_scene_to_file("res://_Game/Escenas y Scripts/node.tscn")


func _on_timer_timeout() -> void:
	rpc("_set_chat_salida_text", "")

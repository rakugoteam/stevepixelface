extends Node

const world_dialogue_path = "res://dialogues/world_dialog.rk"
const world_dialogue_name = "world_dialog"

@onready var dialogue_box = $GUI/TextureRect
@onready var dialogue_box_label = $GUI/TextureRect/Label
@onready var label_pressSpace : Label = get_node("%Label_PressSpace")

@onready var player = $Player
@onready var player_area = $Player/Area2D

var overlapping_area : Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Rakugo.connect("sg_say", Callable(self, "_on_say"))
	Rakugo.connect("sg_execute_script_finished", Callable(self, "_on_execute_script_finished"))
	
	Rakugo.parse_script(world_dialogue_path)

func _on_say(_character:Dictionary, text:String):
	dialogue_box_label.text = text
	
func _on_execute_script_finished(_script_name:String, error_str:String):
	dialogue_box.visible = false
	player.set_physics_process(true)
	label_pressSpace.visible = true

	if not error_str.is_empty():
		push_error(error_str)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if Rakugo.is_waiting_step():
			Rakugo.do_step()
		elif overlapping_area:
			player.animSprite.play("idle")
			player.set_physics_process(false)
			label_pressSpace.visible = false
			Rakugo.execute_script(world_dialogue_name, overlapping_area.name)
			dialogue_box_label.text = ""
			dialogue_box.visible = true


func _on_player_area_entered(area):
	overlapping_area = area
	label_pressSpace.visible = true


func _on_player_area_exited(_area):
	overlapping_area = null
	label_pressSpace.visible = false

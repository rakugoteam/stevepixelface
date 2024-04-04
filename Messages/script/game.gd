extends Node

const file_path = "res://dialogues/main.rk"

@onready var scrollContainer = $ScrollContainer
@onready var vBoxContainer:VBoxContainer = get_node("%VBoxContainer")

var scene_blue_label = preload("res://scene/BlueLabel.tscn")
var scene_yellow_label = preload("res://scene/YellowLabel.tscn")

func _ready():
	Rakugo.sg_say.connect(_on_say)
	Rakugo.sg_step.connect(_on_step)
	Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)
  
	Rakugo.parse_and_execute_script(file_path)
  
func _on_say(character:Dictionary, text:String):
	var new_scene_label
	
	var char_name = character.get("name", "")
	
	if !char_name.is_empty():
		match(char_name):
			"Godot":
				new_scene_label = scene_blue_label.instantiate()
			_:
				new_scene_label = scene_yellow_label.instantiate()
	
	new_scene_label.set_message(char_name, text)
	
	vBoxContainer.add_child(new_scene_label)
	
	await get_tree().process_frame
	
	scrollContainer.ensure_control_visible(new_scene_label)
  
func _on_step():
	prints("Press \"Enter\" to continue...")
	
func _on_execute_script_finished(file_name:String, error_str:String):
	prints("End of script")
  
func _process(delta):
	if Rakugo.is_waiting_step() and Input.is_action_just_pressed("ui_accept"):
		Rakugo.do_step()

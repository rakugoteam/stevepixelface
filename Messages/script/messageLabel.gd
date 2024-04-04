extends VBoxContainer

func set_message(char_name:String, text:String):
	$LabelName.text = char_name
	$LabelMessage.text = text

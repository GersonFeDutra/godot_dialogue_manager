extends Node2D


@onready var settings = $Settings


func _ready():
	DialogueManager.is_strict = false
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	
	var title = settings.get_editor_value("run_title")
	var dialogue_resource = load(settings.get_editor_value("run_resource"))
	DialogueManager.show_example_dialogue_balloon(title, dialogue_resource)


### Signals


func _on_dialogue_finished():
	get_tree().quit()

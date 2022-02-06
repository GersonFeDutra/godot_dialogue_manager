@tool
extends ScrollContainer


signal error_pressed(error)


const ErrorButton = preload("res://addons/dialogue_manager/components/error_button.tscn")


@onready var list: VBoxContainer = $List


var errors: Array:
	set(next_errors):
		errors = next_errors
		
		if errors.size() == 0:
			visible = false
		else:
			visible = true
			
			rect_min_size.y = min(200, errors.size() * 25)
		
			for child in list.get_children():
				child.queue_free()
			
			for error in errors:
				var error_button = ErrorButton.instantiate()
				list.add_child(error_button)
				error_button.text = "Line %d: %s" % [error.get("line") + 1, error.get("message")]
				error_button.pressed.connect(_on_error_pressed.bind(error))


### Signals


func _on_error_pressed(error) -> void:
	emit_signal("error_pressed", error)

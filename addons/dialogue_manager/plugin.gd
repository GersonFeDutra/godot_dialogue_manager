@tool
extends EditorPlugin


const DialogueResource := preload("res://addons/dialogue_manager/dialogue_resource.gd")
const Constants := preload("res://addons/dialogue_manager/constants.gd")
const DialogueExportPlugin := preload("res://addons/dialogue_manager/editor_export_plugin.gd")

const MainView = preload("res://addons/dialogue_manager/views/main_view.tscn")


var export_plugin = DialogueExportPlugin.new()
var main_view


func _enter_tree() -> void:
	add_autoload_singleton("DialogueManager", "res://addons/dialogue_manager/dialogue_manager.gd")
	add_custom_type("DialogueLabel", "RichTextLabel", preload("res://addons/dialogue_manager/dialogue_label.gd"), _get_plugin_icon())
	
	if Engine.is_editor_hint:
		add_export_plugin(export_plugin)
		
		main_view = MainView.instantiate()
		# FIXME
		get_editor_interface().get_editor_main_control().add_child(main_view)
		main_view.plugin = self
		_make_visible(false)


func _exit_tree() -> void:
	remove_custom_type("DialogueLabel")
	remove_autoload_singleton("DialogueManager")
	
	if is_instance_valid(main_view):
		main_view.queue_free()
	
	if export_plugin:
		remove_export_plugin(export_plugin)


func _has_main_screen() -> bool:
	return true


func _make_visible(next_visible: bool) -> void:
	if is_instance_valid(main_view):
		main_view.visible = next_visible


func _get_plugin_name() -> String:
	return "Dialogue"


func _get_plugin_icon() -> Texture:
	var scale = get_editor_interface().get_editor_scale()
	var base_color = get_editor_interface().get_editor_settings().get_setting("interface/theme/base_color")
	var theme = "light" if base_color.v > 0.5 else "dark"
	
	if scale not in [1.0, 1.25, 1.5, 1.75, 2.0]:
		scale = 2.0
	
	return load("res://addons/dialogue_manager/assets/icons/icon_%s_%d.svg" % [theme, scale]) as Texture


func _handles(object) -> bool:
	return object is DialogueResource


func _edit(object) -> void:
	main_view.open_resource(object)

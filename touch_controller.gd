extends CanvasLayer

@onready var run = $run
@onready var jump = $jump

func _on_run_pressed() -> void:
	run.modulate.a = 0.5

func _on_run_released() -> void:
	run.modulate.a = 1.0
	
func _on_jump_pressed() -> void:
	jump.modulate.a = 0.5
	
func _on_jump_released() -> void:
	jump.modulate.a = 1.0

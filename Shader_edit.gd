extends CodeEdit

@onready var color_rect: ColorRect = $"../ColorRect"
@onready var code_edit: CodeEdit = $"."

var minimize: bool = false
var t = 0.0

func _ready() -> void:
	code_edit.text = color_rect.material.shader.code

func _on_text_changed() -> void:
	color_rect.material.shader.code = code_edit.text

func _on_button_2_pressed() -> void:
	minimize = !minimize
	t = 0.
	
func _process(delta: float) -> void:
	
	

	t += delta * 0.4
	scale = scale.lerp(Vector2(float(!minimize),float(!minimize)),t)
	
	

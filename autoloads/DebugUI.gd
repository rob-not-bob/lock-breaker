extends CanvasLayer

var show_debug_ui := false;


func _ready():
	hide();


func log(text: String):
	print(text);

	if OS.is_debug_build() and not visible and show_debug_ui:
		show();
	else:
		return;

	%DebugText.append_text(text + "\n");

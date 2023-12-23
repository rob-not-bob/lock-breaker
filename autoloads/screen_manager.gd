extends CanvasLayer

var screens := {}

signal start();
signal restart();

func _ready():
	for screen in get_children():
		if screen is Screen:
			screens[screen.get_name()] = screen;

	var on_start := func():
		start.emit();
		hide_screens();

	var on_restart := func():
		restart.emit();
		hide_screens();

	$Start.start_button_clicked.connect(on_start);
	$Start.credit_button_clicked.connect(switch_to.bind("Credits"));

	$TryAgain.try_again_clicked.connect(on_restart);

	$Credits.on_back_clicked.connect(switch_to.bind("Start"));

	$TapToResume.tap_to_resume_clicked.connect(on_restart);


func hide_screens() -> void:
	for screen in screens:
		if screens[screen].visible:
			screens[screen].on_screen_exit();
			screens[screen].hide();


func switch_to(screen_name: String) -> void:
	for screen in screens:
		if screen == screen_name:
			screens[screen].on_screen_enter();
			screens[screen].show();
		elif screens[screen].visible:
			screens[screen].on_screen_exit();
			screens[screen].hide();

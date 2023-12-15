extends CanvasLayer

enum Screens {
	Start,
	Credits,
	TryAgain,
	TapToResume,
}

var screens := {}

signal start();
signal restart();

func _ready():
	screens[Screens.Start] = $StartScreen;
	screens[Screens.Credits] = $credits;
	screens[Screens.TryAgain] = $TryAgain;
	screens[Screens.TapToResume] = $TapToResume;

	var on_start := func():
		start.emit();
		hide_screens();

	var on_restart := func():
		restart.emit();
		hide_screens();

	$StartScreen.start_button_clicked.connect(on_start);
	$StartScreen.credit_button_clicked.connect(switch_to.bind(Screens.Credits));

	$TryAgain.try_again_clicked.connect(on_restart);

	$credits.on_back_clicked.connect(switch_to.bind(Screens.Start));

	$TapToResume.tap_to_resume_clicked.connect(on_restart);


func hide_screens() -> void:
	for screen in screens:
		screens[screen].hide();


func switch_to(screen_name: Screens) -> void:
	for screen in screens:
		if screen == screen_name:
			screens[screen].show();
		else:
			screens[screen].hide();

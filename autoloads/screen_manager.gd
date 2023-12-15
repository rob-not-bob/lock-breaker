extends CanvasLayer

enum Screens {
	Start,
	Credits,
	TryAgain,
}

var screens := {}

signal start();
signal restart(with_extra_life: bool);

func _ready():
	screens[Screens.Start] = $StartScreen;
	screens[Screens.Credits] = $credits;
	screens[Screens.TryAgain] = $TryAgain;

	$StartScreen.start_button_clicked.connect(func():
		start.emit();
		hide_screens()
	);
	$StartScreen.credit_button_clicked.connect(switch_to.bind(Screens.Credits));
	
	$TryAgain.try_again_clicked.connect(func(with_extra_life: bool):
		restart.emit(with_extra_life);
		hide_screens();
	);

	$credits.on_back_clicked.connect(switch_to.bind(Screens.Start));


func hide_screens() -> void:
	for screen in screens:
		screens[screen].hide();


func switch_to(screen_name: Screens) -> void:
	for screen in screens:
		if screen == screen_name:
			screens[screen].show();
		else:
			screens[screen].hide();

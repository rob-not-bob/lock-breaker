extends Node2D

func _ready():
	set_theme();
	$GameController.init();
	$EndlessMode.init();
	ScreenManager.switch_to(ScreenManager.Screens.Start);
	ScreenManager.start.connect(_start_game);
	ScreenManager.restart.connect(func():
		print('restart');
		set_theme();
		$GameController.restart();
		$EndlessMode.restart();
		# Ads.load_banner();
	);


func set_theme():
	var theme = Themes.get_random_theme();
	EventBus.theme_set.emit(theme);
	$UI/GameUI/bg.color = theme.bg;


func _start_game():
	%shaderAnimations.play("RESET");
	$UI/StaticGameUI.show();
	$EndlessMode.start();

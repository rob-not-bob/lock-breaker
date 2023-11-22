extends CanvasLayer

var best_score: int = 0:
	set(score):
		best_score = score;
		$MarginContainer/BestScore.text = "Best Score: " + str(score);

@onready var lock = $CenterContainer/SubViewportContainer/SubViewport/lock;

func show_game_over_screen(score: int):
	$MarginContainer.hide();
	$TryAgain.set_scores(score, best_score);
	$AnimationPlayer.play("screen_shake");
	await $AnimationPlayer.animation_finished
	$TryAgain.show();

func load_game():
	var game_state = GameSaver.load_game();
	if game_state.has("best_score"):
		best_score = GameSaver.game_state.best_score;

func _ready():
	load_game();
	set_theme();
	$MarginContainer.hide();
	lock.indicator.direction = 0;

func _on_lose(score: int):
	if score > best_score:
		best_score = score;
		GameSaver.game_state = {
			"best_score": best_score,
		};
		GameSaver.save_game();

	show_game_over_screen(score);

func set_theme():
	var theme = Themes.get_random_theme();
	$bg.color = theme.bg;
	lock.set_theme(theme);

func _start_game():
	# Ads.load_banner();
	lock.reset();
	$AnimationPlayer.play("RESET");
	$TryAgain.hide();
	$StartScreen.hide();
	$MarginContainer.show();

func _on_try_again_clicked():
	set_theme();
	_start_game();

func _on_lock_crit():
	$AnimationPlayer.play("crit");

func _on_start_button_clicked():
	_start_game();

func _on_mute_button_clicked(isMuted):
	$shader.material.set_shader_parameter("PULSE_SIZE", 0.0 if isMuted else 0.05);

func _on_credit_button_clicked():
	$StartScreen.hide();
	$credits.show();

func _on_credits_back_clicked():
	$credits.hide();
	$StartScreen.show();

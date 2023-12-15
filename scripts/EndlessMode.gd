extends Node

@export var lock: Lock;
@export var indicator: Indicator;
@export var score_label: Label;
@export var gameController: GameController;

@export var min_spawn_distance: float = 60;

@export_group("Lock Speed")
@export var max_lock_speed: float = 7.0;
@export var lock_speed: float = 2.0:
	set(speed):
		lock_speed = min(speed, max_lock_speed);
		indicator.rotation_speed = lock_speed;
@export var lives: int = 1;

var score: int = 0:
	set(new_score):
		score = new_score;
		score_label.text = str(score);
		if score < 100:
			score_label.add_theme_font_size_override("font_size", 260);
		elif score >= 100:
			score_label.add_theme_font_size_override("font_size", 190);
		elif score >= 1000:
			score_label.add_theme_font_size_override("font_size", 145);


func _ready():
	gameController.missed_arcs.connect(func():
		lives -= 1;
		if lives <= 0:
			_lose();
	);
	gameController.selected_arc.connect(func(arc_name):
		_update_score(arc_name);
		_scale_difficulty();
		_choose_lock_angle();
	);

	Ads.on_reward_failed_to_earn.connect(func():
		DebugUI.log("Reward Failed to Earn");
		ScreenManager.switch_to(ScreenManager.Screens.TryAgain);
		Ads.load(Ads.AdType.RewardedInterstitial);
	);

	Ads.on_reward_earned.connect(func(type: String, amount: int):
		DebugUI.log("Reward Earned %s %s" % [type, amount]);
		lives += 1;
		ScreenManager.switch_to(ScreenManager.Screens.TapToResume);
		Ads.load(Ads.AdType.RewardedInterstitial);
	);


func start() -> void:
	indicator.direction = T.Direction.CLOCKWISE;


func init() -> void:
	score = 0;
	indicator.direction = T.Direction.NONE;
	_choose_lock_angle();


func restart() -> void:
	if lives > 0:
		indicator.direction = previous_direction;
	else:
		Themes.get_random_theme();
		lives = 1;
		score = 0;
		indicator.direction = T.Direction.CLOCKWISE;

	_choose_lock_angle();


func _scale_difficulty() -> void:
	lock_speed = 2.0 + 0.125 * int(score / 5.0);


func _update_score(arc_name: String) -> void:
	score += _get_point_value(arc_name);


func _get_point_value(arc_name: String) -> int:
	match arc_name:
		'red':
			EventBus.crit.emit();
			return 3;
		'orange':
			return 2;
		'yellow':
			return 1;
		_:
			return 0;


var previous_direction: T.Direction;
func _lose() -> void:
	previous_direction = indicator.direction as T.Direction;
	indicator.direction = T.Direction.NONE;
	EventBus.lost.emit(score);


func _choose_lock_angle() -> void:
	var angle := rad_to_deg(indicator.rotation);
	lock.reverse = indicator.direction == T.Direction.COUNTER_CLOCKWISE;
	lock.angle = randf_range(
		angle + min_spawn_distance,
		angle + 360 - min_spawn_distance
	);

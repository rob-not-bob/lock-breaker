extends Node

signal on_reward_earned(type: String, amount: int);
signal on_reward_failed_to_earn();

const adConfig = preload("./adConfig.gd");
const types = preload("./types.gd");

const AdType = types.AdType;
const Platform = types.Platform;
const Env = types.Env;

var _ads = {};

var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
var rewarded_interstitial_ad_fullscreen_callback := FullScreenContentCallback.new()
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

func _ready():
	MobileAds.initialize();

	#region Rewarded interstitial callbacks
	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		DebugUI.log("ad failed to load: %s" % adError.message);
		on_reward_failed_to_earn.emit();
		print(adError.message)

	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
			DebugUI.log("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
			_ads[AdType.RewardedInterstitial] = rewarded_interstitial_ad;

	rewarded_interstitial_ad_fullscreen_callback.on_ad_dismissed_full_screen_content = func() -> void:
		DebugUI.log("ad dismissed");
		on_reward_failed_to_earn.emit();
		_destroy_ad(AdType.RewardedInterstitial);

	on_user_earned_reward_listener.on_user_earned_reward = func(reward: RewardedItem):
		DebugUI.log("reward earned %s %s" % [reward.type, reward.amount])
		_destroy_ad(Ads.AdType.RewardedInterstitial);
		on_reward_earned.emit(reward.type, reward.amount);
	#endregion


#region Public Methods

# Fully sets up ad of type adType to be shown
func load(adType: AdType) -> void:
	if _ads.get(adType):
		_destroy_ad(adType);
	
	var ad_id: String = _get_ad_id(adType);
	if ad_id == "NA":
		return;

	DebugUI.log('init_ad')
	print(adConfig.ADS);
	_init_ad(adType, ad_id);


func show(adType: AdType) -> void:
	DebugUI.log("show called %s" % adType);
	if _ads.get(adType) == null:
		DebugUI.log(
			'Error: Ad of type {adType} is has not yet been loaded. Call load_ad({adType}) before calling show_ad'.format({ adType: adType })
		);
		print(
			'Error: Ad of type {adType} is has not yet been loaded. Call load_ad({adType}) before calling show_ad'.format({ adType: adType })
		);
		return;

	match adType:
		AdType.Banner:
			_ads[adType].load_ad(AdRequest.new())
		AdType.RewardedInterstitial:
			DebugUI.log("showing reward intersititial");
			_ads[adType].show(on_user_earned_reward_listener);

#endregion


#region Private methods to handle loading ad types to be shown

# Returns the ad id for adType if defined
func _get_ad_id(adType: AdType) -> String:
	var platformAds: Dictionary;
	match OS.get_name():
		"Android":
			platformAds = adConfig.ADS[Platform.Android];
		"iOS":
			platformAds = adConfig.ADS[Platform.IOS];
		_:
			print("No ads for platform %s" % OS.get_name())
			return "NA";

	var env := Env.Test if OS.is_debug_build() else Env.Prod;

	return platformAds.get(adType)[env];


# Destroys any existing adType in _ads dict
func _destroy_ad(adType: AdType) -> void:
	if _ads.get(adType):
		_ads[adType].destroy();
		_ads[adType] = null;


# Initializes the ad into the _ads dict
func _init_ad(adType: AdType, adId: String) -> void:
	match adType:
		AdType.Banner:
			_ads[adType] = AdView.new(adId, AdSize.BANNER, AdPosition.Values.BOTTOM);
		AdType.RewardedInterstitial:
			RewardedInterstitialAdLoader.new().load(adId, AdRequest.new(), rewarded_interstitial_ad_load_callback);

#endregion

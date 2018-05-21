package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.addons.editors.tiled.TiledMap;
import flixel.system.FlxSound;
class PlayState extends FlxState
{
	public var player:Character;
	public var sw:FlxObject;
	public static var TILE_SIZE = 32;
	var level:Level;
	public var _levelNumber:Int;
	var _map:TiledMap;
	public var backpack:Backpack;
	public var powerBar:PowerBar;
	public var lasso:Lasso;
	public var slingshot:Slingshot;
	public var restartButton:FlxSprite;
	public var menuButton:FlxButton;
	public var soundButton:FlxSprite;
	public var bgm:FlxSound;
	public var bgmTime:Float;
	public function new(levelNumber:Int, ?time:Float) {
		super();
		_levelNumber = levelNumber;
		if (time == null) {
			soundButton = new FlxSprite(0,0).loadGraphic("assets/sound.png");
			bgmTime = 0;
		} else {
			bgmTime = time;
			soundButton = new FlxSprite(0,0).loadGraphic("assets/silence.png");
		}

	}

	override public function create():Void
	{
		bgm = FlxG.sound.load("assets/bgm.ogg");
		bgm.looped = true;
		if (soundButton.graphic.key == "assets/silence.png") {
			bgm.volume = 0;
		}
		FlxG.mouse.visible = true;
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		soundButton.scrollFactor.set();
		restartButton = new FlxSprite(0,0).loadGraphic("assets/restart.png");
		restartButton.scrollFactor.set();
		restartButton.setGraphicSize(32,32);
		menuButton = new FlxButton(FlxG.camera.x + FlxG.camera.width - 80, 0, "Menu", menu);
		menuButton.loadGraphic("assets/selected.png", 80, 40);
		menuButton.label.size = 12;
		menuButton.labelOffsets = [FlxPoint.get(0, 10), FlxPoint.get(0, 10), FlxPoint.get(0, 11)];
		menuButton.setGraphicSize(80, 40);
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		level = new Level("assets/level" + _levelNumber + ".tmx", this);
		backpack = new Backpack(TILE_SIZE, 5, FlxColor.GRAY, player);
		powerBar = new PowerBar(32, player);
		powerBar.kill();
		lasso = new Lasso(32, player, powerBar, backpack);
		slingshot = new Slingshot(player, powerBar, backpack);
		// add background
		add(level.backgroundGroup);
		if (_levelNumber == 0) {
			var arrowKey = new FlxSprite(192,2*32).loadGraphic("assets/arrows.png");
			arrowKey.setGraphicSize(3*32, 2*32);
			add(arrowKey);
		}
		// add floating block
		add(level.blockGroup);
		for (i in 0...level.blockGroup.length) {
			add(level.blockGroup.members[i].block);
		}
		add(level.teleGroup);
		// add button
		add(level.buttonGroup);
		for (i in 0...level.buttonGroup.length) {
			var button = level.buttonGroup.members[i];
			button.loadGraphic("assets/button.png");
			add(button);
		}
		// add switch (off)
		add(level.switchoffGroup);
		// add door (closed)
		for (key in level.doorNameToClosedGroup.keys()) {
			add(level.doorNameToClosedGroup[key]);
		}
		// add character
		add(level.itemGroup);
		add(lasso);
		// add slingshot
		add(slingshot);
		add(slingshot.playerBullets);
		add(level.characterGroup);
		// add foreground
		add(level.foregroundGroup);
		// add backpack
		add(backpack.border);
		add(backpack);
		add(backpack.index);
		// add collision
		add(level.collisionGroup);
		add(level.doorGroup);
		// add water
		add(level.waterFrontGroup);
		add(level.waterBackGroup);
		add(level.waterLeftGroup);
		add(level.waterRightGroup);
		add(level.waterGroup);

		// add powerBar UI
		add(powerBar);
		add(powerBar.indicator);
		FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		FlxG.worldBounds.copyFrom(level.bounds);
		

		// add pop up
		add(level.popUp);
		add(level.itemPopUp);
		add(level.tutorialPopUp);
		add(level.backpackPopUp);
		add(slingshot.cooldown);
		add(lasso.cooldown);
		add(restartButton);
		add(menuButton);
		add(soundButton);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
		level.update(elapsed);
		if (!bgm.playing) {
			bgm.play(true, bgmTime);
		}
		restartButton.x = FlxG.camera.x;
		restartButton.y = FlxG.camera.y;
		soundButton.x = FlxG.camera.x + FlxG.camera.width - 120;
		soundButton.y = FlxG.camera.y;
		menuButton.x = FlxG.camera.x + FlxG.camera.width - 70;
		if (FlxG.mouse.overlaps(restartButton, null) && FlxG.mouse.justPressed) {
			restart();
		}
		if (FlxG.mouse.overlaps(soundButton, null) && FlxG.mouse.justPressed) {
			Main.LOGGER.logLevelAction(LoggingInfo.MUTE);
			if (bgm.volume == 0) {
				bgm.volume = 0.6;
				soundButton.loadGraphic("assets/sound.png");
			} else {
				bgm.volume = 0;
				soundButton.loadGraphic("assets/silence.png");
			}
		}
	}	

	public function nextLevel(player:Character, sw:FlxObject):Void
	{
		remove(level.switchoffGroup);
		add(level.switchonGroup);
		Main.LOGGER.logLevelEnd({status: "clear"});
		_levelNumber = _levelNumber + 1;
		if (_levelNumber == Main.SAVE.data.levels.length) {
			Main.SAVE.data.levels.push(1);
			Main.SAVE.flush();
		}
		Main.LOGGER.logLevelStart(_levelNumber);
		if (_levelNumber < 21) {
			slingshot.kill();
			lasso.end.kill();
			lasso.kill();
			var timer = new FlxTimer();
			FlxG.camera.fade(FlxColor.BLACK,.33, false, function()
			{
				FlxG.switchState(new PlayState(_levelNumber, bgm.time));
			});
		} else {
			FlxG.switchState(new EndState());
		}
	}
	private function restart():Void
	{
		Main.LOGGER.logLevelEnd({status: "restart"});
		Main.LOGGER.logLevelStart(_levelNumber, {status: "restart"});
		FlxG.camera.fade(FlxColor.BLACK,.33, false, function()
		{
			FlxG.switchState(new PlayState(_levelNumber, bgm.time));
		});
	}

	private function nextLevelOnTimer(Timer:FlxTimer):Void {
		FlxG.switchState(new PlayState(_levelNumber));
	}

	private function menu():Void
	{
		player.kill();
		FlxG.switchState(new MenuState());
	}

}
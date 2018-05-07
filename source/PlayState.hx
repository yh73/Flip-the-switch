package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.addons.ui.FlxButtonPlus;
import flixel.addons.editors.tiled.TiledMap;
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
	public function new(levelNumber:Int) {
		super();
		_levelNumber = levelNumber;
	}

	override public function create():Void
	{
		FlxG.mouse.visible = true;
		restartButton = new FlxSprite(0,0).loadGraphic("assets/restart.png");
		restartButton.setGraphicSize(32,32);
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
			var arrowKey = new FlxSprite(160,2*32).loadGraphic("assets/arrows.png");
			arrowKey.setGraphicSize(3*32, 2*32);
			add(arrowKey);
		}
		// add floating block
		add(level.blockGroup);
		for (i in 0...level.blockGroup.length) {
			add(level.blockGroup.members[i].block);
		}
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
		add(level.characterGroup);
		// add foreground
		add(level.foregroundGroup);
		// add backpack
		add(backpack.border);
		add(backpack);
		// add collision
		add(level.collisionGroup);
		add(level.doorGroup);
		// add water
		add(level.waterFront);
		add(level.waterBack);
		add(level.waterLeft);
		add(level.waterRight);
		add(level.waterGroup);

		// add powerBar UI
		add(powerBar);
		add(powerBar.indicator);
		FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		FlxG.worldBounds.copyFrom(level.bounds);
		// add slingshot
		add(slingshot);
		add(slingshot.playerBullets);

		// add pop up
		add(level.popUp);
		add(level.itemPopUp);
		add(level.tutorialPopUp);
		add(level.backpackPopUp);
		add(restartButton);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		level.update(elapsed);
		super.update(elapsed);
		restartButton.x = FlxG.camera.scroll.x - 80;
		restartButton.y = FlxG.camera.scroll.y - 80;
		if (FlxG.mouse.overlaps(restartButton, null) && FlxG.mouse.justPressed) {
			restart();
		}
	}	

	public function nextLevel(player:Character, sw:FlxObject):Void
	{
		player.kill();
		remove(level.switchoffGroup);
		add(level.switchonGroup);
		Main.LOGGER.logLevelEnd({status: "clear"});
		_levelNumber = _levelNumber + 1;
		Main.LOGGER.logLevelStart(_levelNumber);
		if (_levelNumber < 11) {
			FlxG.switchState(new PlayState(_levelNumber));
		} else {
			FlxG.switchState(new EndState());
		}
	}
	private function restart():Void
	{
		player.kill();
		Main.LOGGER.logLevelEnd({status: "restart"});
		Main.LOGGER.logLevelStart(_levelNumber);
		FlxG.switchState(new PlayState(_levelNumber));
	}
}
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;
class PlayState extends FlxState
{
	public var player:Character;
	public var sw:FlxObject;
	public static var TILE_SIZE = 32;
	var level:Level;
	var _levelNumber:Int;
	var _map:TiledMap;
	public var backpack:Backpack;
	public var powerBar:PowerBar;
	public var lasso:Lasso;

	public function new(levelNumber:Int) {
		super();
		_levelNumber = levelNumber;
	}

	override public function create():Void
	{
		FlxG.mouse.visible = true;
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		level = new Level("assets/level" + _levelNumber +".tmx", this);
		backpack = new Backpack(TILE_SIZE, 5, FlxColor.GRAY, player);
		powerBar = new PowerBar(32, player);
		powerBar.kill();
		lasso = new Lasso(32, player, powerBar);
		// add background
		add(level.backgroundGroup);
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
		add(backpack.buttons);
		add(backpack.equipSlotBorder);
		add(backpack.equipSlot);
		add(backpack.unEquipButton);
		add(backpack);
		add(backpack.buttons);
		add(level.popUp);
		add(level.itemPopUp);
		// add collision
		add(level.collisionGroup);
		add(level.doorGroup);
		// add powerBar UI
		add(powerBar);
		add(powerBar.indicator);
		FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		FlxG.worldBounds.copyFrom(level.bounds);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		level.update(elapsed);
		super.update(elapsed);
		if (FlxG.overlap(player, sw)) {
			if (FlxG.keys.anyJustPressed([E])) {
				nextLevel(player, sw);
			}
		}
		// FlxG.overlap(player, sw, nextLevel);
	}	

	public function nextLevel(player:Character, sw:FlxObject):Void
	{
		player.kill();
		remove(level.switchoffGroup);
		add(level.switchonGroup);
		_levelNumber = _levelNumber + 1;
		FlxG.switchState(new PlayState(_levelNumber));
		
	}
}
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
	var backpack:FlxTypedGroup<FlxSprite>;

	public function new(levelNumber:Int) {
		super();
		_levelNumber = levelNumber;
	}

	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		level = new Level("assets/level" + _levelNumber +".tmx", this);
		backpack = new Backpack(TILE_SIZE, 5, FlxColor.GRAY, player);
		add(level.backgroundGroup);
		add(level.switchoffGroup);
		add(level.characterGroup);
		add(level.foregroundGroup);
		add(backpack);
		add(level.collisionGroup);
		
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
		add(level.coverSwitchGroup);
		add(level.switchonGroup);
		_levelNumber = _levelNumber + 1;
		FlxG.switchState(new PlayState(_levelNumber));
		
	}
	
}
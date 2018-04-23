package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
class PlayState extends FlxState
{
	var level:Level;
	var player:Character;
	var _map:TiledMap;
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		level = new Level("assets/level1.tmx", this);
		
		add(level.backgroundGroup);
		add(level.characterGroup);
		add(level.foregroundGroup);
		
		add(level.collisionGroup);
		
		FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		FlxG.worldBounds.copyFrom(level.bounds);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		level.update(elapsed);
		super.update(elapsed);
	}	
}
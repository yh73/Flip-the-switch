package;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import openfl.events.Event;
import flixel.FlxSprite;
class Backpack extends FlxSprite
{   
    var player:Character;
    var tileSize:Int;
    static var counter = 0;
	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super(0,0);
        makeGraphic(5 * size, size, color);
        FlxGridOverlay.overlay(this, size, size,  number * size, 
            size, true, color);
        player = character;
        tileSize = size;
        visible = false;
	}
	
    override public function update(elapsed:Float):Void 
    {
        x = player.x - 4.5 * tileSize / 2;
        y = player.y + tileSize;
        if (FlxG.keys.justPressed.B) {
            visible = !visible;
        }
    }
}
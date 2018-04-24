package;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import openfl.events.Event;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
class Backpack extends FlxTypedGroup<FlxSprite>
{   
    var player:Character;
    var tileSize:Int;
    var border:FlxSprite; 
    var itemGroup:FlxTypedGroup<FlxSprite>;
    static var counter = 0;
	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        border = new FlxSprite(0,0).makeGraphic(5 * size, size, color);
        this.add(FlxGridOverlay.overlay(border, size, size,  number * size, 
            size, true, color));
        
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/health.png", 32, 32));
        player = character;
        tileSize = size;
        visible = false;
	}
	


    override public function update(elapsed:Float):Void 
    {   
        for (item in this) {
            item.x = player.x - 4.5 * tileSize / 2;
            item.y = player.y + tileSize;
        }
       
        if (FlxG.keys.justPressed.B) {
            visible = !visible;
        }
    }
}
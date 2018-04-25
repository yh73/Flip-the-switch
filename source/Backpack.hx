package;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import openfl.events.Event;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
class Backpack extends FlxTypedGroup<FlxSprite>
{   
    public var border:FlxSprite;
    var player:Character;
    var tileSize:Int; 
    static var counter = 0;
	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        border = new FlxSprite(0,0).makeGraphic(5 * size, size, color);
        border = FlxGridOverlay.overlay(border, size, size,  number * size, 
            size, true, color);
        
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/health.png", 32, 32));
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/health.png", 32, 32));
        player = character;
        tileSize = size;
        visible = false;
        border.visible = false;
	}
	


    override public function update(elapsed:Float):Void 
    {   
        var i = 0;
        border.x = player.x - 4.5 * tileSize / 2;
        border.y = player.y + tileSize;
        for (item in this) {
            if (FlxG.mouse.overlaps(item, null)) {
                FlxG.mouse.visible = false;
            }
            item.x = player.x - 4.5 * tileSize / 2 + 32 * i;
            item.y = player.y + tileSize;
            i++;
        }
       
        if (FlxG.keys.justPressed.B) {
            visible = !visible;
            border.visible = !border.visible;
        }
    }
}
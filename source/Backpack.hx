package;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import openfl.events.Event;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxButtonPlus;

class Backpack extends FlxTypedGroup<FlxSprite>
{   
    public var border:FlxSprite;
    public var dropDown:FlxUIDropDownMenu;
    public var buttons:FlxTypedGroup<FlxButtonPlus>;
    public var equipSlot:FlxSprite;
    var player:Character;
    var tileSize:Int; 
    static var counter = 0;

	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        player = character;
        tileSize = size;
        buttons = new FlxTypedGroup<FlxButtonPlus>();
        equipSlot = new FlxSprite(0,0).makeGraphic(size, size, color);
        border = new FlxSprite(0,0).makeGraphic(5 * size, size, color);
        border = FlxGridOverlay.overlay(border, size, size,  number * size, 
            size, true, color);
        buttons.add(new FlxButtonPlus(0,0, null,"Equip", 32, 16));
        buttons.add(new FlxButtonPlus(0,0, null,"Craft", 32, 16));
        dropDown = new FlxUIDropDownMenu(0, 0,
            FlxUIDropDownMenu.makeStrIdLabelArray(["Equip", "Craft"]),
            new FlxUIDropDownHeader(64));
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/health.png", 32, 32));
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/health.png", 32, 32));
        visible = false;
        buttons.kill();
        border.visible = false;
        equipSlot.visible = false;
	}
	


    override public function update(elapsed:Float):Void 
    {   
        var i = 0;
        border.x = player.x - 4.5 * tileSize / 2;
        border.y = player.y + tileSize;
        equipSlot.x = player.x - tileSize;
        equipSlot.y = player.y - tileSize / 2;
        for (item in this) {
            item.x = player.x - 4.5 * tileSize / 2 + 32 * i;
            item.y = player.y + tileSize;
            if (FlxG.mouse.overlaps(item, null) && border.visible) {
                /*
                dropDown.revive();
                dropDown.x = item.x;
                dropDown.y = item.y;
                */
                var j = 0;
                buttons.revive();
                for (button in buttons) 
                {  
                    button.x = item.x;
                    button.y = item.y + 16 * j;
                    j++;
                }
            } else if (FlxG.mouse.justPressed) {
                buttons.kill();
            }
            i++;
        }
       
        if (FlxG.keys.justPressed.B) {
            buttons.kill();
            visible = !visible;
            equipSlot.visible = !equipSlot.visible;
            border.visible = !border.visible;
        }
    }

    private function equip() 
    {
        buttons.kill();
    }
}
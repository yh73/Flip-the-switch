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
    public var buttons:FlxTypedGroup<FlxButtonPlus>;
    public var equipSlotBorder:FlxSprite;
    public var equipSlot:FlxSprite;
    public var firstTimeEquip = true;
    var player:Character;
    var tileSize:Int; 
    var lastItemIdx:Int;
    var button:FlxButtonPlus;
    static var counter = 0;

	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        player = character;
        tileSize = size;
        buttons = new FlxTypedGroup<FlxButtonPlus>();
        equipSlotBorder = new FlxSprite(0,0).makeGraphic(size, size, color);
        equipSlot = new FlxSprite(0,0,null);
        border = new FlxSprite(0,0).makeGraphic(5 * size, size, color);
        border = FlxGridOverlay.overlay(border, size, size,  number * size, 
            size, true, color);
        button = new FlxButtonPlus(0,0, equip,"Equip", 32, 16);
        buttons.add(button);
        buttons.add(new FlxButtonPlus(0,0, null,"Craft", 32, 16));
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/gold.png", 32, 32));
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/gold.png", 32, 32));
        this.add(new FlxSprite(border.x, border.y).loadGraphic("assets/health.png", 32, 32));
        visible = false;
        buttons.kill();
        border.visible = false;
        equipSlotBorder.visible = false;
        equipSlot.visible = false;
	}
	


    override public function update(elapsed:Float):Void 
    {   
        var i = 0;
        border.x = player.x - 4.5 * tileSize / 2;
        border.y = player.y + tileSize;
        if (equipSlot != null) {
            equipSlot.x = player.x - tileSize;
            equipSlot.y = player.y - tileSize / 2;
        }
        equipSlotBorder.x = player.x - tileSize;
        equipSlotBorder.y = player.y - tileSize / 2;
        for (item in this) {
            item.x = player.x - 4.5 * tileSize / 2 + 32 * i;
            item.y = player.y + tileSize;
            if (FlxG.mouse.overlaps(item, null) && border.visible) {
                var j = 0;
                buttons.revive();
                for (button in buttons) 
                {  
                    button.x = item.x;
                    button.y = item.y + 16 * j;
                    j++;
                }
            } else if (!FlxG.mouse.overlaps(border, null)) {
                buttons.kill();
            }
            i++;
            
        }
       
        if (FlxG.keys.justPressed.B) {
            buttons.kill();
            visible = !visible;
            if (!firstTimeEquip) {
                equipSlot.visible = !equipSlot.visible;
            }
            equipSlotBorder.visible = !equipSlotBorder.visible;
            border.visible = !border.visible;
        }
    }

    private function equip() 
    {   
        var itemToEquip = new FlxSprite(0,0);
        for (item in this) {
            if (item.x == button.x) {
                itemToEquip = item;
                break;
            }
        }
        lastItemIdx = this.members.indexOf(itemToEquip);
        if (!firstTimeEquip) {
            this.insert(lastItemIdx, new FlxSprite(0,0).loadGraphicFromSprite(equipSlot));
            equipSlot.loadGraphicFromSprite(this.remove(itemToEquip));
        } else {
            equipSlot.loadGraphicFromSprite(this.remove(itemToEquip));
            equipSlot.visible = true;
            firstTimeEquip = false;
        }
        buttons.kill();
    }
}
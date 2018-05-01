package;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.ui.FlxButtonPlus;

class Backpack extends FlxTypedGroup<Item>
{   
    public var border:FlxSprite;
    public var buttons:FlxTypedGroup<FlxButtonPlus>;
    public var equipSlotBorder:FlxSprite;
    public var equipSlot:Item;
    public var firstTimeEquip = true;
    public var unEquipButton:FlxButtonPlus;
    public var powerBar:PowerBar;
    public var hasLasso:Bool;
    public var hasSlingshot:Bool;
    var player:Character;
    var tileSize:Int; 
    var lastItemIdx:Int;
    var equipButton:FlxButtonPlus;
    static var counter = 0;

	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        player = character;
        tileSize = size;
        buttons = new FlxTypedGroup<FlxButtonPlus>();
        equipSlotBorder = new FlxSprite(0,0).makeGraphic(size, size, color);
        equipSlot = new Item(0.0, 0.0, "", "");
        border = new FlxSprite(0,0).makeGraphic(5 * size, size, color);
        border = FlxGridOverlay.overlay(border, size, size,  number * size, 
            size, true, color);
        equipButton = new FlxButtonPlus(0,0, equip,"Equip", 48, 16);
        unEquipButton = new FlxButtonPlus(0,0, unequip,"Unequip", 48, 16);
        buttons.add(equipButton);
        //buttons.add(new FlxButtonPlus(0,0, null,"Craft", 48, 16));
        visible = hasLasso = hasSlingshot = equipSlotBorder.visible =  border.visible = false;
        buttons.kill();
        unEquipButton.kill();
        equipSlot.kill();
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

        if (FlxG.mouse.overlaps(equipSlot, null) && equipSlotBorder.visible && !firstTimeEquip) {
            unEquipButton.revive();
            unEquipButton.x = equipSlot.x;
            unEquipButton.y = equipSlot.y;
        } else if (!FlxG.mouse.overlaps(equipSlot, null)) {
            unEquipButton.kill();
        }

        if (FlxG.keys.justPressed.B) {
            buttons.kill();
            unEquipButton.kill();
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
        var itemToEquip = new Item(0.0, 0.0, "", "");
        for (item in this) {
            if (item.x == equipButton.x) {
                itemToEquip = item;
                break;
            }
        }
        lastItemIdx = this.members.indexOf(itemToEquip);
        equipSlot.revive();
        if (!firstTimeEquip) {
            this.insert(lastItemIdx, new Item(equipSlot.x, equipSlot.y, equipSlot.name, equipSlot.mypath));
            equipSlot.loadGraphicFromItem(this.remove(itemToEquip));
        } else {
            equipSlot.loadGraphicFromItem(this.remove(itemToEquip));
            firstTimeEquip = false;
        }
        buttons.kill();
    }

    private function unequip() 
    {
        this.add(new Item(equipSlot.x, equipSlot.y, equipSlot.name, equipSlot.mypath));
        equipSlot.kill();
        firstTimeEquip = true;
    }

    public function addItem(item:Item) 
    {
        this.add(item);
        if (item.name == "lasso") hasLasso = true;
        if (item.name == "slingshot") hasSlingshot = true;
    }

}
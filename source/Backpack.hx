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
    public var border:FlxTypedGroup<Item>;
    public var powerBar:PowerBar;
    public var hasLasso:Bool;
    public var hasSlingshot:Bool;
    var player:Character;
    public var currentItem:Item;
    var tileSize:Int; 
    var currentItemIdx:Int;
    static var counter = 0;

	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        player = character;
        tileSize = size;
        currentItem = new Item(0.0, 0.0, "", "", "");
        border = new FlxTypedGroup<Item>();
        for (i in 0...6) {
            border.add(new Item(0, 0, "slot", "inventory", "slot"));
        }
        hasLasso = hasSlingshot = false;
        hasLasso = false;
        currentItemIdx = -1;
        hasSlingshot = false;
	}
	


    override public function update(elapsed:Float):Void 
    {   
        var i = 0;
        for (slot in border) {
            slot.x = FlxG.camera.scroll.x + 165 + 45 * i;
            slot.y = FlxG.camera.scroll.y + 435;
            if (FlxG.mouse.overlaps(slot, null) && FlxG.mouse.justPressed && currentItemIdx == i) {
                slot.loadGraphic("assets/inventory.png");
                currentItemIdx = -1;
                currentItem = new Item(0, 0, "", "", "");
            } else if (FlxG.mouse.overlaps(slot, null) && FlxG.mouse.justPressed) {
                slot.loadGraphic("assets/highlight.png");
                if (currentItemIdx != -1) {
                    border.members[currentItemIdx].loadGraphic("assets/inventory.png");
                }
                currentItemIdx = i;
                currentItem = this.members[currentItemIdx];
            }
            i++;
        }
        
        if (currentItem.name == "lasso"){
            hasLasso = true;
            hasSlingshot = false;
        } else if (currentItem.name == "slingshot") {
            hasSlingshot = true;
            hasLasso = false;
        } else {
           hasLasso = hasSlingshot = false;
        }
        i = 0;
        for (item in this) {
            item.x = FlxG.camera.scroll.x + 165 + 45 * i + 6.5;
            item.y = FlxG.camera.scroll.y + 435 + 6.5;
            if (i == currentItemIdx) {
                currentItem = item;
            }
            i++;
        }
    }
    
    public function addItem(item:Item) 
    {
        this.add(item);
    }

}
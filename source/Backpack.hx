package;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
class Backpack extends FlxTypedGroup<Item>
{   
    public var border:FlxTypedGroup<Item>;
    public var index:FlxTypedGroup<FlxText>;
    public var powerBar:PowerBar;
    public var hasLasso:Bool;
    public var hasSlingshot:Bool;
    var player:Character;
    public var currentItem:Item;
    var tileSize:Int; 
    public var currentItemIdx:Int;
    static var counter = 0;

	override public function new(size:Int, number:Int, color:FlxColor, character:Character) 
	{
		super();
        player = character;
        tileSize = size;
        currentItem = new Item(0.0, 0.0, "", "", "");
        border = new FlxTypedGroup<Item>();
        index = new FlxTypedGroup<FlxText>();
        for (i in 0...6) {
            border.add(new Item(0, 0, "slot", "inventory", "slot"));
        }

        for (i in 1...7) {
            index.add(new FlxText(0,0,Std.string(i),8));
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
            var keyPressed = false;
            switch (i) {
                case 0: keyPressed = FlxG.keys.justPressed.ONE;
                case 1: keyPressed = FlxG.keys.justPressed.TWO;
                case 2: keyPressed = FlxG.keys.justPressed.THREE;
                case 3: keyPressed = FlxG.keys.justPressed.FOUR;
                case 4: keyPressed = FlxG.keys.justPressed.FIVE;
                default: keyPressed = FlxG.keys.justPressed.SIX;
            }
            if ((FlxG.mouse.overlaps(slot, null) && FlxG.mouse.justPressed || keyPressed )&& currentItemIdx == i) {
                slot.loadGraphic("assets/inventory.png");
                currentItemIdx = -1;
                currentItem = new Item(0, 0, "", "", "");
            } else if ((FlxG.mouse.overlaps(slot, null) && FlxG.mouse.justPressed) || keyPressed) {
                slot.loadGraphic("assets/highlight.png");
                if (currentItemIdx != -1) {
                    border.members[currentItemIdx].loadGraphic("assets/inventory.png");
                }
                currentItemIdx = i;
                if (i < this.length) {
                    currentItem = this.members[currentItemIdx];
                } else {
                    currentItem = new Item(0, 0, "", "", "");
                }
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

        i = 0;
        for (text in index) {
            text.x = FlxG.camera.scroll.x + 170 + 45 * i;
            text.y = FlxG.camera.scroll.y + 435 + 6.5;
            text.color = FlxColor.CYAN;
            i ++;
        }
    }

    public function openDoor(name:String) {
        for (item in this) {
            if (item.name == name) {
                this.remove(item, true);
                return true;
            }
        }
        return false;
    }
    
    public function addItem(item:Item) 
    {   
        this.add(item);
    }
}
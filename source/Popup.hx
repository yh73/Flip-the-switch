import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import flixel.ui.FlxButton;

class Popup extends FlxSubState
{
    public var content:FlxText;
    public var button:FlxText;
    public var bg:FlxSprite;
    public var bgcolor:FlxSprite;

    override public function new (text:String) {
        super();
        bg = new FlxSprite(160, 150).loadGraphic("assets/popupborder.png");
        bgcolor = new FlxSprite(160, 150).loadGraphic("assets/popupcolor.png");
        content = new FlxText(200, 170, text, 12);
        content.fieldWidth = 240;
        button = new FlxText(337, 285, "Click to Continue ->", 10);
        add(bg);
        add(bgcolor);
        add(content);
        add(button);
    }
	
    override public function update(elapsed:Float):Void
	{
        if (FlxG.mouse.justPressed) {
            close();
        }
    }
}
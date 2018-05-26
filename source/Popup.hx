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
        bg = new FlxSprite(FlxG.camera.x + 160, FlxG.camera.y + 150).loadGraphic("assets/popupborder.png");
        bgcolor = new FlxSprite(FlxG.camera.x + 160, FlxG.camera.y + 150).loadGraphic("assets/popupcolor.png");
        content = new FlxText(FlxG.camera.x + 200, FlxG.camera.y + 170, text, 12);
        bg.scrollFactor.set();
        bgcolor.scrollFactor.set();
        content.scrollFactor.set();
        content.fieldWidth = 240;
        button = new FlxText(FlxG.camera.x + 337, FlxG.camera.y + 285, "Click to Continue ->", 10);
        button.scrollFactor.set();
        add(bg);
        add(bgcolor);
        add(content);
        add(button);
    }
	
    override public function update(elapsed:Float):Void
	{
        if (FlxG.mouse.justPressed || FlxG.keys.anyPressed([SPACE, E])) {
            close();
        }
    }
}
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;

class Item extends FlxSprite{

    public var name:String;

    override public function new(o:TiledObject) {
        var x:Int = o.x;
        var y:Int = o.y;
        super(x, y);
        loadGraphic("assets/" + o.properties.get("name") + ".png");
        immovable = true;
        name = o.name;
    }
}
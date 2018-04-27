import flixel.addons.editors.tiled.TiledObject;
import flixel.FlxObject;

class Door extends FlxObject{

    public var name:String;
    override public function new(o:TiledObject) {
        var x:Int = o.x;
        var y:Int = o.y;
        super(x, y, o.width, o.height);
        immovable = true;
        name = o.name;
    }
}
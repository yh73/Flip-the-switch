import flixel.FlxSprite;

class Item extends FlxSprite{

    public var name:String;
    public var mypath:String;
    public var type:String;

    override public function new(x:Float, y:Float, name:String, mypath:String, type:String) {
        super(x, y);
        this.name = name;
        this.mypath = mypath;
        this.type = type;
        loadGraphic("assets/" + mypath + ".png");
        immovable = true;
    }

    public function loadGraphicFromItem(item:Item):Item {
        loadGraphic("assets/" + item.mypath + ".png");
        this.name = item.name;
        this.mypath = item.mypath;
        return this;
    }
}
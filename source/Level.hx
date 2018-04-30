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
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author MrCdK
 */
class Level extends TiledMap
{
	private inline static var PATH_TILESETS = "assets/maps/tiles.png";
	
	public var backgroundGroup:FlxTypedGroup<FlxTilemapExt>;
	public var foregroundGroup:FlxTypedGroup<FlxTilemapExt>;

	public var switchonGroup:FlxTypedGroup<FlxTilemapExt>;
	public var switchoffGroup:FlxTypedGroup<FlxTilemapExt>;

	public var collisionGroup:FlxTypedGroup<FlxObject>;
	public var characterGroup:FlxTypedGroup<Character>;
	public var itemGroup:FlxTypedGroup<Item>;
	public var doorGroup:FlxTypedGroup<Door>;

	public var waterGroup:FlxTypedGroup<FlxObject>;
	public var waterFront:FlxObject;
	public var waterBack:FlxObject;

	// open area to door collision
	public var openMap:Map<FlxObject, Door>;
	// open area to item
	public var itemMap:Map<FlxObject, Item>;

	public var doorNameToOpenGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	public var doorNameToOpenFgGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	public var doorNameToClosedGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	public var doorNameToClosedFgGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	
	public var popUp:FlxText;
	public var itemPopUp:FlxText;
	public var bounds:FlxRect;

	public var _state:PlayState;

	public function new(level:Dynamic, state:PlayState) 
	{
		super(level);

		_state = state;
		
		// background and foreground groups
		backgroundGroup = new FlxTypedGroup<FlxTilemapExt>();
		foregroundGroup = new FlxTypedGroup<FlxTilemapExt>();

		// switch on/off groups
		switchonGroup = new FlxTypedGroup<FlxTilemapExt>();
		switchoffGroup = new FlxTypedGroup<FlxTilemapExt>();

		// item group
		itemGroup = new FlxTypedGroup<Item>();

		// door group
		doorGroup = new FlxTypedGroup<Door>();

		// water group
		waterGroup = new FlxTypedGroup<FlxObject>();
		waterFront = new FlxObject();
		waterBack = new FlxObject();
		
		// events and collision groups
		characterGroup = new FlxTypedGroup<Character>();
		collisionGroup = new FlxTypedGroup<FlxObject>();

		// Mapping from area to door
		openMap = new Map<FlxObject, Door>();
		// Mapping area to item
		itemMap = new Map<FlxObject, Item>();

		// Mapping from door's name to door's Group
		doorNameToOpenGroup = new Map<String, FlxTypedGroup<FlxTilemapExt>>();
		doorNameToOpenFgGroup = new Map<String, FlxTypedGroup<FlxTilemapExt>>();
		doorNameToClosedGroup = new Map<String, FlxTypedGroup<FlxTilemapExt>>();

		// The bound of the map for the camera
		bounds = FlxRect.get(0, 0, fullWidth, fullHeight);
		
		// Popup ui initialization
		popUp = new FlxText(0,0, 7*32, "E", 12);
		itemPopUp = new FlxText(0,0, 7*32, "E", 12);
		popUp.alignment = FlxTextAlign.CENTER;
		itemPopUp.alignment = FlxTextAlign.CENTER;
		popUp.kill();
		itemPopUp.kill();
		//popUp.kill();
		var tileset:TiledTileSet;
		var tilemap:FlxTilemapExt;
		
		
		for (tiledLayer in layers)
		{
			if (tiledLayer.type != TiledLayerType.TILE)
				continue;
			var layer:TiledTileLayer = cast tiledLayer;
			
			if (layer.properties.contains("tileset"))
				tileset = this.getTileSet(layer.properties.get("tileset"));
			else
				throw "Each layer needs a tileset property with the tileset name";
			
			if (tileset == null)
				throw "The tileset is null";
			
			tilemap = new FlxTilemapExt();
			tilemap.loadMapFromArray(
				layer.tileArray,
				layer.width,
				layer.height,
				PATH_TILESETS,
				tileset.tileWidth,                      // each tileset can have a different tile width or height
				tileset.tileHeight,
				OFF,                                    // disable auto map
				tileset.firstGID                        // IMPORTANT! set the starting tile id to the first tile id of the tileset
			);
			
			
			if (layer.properties.contains("fg"))
				foregroundGroup.add(tilemap);
			else if (layer.properties.contains("switchoff"))
				switchoffGroup.add(tilemap);
			else if (layer.properties.contains("switchon"))
				switchonGroup.add(tilemap);
			else if (layer.properties.contains("bg"))
				backgroundGroup.add(tilemap);
			else if (layer.properties.contains("doorOpen")) {
				var doorOpenGroup:FlxTypedGroup<FlxTilemapExt> = new FlxTypedGroup<FlxTilemapExt>();
				doorOpenGroup.add(tilemap);
				doorNameToOpenGroup.set(layer.properties.get("doorOpen"), doorOpenGroup);
			} else if (layer.properties.contains("doorOpenFg")) {
				var doorOpenFgGroup:FlxTypedGroup<FlxTilemapExt> = new FlxTypedGroup<FlxTilemapExt>();
				doorOpenFgGroup.add(tilemap);
				doorNameToOpenFgGroup.set(layer.properties.get("doorOpenFg"), doorOpenFgGroup);
			} else if (layer.properties.contains("doorClosed")) {
				var doorClosedGroup:FlxTypedGroup<FlxTilemapExt> = new FlxTypedGroup<FlxTilemapExt>();
				doorClosedGroup.add(tilemap);
				doorNameToClosedGroup.set(layer.properties.get("doorClosed"), doorClosedGroup);
			}
		}
		loadObjects(state);
	}
	
	public function loadObjects(state:PlayState)
	{
		var stringOpen:Map<String, FlxObject> = new Map<String, FlxObject>();
		var stringDoor:Map<String, Door> = new Map<String, Door>();
		var stringitem:Map<String, Item> = new Map<String, Item>();
		var stringchoose:Map<String, FlxObject> = new Map<String, FlxObject>();
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var group:TiledObjectLayer = cast layer;

			if (group.properties.contains("opendoor")) {
				for (o in group.objects) {
					var x:Int = o.x;
					var y:Int = o.y;
					var open:FlxObject = new FlxObject(x, y, o.width, o.height);
					open.immovable = true;
					stringOpen.set(o.name, open);
				}
			} else if (group.properties.contains("door")) {
				for (o in group.objects) {
					var door:Door = new Door(o);
					doorGroup.add(door);
					stringDoor.set(o.name, door);
				}
			} else if (group.properties.contains("item")) {
				for (o in group.objects) {
					var item:Item = new Item(o.x, o.y, o.name, o.properties.get("from"));
					stringitem.set(o.name, item);
					itemGroup.add(item);
				}
			} else if (group.properties.contains("itemchoose")) {
				for (o in group.objects) {
					var x:Int = o.x;
					var y:Int = o.y;
					var area:FlxObject = new FlxObject(x, y, o.width, o.height);
					area.immovable = true;
					stringchoose.set(o.name, area);
				}
			}else {
				for (obj in group.objects)
				{
					loadObject(state, obj, group);
				}
			}
		}
		for (key in stringOpen.keys()) {
			openMap.set(stringOpen[key], stringDoor[key]);
		}
		for (key in stringitem.keys()) {
			itemMap.set(stringchoose[key], stringitem[key]);
		}
	}
	
	private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		switch (o.type.toLowerCase())
		{   
            
			case "player":
				var player = new Character(o.name, x, y, "assets/"+o.name+".json");
				player.setBoundsMap(bounds);
				player.controllable = true;
				FlxG.camera.follow(player);
				characterGroup.add(player);
				state.player = player;
				
			case "collision":
				var coll:FlxObject = new FlxObject(x, y, o.width, o.height);
				#if FLX_DEBUG
				coll.debugBoundingBoxColor = 0xFFFF00FF;
				#end
				coll.immovable = true;
				collisionGroup.add(coll);

			case "opensw":
				var sw = new FlxObject(x, y, o.width, o.height);
				state.sw = sw;

			case "water":
				var water = new FlxObject(x, y, o.width, o.height);
				waterGroup.add(water);

			case "waterfront":
				waterFront = new FlxObject(x, y, o.width, o.height);

			case "waterback":
				waterBack = new FlxObject(x, y, o.width, o.height);
		}
	}
	
	public function update(elapsed:Float):Void
	{
		moveBlock();
		updateCollisions();
		updateEventsOrder();
	}

	public function moveBlock():Void
	{
		if (FlxG.keys.anyJustPressed([M])) {
			if (FlxG.overlap(_state.block, waterBack)) {
				_state.block.velocity.y = 60;
			}
			else if (FlxG.overlap(_state.block, waterFront)) {
				_state.block.velocity.y = -60;
			}
		}
	}

	public function updateEventsOrder():Void
	{
		characterGroup.sort(FlxSort.byY);
	}
	
	public function updateCollisions():Void
	{
		popUp.x = _state.player.x - 3*32;
		popUp.y = _state.player.y - 42;
		itemPopUp.x = _state.player.x - 3*32;
		itemPopUp.y = _state.player.y - 42;
		for (open in openMap.keys()) {
			if (FlxG.overlap(characterGroup, open)) {
				popUp.revive();
				if (FlxG.keys.anyJustPressed([E])) {
					var curr:String = openMap[open].name;
					var doorOpenGroup = doorNameToOpenGroup[curr];
					var doorClosedGroup = doorNameToClosedGroup[curr];
					var doorOpenFgGroup = doorNameToOpenFgGroup[curr];
					_state.remove(doorClosedGroup);
					_state.add(doorOpenGroup);
					_state.add(doorOpenFgGroup);
					openMap[open].kill();
				} 
			} else {
				popUp.kill();
			}
		}

		for (choose in itemMap.keys()) {
			if ((FlxG.overlap(characterGroup, choose) && FlxG.keys.justPressed.E)
			|| (FlxG.overlap(_state.lasso.end, choose) && _state.lasso.lifeSpan <= 0)) {
				var item:Item = itemMap[choose];
				_state.backpack.addItem(new Item(item.x, item.y, item.name, item.mypath));
				item.kill();
				itemPopUp.text = "You got a key";
				itemPopUp.revive();
				var timer = new FlxTimer();
				timer.start(1, onTimer, 1);
				itemMap[choose].kill();
				choose.kill();
			}else if (FlxG.overlap(characterGroup, choose)){
				popUp.revive();
			} else {
				popUp.kill();
			}
		}

		if (FlxG.overlap(_state.lasso, collisionGroup) || FlxG.overlap(_state.lasso, doorGroup))
		{
			_state.lasso.lifeSpan = 0;
		}
		FlxG.collide(characterGroup, collisionGroup);
		FlxG.collide(characterGroup, doorGroup);
		FlxG.collide(characterGroup, characterGroup);
	}

	private function onTimer(Timer:FlxTimer):Void {
		itemPopUp.kill();
	}
}
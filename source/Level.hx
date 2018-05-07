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
	public var buttonGroup:FlxTypedGroup<FlxSprite>;
	public var blockGroup:FlxTypedGroup<Block>;

	public var waterGroup:FlxTypedGroup<FlxObject>;
	public var waterFront:FlxObject;
	public var waterBack:FlxObject;
	public var waterLeft:FlxObject;
	public var waterRight:FlxObject;

	// open area to door collision
	public var openMap:Map<FlxObject, Door>;
	// open area to item
	public var itemMap:Map<FlxObject, Item>;
	// button to block
	public var buttonBlock:Map<FlxObject, Block>;

	public var doorNameToOpenGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	public var doorNameToOpenFgGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	public var doorNameToClosedGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	public var doorNameToClosedFgGroup:Map<String, FlxTypedGroup<FlxTilemapExt>>;
	
	public var popUp:FlxText;
	public var itemPopUp:FlxText;
	public var backpackPopUp:FlxText;
	public var tutorialPopUp:FlxSprite;
	public var bounds:FlxRect;

	public var _state:PlayState;
	public var before:Bool = false;
	public var xBebeforeBlock:Float;
	public var yBebeforeBlock:Float;
	public var count:Int;
	public var equipped = false;
	public var tutorialPopped = false;
	public var equippedPopped = false;

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

		// button group
		buttonGroup = new FlxTypedGroup<FlxSprite>();

		// block group
		blockGroup = new FlxTypedGroup<Block>();

		// water group
		waterGroup = new FlxTypedGroup<FlxObject>();
		waterFront = new FlxObject();
		waterBack = new FlxObject();
		waterLeft = new FlxObject();
		waterRight = new FlxObject();
		
		// events and collision groups
		characterGroup = new FlxTypedGroup<Character>();
		collisionGroup = new FlxTypedGroup<FlxObject>();

		// Mapping from area to door
		openMap = new Map<FlxObject, Door>();
		// Mapping area to item
		itemMap = new Map<FlxObject, Item>();
		// Mapping from button to block
		buttonBlock = new Map<FlxObject, Block>();

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

		// tutorial popup initialization
		tutorialPopUp = new FlxSprite(-100, -100);
		tutorialPopUp.loadGraphic("assets/flash.png");
		tutorialPopUp.exists = true;
		tutorialPopUp.kill();
		count = 0;

		// backpack text initialization
		backpackPopUp = new FlxText(0,0, 7*32, "Click your Item to use!", 12);
		backpackPopUp.kill();

		var tileset:TiledTileSet;
		var tilemap:FlxTilemapExt;
		
		
		for (tiledLayer in layers)
		{
			if (tiledLayer.type != TiledLayerType.TILE)
				continue;
			var layer:TiledTileLayer = cast tiledLayer;
			tileset = this.getTileSet("tiles");
			
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
		var stringButton:Map<String, FlxObject> = new Map<String, FlxObject>();
		var stringBlock:Map<String, Block> = new Map<String, Block>();
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
					var item:Item = new Item(o.x, o.y, o.name, o.properties.get("from"), o.type);
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
			} else if (group.properties.contains("button")) {
				for (o in group.objects) {
					var x:Int = o.x;
					var y:Int = o.y;
					var button = new FlxSprite(x+16, y+16);
					var area:FlxObject = new FlxObject(x, y, o.width, o.height);
					area.immovable = true;
					buttonGroup.add(button);
					stringButton.set(o.name, area);
				}
			} else if (group.properties.contains("block")) {
				for (o in group.objects) {
					var x:Int = o.x;
					var y:Int = o.y;
					var curr = new Block(x, y, this, _state);
					blockGroup.add(curr);
					stringBlock.set(o.name, curr);
				}
			} else {
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
		for (key in stringButton.keys()) {
			buttonBlock.set(stringButton[key], stringBlock[key.charAt(0)]);
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
				water.immovable = true;
				waterGroup.add(water);

			case "waterfront":
				waterFront = new FlxObject(x, y, o.width, o.height);

			case "waterback":
				waterBack = new FlxObject(x, y, o.width, o.height);

			case "waterleft":
				waterLeft = new FlxObject(x, y, o.width, o.height);

			case "waterright":
				waterRight = new FlxObject(x, y, o.width, o.height);
		}
	}
	
	public function update(elapsed:Float):Void
	{
		updateTutorial();
		updateSlingshot();
		updateTouchingWater();
		updateButtonBlock();
		updateCollisions();
		updateEventsOrder();
	}

	private function updateTutorial():Void
	{
		if (_state._levelNumber == 5) {
			var hasLasso = _state.backpack.hasLasso;
			var hasSlingshot = _state.backpack.hasSlingshot; 
			if (equipped && (hasLasso || hasSlingshot)) {
				equippedPopped = true;
				tutorialPopUp.kill();
				backpackPopUp.kill();
				if ((!_state.powerBar.exists) && (!tutorialPopped)) {
					displayMsg("Press SPACE to focus!");
				}
				else if (_state.powerBar.exists) {
					tutorialPopped = true;
					if (hasLasso)
						displayMsg("Press SPACE to use lasso!");
					else if (hasSlingshot)
						displayMsg("Press SPACE to shoot!");
				}
			} 
			else if (equipped && (!equippedPopped)) {
				backpackPopUp.reset(FlxG.camera.scroll.x + 100, FlxG.camera.scroll.y + 415);
				if (count <= 25) {
					tutorialPopUp.reset(FlxG.camera.scroll.x + 165, FlxG.camera.scroll.y + 435);
					count++;
				}
				else {
					tutorialPopUp.kill();
					count = (count + 1) % 50;
				}
			}
			if ((!hasLasso) && (!hasSlingshot)) {
				tutorialPopped = false;
			}
		}
	}

	private function updateSlingshot():Void
	{
		FlxG.overlap(_state.slingshot.playerBullets, collisionGroup, stuffHitStuff);
		FlxG.overlap(_state.slingshot.playerBullets, doorGroup, stuffHitStuff);	
	}

	private function stuffHitStuff(Object1:FlxObject, Object2:FlxObject):Void
	{
		Object1.kill();
	}

	private function updateTouchingWater():Void
	{
		var touch:Bool = false;
		for (i in 0...blockGroup.length) {
			var block = blockGroup.members[i].block;
			if (FlxG.overlap(_state.player, block)) {
				touch = true;
				break;
			}
		}
		if (!touch) {
			FlxG.collide(characterGroup, waterGroup);
		}
		if (!touch) {
			if (before && FlxG.overlap(_state.player, waterGroup)) {
				_state.player.kill();
				//Main.LOGGER.logLevelAction(2, {coor: _state.player.x + ", " +_state.player.y});
				_state.player.x = xBebeforeBlock;
				_state.player.y = yBebeforeBlock;
				_state.player.revive();
			}
			before = false;
			xBebeforeBlock = _state.player.x;
			yBebeforeBlock = _state.player.y;
		} else {
			before = true;
		}

	}

	private function updateButtonBlock():Void
	{
		for (key in buttonBlock.keys()) {
            var button = key;
            if (FlxG.overlap(_state.slingshot.playerBullets, button)
			    || (FlxG.overlap(_state.player, button) && FlxG.keys.anyJustPressed([E]))) {
			    moveBlock(buttonBlock[button].block);
		    }
        }
	}

	public function moveBlock(block:FlxSprite):Void
	{
		if (FlxG.overlap(block, waterBack)) {
			block.velocity.y = 60;
		}
		else if (FlxG.overlap(block, waterFront)) {
			block.velocity.y = -60;
		}
		else if (FlxG.overlap(block, waterLeft)) {
			block.velocity.x = 60;
		}
		else if (FlxG.overlap(block, waterRight)) {
			block.velocity.x = -60;
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
		var overlapped = false;
		for (open in openMap.keys()) {
			if (FlxG.overlap(characterGroup, open)) {
				var door:Door = openMap[open];
				overlapped = true;
				if (FlxG.keys.anyJustPressed([E]) && (door.need == "" || (door.need == "key1" && _state.backpack.keyNum > 0))) {
					var curr:String = openMap[open].name;
					var doorOpenGroup = doorNameToOpenGroup[curr];
					var doorClosedGroup = doorNameToClosedGroup[curr];
					var doorOpenFgGroup = doorNameToOpenFgGroup[curr];
					_state.remove(doorClosedGroup);
					_state.add(doorOpenGroup);
					_state.add(doorOpenFgGroup);
					_state.backpack.openDoor();
					openMap[open].kill();
					open.kill();
					break; 
				} else if (FlxG.keys.anyJustPressed([E])) {
					displayMsg("The door is locked.");
				}
			}
		}

		for (choose in itemMap.keys()) {
			if ((FlxG.overlap(characterGroup, choose) && FlxG.keys.justPressed.E)
			|| (FlxG.overlap(_state.lasso.end, choose) && _state.lasso.lifeSpan <= 0)) {
				var item:Item = itemMap[choose];
				_state.backpack.addItem(new Item(item.x, item.y, item.name, item.mypath, item.type));
				item.kill();
				if (item.type == "lasso" || item.type == "slingshot") {
					equipped = true;
				}
				displayMsg("You got a " + item.type);
				itemMap[choose].kill();
				choose.kill();
				break;
			} else if (FlxG.overlap(characterGroup, choose)){
				overlapped = true;
			}
		}
		if (FlxG.overlap(_state.player, _state.sw)) {
			overlapped = true;
			if (FlxG.keys.anyJustPressed([E])) {
				_state.nextLevel(_state.player, _state.sw);
			}
		}

		if ((FlxG.overlap(_state.lasso.end, _state.sw) && _state.lasso.lifeSpan <= 0)) {
			_state.nextLevel(_state.player, _state.sw);
		}

		for (key in buttonBlock.keys()) {
			if (FlxG.overlap(_state.player, key)) {
				overlapped = true;
			}
		}

		if (overlapped && !itemPopUp.alive) {
			popUp.revive();
		} else {
			popUp.kill();
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

	private function displayMsg(content:String) 
	{	
		popUp.kill();
		itemPopUp.text = content;
		itemPopUp.revive();
		var timer = new FlxTimer();
		timer.start(1, onTimer, 1);
	}
}
package;

import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.math.FlxRect;

class PlayState extends FlxState
{
	var tiles = new FlxTypedGroup<Tile>();
	var gameAreaWidth:Int = 10;
	var gameAreaHeight:Int = 8;

	public static inline var TILE_WIDTH:Int = 78;
	public static inline var TILE_HEIGHT:Int = 60;

	var cursors = new FlxTypedGroup<FlxObject>();
	var cursorType:Int = 1;
	public static inline var NUM_CURSOR_TYPES:Int = 13;

	var TILL:Int = 1;
	var WATER:Int = 2;
	var SEED:Int = 3;
	
	var action:Int = 1;

	var bg:FlxSprite;

	var day:Int = 1;
	var dayTime:Float = 0.0;
	var dayTimeTotal:Float = 25.0;

	var dayTimeBar:FlxSprite;

	var dayText:FlxText;

	var cameraHUD:FlxCamera;

	override public function create():Void
	{
		super.create();

		flixelInit();

		bg = new FlxSprite(0, 0, "assets/images/bg.png");
		add(bg);

		var tileX:Float = (FlxG.width - gameAreaWidth * TILE_WIDTH) * 0.5;
		var tileY:Float = ((FlxG.height + 45) - gameAreaHeight * TILE_HEIGHT) * 0.5;
		for (w in 0...gameAreaWidth) {
			for (h in 0...gameAreaHeight) {
				tiles.add(new Tile(tileX + TILE_WIDTH * w, tileY + TILE_HEIGHT * h));
			}
		}

		add(tiles);

		cameraHUD = new FlxCamera();
		FlxG.cameras.add(cameraHUD);

		dayTimeBar = new FlxSprite(0, FlxG.height - 18);
		dayTimeBar.makeGraphic(FlxG.width, 18, 0xffffffff);
		dayTimeBar.camera = cameraHUD;
		add(dayTimeBar);

		dayText = new FlxText(0, 0, 200, "Day 1", 24);
		dayText.camera = cameraHUD;
		add(dayText);

		var cursorX:Float = FlxG.mouse.x - TILE_WIDTH * 2.0;
		var cursorY:Float = FlxG.mouse.y - TILE_HEIGHT * 2.0;
		for (w in 0...5) {
			for (h in 0...5) {
				cursors.add(new FlxObject(cursorX + w * TILE_WIDTH, cursorY + h * TILE_HEIGHT, 0.1, 0.1));
				cursors.members[cursors.members.length - 1].exists = false;
			}
		}

		//  0,  1,  2,  3,  4, 
		//  5,  6,  7,  8,  9,
		// 10, 11, 12, 13, 14,
		// 15, 16, 17, 18, 19,
		// 20, 21, 22, 23, 24

		CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		dayTime += elapsed;
		if (dayTime >= dayTimeTotal) {
			dayTime -= dayTimeTotal;
			updateDay();
		}
		dayTimeBar.clipRect = new FlxRect(0, 0, FlxG.width * (dayTime / dayTimeTotal), 18);
		//trace("dayTimeBar.clipRect.x: " + dayTimeBar.clipRect.x + " .y: " + dayTimeBar.clipRect.y + " .w: " + dayTimeBar.clipRect.width + " .h: " + dayTimeBar.clipRect.height);

		var cursorX:Float = FlxG.mouse.x - TILE_WIDTH * 2.0;
		var cursorY:Float = FlxG.mouse.y - TILE_HEIGHT * 2.0;
		var i = 0;
		for (w in 0...5) {
			for (h in 0...5) {
				cursors.members[i].setPosition(cursorX + w * TILE_WIDTH, cursorY + h * TILE_HEIGHT);
				cursors.members[i].last.set(cursors.members[i].x, cursors.members[i].y);
				i++;
			}
		}

		if (!FlxG.mouse.justPressed && !FlxG.mouse.pressed)
			FlxG.overlap(cursors, tiles, onTileHover);
		else if (FlxG.mouse.justPressed)
			FlxG.overlap(cursors, tiles, onTileClick);

		if (FlxG.mouse.justPressed) {
			cursorType++;
			CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));
		}

		if (FlxG.keys.justPressed.SPACE) {
			CursorType.setType(cursors, FlxG.random.int(1, NUM_CURSOR_TYPES));
		}

		if (FlxG.keys.justPressed.W) {
			action = WATER;
		}
		else if (FlxG.keys.justPressed.T) {
			action = TILL;
		}
		else if (FlxG.keys.justPressed.S) {
			action = SEED;
		}

		if (FlxG.keys.justPressed.L || FlxG.mouse.justPressedMiddle) {
			CursorType.rotateLeft(cursors);
		}
		if (FlxG.keys.justPressed.R || FlxG.mouse.justPressedRight) {
			CursorType.rotateRight(cursors);
		}
	}

	function onTileClick(cursorPos:FlxObject, tile:Tile) {
		if (action == WATER) {
			tile.water();
		}
		else if (action == TILL) {
			tile.till();
		}
		else if (action == SEED) {
			tile.seed();
		}
	}

	function onTileHover(cursorPos:FlxObject, tile:Tile) {
		tile.select();
	}

	function updateDay() {
		day++;

		for (i in 0...tiles.members.length) {
			tiles.members[i].updateDay();
		}

		dayText.text = "Day " + day;
	}

	function flixelInit() {
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.unload();

		FlxG.maxElapsed = 0.05;
		FlxG.fixedTimestep = false;

		FlxG.stage.showDefaultContextMenu = false;

		#if html5
		FlxG.log.redirectTraces = true;
		#end

		FlxG.sound.cacheAll();

		FlxG.camera.bgColor = 0xff1b1c23;
	}
}

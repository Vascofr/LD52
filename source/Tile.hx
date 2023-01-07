package;

class Tile extends FlxSprite {

    var tilled:Int = 0;
    var wetness:Int = 0;
    var seedType:Int = 0;
    var growth:Int = 0;

    static inline var WETNESS_MAX:Int = 2;
    static inline var TILLED_MAX:Int = 4;

    var waterSprite:FlxSprite;
    var soilSprite:FlxSprite;
    var seedSprite:FlxSprite;

    public var selected:Bool = false;
    
    public function new(X:Float, Y:Float, Tilled:Int = 0, Wetness:Int = 0, SeedType:Int = 0) {

        super(X, Y);

        tilled = Tilled;
        wetness = Wetness;
        seedType = SeedType;

        makeGraphic(PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, 0x0);

        
        soilSprite = new FlxSprite(X, Y);
        soilSprite.makeGraphic(PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, 0x0);
        waterSprite = new FlxSprite(X, Y);
        waterSprite.makeGraphic(PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, 0x0);
        seedSprite = new FlxSprite(X, Y);
        seedSprite.makeGraphic(PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, 0x0);
        cast(FlxG.state, PlayState).add(soilSprite);
        cast(FlxG.state, PlayState).add(waterSprite);
        cast(FlxG.state, PlayState).add(seedSprite);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        
        if (selected && !FlxG.mouse.pressed) {
            selected = false;
            makeGraphic(PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, 0x0);
        }

    }

    public function water() {
        wetness++;
        if (wetness > WETNESS_MAX) {
            wetness = WETNESS_MAX;
            /*if (seedType != 0 && growth == 0) {
                seedType = 0;
                seedSprite.makeGraphic(1, 1, 0x0);    
            }*/
        }

        waterSprite.loadGraphic("assets/images/tiles/wet_" + wetness + ".png");
    }

    public function till() {
        
        if (tilled == 0) {
            soilSprite.loadGraphic("assets/images/tiles/tilled.png");
        }

        tilled = TILLED_MAX;        

        if (seedType != 0) {
            seedType = 0;
            seedSprite.makeGraphic(1, 1, 0x0);
        }
    }

    public function seed() {
        if (seedType == 0) {
            seedType = 1;
            seedSprite.loadGraphic("assets/images/tiles/seeds.png");
        }
    }

    public function select() {
        selected = true;
        loadGraphic("assets/images/tiles/selected.png");
    }

    public function updateDay() {
        if (seedType != 0 && growth == 0 && wetness > 0 && tilled > 0) {
            growth++;
            seedSprite.loadGraphic("assets/images/tiles/sprout_" + seedType + "_1.png");
        }


        if (wetness > 0) {
            wetness--;
            if (wetness == 0) {
                waterSprite.makeGraphic(1, 1, 0x0);
            }
            else if (wetness == 1) {
                waterSprite.loadGraphic("assets/images/tiles/wet_" + wetness + ".png");
            }
            
        }

        if (tilled > 0) {
            tilled--;
            if (tilled <= 0) {
                soilSprite.makeGraphic(1, 1, 0x0);
            }
            else if (tilled == 1) {
                soilSprite.loadGraphic("assets/images/tiles/tilled_1.png");
            }
        }
    }
}
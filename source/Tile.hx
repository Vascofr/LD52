package;

import flixel.tweens.FlxEase;

class Tile extends FlxSprite {

    var tilled:Int = 0;
    var wetness:Int = 0;
    var seedType:Int = 0;
    public var growth:Int = 0;
    var wilting:Int = 0;

    static inline var WETNESS_MAX:Int = 2;
    static inline var TILLED_MAX:Int = 4;
    public var maxGrowth:Int = 3;
    var maxWilting:Int = 3;

    var waterSprite:FlxSprite;
    var soilSprite:FlxSprite;
    var selectionSprite:FlxSprite;

    var harvestParticle:FlxSprite = null;

    public var selected:Bool = false;
    
    public function new(X:Float, Y:Float, Tilled:Int = 0, Wetness:Int = 0, SeedType:Int = 0) {

        super(X, Y);

        tilled = Tilled;
        wetness = Wetness;
        seedType = SeedType;

        //makeGraphic(PlayState.TILE_WIDTH, PlayState.TILE_HEIGHT, 0x0);
        loadGraphic("assets/images/tiles/empty_full.png");

        
        soilSprite = new FlxSprite(X, Y);
        soilSprite.loadGraphic("assets/images/tiles/empty_soil.png");
        soilSprite.color = PlayState.levelColor;
        waterSprite = new FlxSprite(X, Y);
        waterSprite.loadGraphic("assets/images/tiles/empty_1px.png");
        selectionSprite = new FlxSprite(X, Y);
        selectionSprite.loadGraphic("assets/images/tiles/empty_1px.png");
        cast(FlxG.state, PlayState).add(soilSprite);
        cast(FlxG.state, PlayState).add(waterSprite);
        cast(FlxG.state, PlayState).add(selectionSprite);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        
        if (selected && !FlxG.mouse.pressed) {
            selected = false;
            selectionSprite.loadGraphic("assets/images/tiles/empty_1px.png");
        }

    }

    public function water() {
        wetness++;
        if (wetness > WETNESS_MAX) {
            wetness = WETNESS_MAX;
        }

        waterSprite.loadGraphic("assets/images/tiles/wet_" + wetness + ".png");
    }

    public function till() {

        if (growth == maxGrowth)
            return;

        if (wilting == maxWilting) {
            color = 0xffffff;
        }
        wilting = 0;

        
        if (tilled <= 1) {
            soilSprite.loadGraphic("assets/images/tiles/tilled.png");
        }

        tilled = TILLED_MAX;        

        if (seedType != 0 && growth != maxGrowth) {
            seedType = 0;
            loadGraphic("assets/images/tiles/empty_full.png");
        }
    }

    public function seed() {
        var playState = cast(FlxG.state, PlayState);

        if (playState.seeds[playState.seedType - 1] <= 0) return;

        if (seedType == 0 || growth == 0) {
            seedType = playState.seedType;
            loadGraphic("assets/images/tiles/seeds.png");

            if (seedType == 1) maxGrowth = 3;
            else if (seedType == 2) maxGrowth = 2;
            else if (seedType == 3) maxGrowth = 4;
            else maxGrowth = 5;

            playState.seeds[seedType - 1]--;
            playState.seedQuantities.members[seedType - 1].text = "" + playState.seeds[seedType - 1];
        }
    }

    public function select() {
        selected = true;
        selectionSprite.loadGraphic("assets/images/tiles/selected.png");
    }

    public function harvest() {
        if (growth != maxGrowth) return;

        var playState = cast(FlxG.state, PlayState);

        //PlayState.cash += Seed.harvestValue[seedType];
        //playState.cashText.text = "$" + PlayState.cash;
        playState.harvested[seedType - 1]++;

        var particle = playState.particles.members[playState.particleIndex];

        particle.loadGraphic("assets/images/tiles/harvest_" + seedType + ".png");
        particle.x = x;
        particle.y = y;
        particle.exists = true;
        particle.alpha = 1.0;
        harvestParticle = particle;

        //playState.tweens.tween(particle, { y: this.y - 30 }, 0.8, { ease: FlxEase.cubeOut });
        playState.tweens.tween(particle, { x: FlxG.width * 0.5 - PlayState.TILE_WIDTH * 0.5,  y: FlxG.height + 45 }, 1.0, { ease: FlxEase.cubeOut });
        //playState.tweens.tween(particle, { alpha: 0.0 }, 0.3, { ease: FlxEase.cubeOut, startDelay: 0.5, onComplete: function(tween) { harvestParticle.exists = false; } });

        playState.particleIndex++;
        if (playState.particleIndex >= PlayState.MAX_PARTICLES) {
            playState.particleIndex = 0;
        }

        FlxG.camera.flash(0xaaffffff, 0.25);


        seedType = 0;
        growth = 0;
        tilled = 0;
        soilSprite.loadGraphic("assets/images/tiles/empty_soil.png");
        if (wilting == maxWilting) {
            color = 0xffffff;
        }
        wilting = 0;
        offset.y = 0.0;
        loadGraphic("assets/images/tiles/empty_full.png");
    }

    public function updateDay() {
        // grow sprouts //
        if (seedType != 0 && wetness > 0 && (growth > 0 || tilled > 0) && wilting < maxWilting) {
            growth++;
            wilting = 0;

            if (growth >= maxGrowth) {
                if (growth > maxGrowth) {
                    growth = maxGrowth;
                }
                else {
                    loadGraphic("assets/images/tiles/harvest_" + seedType + ".png");
                    offset.y = 9;
                }
            }
            else {
                loadGraphic("assets/images/tiles/sprout_" + seedType + "_" + growth + ".png");
            }
        }
        // else wilt sprout if it exists //
        else {
            if (seedType != 0 && growth != maxGrowth && growth > 0) {
                wilting++;
                if (wilting >= maxWilting) {
                    color = 0xaa5522;
                }
            }               
        }

        // dry water //
        if (wetness > 0) {
            wetness--;
            if (wetness == 0) {
                waterSprite.loadGraphic("assets/images/tiles/empty_1px.png");
            }
            else if (wetness == 1) {
                waterSprite.loadGraphic("assets/images/tiles/wet_" + wetness + ".png");
            }
            
        }

        // reduce till //
        if (tilled > 0) {
            tilled--;
            if (tilled <= 0) {
                soilSprite.loadGraphic("assets/images/tiles/empty_soil.png");
            }
            else if (tilled == 1) {
                soilSprite.loadGraphic("assets/images/tiles/tilled_1.png");
            }
        }
    }
}
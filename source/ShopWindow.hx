package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class ShopWindow extends FlxSubState {

    var bg:FlxSprite;
    var fadedBg:FlxSprite;
    var titleText:FlxText;

    var pricesText:FlxText;

    var cashText:FlxText;

    var listLeftText:FlxText;
    var listRightText:FlxText;

    var totalLeftText:FlxText;
    var totalRightText:FlxText;

    var continueButton:FlxButton;

    var slideInAmount:Int = 16;

    var tweens:FlxTweenManager = new FlxTweenManager();

    var waitToClose:Float = 0.0;

    var seedButtons = new FlxTypedGroup<FlxButton>();

    public function new(Title:String = null) {
        super();

        add(tweens);

        fadedBg = new FlxSprite(0, 0);
        fadedBg.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        fadedBg.camera = PlayState.cameraHUD;
        fadedBg.alpha = 0.5;
        add(fadedBg);

        bg = new FlxSprite((FlxG.width - 741) * 0.5, 27, "assets/images/window.png");
        bg.camera = PlayState.cameraHUD;
        bg.alpha = 0.0;
        add(bg);


        titleText = new FlxText(bg.x, bg.y + 39, bg.width, Title, 24);
        titleText.font = "assets/data/PressStart2P.ttf";
		titleText.camera = PlayState.cameraHUD;
        titleText.alignment = FlxTextAlign.CENTER;
        titleText.alpha = 0.0;
        add(titleText);

        pricesText = new FlxText(bg.x + 9, bg.y + 264, bg.width, "    $50   $20   $125  $300", 24);
        pricesText.font = "assets/data/PressStart2P.ttf";
		pricesText.camera = PlayState.cameraHUD;
        pricesText.alignment = FlxTextAlign.LEFT;
        pricesText.alpha = 0.0;
        add(pricesText);

        cashText = new FlxText(bg.x, bg.y + 330, bg.width, "Earnings: $" + PlayState.cash, 24);
        cashText.font = "assets/data/PressStart2P.ttf";
		cashText.camera = PlayState.cameraHUD;
        cashText.alignment = FlxTextAlign.CENTER;
        cashText.alpha = 0.0;
        add(cashText);


        seedButtons.add(new FlxButton(bg.x + 109, bg.y + 168, null, onSeed1));
        seedButtons.members[0].loadGraphic("assets/images/seed1_button.png", true, 69, 78);
        seedButtons.add(new FlxButton(bg.x + 259, bg.y + 168, null, onSeed2));
        seedButtons.members[1].loadGraphic("assets/images/seed2_button.png", true, 69, 78);
        seedButtons.add(new FlxButton(bg.x + 409, bg.y + 168, null, onSeed3));
        seedButtons.members[2].loadGraphic("assets/images/seed3_button.png", true, 69, 78);
        seedButtons.add(new FlxButton(bg.x + 559, bg.y + 168, null, onSeed4));
        seedButtons.members[3].loadGraphic("assets/images/seed4_button.png", true, 69, 78);

        seedButtons.forEach(function(button) { button.alpha = 0.0; button.y -= slideInAmount; });
        add(seedButtons);



        continueButton = new FlxButton(bg.x + 248, bg.y + 408, "Continue", function() { closeWindow(); });
        continueButton.loadGraphic("assets/images/button.png", true, 255, 69);
        continueButton.label.font = "assets/data/PressStart2P.ttf";
        continueButton.label.color = 0xffffff;
        continueButton.label.size = 24;
        continueButton.labelOffsets = [new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0)];
        continueButton.onOver.callback = function() { continueButton.label.color = 0xff4bf0f7; };
        continueButton.onOut.callback = function() { continueButton.label.color = 0xffffffff; };
        continueButton.camera = PlayState.cameraHUD;
        continueButton.alpha = 0.0;
        add(continueButton);


        bg.y -= slideInAmount;
        titleText.y -= slideInAmount;
        pricesText.y -= slideInAmount;
        cashText.y -= slideInAmount;
        continueButton.y -= slideInAmount;

        //tweens.tween(fadedBg, { alpha: 0.5 }, 0.3, { ease: FlxEase.quadOut });

        tweens.tween(bg, { alpha: 1.0 }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(pricesText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(cashText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(continueButton, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        seedButtons.forEach(function(button) { tweens.tween(button, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 }); });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(pricesText, { y: pricesText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(cashText, { y: cashText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        seedButtons.forEach(function(button) { tweens.tween(button, { y: button.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut }); });
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (waitToClose > 0.0) {
            waitToClose -= elapsed;
            if (waitToClose <= 0.0) {
                PlayState.cameraHUD.fade(0xff1b1c23, 1.2, true, null, true);
                close ();
            }
        }
        else if (FlxG.keys.justPressed.SPACE) {
            closeWindow();            
        }
    }

    function closeWindow() {
        tweens.tween(titleText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(pricesText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(cashText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        seedButtons.forEach(function(button) { tweens.tween(button, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut }); });
        tweens.tween(bg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });
        //tweens.tween(fadedBg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(pricesText, { y: pricesText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(cashText, { y: cashText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { waitToClose = 0.4; PlayState.cameraHUD.fade(0xff1b1c23, 0.4); } });
        seedButtons.forEach(function(button) { tweens.tween(button, { y: button.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 }); });
    }

    function onSeed1() {
        if (PlayState.cash < 50) return;

        var playState = cast(FlxG.state, PlayState);
        PlayState.cash -= 50;  //++++ add to seeds inventory   ++++ also put how many you have on top? won't be aligned... 
        playState.cashText.text = "$" + PlayState.cash + " / $" + playState.cashObjective;
        cashText.text = "Earnings: $" + PlayState.cash;
    }

    function onSeed2() {
        if (PlayState.cash < 20) return;

        var playState = cast(FlxG.state, PlayState);
        PlayState.cash -= 20;  //++++ add to seeds inventory
        playState.cashText.text = "$" + PlayState.cash + " / $" + playState.cashObjective;
        cashText.text = "Earnings: $" + PlayState.cash;
    }

    function onSeed3() {
        if (PlayState.cash < 125) return;

        var playState = cast(FlxG.state, PlayState);
        PlayState.cash -= 125;  //++++ add to seeds inventory
        playState.cashText.text = "$" + PlayState.cash + " / $" + playState.cashObjective;
        cashText.text = "Earnings: $" + PlayState.cash;
    }

    function onSeed4() {
        if (PlayState.cash < 300) return;

        var playState = cast(FlxG.state, PlayState);
        PlayState.cash -= 300;  //++++ add to seeds inventory
        playState.cashText.text = "$" + PlayState.cash + " / $" + playState.cashObjective;
        cashText.text = "Earnings: $" + PlayState.cash;
    }
}
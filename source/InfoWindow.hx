package;

import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class InfoWindow extends FlxSubState {

    var bg:FlxSprite;
    var fadedBg:FlxSprite;
    var titleText:FlxText;
    var descriptionText:FlxText;

    var continueButton:FlxButton;

    var tweens:FlxTweenManager = new FlxTweenManager();

    var waitToClose:Float = 0.0;

    var slideInAmount:Int = 16;

    public function new(Title:String = null, Description:String = null) {
        super();

        add(tweens);

        fadedBg = new FlxSprite(0, 0);
        fadedBg.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
        fadedBg.camera = cast(FlxG.state, PlayState).cameraHUD;
        fadedBg.alpha = 0.5;
        add(fadedBg);

        bg = new FlxSprite((FlxG.width - 741) * 0.5, 27, "assets/images/window.png");
        bg.camera = cast(FlxG.state, PlayState).cameraHUD;
        bg.alpha = 0.0;
        add(bg);


        titleText = new FlxText(bg.x, bg.y + 39, bg.width, Title, 24);
        titleText.font = "assets/data/PressStart2P.ttf";
		titleText.camera = cast(FlxG.state, PlayState).cameraHUD;
        titleText.alignment = FlxTextAlign.CENTER;
        titleText.alpha = 0.0;
        add(titleText);

        descriptionText = new FlxText(bg.x + 9, bg.y + 133, bg.width - 18, Description, 24);
        descriptionText.font = "assets/data/PressStart2P.ttf";
		descriptionText.camera = cast(FlxG.state, PlayState).cameraHUD;
        descriptionText.alignment = FlxTextAlign.CENTER;
        descriptionText.alpha = 0.0;
        add(descriptionText);

        


        var playState = cast(FlxG.state, PlayState);

        continueButton = new FlxButton(bg.x + 248, bg.y + 408, "Continue", onContinue );
        continueButton.loadGraphic("assets/images/button.png", true, 255, 69);
        continueButton.label.font = "assets/data/PressStart2P.ttf";
        continueButton.label.color = 0xffffff;
        continueButton.label.size = 24;
        continueButton.labelOffsets = [new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0), new FlxPoint(-3.0, 21.0)];
        continueButton.onOver.callback = function() { continueButton.label.color = 0xff4bf0f7; };
        continueButton.onOut.callback = function() { continueButton.label.color = 0xffffffff; };
        continueButton.camera = cast(FlxG.state, PlayState).cameraHUD;
        continueButton.alpha = 0.0;
        add(continueButton);

        if (EndWindow.won) {
            continueButton.text = "Restart";
            descriptionText.y += 8;
        }


        bg.y -= slideInAmount;
        titleText.y -= slideInAmount;
        descriptionText.y -= slideInAmount; 
        continueButton.y -= slideInAmount;

        //tweens.tween(fadedBg, { alpha: 0.5 }, 0.3, { ease: FlxEase.quadOut });

        tweens.tween(bg, { alpha: 1.0 }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(descriptionText, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });
        tweens.tween(continueButton, { alpha: 1.0 }, 0.4, { ease: FlxEase.quadOut, startDelay: 0.33 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(descriptionText, { y: descriptionText.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.3, { ease: FlxEase.quadOut });
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (waitToClose > 0.0) {
            waitToClose -= elapsed;
            if (waitToClose <= 0.0) {
                //cast(FlxG.state, PlayState).cameraHUD.fade(0xff1b1c23, 1.2, true, null, true);
                close ();
            }
        }
        else if (FlxG.keys.justPressed.SPACE) {
            closeWindow();            
        }
    }

    function closeWindow() {

        tweens.tween(titleText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(descriptionText, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(continueButton, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut });
        tweens.tween(bg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });
        //tweens.tween(fadedBg, { alpha: 0.0 }, 0.15, { ease: FlxEase.quadOut, startDelay: 0.3 });

        tweens.tween(bg, { y: bg.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(titleText, { y: titleText.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25 });
        tweens.tween(continueButton, { y: continueButton.y + slideInAmount }, 0.25, { ease: FlxEase.quadOut, startDelay: 0.25, onComplete: function(tween) { waitToClose = 0.1; /*cast(FlxG.state, PlayState).cameraHUD.fade(0xff1b1c23, 0.4);*/ } });
    }

    function onContinue() {
        FlxG.sound.play("assets/sounds/select.mp3", 0.2);
        
        if (EndWindow.won) {
            PlayState.level = 1;
            PlayState.restartLevel = true;
            FlxG.camera.fade(0xff1b1c23, 1.0);
        }
        else {
            FlxG.sound.playMusic("assets/music/music.mp3", 0.25);
        }

        closeWindow();
    }
    
}
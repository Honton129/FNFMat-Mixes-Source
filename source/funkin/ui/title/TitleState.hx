package funkin.ui.title;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;
import funkin.audio.FunkinSound;
import funkin.graphics.FunkinSprite;
import funkin.graphics.shaders.ColorSwap;
import funkin.graphics.shaders.TitleOutline;
import funkin.ui.AtlasText;
import funkin.ui.MusicBeatState;
import funkin.ui.mainmenu.MainMenuState;
import openfl.Assets;

/**
 * The game's title screen.
 * There's not much to add here.
 */
class TitleState extends MusicBeatState
{
  /**
   * Only play the credits once per session.
   */
  public static var initialized:Bool = false;

  /**
   * Are the assets cleaned from the cache?
   */
  public static var cleanedCache:Bool = false;

  var blackScreen:FlxSprite;
  var credGroup:FlxGroup;
  var textGroup:FlxGroup;
  var ngSpr:FlxSprite;

  // Title text configuration.
  var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
  var titleTextAlphas:Array<Float> = [1, .64];

  var curWacky:Array<String> = [];
  var lastBeat:Int = 0;
  var swagShader:ColorSwap;

  override public function create():Void
  {
    super.create();
    swagShader = new ColorSwap();

    if (cleanedCache)
    {
      Paths.image('gfDanceTitle');
      Paths.image('logoBumpin');
      Paths.image('titleEnter');
    }

    curWacky = FlxG.random.getObject(getIntroTextShit());
    FlxG.sound.cache(Paths.music('freakyMenu/freakyMenu'));
    FlxG.sound.cache(Paths.music('girlfriendsRingtone/girlfriendsRingtone'));

    if (!initialized)
    {
      new FlxTimer().start(1, function(tmr:FlxTimer) {
        startIntro();
      });
    }
    else
    {
      startIntro();
    }
  }

  var logoBl:FlxSprite;
  var outlineShaderShit:TitleOutline;

  var gfDance:FlxSpriteOverlay;
  var danceLeft:Bool = false;
  var titleText:FlxSprite;

  function startIntro():Void
  {
    if (!initialized || FlxG.sound.music == null) playMenuMusic();

    persistentUpdate = true;

    var bg:FunkinSprite = new FunkinSprite(-1).makeSolidColor(FlxG.width + 2, FlxG.height, FlxColor.BLACK);
    bg.screenCenter();
    add(bg);

    logoBl = new FlxSprite(-150, -100);
    logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
    logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
    logoBl.animation.play('bump');
    logoBl.shader = swagShader.shader;
    logoBl.updateHitbox();

    outlineShaderShit = new TitleOutline();

    gfDance = new FlxSpriteOverlay(FlxG.width * 0.4, FlxG.height * 0.07);
    gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
    gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
    gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

    gfDance.shader = swagShader.shader;

    add(logoBl);
    add(gfDance);

    titleText = new FlxSprite(100, FlxG.height * 0.8);
    titleText.frames = Paths.getSparrowAtlas('titleEnter');
    titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
    titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
    titleText.animation.play('idle');
    titleText.updateHitbox();
    titleText.shader = swagShader.shader;
    add(titleText);

    if (!initialized) // Fix an issue where returning to the credits would play a black screen.
    {
      credGroup = new FlxGroup();
      add(credGroup);
    }

    textGroup = new FlxGroup();

    blackScreen = bg.clone();
    if (credGroup != null)
    {
      credGroup.add(blackScreen);
      credGroup.add(textGroup);
    }

    ngSpr = new FlxSprite(0, FlxG.height * 0.52);

    if (FlxG.random.bool(1))
    {
      ngSpr.loadGraphic(Paths.image('newgrounds_logo_classic'));
    }
    else if (FlxG.random.bool(30))
    {
      ngSpr.loadGraphic(Paths.image('newgrounds_logo_animated'), true, 600);
      ngSpr.animation.add('idle', [0, 1], 4);
      ngSpr.animation.play('idle');
      ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.55));
      ngSpr.y += 25;
    }
    else
    {
      ngSpr.loadGraphic(Paths.image('newgrounds_logo'));
      ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
    }

    add(ngSpr);
    ngSpr.visible = false;

    ngSpr.updateHitbox();
    ngSpr.screenCenter(X);

    FlxG.mouse.visible = false;

    if (initialized) skipIntro();
    else
    {
      initialized = true;
    }

    if (FlxG.sound.music != null) FlxG.sound.music.onComplete = moveToAttract;
  }

  /**
   * After sitting on the title screen for a while, transition to the attract screen.
   */
  function moveToAttract():Void
  {
    FlxG.switchState(() -> new AttractState());
  }

  function playMenuMusic():Void
  {
    var shouldFadeIn:Bool = (FlxG.sound.music == null);
    // Load music. Includes logic to handle BPM changes.
    FunkinSound.playMusic('freakyMenu',
      {
        startingVolume: 0.0,
        overrideExisting: true,
        restartTrack: false,
        // Continue playing this music between states, until a different music track gets played.
        persist: true
      });
    // Fade from 0.0 to 1 over 4 seconds
    if (shouldFadeIn) FlxG.sound.music.fadeIn(4.0, 0.0, 1.0);
  }

  function getIntroTextShit():Array<Array<String>>
  {
    var fullText:String = Assets.getText(Paths.txt('introText'));

    // Split into lines and remove empty lines
    var firstArray:Array<String> = fullText.split('\n').filter(function(s:String) return s != '');
    var swagGoodArray:Array<Array<String>> = [];

    for (i in firstArray)
    {
      swagGoodArray.push(i.split('--'));
    }

    return swagGoodArray;
  }

  var transitioning:Bool = false;
  var titleTimer:Float = 0;

  override function update(elapsed:Float):Void
  {
    FlxG.bitmapLog.add(FlxG.camera.buffer);

    #if desktop
    // Pressing BACK on the title screen should close the game.
    // This lets you exit without leaving fullscreen mode.
    // Only applicable on desktop.
    if (controls.BACK)
    {
      openfl.Lib.application.window.close();
    }
    #end

    Conductor.instance.update();

    if (FlxG.keys.justPressed.I)
    {
      FlxTween.tween(outlineShaderShit, {funnyX: 50, funnyY: 50}, 0.6, {ease: FlxEase.quartOut});
    }

    if (FlxG.keys.pressed.D) outlineShaderShit.funnyX += 1;
    if (FlxG.keys.justPressed.Y)
    {
      FlxTween.cancelTweensOf(FlxG.stage.window, ['x', 'y']);
      FlxTween.tween(FlxG.stage.window, {x: FlxG.stage.window.x + 300}, 1.4, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.35});
      FlxTween.tween(FlxG.stage.window, {y: FlxG.stage.window.y + 100}, 0.7, {ease: FlxEase.quadInOut, type: PINGPONG});
    }

    if (FlxG.sound.music != null) Conductor.instance.update(FlxG.sound.music.time);

    // do controls.PAUSE | controls.ACCEPT instead?
    var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

    var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

    if (gamepad != null)
    {
      if (gamepad.justPressed.START) pressedEnter = true;
      #if switch
      if (gamepad.justPressed.B) pressedEnter = true;
      #end
    }

    titleTimer += FlxMath.bound(elapsed, 0, 1);
    if (titleTimer > 2) titleTimer -= 2;
    if (initialized && !transitioning && skippedIntro)
    {
      if (!pressedEnter)
      {
        var timer:Float = titleTimer;
        if (timer >= 1) timer = (-timer) + 2;

        timer = FlxEase.quadInOut(timer);

        titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
        titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
      }
    }

    // If you spam Enter, we should skip the transition.
    if (pressedEnter && transitioning && skippedIntro)
    {
      FlxG.switchState(() -> new MainMenuState());
    }

    if (pressedEnter && !transitioning && skippedIntro)
    {
      if (FlxG.sound.music != null) FlxG.sound.music.onComplete = null;
      titleText.color = FlxColor.WHITE;
      titleText.alpha = 1;

      titleText.animation.play('press');
      FlxG.camera.flash(FlxColor.WHITE, 1);
      FunkinSound.playOnce(Paths.sound('confirmMenu'), 0.7);
      transitioning = true;

      var targetState:NextState = () -> new MainMenuState();

      new FlxTimer().start(2, function(tmr:FlxTimer) {
        clearAssets();
        FlxG.switchState(targetState);
      });
    }
    if (pressedEnter && !skippedIntro && initialized) skipIntro();

    if (controls.UI_LEFT) swagShader.update(-elapsed * 0.1);
    if (controls.UI_RIGHT) swagShader.update(elapsed * 0.1);
    if (!cheatActive && skippedIntro) cheatCodeShit();
    super.update(elapsed);
  }

  // These assets are very unlikely to be used for the rest of gameplay, so it unloads them from cache/memory
  // Saves about 50mb of RAM or so???
  function clearAssets():Void
  {
    Assets.cache.clear(Paths.image('gfDanceTitle'));
    Assets.cache.clear(Paths.image('logoBumpin'));
    Assets.cache.clear(Paths.image('titleEnter'));
    cleanedCache = true;
  }

  var cheatArray:Array<Int> = [0x0001, 0x0010, 0x0001, 0x0010, 0x0100, 0x1000, 0x0100, 0x1000];
  var curCheatPos:Int = 0;
  var cheatActive:Bool = false;

  function cheatCodeShit():Void
  {
    if (FlxG.keys.justPressed.ANY)
    {
      if (controls.NOTE_DOWN_P || controls.UI_DOWN_P) codePress(FlxDirectionFlags.DOWN);
      if (controls.NOTE_UP_P || controls.UI_UP_P) codePress(FlxDirectionFlags.UP);
      if (controls.NOTE_LEFT_P || controls.UI_LEFT_P) codePress(FlxDirectionFlags.LEFT);
      if (controls.NOTE_RIGHT_P || controls.UI_RIGHT_P) codePress(FlxDirectionFlags.RIGHT);
    }
  }

  function codePress(input:Int):Void
  {
    if (input == cheatArray[curCheatPos])
    {
      curCheatPos += 1;
      if (curCheatPos >= cheatArray.length) startCheat();
    }
    else
    {
      curCheatPos = 0;
    }

    trace(input);
  }

  function startCheat():Void
  {
    cheatActive = true;

    FunkinSound.playMusic('girlfriendsRingtone',
      {
        startingVolume: 0.0,
        overrideExisting: true,
        restartTrack: true
      });

    FlxG.sound.music.fadeIn(4.0, 0.0, 1.0);

    FlxG.camera.flash(FlxColor.WHITE, 1);
    FunkinSound.playOnce(Paths.sound('confirmMenu'), 0.7);
  }

  function createCoolText(textArray:Array<String>):Void
  {
    if (credGroup == null || textGroup == null) return;

    for (i in 0...textArray.length)
    {
      var money:AtlasText = new AtlasText(0, 0, textArray[i], AtlasFont.BOLD);
      money.screenCenter(X);
      money.y += (i * 60) + 200;
      textGroup.add(money);
    }
  }

  function addMoreText(text:String):Void
  {
    if (credGroup == null || textGroup == null) return;

    lime.ui.Haptic.vibrate(100, 100);

    var coolText:AtlasText = new AtlasText(0, 0, text.trim(), AtlasFont.BOLD);
    coolText.screenCenter(X);
    coolText.y += (textGroup.length * 60) + 200;
    textGroup.add(coolText);
  }

  function deleteCoolText():Void
  {
    if (credGroup == null || textGroup == null) return;

    while (textGroup.members.length > 0)
    {
      textGroup.remove(textGroup.members[0], true);
    }
  }

  var isRainbow:Bool = false;
  var skippedIntro:Bool = false;

  override function beatHit():Bool
  {
    // super.beatHit() returns false if a module cancelled the event.
    if (!super.beatHit()) return false;

    if (!skippedIntro)
    {
      // if the user is draggin the window some beats will
      // be missed so this is just to compensate
      if (Conductor.instance.currentBeat > lastBeat)
      {
        // TODO: Why does it perform ALL the previous steps each beat?
        for (i in lastBeat...Conductor.instance.currentBeat)
        {
          switch (i + 1)
          {
            case 1:
              createCoolText(['The', 'Mat Mixes Team']);
            case 3:
              addMoreText('presents');
            case 4:
              deleteCoolText();
            case 5:
              createCoolText(['Not associated', 'with']);
            case 7:
              addMoreText('newgrounds');
              if (ngSpr != null) ngSpr.visible = true;
            case 8:
              deleteCoolText();
              if (ngSpr != null) ngSpr.visible = false;
            case 9:
              createCoolText([curWacky[0]]);
            case 11:
              addMoreText(curWacky[1]);
            case 12:
              deleteCoolText();
            case 13:
              addMoreText('FNF');
            case 14:
              // We make a little easter egg with the Mat-ing time joke :)
              if (curWacky[0] == "mat-ing") addMoreText('Mat-ing');
              else
              {
                addMoreText('Mat');
              }
            case 15:
              addMoreText('Mixes');
            case 16:
              skipIntro();
          }
        }
      }
      lastBeat = Conductor.instance.currentBeat;
    }
    if (skippedIntro)
    {
      if (cheatActive && Conductor.instance.currentBeat % 2 == 0) swagShader.update(0.125);

      if (logoBl != null && logoBl.animation != null) logoBl.animation.play('bump', true);

      danceLeft = !danceLeft;

      if (gfDance != null && gfDance.animation != null)
      {
        if (danceLeft) gfDance.animation.play('danceRight');
        else
        {
          gfDance.animation.play('danceLeft');
        }
      }
    }

    return true;
  }

  function skipIntro():Void
  {
    if (!skippedIntro)
    {
      remove(ngSpr);

      FlxG.camera.flash(FlxColor.WHITE, initialized ? 1 : 4);

      if (credGroup != null) remove(credGroup);
      skippedIntro = true;
    }
  }
}

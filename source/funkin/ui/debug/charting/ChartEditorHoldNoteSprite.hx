package funkin.ui.debug.charting;

import funkin.play.notes.Strumline;
import funkin.data.notestyle.NoteStyleRegistry;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import funkin.play.notes.SustainTrail;
import funkin.data.song.SongData.SongNoteData;

/**
 * A hold note sprite that can be used to display a note in a chart.
 * Designed to be used and reused efficiently. Has no gameplay functionality.
 */
@:nullSafety
class ChartEditorHoldNoteSprite extends SustainTrail
{
  /**
   * The ChartEditorState this note belongs to.
   */
  public var parentState:ChartEditorState;

  public function new(parent:ChartEditorState)
  {
    var noteStyle = NoteStyleRegistry.instance.fetchDefault();

    super(0, 100, noteStyle);

    this.parentState = parent;

    zoom = 1.0;
    zoom *= noteStyle.fetchHoldNoteScale();
    zoom *= 0.7;
    zoom *= ChartEditorState.GRID_SIZE / Strumline.STRUMLINE_SIZE;

    setup();
  }

  /**
   * Set the height directly, to a value in pixels.
   * @param h The desired height in pixels.
   */
  public function setHeightDirectly(h:Float)
  {
    sustainLength = h / (getScrollSpeed() * Constants.PIXELS_PER_MS);
    fullSustainLength = sustainLength;
  }

  function setup():Void
  {
    strumTime = 999999999;
    missedNote = false;
    hitNote = false;
    active = true;
    visible = true;
    alpha = 1.0;
    width = graphic.width / 8 * zoom; // amount of notes * 2
  }

  public override function revive():Void
  {
    super.revive();

    setup();
  }

  public override function kill():Void
  {
    super.kill();

    active = false;
    visible = false;
    noteData = null;
    strumTime = 999999999;
    noteDirection = 0;
    sustainLength = 0;
    fullSustainLength = 0;
  }

  /**
   * Return whether this note is currently visible.
   */
  public function isHoldNoteVisible(viewAreaBottom:Float, viewAreaTop:Float):Bool
  {
    // True if the note is above the view area.
    var aboveViewArea = (this.y + this.height < viewAreaTop);

    // True if the note is below the view area.
    var belowViewArea = (this.y > viewAreaBottom);

    return !aboveViewArea && !belowViewArea;
  }

  /**
   * Return whether a hold note, if placed in the scene, would be visible.
   */
  public static function wouldHoldNoteBeVisible(viewAreaBottom:Float, viewAreaTop:Float, noteData:SongNoteData, ?origin:FlxObject):Bool
  {
    var noteHeight:Float = noteData.getStepLength() * ChartEditorState.GRID_SIZE;
    var stepTime:Float = inline noteData.getStepTime();
    var notePosY:Float = stepTime * ChartEditorState.GRID_SIZE;
    if (origin != null) notePosY += origin.y;

    // True if the note is above the view area.
    var aboveViewArea = (notePosY + noteHeight < viewAreaTop);

    // True if the note is below the view area.
    var belowViewArea = (notePosY > viewAreaBottom);

    return !aboveViewArea && !belowViewArea;
  }

  public function updateHoldNotePosition(?origin:FlxObject):Void
  {
    if (this.noteData == null) return;

    var cursorColumn:Int = this.noteData.data;

    if (cursorColumn < 0) cursorColumn = 0;
    if (cursorColumn >= (ChartEditorState.STRUMLINE_SIZE * 2 + 1))
    {
      cursorColumn = (ChartEditorState.STRUMLINE_SIZE * 2 + 1);
    }
    else
    {
      // Invert player and opponent columns.
      if (cursorColumn >= ChartEditorState.STRUMLINE_SIZE)
      {
        cursorColumn -= ChartEditorState.STRUMLINE_SIZE;
      }
      else
      {
        cursorColumn += ChartEditorState.STRUMLINE_SIZE;
      }
    }

    this.x = cursorColumn * ChartEditorState.GRID_SIZE;

    // Notes far in the song will start far down, but the group they belong to will have a high negative offset.
    // noteData.getStepTime() returns a calculated value which accounts for BPM changes
    var stepTime:Float =
    inline this.noteData.getStepTime();
    if (stepTime >= 0)
    {
      // Add epsilon to fix rounding issues?
      // var roundedStepTime:Float = Math.floor((stepTime + 0.01) / noteSnapRatio) * noteSnapRatio;
      this.y = stepTime * ChartEditorState.GRID_SIZE;
    }

    this.x += ChartEditorState.GRID_SIZE / 2;
    this.x -= this.width / 2;

    this.y += ChartEditorState.GRID_SIZE / 2;

    if (origin != null)
    {
      this.x += origin.x;
      this.y += origin.y;
    }
  }
}
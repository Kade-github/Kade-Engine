package ui;

import flixel.FlxG;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import flixel.util.FlxDestroyUtil;
import flixel.ui.FlxButton;
import flixel.graphics.frames.FlxAtlasFrames;
import flash.display.BitmapData;
import flixel.graphics.FlxGraphic;
import openfl.utils.ByteArray;

/**
 * A gamepad which contains 4 directional buttons and 4 action buttons.
 * It's easy to set the callbacks and to customize the layout.
 *
 * @author Ka Wing Chin
 */
@:keep @:bitmap("assets/preload/images/virtual-input.png")
class GraphicVirtualInput extends BitmapData {}
 
@:file("assets/preload/images/virtual-input.txt")
class VirtualInputData extends #if (lime_legacy || nme) ByteArray #else ByteArrayData #end {}

class FlxVirtualPad extends FlxSpriteGroup
{
	public var buttonA:FlxButton;
	public var buttonB:FlxButton;
	public var buttonC:FlxButton;
	public var buttonY:FlxButton;
	public var buttonX:FlxButton;
	public var buttonLeft:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	public var buttonDown:FlxButton;

	public var button6:FlxButton;
	public var button1:FlxButton;
	public var button7:FlxButton;
	public var buttonIn:FlxButton;
	public var buttonOut:FlxButton;
	public var buttonSave:FlxButton;
	public var buttonL:FlxButton;
	public var buttonR:FlxButton;
	public var buttonR2:FlxButton;
	public var buttonStage:FlxButton;

	public var buttonUp2:FlxButton;
	public var buttonDown2:FlxButton;


	/**
	 * Group of directions buttons.
	 */
	public var dPad:FlxSpriteGroup;

	/**
	 * Group of action buttons.
	 */
	public var actions:FlxSpriteGroup;

	/**
	 * Create a gamepad which contains 4 directional buttons and 4 action buttons.
	 *
	 * @param   DPadMode     The D-Pad mode. `FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(?DPad:FlxDPadMode, ?Action:FlxActionMode)
	{
		super();
		scrollFactor.set();

		if (DPad == null)
			DPad = FULL;
		if (Action == null)
			Action = A_B_C;

		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();

		switch (DPad)
		{
			case UP_DOWN:
				dPad.add(add(buttonUp = createButton(0, FlxG.height - 85 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonDown = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));
			case LEFT_RIGHT:
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(42 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "right")));
			case UP_LEFT_RIGHT:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "right")));
			case FULL:
				dPad.add(add(buttonUp = createButton(35 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(0, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(69 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "right")));
				dPad.add(add(buttonDown = createButton(35 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));
			case RIGHT_FULL:
				dPad.add(add(buttonUp = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(FlxG.width - 130 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, 44 * 3, 45 * 3, "right")));
				dPad.add(add(buttonDown = createButton(FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, 44 * 3, 45 * 3, "down")));
			case ANIMATION:
				dPad.add(add(buttonUp2 = createButton(0, FlxG.height - 85 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonDown2 = createButton(0, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));	

				dPad.add(add(buttonUp = createButton(75 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "up")));
				dPad.add(add(buttonLeft = createButton(40 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "left")));
				dPad.add(add(buttonRight = createButton(109 * 3, FlxG.height - 81 * 3, 44 * 3, 45 * 3, "right")));
				dPad.add(add(buttonDown = createButton(75 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "down")));				
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
			case A_B:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
			case STAGE:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				actions.add(add(buttonC = createButton(FlxG.width - 128 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "c")));
				actions.add(add(buttonIn = createButton(FlxG.width - 44 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "in")));
				actions.add(add(buttonOut = createButton(FlxG.width - 86 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "out")));
				actions.add(add(buttonSave = createButton(FlxG.width - 86 * 3, FlxG.height - 160 * 3, 44 * 3, 45 * 3, "save")));
				actions.add(add(buttonL = createButton(0, FlxG.height - 160 * 3, 44 * 3, 45 * 3, "l")));
				actions.add(add(buttonR = createButton(42 * 3, FlxG.height - 160 * 3, 44 * 3, 45 * 3, "r")));
				actions.add(add(buttonR2 = createButton(84 * 3, FlxG.height - 160 * 3, 44 * 3, 45 * 3, "r2")));
			case ANIMATION:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				actions.add(add(buttonIn = createButton(FlxG.width - 44 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "in")));
				actions.add(add(buttonOut = createButton(FlxG.width - 86 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "out")));	
				actions.add(add(buttonSave = createButton(FlxG.width - 86 * 3, FlxG.height - 160 * 3, 44 * 3, 45 * 3, "save")));				
			case SONGD:
				actions.add(add(buttonStage = createButton(0, FlxG.height - 240 * 3, 44 * 3, 45 * 3, "stage")));								
			case A_B_6:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				actions.add(add(button6 = createButton(FlxG.width - 44 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "6")));
			case A_B_6_1:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				actions.add(add(button6 = createButton(FlxG.width - 44 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "6")));
				actions.add(add(button1 = createButton(FlxG.width - 86 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "1")));
			case A_B_6_1_7:
				actions.add(add(buttonA = createButton(FlxG.width - 44 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86 * 3, FlxG.height - 45 * 3, 44 * 3, 45 * 3, "b")));
				actions.add(add(button6 = createButton(FlxG.width - 44 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "6")));
				actions.add(add(button1 = createButton(FlxG.width - 44 * 3, FlxG.height - 160 * 3, 44 * 3, 45 * 3, "1")));	
				actions.add(add(button7 = createButton(FlxG.width - 86 * 3, FlxG.height - 116 * 3, 44 * 3, 45 * 3, "7")));																					
			case A_B_C:
				actions.add(add(buttonA = createButton(FlxG.width - 128, FlxG.height - 45, 44, 45, "a")));
				actions.add(add(buttonB = createButton(FlxG.width - 86, FlxG.height - 45, 44, 45, "b")));
				actions.add(add(buttonC = createButton(FlxG.width - 44, FlxG.height - 45, 44, 45, "c")));
			case A_B_X_Y:
				actions.add(add(buttonY = createButton(FlxG.width - 86, FlxG.height - 85, 44, 45, "y")));
				actions.add(add(buttonX = createButton(FlxG.width - 44, FlxG.height - 85, 44, 45, "x")));
				actions.add(add(buttonB = createButton(FlxG.width - 86, FlxG.height - 45, 44, 45, "b")));
				actions.add(add(buttonA = createButton(FlxG.width - 44, FlxG.height - 45, 44, 45, "a")));
			case NONE: // do nothing
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		dPad = FlxDestroyUtil.destroy(dPad);
		actions = FlxDestroyUtil.destroy(actions);

		dPad = null;
		actions = null;
		buttonA = null;
		buttonB = null;
		buttonC = null;
		buttonY = null;
		buttonX = null;
		buttonLeft = null;
		buttonUp = null;
		buttonDown = null;
		buttonRight = null;

		button1 = null;
		button6 = null;
		button7 = null;
		buttonIn = null;
		buttonOut = null;
		buttonSave = null;
		buttonL = null;
		buttonR = null;
		buttonR2 = null;
		buttonStage = null;
		buttonUp2 = null;
		buttonDown2 = null;
	}

	/**
	 * @param   X          The x-position of the button.
	 * @param   Y          The y-position of the button.
	 * @param   Width      The width of the button.
	 * @param   Height     The height of the button.
	 * @param   Graphic    The image of the button. It must contains 3 frames (`NORMAL`, `HIGHLIGHT`, `PRESSED`).
	 * @param   Callback   The callback for the button.
	 * @return  The button
	 */
	public function createButton(X:Float, Y:Float, Width:Int, Height:Int, Graphic:String, ?OnClick:Void->Void):FlxButton
	{
		var button = new FlxButton(X, Y);
		var frame = getVirtualInputFrames().getByName(Graphic);
		button.frames = FlxTileFrames.fromFrame(frame, FlxPoint.get(Width, Height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();

		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end

		if (OnClick != null)
			button.onDown.callback = OnClick;

		return button;
	}

	public static function getVirtualInputFrames():FlxAtlasFrames
	{
			#if !web
			var bitmapData = new GraphicVirtualInput(0, 0);
			#end

			/*
			#if html5 // dirty hack for openfl/openfl#682
			Reflect.setProperty(bitmapData, "width", 399);
			Reflect.setProperty(bitmapData, "height", 183);
			#end
			*/
			
			#if !web
			var graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmapData);
			return FlxAtlasFrames.fromSpriteSheetPacker(graphic, Std.string(new VirtualInputData()));
			#else
			var graphic:FlxGraphic = FlxGraphic.fromAssetKey(Paths.image('virtual-input'));
			return FlxAtlasFrames.fromSpriteSheetPacker(graphic, Std.string(new VirtualInputData()));
			#end
	}
}

enum FlxDPadMode
{
	NONE;
	UP_DOWN;
	ANIMATION;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	RIGHT_FULL;
	FULL;
}

enum FlxActionMode
{
	NONE;
	A;
	A_B;
	ANIMATION;
	SONGD;
	STAGE;
	A_B_6;
	A_B_6_1;
	A_B_6_1_7;
	A_B_C;
	A_B_X_Y;
}

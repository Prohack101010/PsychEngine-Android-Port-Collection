package mobile.flixel;

import flixel.FlxG;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets;

// Lua VirtualPad
import haxe.ds.StringMap;

typedef MobileButton = VirtualButton;

class FlxVirtualPad extends FlxSpriteGroup {
	//Actions
	public var buttonA:MobileButton = new MobileButton(0, 0);
	public var buttonB:MobileButton = new MobileButton(0, 0);
	public var buttonC:MobileButton = new MobileButton(0, 0);
	public var buttonD:MobileButton = new MobileButton(0, 0);
	public var buttonE:MobileButton = new MobileButton(0, 0);
	public var buttonM:MobileButton = new MobileButton(0, 0);
	public var buttonP:MobileButton = new MobileButton(0, 0);
	public var buttonQ:MobileButton = new MobileButton(0, 0);
	public var buttonV:MobileButton = new MobileButton(0, 0);
	public var buttonX:MobileButton = new MobileButton(0, 0);
	public var buttonY:MobileButton = new MobileButton(0, 0);
	public var buttonZ:MobileButton = new MobileButton(0, 0);
	public var buttonF:MobileButton = new MobileButton(0, 0);
	public var buttonG:MobileButton = new MobileButton(0, 0);
	
	//Extra
    public var buttonExtra1:MobileButton = new MobileButton(0, 0);
	public var buttonExtra2:MobileButton = new MobileButton(0, 0);
	public var buttonExtra3:MobileButton = new MobileButton(0, 0);
	public var buttonExtra4:MobileButton = new MobileButton(0, 0);
    
	//DPad
	public var buttonLeft:MobileButton = new MobileButton(0, 0);
	public var buttonUp:MobileButton = new MobileButton(0, 0);
	public var buttonRight:MobileButton = new MobileButton(0, 0);
	public var buttonDown:MobileButton = new MobileButton(0, 0);

	//PAD DUO MODE
	public var buttonLeft2:MobileButton = new MobileButton(0, 0);
	public var buttonUp2:MobileButton = new MobileButton(0, 0);
	public var buttonRight2:MobileButton = new MobileButton(0, 0);
	public var buttonDown2:MobileButton = new MobileButton(0, 0);
    
	public var buttonCEUp:MobileButton = new MobileButton(0, 0);
	public var buttonCEDown:MobileButton = new MobileButton(0, 0);
	public var buttonCEG:MobileButton = new MobileButton(0, 0);
	
	public var dPad:FlxSpriteGroup;
	public var actions:FlxSpriteGroup;
	
	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */

	public function new(DPad:String, Action:String) {
		super();
		
		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();
		
		if (DPad != "NONE")
		{
			if (!MobileData.dpadModes.exists(DPad))
				throw 'The virtualPad dpadMode "$DPad" doesn\'t exists.';

			for (buttonData in MobileData.dpadModes.get(DPad).buttons)
			{
				Reflect.setField(this, buttonData.button,
					createMobileButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color)));
				dPad.add(add(Reflect.field(this, buttonData.button)));
			}
		}

		if (Action != "NONE" && Action != "controlExtend")
		{
			if (!MobileData.actionModes.exists(Action))
				throw 'The virtualPad actionMode "$Action" doesn\'t exists.';

			for (buttonData in MobileData.actionModes.get(Action).buttons)
			{
				Reflect.setField(this, buttonData.button,
					createMobileButton(buttonData.x, buttonData.y, buttonData.graphic, CoolUtil.colorFromString(buttonData.color)));
				actions.add(add(Reflect.field(this, buttonData.button)));
			}
		}

		switch (Action){			
			case "controlExtend":
			    if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.extraKeys >= 1) actions.add(add(buttonExtra1 = createMobileButton(FlxG.width * 0.5 - 44 * 3, FlxG.height * 0.5 - 127 * 0.5, "f", 0xFF0000)));
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.extraKeys >= 2) actions.add(add(buttonExtra2 = createMobileButton(FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "g", 0xFFFF00)));
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.extraKeys >= 3) actions.add(add(buttonExtra3 = createMobileButton(FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "x", 0x99062D)));
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.extraKeys >= 4) actions.add(add(buttonExtra4 = createMobileButton(FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "y", 0x4A35B9)));
			case "NONE":
		}
	}
	
	public function createMobileButton(x:Float, y:Float, Frames:String, ColorS:Int):Dynamic
	{
	    return createVirtualButton(x, y, Frames, ColorS);
	}
	
	public function createVirtualButton(x:Float, y:Float, Frames:String, ?ColorS:Int = 0xFFFFFF):VirtualButton {
	    var frames:FlxGraphic;
	    
        final path:String = 'shared:assets/shared/images/virtualpad/$Frames.png';
		#if MODS_ALLOWED
		final modsPath:String = Paths.modsImages('virtualpad/$Frames');
		if(sys.FileSystem.exists(modsPath))
			frames = FlxGraphic.fromBitmapData(BitmapData.fromFile(modsPath));
		else #end if(Assets.exists(path))
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(path));
		else
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData('shared:assets/shared/images/virtualpad/default.png'));
			
		var button = new VirtualButton(x, y);
        button.frames = FlxTileFrames.fromGraphic(frames, FlxPoint.get(Std.int(frames.width / 2), frames.height));
        
        //button.scale.set(0.243, 0.243);
        button.updateHitbox();
        button.updateLabelPosition();
    
        button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
        button.centerBounds();
    
        button.immovable = true;
        button.solid = button.moves = false;
        button.antialiasing = ClientPrefs.globalAntialiasing;
        button.tag = Frames.toUpperCase();
    
        if (ColorS != -1) button.color = ColorS;
        //button.parentAlpha = button.alpha;
    
        return button;
    }
	
	override public function destroy():Void
	{
		super.destroy();
		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), MobileButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}
}
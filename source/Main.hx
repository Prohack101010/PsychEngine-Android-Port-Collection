package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		
		#if mobile
 		#if android
 		StorageUtil.requestPermissions();
 		#end
 		Sys.setCwd(StorageUtil.getStorageDirectory());
 		#end
 		CrashHandler.init();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
	    #if (openfl <= "9.2.0")
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1.0)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		#else
 		if (zoom == -1.0)
 			zoom = 1.0;
 		#end

		#if !debug
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, #if mobile CopyState.checkExistingFiles() ? initialState : CopyState #else initialState #end, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash, startFullscreen));

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		FlxG.fixedTimestep = false;
 		FlxG.game.focusLostFramerate = #if mobile 30 #else 60 #end;
 		#if web
 		FlxG.keys.preventDefaultKeys.push(TAB);
 		#else
 		FlxG.keys.preventDefaultKeys = [TAB];
 		#end
 
 		#if android FlxG.android.preventDefaultKeys = [BACK]; #end
 		
 		#if mobile
 		FlxG.scaleMode = new MobileScaleMode();
 		#end
 
 		// shader coords fix
 		FlxG.signals.gameResized.add(function (w, h) {				
 		    if (FlxG.cameras != null) {
 			  for (cam in FlxG.cameras.list) {
 				if (cam != null && cam.filters != null)
 				  resetSpriteCache(cam.flashSprite);
 			  }
 			}
 
 			if (FlxG.game != null)
 			    resetSpriteCache(FlxG.game);
 		});
 	}
 	
 	static function resetSpriteCache(sprite:Sprite):Void {
 		@:privateAccess {
 		        sprite.__cacheBitmap = null;
 			sprite.__cacheBitmapData = null;
 		}
	}
}

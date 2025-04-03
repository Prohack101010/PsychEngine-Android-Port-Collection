import Paths;

import shaders.flixel.system.FlxShader;
import haxe.ds.StringMap;

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

// Mobile Things
import mobile.flixel.*;
import mobile.objects.*;
import mobile.backend.*;
import mobile.substates.*;
import mobile.states.*;
import mobile.flixel.FlxVirtualPad;
import mobile.backend.StorageUtil;
import mobile.flixel.FlxNewHitbox;
import Alphabet;

// Android
#if android
import android.Tools as AndroidTools;
import android.Settings as AndroidSettings;
import android.widget.Toast as AndroidToast;
import android.content.Context as AndroidContext;
import android.Permissions as AndroidPermissions;
import android.os.Build.VERSION as AndroidVersion;
import android.os.Environment as AndroidEnvironment;
import android.os.BatteryManager as AndroidBatteryManager;
import android.os.Build.VERSION_CODES as AndroidVersionCode;
#end

//Flixel
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.input.actions.FlxActionInput;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.transition.FlxTransitionableState;

import openfl.display3D.textures.RectangleTexture;

using StringTools;
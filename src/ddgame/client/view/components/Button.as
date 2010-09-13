/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.view.components {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
//	import mx.core.EventPriority;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  15.04.2008
	 */
	public class Button extends SimpleButton {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function Button(labelText:String = "")
		{
			_label = labelText;
			draw();
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		[Embed(source="/ddgame/assets/Panel.swf", symbol="ButtonAssetSkinLeft")]
		private var skinLeftAsset:Class;
		[Embed(source="/ddgame/assets/Panel.swf", symbol="ButtonAssetSkinMiddle")]
		private var skinMiddleAsset:Class;
		[Embed(source="/ddgame/assets/Panel.swf", symbol="ButtonAssetSkinRight")]
		private var skinRightAsset:Class;
		
		protected var _nsSprite:Sprite;		// Normal state display	
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		protected var _label:String;
		public function get label():String
		{
			return _label;
		}
		
		public function set label(val:String):void
		{
			
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function set width(val:Number):void
		{
			
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function draw():void
		{
			upState = displayState(	Sprite(new skinLeftAsset()),
											Sprite(new skinMiddleAsset()),
											Sprite(new skinRightAsset()),
											_label,
											new TextFormat("_sans", 13, 0xF2C7F3, true));
			overState = displayState(	Sprite(new skinLeftAsset()),
												Sprite(new skinMiddleAsset()),
												Sprite(new skinRightAsset()),
												_label,
												new TextFormat("_sans", 13, 0xFFFFFF, true));
			downState = upState;
														
			hitTestState = upState;
/*			hitTestState.x = -(size / 4);
			hitTestState.y = hitTestState.x; */
			useHandCursor  = true;
		}
		
		private function displayState(leftSkin:Sprite, middleSkin:Sprite, rightSkin:Sprite, txt:String, tFormat:TextFormat):Sprite
		{
			var usp:Sprite = new Sprite();
			var tf:TextField = new TextField();
	//		tf.defaultTextFormat = new TextFormat("Bitstream Vera Sans", 13, 0xFFFFFF);
	//		tf.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			tf.defaultTextFormat = tFormat;
			tf.antiAliasType = AntiAliasType.ADVANCED;
	//		tf.embedFonts = true;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = false;
			tf.wordWrap = false;
			tf.text = txt;
			tf.width = tf.textWidth;
			
			middleSkin.x = tf.x = leftSkin.width;
			middleSkin.width = tf.width;
			rightSkin.x = middleSkin.x + middleSkin.width;
			
			usp.addChild(leftSkin);
			usp.addChild(middleSkin);
			usp.addChild(rightSkin);
			usp.addChild(tf);
			
			return usp;
			
		}		
		
	}
	
}

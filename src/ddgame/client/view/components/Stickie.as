/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.view.components {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  20.04.2008
	 */
	public class Stickie extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function Stickie(width:Number, text:String, bgColor:uint = 0xD795AA, textColor:uint = 0, arrow:Boolean = true)
		{
			_size = width;
			_text = text;
			_bgColor = bgColor;
			_textColor = textColor;
			_arrow = arrow;
			draw();
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _text:String;
		protected var _size:Number;
		protected var _bgColor:uint;
		protected var _textColor:uint;
		protected var _arrow:Boolean;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function draw():void
		{
			var tf:TextField = createTextField();
			tf.width = _size;
			tf.text = _text;
			var bg:Shape = createBackground(_size + 10, tf.height + 10);
			addChild(bg);
			addChild(tf);
									
			if (_arrow)
			{
				var ar:Shape = drawArrow();
				ar.x = -(ar.width / 2);
				ar.y = -ar.height;
				bg.x = -(bg.width / 2);
				bg.y = -(bg.height + ar.height);
				
				addChild(ar);
			}
			
			tf.x = bg.x + 5;
			tf.y = bg.y + 5;
			
		}
		
		private function createBackground(w:Number, h:Number):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(_bgColor);
			//s.graphics.lineStyle(borderSize, borderColor);
			s.graphics.drawRect(0, 0, w, h);
			s.graphics.endFill();
			
			return s;
		}
		
		private function drawArrow():Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(_bgColor);
			s.graphics.lineTo(10,0);
			s.graphics.lineTo(5,10);
			s.graphics.lineTo(0,0);
			s.graphics.endFill();
			
			return s;
		}
		
		private function createTextField():TextField
		{
			var tfi:TextField = new TextField();
			var tf:TextFormat = new TextFormat("_sans", 12, _textColor);
			with (tfi)
			{
				defaultTextFormat = tf;
				antiAliasType = AntiAliasType.ADVANCED;
				autoSize = TextFieldAutoSize.LEFT;
				wordWrap = true;
				multiline = true;
				selectable = false;
			}
			return tfi;
		}
		
	}
	
}

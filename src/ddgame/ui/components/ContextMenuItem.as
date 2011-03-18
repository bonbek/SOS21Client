/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.ui.components {
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import com.sos21.debug.log;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  17.04.2008
	 */
	public class ContextMenuItem extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function ContextMenuItem(label:String, textFormat:TextFormat = null)
		{
			this.label = label;
			if (textFormat) _textFormat = textFormat;
			draw();
			createEventListener();
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _textFormat:TextFormat = new TextFormat("Verdana", 12, 0xBF6682, false);
		private var _textField:TextField;
		private var _height:Number;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	Définit le textFormat de l'item
		 */
		public function set textFormat(val:TextFormat):void {
			_textFormat = val;
			_textField.defaultTextFormat = _textFormat;
		}
		
		override public function set width(val:Number):void
		{
			
		}
		
		override public function set height(val:Number):void
		{
			_height = val;
		}
		
		override public function get height():Number
		{
			return _height ? _height : _textField.height;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public var label:String;
		public var overColor:uint = 0xFFFFFF;
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function mouseHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					_textField.textColor = overColor;
					break;
				}
				case MouseEvent.MOUSE_OUT :
				{
					_textField.textColor = uint(_textFormat.color);
					break;
				}
				default :
				{
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function draw():void
		{
			_textField = new TextField();
			_textField.defaultTextFormat = _textFormat;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.selectable = false;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = false;
			_textField.wordWrap = false;
			_textField.text = label;
			_textField.width = _textField.textWidth;
			addChild(_textField);
		}
		
		private function createEventListener():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false, 0, true);
			mouseChildren = false;
			buttonMode = true;
		}
		
	}
	
}

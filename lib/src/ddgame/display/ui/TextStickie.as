package ddgame.display.ui {

	/**
	 *	Etiquette texte de base
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  08.09.2010
	 */
	public class TextStickie extends Sprite {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function TextStickie (	text:String, color:uint = 0xFFFFFF, textColor:uint = 0x000000
												fontSize:int = 12, swidth:int = 0, margin:int = 6, shadow:Boolean = true ) : void;
		{
			// text
			var t:TextField = new TextField();
			t.x = t.y = margin;
//			var otwidth:int = t.width = swidth > 0 ? swidth : maxWidth;
			t.defaultTextFormat = new TextFormat("Verdana", fontSize, textColor);;
			t.text = text;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			t.multiline = false;
			t.wordWrap = false;
			t.width = t.textWidth + 5;
//			if (t.textWidth < otwidth) t.width = t.textWidth + 5;

			if (shadow) filters = [new DropShadowFilter(4)];
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		/*protected var _margin:int;
		protected var _color:uint;
		protected var _shadow:Boolean;*/
		
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
	
	}

}


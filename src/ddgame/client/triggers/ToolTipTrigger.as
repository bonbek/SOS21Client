package ddgame.client.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import com.sos21.debug.log;
	import com.sos21.events.BaseEvent;
	import ddgame.client.triggers.AbstractTrigger;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.events.ApplicationChannel;
	import ddgame.view.UIHelper;
	import ddgame.server.events.PublicServerEventList;
	
	/**
	 *	Trigger ToolTip.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ToolTipTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 7;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _component:Sprite;
		private var _over:Boolean = false;
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var defaultColor:uint = 0xFFFFFF;	// couleur du fond par défaut
		public var maxWidth:int = 200;				// largeur maximum du tooltip
		public var margin:int = 8;						// marges intérieurs
		public var defaultStyleSheet:StyleSheet;
		public var defaultTextFormat:TextFormat;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function get classID():int {
			return CLASS_ID;
		}
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function execute(event:Event = null):void
		{
			if (isPropertie("text"))
			{
				_build();
			} else if (isPropertie("id")) {
				ApplicationChannel.getInstance().addEventListener(PublicServerEventList.ON_DATACONTENT, dataContentHandler);
				sendPublicEvent(new BaseEvent(PublicServerEventList.GET_DATACONTENT, getPropertie("id")));								
			} else {
				complete();
				return;
			}
			
			if (sourceTarget.inGroup) {
				var gr:Object = sourceTarget.inGroup;
				var n:int = gr.length;
				while (--n > -1)
				{
					gr.getChild(n).addEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false);
					gr.getChild(n).addEventListener(MouseEvent.CLICK, mouseHandler, false);
				}					
			}
			
			sourceTarget.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false);
			sourceTarget.addEventListener(MouseEvent.CLICK, mouseHandler, false);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function cancel () : void
		{
			_release();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Réception des data (contenu texte / html) depuis
		 *	le remoting
		 */
		protected function dataContentHandler(event:BaseEvent):void
		{
			ApplicationChannel.getInstance().removeEventListener(PublicServerEventList.ON_DATACONTENT, dataContentHandler);
			setPropertie("text", event.content.body);
			if (!_over) _build();
		}
		
		/**
		 *	Reception des évênements souris du tile
		 */
		protected function mouseHandler(event:MouseEvent):void
		{
			_release();
			_over = true;
			complete();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function _release () : void
		{
			if (_component)
			{
				_component.stopDrag();
				if (sourceTarget.inGroup) {
					var gr:Object = sourceTarget.inGroup;
					var n:int = gr.length;
					while (--n > -1)
					{
						gr.getChild(n).removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false);
						gr.getChild(n).removeEventListener(MouseEvent.CLICK, mouseHandler, false);
					}

				}				
				sourceTarget.removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false);
				sourceTarget.removeEventListener(MouseEvent.CLICK, mouseHandler, false);
				stage.removeChild(_component);
				_component = null;
			}
		}
		
		protected function createDefaultTextFormat():void
		{
			defaultTextFormat = new TextFormat();
			defaultTextFormat.font = "Verdana";
			defaultTextFormat.size = 11;
			var col:uint = isPropertie("textColor") ? getPropertie("textColor") : 0x000000;
			defaultTextFormat.color = col;
		}
		
		private function _createDefaultStyleSheet():void
		{
			defaultStyleSheet = new StyleSheet();
			var css:String = "a {font-size: 12; text-decoration: underline} div {font-family: Arial, Helvetica, _sans; font-size: 12; color:" + isPropertie("textColor") ? "#" + getPropertie("textColor") : "#FFFFFF}";
			defaultStyleSheet.parseCSS(css);
		}
		
		protected function _build():void
		{
//			_createDefaultStyleSheet();
			createDefaultTextFormat();
			var dmarg:int = margin / 2;
			var t:TextField = new TextField();
			t.x = t.y = dmarg;
			var otwidth:int = t.width = isPropertie("width") ? getPropertie("width") : maxWidth;
//			t.styleSheet = defaultStyleSheet;
			t.defaultTextFormat = defaultTextFormat;
			t.htmlText = "<div>" + getPropertie("text") + "<div>";
			t.autoSize = TextFieldAutoSize.LEFT;
			t.selectable = false;
			t.multiline = true;
			t.wordWrap = true;
			
			if (t.textWidth < otwidth) t.width = t.textWidth + 5;
			
			_component = new Sprite();
			var col:uint = isPropertie("bgColor") ? getPropertie("bgColor") : defaultColor;
			_component.graphics.beginFill(col);
			_component.graphics.drawRoundRect(0, 0, t.width + margin, t.height + margin, 6);
			_component.graphics.endFill();
			_component.addChild(t);
			var filt:DropShadowFilter = new DropShadowFilter(4);
			filt.alpha = 0.5;
			_component.filters = [filt];
			
//			var boun:Rectangle = Sprite(sourceTarget).getBounds(stage);
			var mx:int = stage.mouseX;
			var my:int = stage.mouseY;
			var cw:int = _component.width;
			var ch:int = _component.height;
			var mw:int = UIHelper.VIEWPORT_AREA.x + UIHelper.VIEWPORT_AREA.width;
			var mh:int = UIHelper.VIEWPORT_AREA.y;
			_component.x = mx + cw > mw ? mx - cw - dmarg : mx + dmarg;
			_component.y = my - ch < mh ? my + dmarg : my - ch - dmarg;
			stage.addChild(_component);
			_component.startDrag();
		}
			
	}

}


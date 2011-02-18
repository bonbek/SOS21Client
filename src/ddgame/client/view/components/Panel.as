/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.view.components {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import com.sos21.debug.log;
	import ddgame.client.view.components.CrossButton;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  01.04.2008
	 */
	public class Panel extends Sprite {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLOSE:String = "panelClose";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function Panel(parent:DisplayObjectContainer, w:Number = 100, h:Number = 100)
		{
			constructChildren();
			defineMargin();
			width = w;
			height = h;
			parent.addChild(this);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		[Embed(source="../../../../../assets/Panel.swf", symbol="PanelAsset")]
		private var _skinAssetClass:Class;
		
		protected var _closeBtn:CrossButton;
		protected var _background:Sprite;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public var content:Sprite;
		public var marginTop:Number;
		public var marginBottom:Number;
		public var marginLeft:Number;
		public var marginRight:Number;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public var autoSize:Boolean = true;
		
		override public function set width(w:Number):void
		{
			_background.width = w;
			_closeBtn.x = w - _closeBtn.width - 4;
		}
		
		override public function set height(h:Number):void
		{
			_background.height = h;
			_closeBtn.y = 4;			
		}
		
		public function close(event:Event = null):void
		{
			content.removeEventListener(Event.ADDED, childAddedHandler);
			_closeBtn.addEventListener(MouseEvent.MOUSE_UP, close);
			removeChild(_closeBtn);
			removeChild(_background);
			removeChild(content);
			content = null;
			_closeBtn = null;
			_background = null;
			parent.removeChild(this);
			dispatchEvent(new Event(CLOSE, true, false));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function childAddedHandler(event:Event):void
		{
//			trace("testAdded" + event.target);
//			event.stopImmediatePropagation();
			if (autoSize)
			{
				height = content.height + marginTop + marginBottom;
				width =  content.width + marginLeft + marginRight;
			}
		}
				
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function constructChildren():void
		{
//			var bgClass:Class = ApplicationDomain.currentDomain.getDefinition("PanelSkin") as Class;
//			var closeBtnClass:Class = ApplicationDomain.currentDomain.getDefinition("CrossButton") as Class;
			_closeBtn = new CrossButton();
			_background = Sprite(new _skinAssetClass());
			content = new Sprite();
			content.x = _background.scale9Grid.x;
			content.y = _background.scale9Grid.y;
			
				// track added child to content
			content.addEventListener(Event.ADDED, childAddedHandler);
			_closeBtn.addEventListener(MouseEvent.MOUSE_UP, close);
			
			addChild(_background);
			addChild(_closeBtn);
			addChild(content);
		}
		
		private function defineMargin():void
		{
			marginTop = _background.scale9Grid.y;
			marginLeft = _background.scale9Grid.x;
			marginBottom = _background.height - _background.scale9Grid.bottom;
			marginRight = _background.width - _background.scale9Grid.right;
		}
		
	}
	
}

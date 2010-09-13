/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package ddgame.client.view {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.sos21.events.BaseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import gs.TweenLite;
	import caurina.transitions.Equations;
	import com.sos21.debug.log;
	import com.sos21.helper.AbstractHelper;
	import ddgame.client.events.EventList;
	import ddgame.client.view.components.IconLibrary;
	import ddgame.client.view.components.UIRessourceItem;
	import ddgame.client.view.components.Stickie;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  18.04.2008
	 */
	public class UIRessourcesHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.UIRESSOURCES_HELPER;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function UIRessourcesHelper(button:MovieClip)
		{
			_UIbutton = button;
			_UIbutton.stop();
			super(NAME);
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _UIbutton:MovieClip;
		private var _ressourcesSprite:Sprite;
		private var _ballonSprite:Sprite;
		
		private var _ressourceItemList:Array = [];
		private var _ressourceOpen:Boolean = false;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function pushRessourceItem(mItem:UIRessourceItem):void
		{
			_ressourceItemList.push(mItem);			
		}
		
		public function clearAllRessourceItems():void
		{
			_ressourceItemList = new Array();
		}
		
		public function displayBallon(textS:String):void
		{
			if (_ballonSprite != null)
				removeBallon();

			_ballonSprite = new Stickie(200, textS);
			var filt:GlowFilter = new GlowFilter(0xFFFFFF, 1);
			_ballonSprite.filters = [filt];
			_ballonSprite.x = _UIbutton.x + _UIbutton.width / 2;
			_ballonSprite.y = _UIbutton.y - 8;			

			stage.addChild(_ballonSprite);
			stage.addEventListener(MouseEvent.MOUSE_UP, removeBallon, false, 100);
			
			TweenLite.from(_ballonSprite, 1, {tint:0xFFFFF});
			_UIbutton.play();
		}
		
		public function removeBallon(event:Event = null):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, removeBallon, false);
			if (stage.contains(_ballonSprite))
				stage.removeChild(_ballonSprite);
			_ballonSprite = null;
		}
		
		public function closeRessourceList():void
		{
			var l:int = _ressourceItemList.length;
			for (var i:int = 0; i < l; i++)
			{
				var sprite:UIRessourceItem = UIRessourceItem(_ressourceItemList[i]);
				_ressourcesSprite.removeChild(sprite);
			}
			stage.removeChild(_ressourcesSprite);
			
			_ressourceOpen = false;
		}
		
		public function openRessourceList():void
		{
			if (_ressourceItemList.length < 1)
				return;
				
			var filt:GlowFilter = new GlowFilter(0x000000, 1);
			_ressourcesSprite.filters = [filt];
			stage.addChild(_ressourcesSprite);
			
			var l:int = _ressourceItemList.length;
			var d:Number = 0;
			var ofs:Number = 0;
			for (var i:int = 0; i < l; i++)
			{
				var sprite:UIRessourceItem = UIRessourceItem(_ressourceItemList[i]);
				sprite.y = ofs;
				_ressourcesSprite.addChild(sprite);
				ofs += sprite.x + sprite.height + 8;
			}
			
			_ressourcesSprite.x = _UIbutton.x - _ressourcesSprite.width / 2;
			_ressourcesSprite.y = _UIbutton.y - _ressourcesSprite.height - 30;
			
			for (var j:int = 0; j < l; j++)
			{
				var spritet:UIRessourceItem = UIRessourceItem(_ressourceItemList[j]);
				TweenLite.from(spritet, 1, {y:sprite.y + sprite.height, ease:Equations.easeOutElastic});
			}
			
			_ressourceOpen = true;
		}
		
		override public function initialize():void
		{
			_ressourcesSprite = new Sprite();
			//stage.addChild(_ressourcesSprite);
			_UIbutton.addEventListener(MouseEvent.MOUSE_UP, buttonMouseHandler, false);
			_UIbutton.buttonMode = true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function buttonMouseHandler(event:MouseEvent = null):void
		{
			if (_ressourceOpen == false)
			{
				openRessourceList();
				stage.addEventListener(MouseEvent.CLICK, mouseHandler, false, 0);
			} else {
				closeRessourceList();
				stage.removeEventListener(MouseEvent.CLICK, mouseHandler, false);
			}
			_UIbutton.gotoAndStop(1);
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
//			trace(event.target);
			if (event.target != _UIbutton && _ressourceOpen == true)
				buttonMouseHandler();
		}
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch (event.type)
			{
				case EventList.ADD_RESSOURCES :
				{
					
					break;
				}
				case EventList.CLEAR_RESSOURCES :
				{
					
					break;
				}
				default :
				break;
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Call by super class
		 * List the Event interest this Helper is interested in
		 */
		override protected function listInterest():Array
		{
			return [	EventList.ADD_RESSOURCES ];
		}

	}
	
}

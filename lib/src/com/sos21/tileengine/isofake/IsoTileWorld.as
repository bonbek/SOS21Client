package com.sos21.tileengine.isofake {	

	import flash.utils.*;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	import com.sos21.tileengine.display.Layer;
	import com.sos21.tileengine.display.TileLayer;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.isofake.IsoDrawer;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.10.2007
	 */
	public class IsoTileWorld extends Layer {
		
		
		public function IsoTileWorld ()
		{			
			super( "isotileWorld" );
			_init();
		}
		
		public var groundLayer : TileLayer;
		public var sceneLayer : TileLayer;
		public var foregroundLayer : Layer;
		public var backgroundLayer : Layer;
		public var debugLayer : TileLayer;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------	
		
		private var _noMouseEventInAlpha:Boolean = false;
		private var _tileUnderMouse:AbstractTile;
		// rectangle de test alpha
		/*private var _htRect:Rectangle;
		private var _htRectOfs:int;*/
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------	
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Active la capture des events souris sur le zones transparentes
		 * des enfants de ce  conteneur
		 *	@private
		 */
		public function enableNoMouseEventInAlpha (hitZoneArea:int = 10) : void
		{
			if (_noMouseEventInAlpha) return;

			/*if (!_htRect) {
				_htRect = new Rectangle(0, 0, hitZoneArea, hitZoneArea);
				_htRectOfs = hitZoneArea / 2;
			}*/
			
			with (stage)
			{
				addEventListener(MouseEvent.MOUSE_OVER, catchMouseEvents, true);
				addEventListener(MouseEvent.MOUSE_OUT, catchMouseEvents, true);			
			}

			addEventListener(MouseEvent.CLICK, mouseClickMouseDownHandler, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseClickMouseDownHandler, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseClickMouseDownHandler, true);
			//addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);	
			
			_noMouseEventInAlpha = true;
		}
		
		/**
		 * Désactive la capture des events souris sur le zones transparentes
		 * des enfants de ce  conteneur
		 *	@private
		 */
		public function disableNoMouseEventInAlpha () : void
		{
			if (!_noMouseEventInAlpha) return;
			
			with (stage)
			{
				removeEventListener(MouseEvent.MOUSE_OVER, catchMouseEvents, true);
				removeEventListener(MouseEvent.MOUSE_OUT, catchMouseEvents, true);
			}

			removeEventListener(MouseEvent.CLICK, mouseClickMouseDownHandler, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseClickMouseDownHandler, true);
			removeEventListener(MouseEvent.MOUSE_UP, mouseClickMouseDownHandler, true);							
			// removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
			
			_noMouseEventInAlpha = false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@param event MouseEvent
		 */
		private function catchMouseEvents (event:MouseEvent) : void
		{
			if (event.target is AbstractTile || contains(DisplayObject(event.target)))
			{
					addEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
					event.stopPropagation();
			}
			else
			{
				if (event.type == MouseEvent.MOUSE_OVER)
				{
					if (_tileUnderMouse)
					{
						if (_tileUnderMouse.inGroup)
						{
							var n2:int = _tileUnderMouse.inGroup.length;
							while (--n2 > -1) {
								_tileUnderMouse.inGroup.getChild(n2).useHandCursor = false;
							}
						}
						else
						{
							_tileUnderMouse.useHandCursor = false;
						}

						dispatchMouseEvent(_tileUnderMouse, MouseEvent.MOUSE_OUT);
						_tileUnderMouse = null;					
					}
//					trace("remove enter frame handler");
					removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
				} else if (event.type == MouseEvent.MOUSE_OUT) {
//					trace("add enter frame handler");
					addEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
				}
			}
		}
		
		/**
		 * Réception de events click mouseDown et mouseUp
		 * Lance les test sur les zones transparente de l'objet
		 * cliqué et tous les objets en dessous du point cliqué
		 *	@param event Event
		 */
		protected function mouseClickMouseDownHandler (event:MouseEvent) : void
		{
			if (!_tileUnderMouse)
			{
				if (event.target is AbstractTile)
				{
					event.stopPropagation();
					removeEventListener(event.type, mouseClickMouseDownHandler, true);
					event.target.parent.dispatchEvent(new MouseEvent(event.type));
					addEventListener(event.type, mouseClickMouseDownHandler, true);					
				}
				return;
			}
						
			var targ:DisplayObject = DisplayObject(event.target);
			if (targ is AbstractTile || contains(targ))
			{
				var lay:Layer;
				var dob:AbstractTile;
				var n:int = numChildren;

				while (--n > -1)
				{
					lay = getChildAt(n) as Layer;
					if (lay is TileLayer)
					{
						dob = TileLayer(lay).getTileUnderMouse();
						if (dob)
						{
							if (!dob.mouseChildren)
							{
								event.stopPropagation();
								removeEventListener(event.type, mouseClickMouseDownHandler, true);
								dob.dispatchEvent(new MouseEvent(event.type));
								addEventListener(event.type, mouseClickMouseDownHandler, true);
							}
							break;
						}
					}
				}
			}
		}
		
		/**
		 * Test interactions mouse-over mouse-out avec prise en compte des
		 * zones transparentes sur les layers de conteneur
		 *	@param event Event
		 */
		protected function enterFrameHandler (event:Event = null) : Boolean
		{
			if (!_noMouseEventInAlpha) return false;
			
			var t:int = getTimer();

			var lay:Layer;
			var dob:AbstractTile;
			var n:int = numChildren;
			
			while (--n > -1)
			{
				lay = getChildAt(n) as Layer;
				if (lay is TileLayer)
				{
					dob = TileLayer(lay).getTileUnderMouse();
					if (dob)
					{
						// on dispatch un mouse out si un tile était en survol
						// autre que le nouveau
						if (_tileUnderMouse)
						{
							if (_tileUnderMouse != dob)
							{
								// check si on est sur un groupe
								if (_tileUnderMouse.inGroup && dob.inGroup)
								{
									// on est sur un tile qui appartient au même groupe que l'ancien
									// tile en roll over
									if (_tileUnderMouse.inGroup.owner != dob.inGroup.owner)
									{
										var n2:int = _tileUnderMouse.inGroup.length;
										while (--n2 > -1)
											_tileUnderMouse.inGroup.getChild(n2).useHandCursor = false;
									}
								} else {
									_tileUnderMouse.useHandCursor = false;
								}
								dispatchMouseEvent(_tileUnderMouse, MouseEvent.MOUSE_OUT);				
							} else {
								break;
							}
						}
						
						// check si on est sur un groupe
						if (dob.inGroup)
						{
							n2 = dob.inGroup.length;
							while (--n2 > -1) {
								dob.inGroup.getChild(n2).useHandCursor = true;
							}
						} else {
							dob.useHandCursor = true;
						}
						
						// dispatch mouse over d'un nouveau
						dispatchMouseEvent(dob, MouseEvent.MOUSE_OVER);
						_tileUnderMouse = dob;

						break;
					}
				}
			}
			
			var chek:Boolean = n > -1;
			if (!chek)
			{
				if (_tileUnderMouse)
				{
					if (_tileUnderMouse.inGroup)
					{
						n2 = _tileUnderMouse.inGroup.length;
						while (--n2 > -1) {
							_tileUnderMouse.inGroup.getChild(n2).useHandCursor = false;
						}
					} else {
						_tileUnderMouse.useHandCursor = false;
					}
					
					dispatchMouseEvent(_tileUnderMouse, MouseEvent.MOUSE_OUT);
					_tileUnderMouse = null;
				}
			}
//trace("check mouse: ", getTimer() - t);
			return chek;
		}

		private function render (event:Event) : void
		{
			drawer.render(sceneLayer);
			drawer.render(debugLayer);
		}
	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
//		private function getTileUnderMouse()

		private function dispatchMouseEvent (dispatcher:IEventDispatcher, evtType:String) : void
		{
			stage.removeEventListener(evtType, catchMouseEvents, true);
			dispatcher.dispatchEvent(new MouseEvent(evtType));
			stage.addEventListener(evtType, catchMouseEvents, true);
		}
		
		private function _init() : void
		{
			drawer = new IsoDrawer();
			
			sceneLayer = new TileLayer("sceneLayer", 3);
//			sceneLayer.enableNoMouseEventInAlpha();
			groundLayer = new TileLayer("groundLayer", 2);
			backgroundLayer = new Layer("backgroundLayer", 0);
			foregroundLayer = new Layer("foregroundLayer", 4);
			debugLayer = new TileLayer("debugLayer", 5);
			
			addLayer(sceneLayer);
			addLayer(groundLayer);
			addLayer(backgroundLayer);
			addLayer(foregroundLayer);
			addLayer(debugLayer);
			
			addEventListener(Event.ENTER_FRAME, render, false, 0, true);	
		}
		
		
	}
	
}

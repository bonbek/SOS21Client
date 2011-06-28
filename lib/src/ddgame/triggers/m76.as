package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.observer.IObserver;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
	import ddgame.helper.HelperList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.tileengine.events.TileEvent;

	/**
	 * Trigger map id 21 (cour du collège)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m76 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m76():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m76.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjAccueil:Object;					// pnj accueil
		public var pnjAgenda:Object;					// pnj agenda
		public var playerHelper:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		private var _inited:Boolean = false;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 *	
		 */
		override public function execute(event:Event = null):void
		{
			// refs utiles
			playerHelper = facade.getObserver(HelperList.PLAYER_HELPER);
			
			// on test si les data sont arrviées et si l'init pas
			// encore fait
			if (data && !_inited)
				_init();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function tileEventHandler(event:TileEvent):void
		{
			var up:Object = event.getCell();
			switch (event.type)
			{
				case TileEvent.ENTER_CELL :
				{
					if (up.xu <= 15 && up.zu < 24) {
						trace("IN IN")
						playerHelper.component.removeEventListener(TileEvent.ENTER_CELL, tileEventHandler, false);
						pnjAgenda.component.addEventListener(MouseEvent.MOUSE_OVER, pnjAgendaMouseHandler, false, 0, true);
						pnjAgenda.autoLife = true;
					} 
					break;
				}
			}
		}
		
		private function pnjAgendaMouseHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					pnjAgenda.jumpInLife("needHelp");
					pnjAgenda.autoLife = true;
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception chargement des data (m21.xml)
		 */
		private function dataLoaderHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, dataLoaderHandler, false);
			data = XML(event.target.data);
			data.ignoreComments = true;
			_init();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 */
		private function _init():void
		{
			_inited = true;
			
			// pnj accueil
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			var tv:Object = objBuilder.createMCTileView(new TileViewPnjAccueil());
			var at:Object = objBuilder.createAbstractTile("pnjAccueil", 0, 0, 0, tv);
			pnjAccueil = objBuilder.createPNJHelper("pnjAccueil", at);
			facade.registerObserver(pnjAccueil.name, IObserver(pnjAccueil));
			pnjAccueil.iaData = data.pnj.(@id == "pnjAccueil")[0];
			pnjAccueil.autoLife = true;
			
			// pnj agenda 21
			tv = objBuilder.createMCTileView(new TileViewPnjAgenda());
			at = objBuilder.createAbstractTile("pnjAgenda", 0, 0, 0, tv);
			pnjAgenda = objBuilder.createPNJHelper("pnjAgenda", at);
			facade.registerObserver(pnjAgenda.name, IObserver(pnjAgenda));
			pnjAgenda.iaData = data.pnj.(@id == "pnjAgenda")[0];
			pnjAgenda.autoLife = true;
			
			// écoute entrées céllule
			playerHelper.component.addEventListener(TileEvent.ENTER_CELL, tileEventHandler, false, 0, true);
						
			// ajout listener sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);						
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			super.complete();
		}
		
	}

}
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
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.observer.IObserver;

//	import ddgame.client.view.PNJHelper;

	/**
	 * Trigger map id 82 (port st Tropez)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m83 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m83():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m83.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		// pnjs
		public var pnjOffice:Object;
		public var pnjMystere:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		
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
			// on test si les data sont arrviées et si l'init pas
			// encore fait
			if (data)
				_init();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Réception des evenst souris sur les pnj's
		 */
		private function pnjMouseHandler(e:Event):void
		{
			var targ:Object = e.target;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
				{
					switch (true)
					{
						case targ == pnjOffice.component :
						{
							if (pnjMystere.ballon) {
								pnjMystere.removeBallon();
							}
							pnjOffice.jumpInLife("needHelp");
							pnjOffice.autoLife = true;
							break;
						}
						case targ == pnjMystere.component :
						{
							if (pnjOffice.ballon) {
								pnjOffice.removeBallon();
							}
							pnjMystere.jumpInLife("needHelp");
							pnjMystere.autoLife = true;
							break;
						}
					}		
					break;
				}
			}
		}
		
		/**
		 *	@private
		 *	Réception chargement des data (m82.xml)
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
			// mise en place pnjs
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);

			var tv:Object = objBuilder.createMCTileView(new TileViewPnjOffice());
			var at:Object = objBuilder.createAbstractTile("pnjOffice", 0, 0, 0, tv);
			pnjOffice = objBuilder.createPNJHelper("pnjOffice", at);
			facade.registerObserver(pnjOffice.name, IObserver(pnjOffice));
			pnjOffice.iaData = data.pnj.(@id == "pnjOffice")[0];
			pnjOffice.autoLife = true;

			tv = objBuilder.createMCTileView(new TileViewPnjMystere());
			at = objBuilder.createAbstractTile("pnjMystere", 0, 0, 0, tv);
			pnjMystere = objBuilder.createPNJHelper("pnjMystere", at);
			facade.registerObserver(pnjMystere.name, IObserver(pnjMystere));
			pnjMystere.iaData = data.pnj.(@id == "pnjMystere")[0];
			pnjMystere.autoLife = true;
			
			// ecoute events souris sur pnjs
			pnjOffice.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			pnjMystere.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			
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
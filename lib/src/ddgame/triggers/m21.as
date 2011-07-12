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
	import ddgame.helper.HelperList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import com.sos21.observer.IObserver;

//	import ddgame.client.view.PNJHelper;

	/**
	 * Trigger map id 21 (cour du collège)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m21 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m21():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m21.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjPione:Object;					// pnj pione
		public var playerHelper:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get bobInCour():Boolean {
			return playerHelper.component.upos.xu <= 23;
		}
		
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
			// refs utiles
			playerHelper = facade.getObserver(HelperList.PLAYER_HELPER);
			
			// pnj
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			var tv:Object = objBuilder.createMCTileView(new TileViewPnjPione());
			var at:Object = objBuilder.createAbstractTile("pnjPione", 15, 21, 0, tv);
			pnjPione = objBuilder.createPNJHelper("pnjPione", at);
			facade.registerObserver(pnjPione.name, IObserver(pnjPione));
			pnjPione.iaData = data.pnj.(@id == "pione")[0];
			
			pnjPione.component.gotoAndStop("stand");
			
			// test dans quelle partie de la scène se trouve bob pour
			// switcher sur comportement du pnj
			var nodId:String;
			if (!bobInCour) {
				nodId = "intro";
				pnjPione.component.rotation = 0;
			} else {
				var dtm:Object = facade.getProxy(ProxyList.DATAMAP_PROXY);
				var lmid:int = dtm.lastMapId;
				nodId = "fromMap" + String(lmid);
				if (lmid == 35) // on revient de la cantine
				{
					pnjPione.component.rotation = 225;
				} else {
					pnjPione.component.rotation = 180;
				}
			}

			pnjPione.jumpInLife(nodId);
			pnjPione.autoLife = true;
			
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
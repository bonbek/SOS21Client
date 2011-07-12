package ddgame.triggers {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import gs.TweenMax;
	import gs.easing.Strong;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.observer.IObserver;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
	import ddgame.helper.HelperList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	

//	import ddgame.client.view.PNJHelper;

	/**
	 * Trigger map id 21 (cour du collège)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m72 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m72():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m72.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjMtaterre:Object;					// pnj pione
		public var playerHelper:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		protected var data:XML;
		private var _inited:Boolean = false;
		
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
			// refs utiles
			playerHelper = facade.getObserver(HelperList.PLAYER_HELPER);
			playerHelper.component.visible = false;			

			var datamapProxy:Object = facade.getProxy(ProxyList.DATAMAP_PROXY);
			// on vient de la map M ta Terre (ascenseur)
			var isosceneHelper:Object = facade.getObserver(HelperList.ISOSCENE_HELPER);
			var ascenseurLoader:Object = isosceneHelper.getTile("ascenseur").getChildAt(0);
			if (!ascenseurLoader.content)
			{
				isosceneHelper.getTile("ascenseur").getChildAt(0).contentLoaderInfo.addEventListener(Event.COMPLETE, execute, false, 0, true);
			} else {
				var soundFx:MovieClip = new ascenseurSoundIn72();
				ascenseurLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, execute, false);
				var ascenseur:Object = isosceneHelper.getTile("ascenseur").getChildAt(0).content.capsule;
				TweenMax.from(ascenseur, 5, {y:-600, ease:Strong.easeOut, onComplete:ascenseurCompleteHandler, onCompleteParams:[false]});
			}
			
			// on test si les data sont arrviées et si l'init pas
			// encore fait
			if (data && !_inited)
				_init();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @private
		 * Réception des events triggers
		 */
		private function triggersHandlers(event:TriggerEvent):void
		{
			// on est sur le trigger bouger perso jusqu'à l'ascenseur
			if (event.type == TriggerEvent.COMPLETE)
			{
				if (event.trigger.properties.id == 2)
				{
					var isosceneHelper:Object = facade.getObserver(HelperList.ISOSCENE_HELPER);
					var ascenseur:Object = isosceneHelper.getTile("ascenseur").getChildAt(0).content.capsule;

					playerHelper.component.visible = false;
					TweenMax.to(ascenseur, 4, {y:-600, ease:Strong.easeIn, onComplete:ascenseurCompleteHandler});
					var soundFx:MovieClip = new ascenseurSoundOut72();
				}				
			}
		}
		
		private function ascenseurCompleteHandler(goOut:Boolean = true):void
		{
			var triggerProxy:Object = facade.getProxy(ProxyList.TRIGGERS_PROXY);
			var tid:int = goOut ? 3 : 4;

			triggerProxy.launchTrigger(triggerProxy.getTrigger(tid));

			playerHelper.component.visible = true;
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
			// pnj
			var objBuilder:Object = facade.getProxy(ProxyList.OBJECTBUILDER_PROXY);
			var tv:Object = objBuilder.createMCTileView(new TileViewMtaterre());
			var at:Object = objBuilder.createAbstractTile("pnjMtaterre", 17, 25, 0, tv);
			pnjMtaterre = objBuilder.createPNJHelper("pnjMtaterre", at);
			facade.registerObserver(pnjMtaterre.name, IObserver(pnjMtaterre));
			pnjMtaterre.iaData = data.pnj.(@id == "mtaterre")[0];
			
			pnjMtaterre.component.gotoAndStop("stand");

//			pnjMtaterre.jumpInLife(nodId);
			pnjMtaterre.autoLife = true;
			
			// écoute execution des triggers
			channel.addEventListener(TriggerEvent.COMPLETE, triggersHandlers, false, 0, true);
			// ajout listener sur changement de map
			channel.addEventListener(EventList.CLEAR_MAP, complete, false, 50);						
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			channel.removeEventListener(EventList.CLEAR_MAP, complete, false);
			channel.removeEventListener(TriggerEvent.COMPLETE, triggersHandlers, false);
			super.complete();
		}
		
	}

}
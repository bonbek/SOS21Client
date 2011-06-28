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
	import gs.easing.Quad;
	
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
	public class m71 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m71():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m71.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjAdeme:Object;					// pnj pione
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
			
			var datamapProxy:Object = facade.getProxy(ProxyList.DATAMAP_PROXY);
			// on vient de la map M ta Terre (ascenseur)
			if (datamapProxy.lastMapId == 72)
			{
				var isosceneHelper:Object = facade.getObserver(HelperList.ISOSCENE_HELPER);
				var ascenseurLoader:Object = isosceneHelper.getTile("ascenseur").getChildAt(0);
				if (!ascenseurLoader.content)
				{
					isosceneHelper.getTile("ascenseur").getChildAt(0).contentLoaderInfo.addEventListener(Event.COMPLETE, execute, false, 0, true);
				} else {
					ascenseurLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, execute, false);
					var ascenseur:Object = ascenseurLoader.content.capsule;
					TweenMax.from(ascenseur, 2, {y:ascenseur.y + ascenseur.height, ease:Quad.easeOut, onComplete:ascenseurCompleteHandler, onCompleteParams:[false]});
					var soundFx:MovieClip = new ascenseurSoundIn();
				}
				
				playerHelper.component.visible = false;				
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
			if (event.type == TriggerEvent.COMPLETE)
			{
				// on est sur le trigger bouger perso jusqu'à l'ascenseur
				if (event.trigger.properties.id == 2)
				{
					var isosceneHelper:Object = facade.getObserver(HelperList.ISOSCENE_HELPER);
					var ascenseur:Object = isosceneHelper.getTile("ascenseur").getChildAt(0).content.capsule;
				
					playerHelper.component.visible = false;
					TweenMax.to(ascenseur, 2, {y:ascenseur.y + ascenseur.height, ease:Quad.easeIn, onComplete:ascenseurCompleteHandler});
					var soundFx:MovieClip = new ascenseurSoundOut();
				}
			}
		}
		
		/**
		 *	@private
		 * Reception fin anim ascenseur
		 */	
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
			var tv:Object = objBuilder.createMCTileView(new TileViewPnjAdeme());
			var at:Object = objBuilder.createAbstractTile("pnjAdeme", 20, 21, 0, tv);
			pnjAdeme = objBuilder.createPNJHelper("pnjAdeme", at);
			facade.registerObserver(pnjAdeme.name, IObserver(pnjAdeme));
			pnjAdeme.iaData = data.pnj.(@id == "ademe")[0];
			
			pnjAdeme.component.gotoAndStop("stand");
			
			// test dans quelle partie de la scène se trouve bob pour
			// switcher sur comportement du pnj
			var nodId:String;
			nodId = "intro";
			var dtm:Object = facade.getProxy(ProxyList.DATAMAP_PROXY);
			var lmid:int = dtm.lastMapId;
			if (lmid == 72)
				nodId = "fromMap" + String(lmid);

			pnjAdeme.jumpInLife(nodId);
			pnjAdeme.autoLife = true;
			
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
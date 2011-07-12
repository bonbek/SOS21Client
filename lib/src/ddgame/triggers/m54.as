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
	public class m54 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m54():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m54.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjAgora:Object;					// pnj pione
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
		
		/**
		 * @private
		 * Réception des events triggers
		 */
		private function triggersHandlers(event:TriggerEvent):void
		{
			var pid:int = event.trigger.properties.id;
			switch (pid)
			{
				case 3 : // retour de la salle de projection
				{
					if (event.type == TriggerEvent.COMPLETE)
					{
						pnjAgora.autoLife = true;
						pnjAgora.jumpInLife("waitOut");
					}						
					break;
				}
				case 21 : // clique sur fleche sortie
				{
					if (event.type == TriggerEvent.EXECUTE)
					{
						pnjAgora.autoLife = true;
						pnjAgora.jumpInLife("byebye");
						pnjAgora.autoLife = true;
					}
					break;
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
			var tv:Object = objBuilder.createMCTileView(new TileViewAgora());
			var at:Object = objBuilder.createAbstractTile("pnjAgora", 0, 0, 0, tv);
			pnjAgora = objBuilder.createPNJHelper("pnjAgora", at);
			facade.registerObserver(pnjAgora.name, IObserver(pnjAgora));
			pnjAgora.iaData = data.pnj.(@id == "agora")[0];
			
			pnjAgora.component.gotoAndStop("stand");

//			pnjAgora.jumpInLife(nodId);
			pnjAgora.autoLife = true;
			
			// écoute execution des triggers
			channel.addEventListener(TriggerEvent.EXECUTE, triggersHandlers, false, 0, true);
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
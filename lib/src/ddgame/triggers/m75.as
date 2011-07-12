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

	/**
	 * Trigger map id 21 (cour du collège)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m75 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m75():void
		{
			super();
			
			// chargement xml data
			var dataLoader:URLLoader = new URLLoader();
			dataLoader.addEventListener(Event.COMPLETE, dataLoaderHandler, false, 0, true);
			dataLoader.load(new URLRequest("data/m75.xml"));
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		public var pnjClaude:Object;					// pnj pione
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
		
		private function pnjMouseHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_OVER :
				{					
					pnjClaude.jumpInLife("needHelp");
//					pnjClaude.autoLife = false;
//					pnjClaude.component.addEventListener(MouseEvent.MOUSE_OUT, pnjMouseHandler, false, 0, true);
//					pnjClaude.component.addEventListener(MouseEvent.CLICK, pnjMouseHandler, false, 0, true);
					break;
				}
			}
		}
		
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
						pnjClaude.autoLife = true;
						pnjClaude.jumpInLife("waitOut");
					}						
					break;
				}
				case 21 : // clique sur fleche sortie
				{
					if (event.type == TriggerEvent.EXECUTE)
					{
						pnjClaude.autoLife = true;
						pnjClaude.jumpInLife("byebye");
						pnjClaude.autoLife = true;
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
			var tv:Object = objBuilder.createMCTileView(new TileViewClaude());
			var at:Object = objBuilder.createAbstractTile("pnjClaude", 0, 0, 0, tv);
			pnjClaude = objBuilder.createPNJHelper("pnjClaude", at);
			facade.registerObserver(pnjClaude.name, IObserver(pnjClaude));
			pnjClaude.iaData = data.pnj.(@id == "claude")[0];

			pnjClaude.autoLife = true;
			
			// écoute souris sur phil
			pnjClaude.component.addEventListener(MouseEvent.MOUSE_OVER, pnjMouseHandler, false, 0, true);
			
			// écoute execution des triggers
//			channel.addEventListener(TriggerEvent.EXECUTE, triggersHandlers, false, 0, true);
//			channel.addEventListener(TriggerEvent.COMPLETE, triggersHandlers, false, 0, true);
			
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
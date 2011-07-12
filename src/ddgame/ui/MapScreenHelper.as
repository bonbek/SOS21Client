package ddgame.ui {

	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import br.com.stimuli.loading.BulkLoader;

	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.BaseEvent;
	import ddgame.helper.HelperList;
	import ddgame.ui.UIHelper;
	import ddgame.events.EventList;
	import ddgame.proxy.TileTriggersProxy;
	import ddgame.display.MiniProgressBar;
	import ddgame.scene.IsosceneHelper;
	
	/**
	 *	Helper carte de déplacement
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  08.11.2010
	 */
	public class MapScreenHelper extends AbstractHelper {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.MAPSCREEN_HELPER;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function MapScreenHelper ()
		{
			super(NAME);
		}
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var map:MovieClip;
		private var progressBar:MiniProgressBar;
	
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Affichage de la carte
		 */
		public function openMap () : void
		{
			if (map) return;
			
			// freeze de la scène
			sendEvent(new BaseEvent(EventList.FREEZE_SCENE));
			IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).component.visible = false;
			
			var loader:BulkLoader = BulkLoader.getLoader("mapScreen");
			if (!loader) loader = new BulkLoader("mapScreen");

			loader.add("uis/MapScreen.swf", {id:"mapAsset", preventCache:true, context:new LoaderContext(false, ApplicationDomain.currentDomain)});
			loader.addEventListener(Event.COMPLETE, onAssetsLoaded);
			
			// barre de progression
			progressBar = new MiniProgressBar();
			progressBar.suscribe(loader);
			progressBar.x = UIHelper.VIEWPORT_AREA.x + ((UIHelper.VIEWPORT_AREA.width - progressBar.width) / 2);
			progressBar.y = UIHelper.VIEWPORT_AREA.y + ((UIHelper.VIEWPORT_AREA.height - progressBar.height) / 2);
			stage.addChild(progressBar);
			
			loader.start();
		}
		
		/**
		 *	Fermeture la carte
		 */
		public function closeMap () : void
		{
			if (!map) return;
			
			stage.removeChild(map);
			map = null;
			
			sendEvent(new BaseEvent(EventList.UNFREEZE_SCENE));
			IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).component.visible = true;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception chargement assets
		 *	@param event Event
		 */
		private function onAssetsLoaded (event:Event) : void
		{
			var loader:BulkLoader = BulkLoader.getLoader("mapScreen");
			loader.removeEventListener(Event.COMPLETE, onAssetsLoaded);
			stage.removeChild(progressBar);
			progressBar = null;
			
			// test
			map = loader.getMovieClip("mapAsset", true);
			map.x = UIHelper.VIEWPORT_AREA.x;
			map.y = UIHelper.VIEWPORT_AREA.y;
			stage.addChild(map);
			
			map.addEventListener(MouseEvent.CLICK, onClickMap);
		}
		
		/**
		 * Réception clique sur la map
		 *	@param event MouseEvent
		 */
		private function onClickMap (event:MouseEvent) : void
		{
			if (event.target == map.closeButton) 
			{
				closeMap();
				return;
			}
			
			var tprop:Object = map.triggers[event.target];
			if (tprop)
			{
				var triggerProxy:TileTriggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
				triggerProxy.createTrigger(tprop);
				triggerProxy.launchTriggerByID(tprop.id);
			}

		}
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent (event:Event) : void
		{
			switch (event.type)
			{
				case ddgame.events.EventList.CLEAR_MAP :
					if (map) closeMap();
					break;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function listInterest () : Array
		{
			return [	ddgame.events.EventList.CLEAR_MAP ];
		}
	
	}

}
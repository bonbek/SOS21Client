package ddgame.scene {
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.sos21.lib.GLib;
	import ddgame.sound.SoundTrack;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import ddgame.sound.AudioHelper;
	import com.sos21.tileengine.events.TileEvent;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.MCTileView;
	import ddgame.helper.HelperList;
	import ddgame.events.EventList;
	import ddgame.proxy.DatamapProxy;
	import ddgame.proxy.LibProxy;
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.scene.PNJHelper;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class PlayerHelper extends PNJHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.PLAYER_HELPER;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function PlayerHelper (skin:Object = null)
		{
			super(NAME);
			_skin = skin;
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
//		private var _skin:Object;
		private var timer:Timer;
		private var lastLabel:Object;
		private var lastRotation:int;
		private var sndFx:SoundTrack;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le composant casté
		 */
		/*public function get component ():AbstractTile
		{ 
			return AbstractTile(_component);
		}*/
		
		/**
		 * Retourne la position du composant relative au stage
		 */
		public function get stagePosition ():Point
		{
			var lp:Point = new Point(component.x, component.y);
			return component.contener.localToGlobal(lp);
		}
		
		public function get playerPosition () : UPoint
		{ 
			return component.upos;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Définit l'apparence de l'avatar du joueur
		 * @param	val	 l'identifiant (classe)  
		 */
		public function set skin (val:Object):void
		{
			if (val != _skin)
				_skin = val;
				
			// TODO update de l'avatar
		}
		
		public function movePlayer (path:Array /* of Object */) : void
		{
			timer.reset();
			component.stage.removeEventListener(MouseEvent.CLICK, handleEvent, true);
			component.pathTo(path);
			//sndFx.play(0, -1);
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function initialize():void
		{
			defaultInit();
 			timer = new Timer(60000, 1);
			timer.addEventListener(TimerEvent.TIMER, handleEvent);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent (event:Event) : void
		{
			switch(event.type)
			{
				case EventList.SCENE_BUILDED :
				{
					if (!component) createAvatar();
					addComponentToScene();
					break;
				}
				case TileEvent.MOVE_COMPLETE :
				{
					sendEvent(new Event(EventList.PLAYER_MOVE_COMPLETE));
					stage.addEventListener(MouseEvent.CLICK, handleEvent, true);
					timer.start();
					//sndFx.stop();
					break;
				}
				case TileEvent.MOVE :
				{
					sendEvent(new Event(EventList.PLAYER_MOVE));
					break;
				}
				case TileEvent.LEAVE_CELL :
				{
					sendEvent(new BaseEvent(EventList.PLAYER_LEAVE_CELL, TileEvent(event).getCell()));
					break;
				}
				case TileEvent.ENTER_CELL :
				{
					sendEvent(new BaseEvent(EventList.PLAYER_ENTER_CELL, TileEvent(event).getCell()));
					break;
				}
				case EventList.CLEAR_MAP :
				{
					stage.removeEventListener(MouseEvent.CLICK, handleEvent, true);
					component.stop();
					timer.reset();
					if (ballon)
					{
						ballon.data.stopAutoLife = false;
						removeBallon();
					}
					break;
				}
				case TimerEvent.TIMER :
				{
					timer.reset();
					lastRotation = component.rotation;
					lastLabel = component.getView().label;
					
					component.rotation = 0;
					component.gotoAndPlay("buzy");
					break;
				}
				case MouseEvent.CLICK :
				{
					if (component.getView().label == "buzy")
					{
						component.rotation = lastRotation;
						component.gotoAndStop(String(lastLabel));						
					}
					break;
				}
				default :
				{
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function createAvatar ():void
		{
			if (component) return;
			
			var cl:Class = libProxy.getDefinitionFrom(libProxy.spritesPath + "AvatarSkins.swf", _skin.className);
			var mc:MovieClip = new cl();
			
			// --> Patch pour scale du perso 
			/*var factor:Number = dataMap.avatarFactor;
			mc.scaleX = mc.scaleY = factor;
			mc.y = dataMap.tileh / 2;*/

			// <--
			
			var tv:MCTileView = new MCTileView(mc);
			
			var up:UPoint = new UPoint( 0, 0, 0, dataMap.tilew, dataMap.tileh, dataMap.tiled, 0, 0, 0);
			up.width = 1;
			up.height = 2;
			up.depth = 1;
			_component = new AbstractTile("bob", up, tv);
			component.name = "BoB";
			component.addEventListener(TileEvent.MOVE_COMPLETE, handleEvent, false, 0, true);
			component.addEventListener(TileEvent.MOVE, handleEvent, false, 0, true);
			component.addEventListener(TileEvent.ENTER_CELL, handleEvent, false, 0, true);
			component.addEventListener(TileEvent.LEAVE_CELL, handleEvent, false, 0, true);
		}
		
		/**
		 *	@private
		 */
		override protected function addComponentToScene ():void
		{
			// -- > Patch pour scale du perso
//			return;
			var factor:Number = dataMap.avatarFactor;
			var tview:MovieClip = MCTileView(component.getView()).asset;
			tview.scaleX = tview.scaleY = factor;
			tview.y = dataMap.tileh / 2;
			component.speed = 90 * factor;
			// < --
			
			component.upos.xFactor = dataMap.tilew;
			component.upos.yFactor = dataMap.tiled;
			component.upos.zFactor = dataMap.tileh;
			component.upos.matchPos(dataMap.entryPoint);
			IsosceneHelper(facade.getObserver(IsosceneHelper.NAME)).addAvatar(component);

			stage.addEventListener(MouseEvent.CLICK, handleEvent, true);
			
			//timer.start();
		}
		
		/**
		 * @private
		 */
		private function get dataMap ():DatamapProxy
		{
			return DatamapProxy(facade.getProxy (DatamapProxy.NAME))
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function listInterest() : Array
		{
			return [ EventList.SCENE_BUILDED,
			 			EventList.CLEAR_MAP ];
		}

	}
	
}
package ddgame.client.view {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.display.MovieClip;
	import com.sos21.events.BaseEvent;
	import com.sos21.helper.AbstractHelper;
	import com.sos21.proxy.ConfigProxy;
	import com.sos21.lib.GLib;
	import com.sos21.tileengine.utils.PathFinder;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.isofake.IsoTileWorld;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.MCTileView;
	import ddgame.client.events.EventList;
	import ddgame.client.events.PublicIsoworldEventList;
	import ddgame.client.proxy.LibProxy;
	import ddgame.client.proxy.DatamapProxy;
	import ddgame.client.proxy.TileTriggersProxy;
	import ddgame.client.view.HelperList;
	import ddgame.client.view.PlayerHelper;
	import ddgame.view.UIHelper;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  24.02.2008
	 */
	public class IsosceneHelper extends AbstractHelper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = HelperList.ISOSCENE_HELPER;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function IsosceneHelper(sname:String = null)
		{
			super(sname == null ? NAME : sname);
			
			_isoScene = new IsoTileWorld();
			_isoScene.x = UIHelper.VIEWPORT_AREA.x;
			_isoScene.y = UIHelper.VIEWPORT_AREA.y;
		}

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var datamapProxy:DatamapProxy;
		private var triggersProxy:TileTriggersProxy;
		private var lib:GLib;
		private var _isoScene:IsoTileWorld;
		
		public var pathFinder:PathFinder;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Additional getter to return the correct component type
		 */
		public function get component() : IsoTileWorld
		{
			return _isoScene;
		}

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function buildScene (tlist:Array /* of AbstractTile */) : void
		{
			trace("-- build scene @" + toString());
			stage.addChildAt(_isoScene, 0);
			
			if (datamapProxy.enableNoMouseEventInAlpha)
				_isoScene.enableNoMouseEventInAlpha();
			else
			 	_isoScene.disableNoMouseEventInAlpha();
			
/*			var cl:Class = lib.getClassFrom("uis/uis.swf", "UIMovieClip");
			var mc:MovieClip = new cl();
			stage.addChild(mc); */

			var fgFile:String = datamapProxy.foregroundFile;
			if (fgFile)
				_isoScene.foregroundLayer.addGfx(lib.getLoader(fgFile));

			var bgFile:String = datamapProxy.backgroundFile;
			if (bgFile)
				_isoScene.backgroundLayer.addGfx(lib.getLoader(bgFile));

				// calcul offset de centrage
			var ofs:Point = _isoScene.drawer.findPoint(new UPoint(0, Math.floor(datamapProxy.dimy * .5) , 0, datamapProxy.tilew, datamapProxy.tileh, datamapProxy.tiled));			
			ofs.x = Math.abs(ofs.x) - datamapProxy.tilew * .5;
			ofs.y = -(ofs.y);
			
			with (_isoScene.sceneLayer)
			{
				upos.xFactor = datamapProxy.tilew;
				upos.yFactor = datamapProxy.tileh;
				upos.zFactor = datamapProxy.tiled;
				xoffset = ofs.x;
				yoffset = ofs.y;
			}

			with (_isoScene.groundLayer)
			{
				upos.xFactor = datamapProxy.tilew;
				upos.yFactor = datamapProxy.tileh;
				upos.zFactor = datamapProxy.tiled;
				xoffset = ofs.x;
				yoffset = ofs.y;
			}

			with (_isoScene.debugLayer)
			{
				upos.xFactor = datamapProxy.tilew;
				upos.yFactor = datamapProxy.tileh;
				upos.zFactor = datamapProxy.tiled;
				xoffset = ofs.x;
				yoffset = ofs.y;
			}

			var t:AbstractTile;
			var n:int = tlist.length;
			while (--n > -1)
			{
				t = AbstractTile(tlist[n]);
//				t.mouseEnabled = false;
				
				// on test si le tile à un trigger associé
				if (triggersProxy.hasValidTrigger(t))
				{
					t.buttonMode = true;
				} else {
//					t.mouseEnabled = false;
				}
				
				_isoScene.sceneLayer.addTile(t);
				// on envoie un event tile ajouté à la scène
				sendEvent(new BaseEvent(EventList.ISOSCENE_TILE_ADDED, t));
			}
						
			// on ajoute les listeners pour les events souris sur les tiles
			_isoScene.backgroundLayer.mouseChildren = false;
			_isoScene.foregroundLayer.mouseChildren = false;
			_isoScene.foregroundLayer.mouseEnabled = false;

			/*_isoScene.addEventListener(MouseEvent.CLICK, sceneMouseHandler);	
			_isoScene.addEventListener(MouseEvent.MOUSE_OVER, sceneMouseHandler);
			_isoScene.addEventListener(MouseEvent.MOUSE_OUT, sceneMouseHandler);
			_isoScene.addEventListener(MouseEvent.MOUSE_DOWN, sceneMouseHandler);
			_isoScene.addEventListener(MouseEvent.MOUSE_UP, sceneMouseHandler);*/
			addListeners();
			
			unfreezeScene();
			
			sendEvent(new Event(PublicIsoworldEventList.ISOSCENE_BUILDED));
			sendPublicEvent(new Event(PublicIsoworldEventList.ISOSCENE_BUILDED));
		}
		
		public function addListeners():void
		{
			_isoScene.addEventListener(MouseEvent.CLICK, sceneMouseHandler);	
			_isoScene.addEventListener(MouseEvent.MOUSE_OVER, sceneMouseHandler);
			_isoScene.addEventListener(MouseEvent.MOUSE_OUT, sceneMouseHandler);
			_isoScene.addEventListener(MouseEvent.MOUSE_DOWN, sceneMouseHandler);
			_isoScene.addEventListener(MouseEvent.MOUSE_UP, sceneMouseHandler);			
		}
		
		public function removeListeners():void
		{
			_isoScene.removeEventListener(MouseEvent.CLICK, sceneMouseHandler);
			_isoScene.removeEventListener(MouseEvent.MOUSE_OVER, sceneMouseHandler);
			_isoScene.removeEventListener(MouseEvent.MOUSE_OUT, sceneMouseHandler);
			_isoScene.removeEventListener(MouseEvent.MOUSE_DOWN, sceneMouseHandler);
			_isoScene.removeEventListener(MouseEvent.MOUSE_UP, sceneMouseHandler);						
		}
		
		
		// -----------------------
		
		public function getTile (id:String) : AbstractTile
		{
			return AbstractTile.getTile(id);
		}
		
		public function getTileList () : Array
		{
			return AbstractTile.tileList;
		}
		
		// -----------------------
		
		/**
		 *	Efface la scène
		 */
		public function clearScene():void
		{			
			trace("clearScene() @" + toString());
			_isoScene.sceneLayer.removeAllTile();
			_isoScene.foregroundLayer.removeAllGfx();
			_isoScene.backgroundLayer.removeAllGfx();
			_isoScene.disableNoMouseEventInAlpha();
			stage.removeChild(_isoScene);
		}
		
		public function addAvatar (t:AbstractTile) : void
		{
//			t.mouseChildren = false;
//			t.mouseEnabled = false
			_isoScene.sceneLayer.addTile(t);
		}
		
		public function freezeScene():void
		{
//			trace("FREEZE_SCENE @" + toString());
			_isoScene.mouseEnabled = false;
			_isoScene.mouseChildren = false;
		}
		
		public function unfreezeScene():void
		{
//			trace("UNFREEZE_SCENE @" + toString());
			_isoScene.mouseEnabled = true;
			_isoScene.mouseChildren = true;
		}
		
		private var _moveMarker:AbstractTile;
		
		// TODO
		private function displayMoveMarker(pto:UPoint):void
		{
			if (_moveMarker != null)
				return;
				
			var classRef:Class = lib.getClassFrom("sprites/moveMarker.swf", "MoveMarker");
			var mc:MovieClip = new classRef();
			var tv:MCTileView = new MCTileView(mc);
			var p:UPoint = new UPoint(pto.xu, pto.yu, pto.zu, datamapProxy.tilew, datamapProxy.tileh, datamapProxy.tiled)
			_moveMarker = new AbstractTile("marker", p, tv);
//			_moveMarker.play();
			mc.addEventListener("moveMarkerComplete", moveMarkerCompleteHandler, false, 0, true);
			_isoScene.groundLayer.addTile(_moveMarker);
		}
		
		private function moveMarkerCompleteHandler(event:Event):void
		{
			event.currentTarget.removeEventListener("moveMarkerComplete", moveMarkerCompleteHandler);
			_isoScene.groundLayer.removeTile(_moveMarker);
			_moveMarker.stop();
			_moveMarker = null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	Handler évênements souris dans la scène
		 *	Si l'event concerne un tile et qu celui-ci est à un trigger associé, le
		 *	trigger est déclenché, sinon le perso est bougé j'usqu'au tile.
		 *	Si l'event concerne le fond de scéne, le perso est bougé quand l'event est
		 *	de type click
		 */
		private function sceneMouseHandler(event:MouseEvent):void
		{
			if (event.isDefaultPrevented()) return;
			
			// on recup le type d'évênement
			var evtype:String = event.type;
			// on test savoir si la cible est un tile	
			if (event.target is AbstractTile)
			{
				var tile:AbstractTile = AbstractTile(event.target);
//				var isAtt:Boolean = triggersProxy.isActiveTileTrigger(tile, evtype);
				
				
				
				// -- Roll over - out --
				
				if (event.type == MouseEvent.MOUSE_OUT)
					tile.filters = [];
				
				if (!tile.inGroup && !tile.group)
				{
					/*if (isAtt)*/
					if (triggersProxy.hasValidTrigger(tile))
					{
						tile.buttonMode = true; // ?
						
						// Effet halo roll over - out
						if (event.type == MouseEvent.MOUSE_OVER)
							tile.filters = [new GlowFilter(0x99FF00)];
						
					} else {
						tile.buttonMode = false;
					}
				} else {
					if (tile.inGroup)
						tile = AbstractTile(tile.inGroup.owner);
				}
								
				// -- lancement du trigger --
				var id:String = String(tile.ID);
				// on test savoir si le tile à un trigger associé
				if (triggersProxy.isTrigger(id, evtype))
				{
					// si oui on déclenche
					if (!triggersProxy.isActiveTileTrigger(tile, evtype))
					{
						triggersProxy.launchTriggerByRef(id, evtype, tile);			
						return;
					}
				} else {
					// si non, on bouge le perso jusqu'au tile , si cliqué
//					if (evtype == MouseEvent.CLICK)
//						sendEvent(new BaseEvent(EventList.MOVE_PLAYER_TO_TILE, tile));
				}
//				return;
//			} else {

			}
			// l'event ne concerne pas un tile, on bouge le perso si cliqué
			if (evtype == MouseEvent.CLICK)
			{
				// la scene est freezée
				if (!_isoScene.mouseChildren) return;

				var p:Point = _isoScene.sceneLayer.findGridPoint(new Point (component.stage.mouseX, component.stage.mouseY));
				var up:UPoint = new UPoint(p.x, p.y, 0);
trace(up.posToString() + " @" + toString());
				var mevent:BaseEvent = new BaseEvent(EventList.MOVE_PLAYER, up);
//				var mevent:BaseEvent = new BaseEvent(EventList.MOVE_PLAYER, new Point (stage.mouseX, stage.mouseY));
				sendEvent(mevent);
				/*if (!mevent.isDefaultPrevented())
					displayMoveMarker(up);*/
			}
		}
		
		/**
		 * Default Event handler
		 */
		override public function handleEvent(event:Event):void
		{
			switch (event.type)
			{
				case EventList.TILEFACTORY_TILELIST_PARSED :
				{
					buildScene(BaseEvent(event).content as Array);
					break;
				}
				case EventList.COLLISIONGRID_PARSED :
				{
					pathFinder = new PathFinder(datamapProxy.collisionGrid);
					break;
				}
				case EventList.CLEAR_MAP :
				{
					clearScene();
					break;
				}
				case EventList.MOVE_PLAYER :
				{
//					displayMoveMarker(UPoint(BaseEvent(event).content));
/*					_moveMarker.upos.matchPos(UPoint(BaseEvent(event).content));
					_isoScene.groundLayer.addTile(_moveMarker); */
					break;
				}
				case EventList.PLAYER_MOVE_COMPLETE :
				{
//					_isoScene.groundLayer.removeTile(_moveMarker);
					break;
				}
				case EventList.FREEZE_SCENE :
				{
					freezeScene();
					break;
				}
				case EventList.UNFREEZE_SCENE :
				{
					unfreezeScene();
					break;
				}
				default :
				{
					break;
				}
			}
		}
		
		override public function initialize():void
		{
			// on pointe la référence au DatamapProxy
			datamapProxy = DatamapProxy(facade.getProxy(DatamapProxy.NAME));
			// au TriggerProxy	
			triggersProxy = TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME));
			// à la librairie
			lib = LibProxy(facade.getProxy(LibProxy.NAME)).lib;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 */
		override protected function listInterest():Array /* of Constant */
		{
			return [
						EventList.TILEFACTORY_TILELIST_PARSED,
						EventList.COLLISIONGRID_PARSED,
						EventList.PLAYER_MOVE_COMPLETE,
//						EventList.CLEAR_MAP,
						EventList.FREEZE_SCENE,
						EventList.UNFREEZE_SCENE
					];
		}

	}
	
}

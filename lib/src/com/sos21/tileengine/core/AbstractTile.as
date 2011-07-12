package com.sos21.tileengine.core {
	
	import flash.utils.*;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.geom.Point;	

	import com.sos21.tileengine.core.ITile;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.IUDrawable;
	import com.sos21.tileengine.display.UAbstractDrawable;
	import com.sos21.tileengine.display.ITileLayer;
	import com.sos21.tileengine.display.ITileView;
	import com.sos21.tileengine.display.TileView;
	import com.sos21.tileengine.events.TileEvent;

	import caurina.transitions.Tweener;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AbstractTile extends UAbstractDrawable implements ITile {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function AbstractTile (id:String, p:UPoint = null, view:ITileView = null)
		{
			super(p);
			_ID = id;
			if (view) setView(view);
			mouseChildren = false;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private static var _tileList:Dictionary = new Dictionary(true);
		private var _ID:String;
		protected var _assets:Array = [];
		protected var _view:ITileView;
		protected var _rotation:int = 0;
		protected var _action:String;
		protected var _myPath:Array;
		protected var _myNode:UPoint;
		protected var _loop:int;
		protected var _speed:Number = 90;
		protected var _paused:Boolean;
		
		public var data:Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	Retourne la liste des tiles
		 */
		static public function get tileList () : Array
		{
			var a:Array = [];
			for each (var t:AbstractTile in _tileList)
				a.push(t);

			return a;
		}
		
		public function getTileList () : Array
		{ return AbstractTile.tileList; }
		
		public function get ID():String
		{
			return _ID;
		}
		
		public function get assets():Array /* of DisplayObject */
		{
			return _assets;
		}
		
		public function set speed (val:Number) : void
		{ _speed = val; }
		
		public function get speed () : Number
		{ return _speed; }
		
		/*override public function get name () : String
		{
			return super.name;
		}*/
		
		/*override public function set mouseEnabled(val:Boolean):void {
			if (super.mouseEnabled != val)
			
			if (_group) {
				var n:int = _inGroup.length;
				while(--n > -1)
					_inGroup.getChild(n).mouseEnabled = val;
			}
				
			
			if (_inGroup)
			{
				_inGroup.owner.
			}
		}*/
		
		/**
		 * Rotation
		 */
		override public function get rotation () : Number
		{ return _rotation; }

		override public function set rotation (val:Number) : void
		{
			_rotation = val;
			_view.draw(val);
		}
		
		/**
		 * Retourne le tableau des angles pour l'animation
		 * courante
		 */
		public function get angles () : Array
		{ return _view.angles; }
		
		/**
		 * Retourne l'index image de l'animation courante
		 */
		public function get currentFrame () : int
		{ return _view.frame; }
		
		/**
		 * Retourne l'animation courante
		 */
		public function get animation () : Object
		{ return _view.label; }

		/**
		 * Retourne la liste des étiquettes animations
		 */
		public function get animations () : Array /* of String */
		{ return _view.animations; }

		/**
		 * Retourne le nombre de frame pour l'animation
		 * en cours
		 */
		public function get currentFrameCount () : int
		{ return _view.totalFrames; }
		
		/**
		 *	Retourne les coordonées relatives au stage 
		 */
		public function get stagePosition () : Point
		{ return contener.localToGlobal(new Point(x, y)); }
		
		public function getView ():ITileView
		{ return _view; }
		
		public function setView (v:ITileView) : void
		{
			if (_view) _view.release();

			_view = v;
			_view.setModel(this);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public static function getTile (id:String) : AbstractTile
		{
			return _tileList[id];
		}
		
		public function release ():void
		{
			stop();
			delete _tileList[_ID];
		}
				
		public function addAsset (dO:DisplayObject) : void
		{
			_view.addAsset(dO)
		}
		
		/**
		 * Flag est en mouvement
		 */
		public function get isMoving () : Boolean
		{ return _myNode != null && !_paused; }
		
		/**
		 * Flasg est en pause
		 */
		public function get isPaused () : Boolean
		{ return _paused && _myNode != null; }
		
		/**
		 *	Déplace le tile suivant un chemin
		 */
		public function pathTo (path:Array /* of UPoint */) : void
		{
			// TODO patch gotoAndPlay
			this.removeEventListener(Event.ENTER_FRAME, redrawView, false);
			// on mets à -1 au cas ou le tile était en play
			_loop = -1;
			// on test si le tile est deja en mouvement
			if (isMoving)
			{
				_myPath = path;
				play(-1);
			} else {
				gotoAndPlay("walk", -1);
				_paused = false;
				_myPath = path;
				_myNode = _myPath[0];
				nextPathStep();
			}
		}
				
		public function nextPathStep (e:Event = null) : void
		{
			if (_myPath.length > 1)
			{
				var nNode:UPoint = _myPath.shift();
				_myNode = nNode;
				var ptu:UPoint = _myPath[0];
				
				rotation = computeAngle(ptu);
				
				_upos.updatePos(ptu.xu, ptu.yu, ptu.zu);
				
				var pt:Point = drawer.findPoint(_upos);
				var t:Number = Point.distance(new Point(x, y), pt) / _speed;
				
				Tweener.addTween(this, {time:t, x:pt.x, y:pt.y, onUpdate:updateHanlder, onComplete:nextPathStep, transition:"linear"});
			}
			else
			{
				_myPath = null;
				_myNode = null;
				gotoAndStop("stand");
				dispatchEvent(new TileEvent(TileEvent.MOVE_COMPLETE));
			}
			
		}
		
		
		/**
		 *	Joue l'action correspondante au label
		 *	@param	label	 le label (étiquette) de l'action
		 *	@param	loop	 nombre de fois que l'action est répétée, -1 = à l'infini
		 */
		public function gotoAndPlay (label:String, loop:int = -1) : void
		{
			_action = label;
			_view.draw(label);
			play(loop);
		}
		
		/**
		 *	Affiche la première image d'une animation
		 *	@param	label	 étiquette de l'action
		 */
		public function gotoAndStop (label:String) : void
		{
			// TODO patch gotoAndPlay
			stop();
			_action = label;
			_view.draw(label);
		}
		
		/** 
		 *	@param frame int
		 */
		public function setFrame (frame:int) : void
		{
			_view.frame = frame;
		}
		
		/**
		 *	Joue l'animation en cours
		 *	@param	loop	 nombre de fois que l'action est répétée, -1 = à l'infini
		 */
		public function play (loop:int = -1) : void
		{
			_loop = loop;
			this.addEventListener(Event.ENTER_FRAME, redrawView, false, 0, true);
		}
		
		/**
		 *	Arrête l'animation en cours
		 * @param	smooth	 arrêter en douceur, si objet en
		 * déplacement, il s'arretera quand centré sur la cellule modue en cours
		 */
		public function stop (smooth:Boolean = false) : void
		{
			// Experimental
			if (isMoving)
				dispatchEvent(new TileEvent(TileEvent.MOVE_CANCELED));
			
			if (_myPath && smooth)
			{
				_myPath.splice(0);				
			}
			else {
				this.removeEventListener(Event.ENTER_FRAME, redrawView, false);
				Tweener.removeTweens(this);
				_myPath = null;
				_myNode = null;				
			}
		}
		
		/**
		 *	Passe l'animation courante en pause
		 */
		public function pause () : void
		{
			if (Tweener.isTweening(this))
			{
				Tweener.pauseTweens(this);
				_paused = true;
			}
		}
		
		/**
		 *	Reprend l'animation courante
		 */
		public function resume () : void
		{
			if (_paused)
			{
				_view.draw("walk");
				Tweener.resumeTweens(this);
				_paused = false;
			}
		}

		override public function zsort (o:IUDrawable) : void
		{ }
		
		/**
		 * @inheritDoc
		 */
		override public function toString () : String
		{ return getQualifiedClassName(this) + " ID:" + ID; }
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Handler reception des events mise à jour de la vue
		 *	// TODO implémenter temps réel
		 */
		protected function redrawView (event:Event = null) : void
		{
			_view.nextFrame();
			
			if (_view.frame == _view.totalFrames)
			{
				if (--_loop == 0) {
					stop();
					// ? est ce bien raisonnable
					dispatchEvent(new TileEvent(TileEvent.PLAY_COMPLETE));
				}
			}
		}
		
//		private var playComplete:Event = new TileEvent(Event.COMPLETE);
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Maj vue et dispatch entrée sortie de célulle
		 *	@param event Event
		 */
		public function updateHanlder (event:Event = null) : void
		{
			var p:Point = drawer.computeGridPoint(new Point(x, y), upos);
			upos.updatePos(p.x, p.y, 0);
//			contener.zsort(this);

			//  test changement de céllule
			var p2:Point = drawer.findGridPoint(new Point (x, y + 5), upos);
			var up:UPoint = new UPoint(p2.x, p2.y, 0);
			
			// on test si entrée dans une nouvelle céllule et si cette
			// nouvelle céllule est la prochaine ciblée pour le déplacement
			if (!up.isMatchPos(_myNode) && up.isMatchPos(_myPath[0]))
			{				
				dispatchEvent(new TileEvent(TileEvent.LEAVE_CELL, _myNode));
				dispatchEvent(new TileEvent(TileEvent.ENTER_CELL, _myNode = up));
			}
		}
		
		/**
		 * Internal
		 * Utilisé pour calculer l'angle à prendre au changement
		 * de cellule
		 *	@param p UPoint
		 *	@return int
		 */
		public function computeAngle (p:UPoint) : int
		{
		 	var deltaX:int = p.xu - _upos.xu;
			var deltaY:int = p.yu - _upos.yu;
			var rot:int = Math.atan2(deltaY ,  deltaX) * 180 / Math.PI;
			
			return rot < 0 ? rot + 360 : rot;
		}

		/**
		 * Internal
		 *	@param id String
		 */
		public function _setID (id:String) : void
		{
			_ID = id;
			_tileList[id] = this;
		}
		
	}
	
}

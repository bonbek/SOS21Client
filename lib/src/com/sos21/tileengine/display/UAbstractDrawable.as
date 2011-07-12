package com.sos21.tileengine.display {	
	
	import flash.utils.*;	
	import flash.geom.Point;
	import flash.display.Sprite;
	import com.sos21.debug.log;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.IUDrawable;
	import com.sos21.tileengine.core.IUDrawer;
	import com.sos21.tileengine.events.TileEvent;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0<em></em>
	 *
	 *	@author toffer
	 *	@since  30.11.2007
	 */
	public class UAbstractDrawable extends Sprite implements IUDrawable  {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function UAbstractDrawable(up:UPoint = null)
		{
			up == null ? upos = new UPoint() : upos = up;			
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _contener:UAbstractDrawable;
		protected var _drawer:IUDrawer;
		protected var _drawableChilds:Array = [];
		protected var _group:UGroup;
		protected var _inGroup:UGroup;
		
		protected var _upos:UPoint;
		private var _zdepth:Number = 0;
		private var _rZdepth:uint = 0;

		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------	
		
		public function get children () : Array
		{ return _drawableChilds; }
		
		public function get contener():UAbstractDrawable
		{
//			trace( this + " contener :" + _contener );
			return _contener;
		}
		public function set contener(val:UAbstractDrawable):void
		{
//			trace( this + ".set contener: " + o );
			_contener = val;
		}
		
		public function get drawer():IUDrawer
		{
			var dr:IUDrawer = _drawer;
			if (dr == null)
			{
				if (contener != null)
					dr = contener.drawer;
			}
			
			if (dr != null)
				drawer = dr;

			return dr;
		}
		
		public function set drawer(val:IUDrawer):void
		{
			_drawer = val;
		}
		
//		public function get xoffset() : Number { return _xoffset }
		public function set xoffset(val:Number):void
		{
			upos.xoffset = val;
			if (drawer != null)
				move(drawer.findPoint(upos));
		}

//		public function get yoffset() : Number { return _yoffset }
		public function set yoffset(val:Number):void
		{
			upos.yoffset = val;
			if (drawer != null)
				move(drawer.findPoint(upos));
		}
//		public function get zoffset() : Number { return _zoffset }
		public function set zoffset(val:Number):void
		{
			upos.zoffset = val
			if (drawer != null)
				move(drawer.findPoint(upos));
		}
		
		public function get upos():UPoint
		{
			return _upos;
		}
		
		public function set upos(val:UPoint):void
		{
			_upos = val;
		}
		
		public function get zdepth():Number
		{
//			return drawer.findDepth(upos);
			return _zdepth;
		}
		
		public function set zdepth(val:Number):void
		{
			_zdepth = val;
		}
		
		public function get rZdepth():uint
		{
			return _rZdepth;
		}
		
		public function set rZdepth(val:uint):void
		{
			_rZdepth = val;
		}
		
		/**
		 *	@inheritDoc
		 *	Dispatch d'un event move
		 */
		override public function set x(val:Number):void
		{
			super.x = val;
			dispatchEvent(new TileEvent(TileEvent.MOVE));
		}
		
		/**
		 *	@inheritDoc
		 *	Dispatch d'un event move
		 */
		override public function set y(val:Number):void
		{
			super.y = val;
			dispatchEvent(new TileEvent(TileEvent.MOVE));
		}
		
		public function get group():UGroup
		{
			if (_inGroup) {
				return _inGroup.owner == this ? _inGroup : null;
			}
			
			return null;
		}
		
		public function get inGroup():UGroup
		{
			return _inGroup;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@param t Object
		 */
		public function groupWith(t:Object):void
		{
			var gr:UGroup;
			if (t is UAbstractDrawable)
			{
				if (!t.group) {
					t.createGroup();
				}					
				gr =  t.inGroup;
			} else {
				gr = t as UGroup;
			}
			gr.push(this);
			_inGroup = gr;
		}
		
		public function unGroup():void
		{
			
		}
		
		public function createGroup():void
		{
//			_group = new UGroup(this);
			_inGroup = new UGroup(this);
		}
		
		/**
		 *	Déplace l'objet
		 */
		public function move(p:Point):void
		{
			x = p.x;
			y = p.y;
		}
		
		/**
		 *	Déplace l'objet suivant des cordonnées
		 *	grille
		 */
		public function umove (nup:UPoint, grouped:Boolean = true) : void
		{			
			if (grouped)
			{
				if (_inGroup)
				{
					if (_inGroup.owner == this)
					{
						var t:Object;
						var n:int = _inGroup.length;
						while (--n > -1)
						{
							t = _inGroup.getChild(n);
							tup = nup.clone();
							tup.substract(_upos);
							t.upos.add(tup);
							t.umove(t.upos, false);
						}
					} else {
						nup.substract(_upos);
						var tup:UPoint = _inGroup.owner.upos.clone();
						tup.add(nup);
						_inGroup.owner.umove(tup);
					}
					return;
				}
			}
						
			upos.matchPos(nup);
			var p:Point = drawer.findPoint(upos);
			x = p.x;
			y = p.y;
			contener.zsort(this);
		}
		
		/**
		 *	Retourne les coordonées x y converties en
		 *	coordonées grille entières
		 */
		public function findGridPoint(p:Point):Point
		{
//			debug.trace("p> ", p);
			var pl:Point = globalToLocal(p);
//			debug.trace("p r> ", pl);
			var pr:Point = drawer.findGridPoint(pl, upos);
			return pr;
		}
		
		/**
		 *	Retourne les coordonées x y converties en
		 *	coordonées grille
		 */
		public function findFloatGridPoint(p:Point):Point
		{
//			debug.trace("pf> ", p);
			var pl:Point = globalToLocal(p);
//			debug.trace("pf r> ", pl);
			var pr:Point = drawer.findFloatGridPoint(pl, upos);
			return pr;
		}
		
		public function computeZdepth () : void
		{
			_zdepth = drawer.findDepth(upos);
		}
		
		public function zsort (o:IUDrawable) : void
		{
			o.computeZdepth();
			_drawableChilds.sortOn("zdepth", Array.NUMERIC);
			var dO:UAbstractDrawable = UAbstractDrawable(o);
			addChildAt(dO, _drawableChilds.indexOf(dO));
		}
		
			// TODO implémenter méthode
		public function remove() : void
		{
			trace("!! implementer méthode @" + toString());
		}
		
		override public function toString():String
		{
			return getQualifiedClassName(this) + "name: " + name;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Mémorise un enfant de cette instance
		 *	(utilisé pour le z-sorting)
		 */
		protected function registerChild(o:IUDrawable):Boolean
		{
			_drawableChilds.push(o);
			return true;
		}
		
		/**
		 *	@private
		 */
		protected function unregisterChild(o:IUDrawable):Boolean
		{
			var ind:uint = _drawableChilds.indexOf(o);
			if (ind == -1 )
				return false;
			
			_drawableChilds.splice(ind, 1);
			return true;
		}
		
	}
	
}

internal class UGroup {
	
	
	//---------------------------------------
	// CONSTRUCTOR
	//---------------------------------------
	
	function UGroup(owner:Object)
	{
		_a = [];
		_owner = owner;
		_a.push(_owner);
	}
	
	//---------------------------------------
	// PRIVATE & PROTECTED INSTANCE VARIABLES
	//---------------------------------------
	
	private var _owner:Object;
	private var _a:Array;
	
	//---------------------------------------
	// GETTER / SETTERS
	//---------------------------------------
	
	public function get length():int {
		return _a.length;
	}
	
	public function get owner():Object {
		return _owner;
	}
	
	public function getChild(ind:int):* {
		return _a[ind];
	}
	
	public function push(val:*):void {
		_a.push(val);
	}
	
}


package com.sos21.tileengine.display {
	
	import flash.utils.*
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.filters.GlowFilter;
	
	import com.sos21.tileengine.events.TileEvent;
	import com.sos21.tileengine.display.ITileLayer;
	import com.sos21.tileengine.core.ITile;
	import com.sos21.tileengine.display.ITileView;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.Layer;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  30.11.2007
	 */
	public class TileLayer extends Layer implements ITileLayer {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TileLayer(sname:String, nzindex:int = void)
		{
			super(sname, nzindex);
			hitTestAlphaArea = 10;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _htRect:Rectangle;
		private var _htRectOfs:int;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Définit le rectangle de test souris dans
		 * les zones transparentes
		 */
		public function set hitTestAlphaArea (val:int) : void
		{
			if (!_htRect)
			{
				_htRect = new Rectangle(0, 0, val, val);
			}
			else
			{
				_htRect.width = val;
				_htRect.height = val;
			}
			
			_htRectOfs = val / 2;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getTileUnderMouse () : AbstractTile
		{
			var mx:int = mouseX;
			var my:int = mouseY;
			var n:int = numChildren;
			var dob:AbstractTile;

			while (--n > -1)
			{	
				dob = AbstractTile(getChildAt(n));
				if (!dob.mouseEnabled || !dob.visible) continue;
				if (hitTestAlphaMouse(dob))
					break;
			}
			
			return n > -1 ? dob : null;
		}
		
		/**
		 *	Ajoute un tile à ce layer
		 *	@param	t	 le tile à ajouter
		 */
		public function addTile(t:AbstractTile):void
		{			
			t.contener = this;
			registerChild(t);
			t._setID(t.ID);
			t.move(t.drawer.findPoint(t.upos));
			zsort(t);
			t.dispatchEvent(new TileEvent(TileEvent.ENTER_CELL, t.upos));
		}
		
		
		/**
		 *	Supprime un tile de ce Layer
		 */
		public function removeTile(t:AbstractTile):void
		{
			if (unregisterChild(t))
			{
				t.release();
				removeChild(t);
			} else {
				trace("can't remove Tile: " + t.toString() + " @" + toString());
			}
		}
		
		/**
		 *	Supprime tout les tiles contenus dans ce layer
		 */
		public function removeAllTile():void //TODO revoir
		{
			var n:int = _drawableChilds.length;
			while (--n > -1)
			{
				removeTile(AbstractTile(_drawableChilds[n]));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
 				
		/**
		 *	Retourne la liste des DisplayObject en dessous et en intersection
		 * d'avec le DisplayObject passé en param 
		 *	@param otile AbstractTile
		 *	@return Array
		 */
		private function getObjectsUnder(dob:DisplayObject):Array
		{
			var tlist:Array = [];
			var tdob:DisplayObject;
			var ind:int = getChildIndex(dob);
			while (--ind > -1)
			{
				tdob = getChildAt(ind);
				if (tdob is InteractiveObject == false) continue;
				
				if (tdob.hitTestObject(dob)) tlist.push(tdob);
			}
							
			return tlist;
		}

		/**
		 *	Test si une zone rectangulaire coordonnées souris se trouve sur une
		 * zone opaque dans le DisplayObject passé en param
		 *	@param dob DisplayObject
		 *	@return Boolean
		 */
		private function hitTestAlphaMouse (dob:InteractiveObject) : Boolean
		{
			// patch quand objet vide dans le layer (le loader n'à pas fini de charger)
			if (!dob.width && !dob.height) return false;
			
			var bd:Object = dob.getBounds(dob);
			var bleft:int = -bd.left;
			var btop:int = -bd.top;
			var bmpdata:BitmapData = new BitmapData(bd.width, bd.height, true, 0);
			var mtx:Matrix = new Matrix();
			mtx.translate(bleft, btop);
			try {
				bmpdata.draw(dob, mtx, null, null, null, true);
			} catch (e:Error) {}
			
			// test sur valeur alpha
//			var mpx:int = dob.mouseX + (bleft);
//			var mpy:int = dob.mouseY + (btop);			
//			var alphaVal:uint = bmpdata.getPixel32(mpx, mpy) >> 24 & 0xFF;
//			bmpdata.dispose();
//			return alphaVal > 200;
			
			_htRect.x = dob.parent.mouseX + bleft - _htRectOfs;
			_htRect.y = dob.parent.mouseY + btop - _htRectOfs;
			var at:Boolean = bmpdata.hitTest(new Point(dob.x, dob.y), 100, _htRect);
			bmpdata.dispose();
			
			return at;
		}

	}
	
}

/* AS3
	Copyright 2007 __MyCompanyName__.
*/
package com.sos21.tileengine.isofake {

	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.*;
	
	import com.sos21.tileengine.core.IUDrawer;
	import com.sos21.tileengine.core.IUDrawable;	
	import com.sos21.tileengine.structures.IUPositionable;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.display.UAbstractDrawable;
	import com.sos21.tileengine.display.Layer;

	import gs.TweenLite;
//	import mx.effects.easing.Linear;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  03.12.2007
	 */
	public class IsoDrawer implements IUDrawer {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		private var depth:uint;
		private var visited:Dictionary = new Dictionary();
		private var layer:Layer;
		private var dependency:Dictionary;

		/**
		 * Merci As3Isolib... vivement qu'on switch !!
		 *	@param layer UAbstractDrawable
		 */
		public function render (layer:Layer) : void
		{
			var rTime:int = getTimer();

			this.layer = layer;
			var startTime:uint = getTimer();

			dependency = new Dictionary();

			var children:Array = layer.children;

			var n:uint = children.length;

			var oA:UAbstractDrawable;
			var oB:UAbstractDrawable;
			
			var oARight:Number;
			var oAFront:Number;			
			var oATop:Number;
			var ofsR:Number;
			var ofsF:Number;
			
			/*var wp:Number;
			var dp:Number;
			var hp:Number;*/
			var ratio:Number;
			
			for (var i:uint = 0; i < n; ++i)
			{
				var behind:Array = [];
				
				oA = children[i];
				if (!layer.contains(oA)) layer.addChild(oA);
				
				ratio = 60 / oA.upos.xFactor;
				//trace("ratio", ratio);
				oARight = oA.upos.xu + (oA.upos.width * ratio);
				oAFront = oA.upos.yu + (oA.upos.depth * ratio);
				oATop = oA.upos.zu + (oA.upos.height * ratio);

				/*oARight = oA.upos.xu + oA.upos.width;
				oAFront = oA.upos.yu + oA.upos.depth;*/
				
				for (var j:uint = 0; j < n; ++j)
				{
					oB = children[j];
					
					/*ofsR = 0;
					ofsF = 0;*/
					ofsR = (Math.min(oB.upos.width, oA.upos.width) * ratio) / 3;
					ofsF = (Math.min(oB.upos.depth, oA.upos.depth) * ratio) / 3;
					
					if (	(oB.upos.xu < oARight - ofsR) && (oB.upos.yu < oAFront - ofsF) &&							
							((oB.upos.xu + (oB.upos.width * ratio) < oARight) ||
							(oB.upos.yu +  (oB.upos.depth * ratio) < oAFront) ||
							(oB.upos.zu +  (oB.upos.height * ratio) < oATop)) &&
							(oB.upos.zu < oA.upos.zu + (oA.upos.height * ratio)) && (i !== j))
					{
							behind.push(oB);
					}
					
					/*ofsR = Math.min(oB.upos.width, oA.upos.width) / 3;
					ofsF = Math.min(oB.upos.depth, oA.upos.depth) / 3;
					
					if (	(oB.upos.xu < oARight - ofsR) && (oB.upos.yu < oAFront - ofsF) &&							
							((oB.upos.xu + oB.upos.width < oARight) || (oB.upos.yu +  oB.upos.depth < oAFront)) &&
							(oB.upos.zu < oA.upos.zu + oA.upos.height) && (i !== j))
					{
							behind.push(oB);
					}*/
				}

				dependency[oA] = behind;
			}


			//trace("dependency scan time", getTimer() - startTime, "ms");

			// TODO - set the invalidated children first, then do a rescan to make sure everything else is where it needs to be, too?  probably need to order the invalidated children sets from low to high index

			// Set the childrens' depth, using dependency ordering
			depth = 0;
			for each (var obj:UAbstractDrawable in children)
			{
				if (true !== visited[obj]) place(obj);			
			}

			// Clear out temporary dictionary so we're not retaining memory between calls
			visited = new Dictionary();
//			trace("render time", getTimer() - rTime, "ms (manual sort)");
		}



		private function place (obj:UAbstractDrawable) : void
		{
			visited[obj] = true;

			for each(var inner:UAbstractDrawable in dependency[obj])
			{
				if (true !== visited[inner]) place(inner);
			}

			if (depth != layer.getChildIndex(obj))
			{
				layer.setChildIndex(obj, depth);
			}

			++depth;
		};
		
		
		public function findPoint(o:IUPositionable):Point
		{
			var x:Number = o.xFactor * (o.xu - o.yu) * .5 + o.xoffset;
			var y:Number = o.yFactor * (o.yu + o.xu) * .5 + o.yoffset - (o.zu * o.zFactor);
			
			return new Point(x, y);
		}
		
		public function findGridPoint(p:Point, o:IUPositionable):Point
		{
			/*debug.trace("--- find ----");
			debug.trace(p);*/
			
			var y1:Number = (2 * p.y - p.x) / 2;
			var x1:Number = p.x + y1;
			y1 = int(y1 / o.yFactor);
			x1 = int(x1 / o.xFactor * 2);

			
			return new Point(x1, y1);
		}
		
		public function findFloatGridPoint(p:Point, o:IUPositionable):Point
		{
			/*debug.trace("--- findfloat ----");
			debug.trace(p);*/
			
			var y1:Number = (2 * p.y - p.x) / 2;
			var x1:Number = p.x + y1;
			y1 = y1 / o.yFactor;
			x1 = x1 / o.xFactor * 2;
			/*debug.trace(x1, " : ", y1);						
			debug.trace("-------------");*/
			return new Point(x1, y1);
		}
		
		public function computeGridPoint(p:Point, o:IUPositionable):Point
		{			
			var y1:Number = (2 * p.y - p.x) / 2;
			var x1:Number = p.x + y1;
			y1 = y1 / o.yFactor;
			x1 = x1 / o.xFactor * 2;
						
			return new Point(x1, y1);
		}
		
		
		public function findDepth(o:Object):Number
		{
			// ORIGINAL
//			var sum:int = o.xu + o.yu;
//			var zdepth:uint =  sum * ( sum + 1 ) / 2 + o.xu * 10;
//			zdepth += o.zindex + o.zu;

//			var op:UPoint = UPoint(o);
			var x:Number = o.xu;
			var y:Number = o.yu;
			var z:Number = o.zu;
			
			
			var w:Number = 1;
			var h:Number = 1;
			var d:Number = 1;
			
			try
			{
				w = o.width;
				h = o.height;
				d = o.depth;
			} catch (e:Error) { }

			var zdepth:Number;
			var sum:Number;

			/*sum = x + ((w + d) / 2) + y;
			zdepth =  int((sum * (sum + 1) / 2 + x + z + d) + (z * (w + d)));
			zdepth += o.zindex;*/

			sum = x + ((w + d) / 2) + y;
			zdepth =  int((sum * (sum + 1) / 2 + x + z + d) + (z * (w + d)));
			zdepth += o.zindex;

			return zdepth;
		}
		
		/*public function findDepth(o:IUPositionable):Number
		{
			// ORIGINAL
//			var sum:int = o.xu + o.yu;
//			var zdepth:uint =  sum * ( sum + 1 ) / 2 + o.xu * 10;
//			zdepth += o.zindex + o.zu;
			
//			var op:UPoint = UPoint(o);
			var x:Number = op.xu;
			var y:Number = op.yu;
			var z:Number = op.zu;

			var w:Number = op.width;
			var h:Number = op.height;
			var d:Number = op.depth;
			
			var zdepth:Number;
			var sum:Number;

			sum = x + ((w + d) / 2) + y;
			zdepth =  int((sum * (sum + 1) / 2 + x + z + d) + (z * (w + d)));
			zdepth += o.zindex;

			return zdepth;
		}*/
		
		public function followPath(target:UAbstractDrawable, path:Array /* of UPoint */, params:Object = null):void
		{
			var upos:IUPositionable = target.upos;
			if (path.length > 1) {
				path.shift();
				var ptu:IUPositionable = path[0];
				
				if (ptu.xu != upos.xu && ptu.xu > upos.xu || ptu.xu == upos.xu && ptu.yu > upos.yu)
					upos.updatePos(ptu.xu, ptu.yu, ptu.zu);				
				
				target.contener.zsort(target);
				upos.updatePos(ptu.xu, ptu.yu, ptu.zu);
				
				var pt:Point = findPoint(upos);
				var t:Number = Point.distance(new Point(target.x, target.y), pt) / params.speed;
					// Test TweenLite
				TweenLite.to(target, t, {x:pt.x, y:pt.y, ease:params.ease, onComplete:followPath, onCompleteParams:[target,path,params], onUpdate:params.onUpdate});
			} else {
//				target.dispatchEvent(new TileEvent(TileEvent.ON_MOVE_COMPLETE));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

package com.sos21.tileengine.display {	
	
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.*;
	import com.sos21.tileengine.display.ITileView;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class AnimatedTileView implements ITileView {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AnimatedTileView (asset:DisplayObject = null, sheet:Object = null)
		{			
			_asset = Bitmap(asset);
			_sheet = sheet;
			// on à une feuille d'anim
			if (_sheet)
			{
				// offset placement
				_ofsX = _sheet.shift();
				_ofsY = _sheet.shift();
				// taille slices
				_sliceWidth = _sheet.shift();
				_sliceHeight = _sheet.shift();
				// on pointe le premier label de la liste
				_label = _sheet[0];
				/*_incrAngle = 360 / (sheet.width / _sliceWidth);
				_frameCount = sheet.height / _sliceHeight;*/
				_slice = new Rectangle(0, 0, _sliceWidth, _sliceHeight);
			}
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _asset:Bitmap;
		protected var _model:Sprite;
		protected var _label:Object;
		protected var _frame:int = 1;
		
		protected var _ofsX:int;
		protected var _ofsY:int;
		protected var _sliceWidth:int;
		protected var _sliceHeight:int;
		protected var _incrAngle:int;
		protected var _frameCount:int;
		protected var _slice:Rectangle;
		protected var _sheet:Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		public function set frame (val:int) : void
		{
			_frame = val;
//			trace(this, "set frame", val);
			render();
		}
		
		/**
		 *	@inheritDoc
		 */
		public function get frame () : int
		{
			return _frame;
		}
		
		public function get label () : Object
		{
			return _label;
		}
		
		/**
		 *	@inheritDoc
		 */
		public function get totalFrames () : int
		{
			return _frameCount;
		}
		
		public function get angles () : Array
		{ trace("warning", this, "TODO"); return null; }
		
		public function get animations () : Array
		{ return _sheet as Array; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------			
		
		public function getModel () : DisplayObjectContainer
		{
			return _model;
		}
		
		public function setModel (m:DisplayObjectContainer) : void
		{
			_model = Sprite(m);
			draw(_label);
//			addAsset(_asset);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function draw (label:Object) : void
		{
			if (label is String)
			{
				var ind:int = _sheet.indexOf(label);
				// pas de description pour ce label
				if (ind == -1) return;

				_label = label;
	//			_incrAngle = 360 / (sheet.width / _sliceWidth);
				_incrAngle = 360 / _sheet[ind + 2];
	//			_frameCount = sheet.height / _sliceHeight;
				_frameCount = _sheet[ind + 1];			
			}
			render();
		}
		
		/**
		 *	@inheritDoc
		 */
		public function nextFrame () : void
		{
			
		}
		
		/**
		 *	@inheritDoc
		 */		
		public function prevFrame () : void
		{
			
		}

		/**
		 *	@inheritDoc
		 */
		public function addAsset (asset:DisplayObject) : void
		{
			// _model.addChild(asset);
		}
		

		public function getSlice (angle:int, nframe:int) : Rectangle
		{
			// on test si l'angle est valide pour cette feuille, si non on retrouve l'angle valide le plus proche
			if (angle % _incrAngle) angle = angle > _incrAngle ? int(angle / _incrAngle) * _incrAngle : 0;
			_slice.x = angle / _incrAngle * _sliceWidth;
			// on test si la frame est valide
			if (nframe > _frameCount) nframe = _frameCount;
			_slice.y = --nframe * _sliceHeight;

			return _slice;
//			return new Rectangle(x, y, _sliceWidth, _sliceHeight);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function release () : void
		{
			_model.graphics.clear();
			_model = null;
			_sheet = null;
			_asset = null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function render () : void
		{
//			trace(this, "render");
//			var sList:Array = getSheets(_label);
//			var sheet:BitmapSheet;
//			var n:int = sList.length;
			_model.graphics.clear();
			var m:Matrix = new Matrix();
//			for (var i:int = 0; i < n; i++)
//			{
				// TODO faire test de perfs
//				sheet = sList[i];
				var btpSource:BitmapData = _asset.bitmapData;	// le bitamp source
				var r:Object = getSlice(_model.rotation, _frame);
//				trace(r);
//				var oX:int = -sheet.offsetX;
//				var oY:int = -sheet.offsetY;
//				var m:Matrix = new Matrix();
//				m.identity();
				m.translate(-r.x + _ofsX,-r.y + _ofsY);
				
				/*_model.graphics.beginBitmapFill( btpSource, m, true );
				_model.graphics.moveTo(_ofsX, _ofsY)
				_model.graphics.lineTo(r.width + _ofsX, _ofsY);
				_model.graphics.lineTo(r.width + _ofsX, r.height + _ofsY);
				_model.graphics.lineTo(_ofsX, r.height + _ofsY);*/
				
				_model.graphics.beginBitmapFill(btpSource, m, true);
        		_model.graphics.drawRect(_ofsX, _ofsY, r.width, r.height);
          	_model.graphics.endFill();

			//}
		}
		
	}
	
}

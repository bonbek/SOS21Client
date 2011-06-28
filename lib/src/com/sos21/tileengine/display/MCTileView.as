package com.sos21.tileengine.display {

	import flash.utils.Dictionary;
	import flash.display.FrameLabel;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import com.bourre.structures.Range;		
	import com.sos21.tileengine.display.TileView;
	import com.sos21.tileengine.display.ITileView;
	
	/**
	 *	Vue type MovieClip pour un tile
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MCTileView extends TileView {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MCTileView (asset:MovieClip)
		{
			super(asset);
			this.asset = MovieClip(_asset);
			// on chope le premier label
			_label = asset.currentLabel.replace(/\d+/, "");
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var asset:MovieClip;
		protected var _currentRange:Object = new Range(0, 0);
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override public function set frame (val:int) : void
		{
			var of:int = val + _currentRange.min;
			if (_currentRange.surround(val + _currentRange.min))
			{
				asset.gotoAndStop(of);
				_frame = val;
			} else {
				asset.gotoAndStop(_currentRange.min);
				_frame = 1;
			}
		}
		
		override public function get angles () : Array
		{
			var labels:Array = asset.currentLabels;
			var angles:Array = [];
			var n:int = _label.length;
			var lb:String;
			for each (var fl:FrameLabel in labels)
			{
				lb = fl.name;
				if (lb.substring(0, n) == _label) angles.push(int(lb.substring(n)));
			}

			return angles.sort(Array.NUMERIC);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get animations () : Array
		{ 
			var labels:Array = asset.currentLabels;
			var anims:Array = [];
			var lb:String;
			for each (var fl:FrameLabel in labels)
			{
				lb = fl.name.replace(/\d+/, "");		
				if (anims.indexOf(lb) == -1) anims.push(lb);
			}

			return anims;
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function get totalFrames () : int
		{ return _currentRange is Range ? _currentRange.size() + 1 : 1; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override public function addAsset (asset:DisplayObject) : void
		{
			// on test si le gxf est un MovieClip
			if (!asset is MovieClip) return;
			
			if (_model.contains(this.asset))
				_model.removeChild(this.asset);
			
			this.asset = MovieClip(asset);
			this.asset.stop();
			_currentRange.min = 1;
			_currentRange.max = this.asset.totalFrames;
			super.addAsset(this.asset);
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function draw (label:Object) : void
		{
			if (label is String)
				super.draw(label);
				
			computeFramesRange();
			this.frame = _frame;
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function nextFrame () : void
		{
			var acf:int = asset.currentFrame;
			if (acf < _currentRange.max)
			{
				asset.nextFrame();
				++_frame;
			} else {
				asset.gotoAndStop(_currentRange.min);
				_frame = 1;
			}
		}
		
		/**
		 *	@inheritDoc
		 */		
		override public function prevFrame () : void
		{
			if (asset.currentFrame > _currentRange.min)
			{
				asset.prevFrame();
				--_frame;
			} else {
				asset.gotoAndStop(_currentRange.max);
				_frame = totalFrames;
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------


		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Extrait l'interval d'images pour l'action en cours
		 */
		protected function computeFramesRange () : void
		{
			var flabels:Array = asset.currentLabels;
			var label:FrameLabel;
			// TODO optimisation
//			_currentRange.min = 1;
//			_currentRange.max = asset.totalFrames;
			var goodLabel:String = _label + _model.rotation;
			
			var len:int = flabels.length;
			for (var i:int = 0; i < len; i++)
			{
				label = flabels[i];
				if (label.name == goodLabel)
				{
					_currentRange.min = label.frame;
					var nlabel:FrameLabel = flabels[i + 1];
					_currentRange.max = nlabel ? nlabel.frame - 1 : asset.totalFrames;
					break;
				}
			}
			
		}
		
	}
	
}

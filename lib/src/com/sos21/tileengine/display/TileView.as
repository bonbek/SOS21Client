package com.sos21.tileengine.display {	
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.sos21.tileengine.display.ITileView;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class TileView implements ITileView {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TileView (asset:DisplayObject = null)
		{			
			_asset = asset;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _asset:DisplayObject;
		protected var _model:DisplayObjectContainer;
		protected var _label:Object;
		protected var _frame:int = 1;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		public function set frame (val:int) : void
		{
			_frame = val
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
			return 0;
		}
		
		public function get angles () : Array
		{ return null;}

		public function get animations () : Array
		{ return null; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------			
		
		public function getModel () : DisplayObjectContainer
		{
			return _model;
		}
		
		public function setModel (m:DisplayObjectContainer) : void
		{
			_model = m;
			addAsset(_asset);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function draw (label:Object) : void
		{
			_label = label;
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
		public function prevFrame() : void
		{
			
		}

		/**
		 *	@inheritDoc
		 */
		public function addAsset (asset:DisplayObject) : void
		{
			_model.addChild(asset);
		}
		
		/**
		 *	@inheritDoc
		 */
		public function release () : void
		{
			_model.removeChild(_asset);
			_model = null;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

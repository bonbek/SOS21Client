package com.bourre.load
{
	import com.bourre.error.IllegalStateException;	
	import com.bourre.load.strategy.LoaderStrategy;
	import com.bourre.log.*;

	import flash.display.*;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class GraphicLoader 
		extends AbstractLoader
	{
		private var _target : DisplayObjectContainer;
		private var _index : int;
		private var _bAutoShow : Boolean;
		private var _bMustUnregister : Boolean;
		private var _oContext : LoaderContext;

		public function GraphicLoader( target : DisplayObjectContainer = null, index : int = -1, bAutoShow : Boolean = true )
		{
			super( new LoaderStrategy() );

			_target = target;
			_index = index;
			_bAutoShow = bAutoShow;
			_bMustUnregister = false;
		}

		public function setTarget( target : DisplayObjectContainer ) : void
		{
			var b : Boolean = isVisible();
			hide();
			_target = target ;
			if (b) show();
		}

		protected override function getLoaderEvent( type : String ) : LoaderEvent
		{
			return new GraphicLoaderEvent( type, this );
		}

		public override function load( url : URLRequest = null, context : LoaderContext = null ) : void
		{
			if ( context ) setContext( context );
			super.load( url, getContext() );
		}

		protected override function onInitialize() : void
		{
			if ( getName() != null ) 
			{
				if ( !(GraphicLoaderLocator.getInstance().isRegistered(getName())) )
				{
					_bMustUnregister = true;
					GraphicLoaderLocator.getInstance().register( getName(), this );
				} else
				{
					_bMustUnregister = false;
					var msg : String = this + " can't be registered to " + GraphicLoaderLocator.getInstance() 
										+ " with '" + getName() + "' name. This name already exists.";
					PixlibDebug.ERROR( msg );
					fireOnLoadErrorEvent( msg );
					throw new IllegalStateException( msg );
				}
			}
			
			if ( _bAutoShow ) show();
			super.onInitialize();
		}
		
		override public function setContent( content : Object ) : void
		{	
			if ( content is Bitmap )
			{
				var mc : Sprite = new Sprite();
				mc.addChild( content as Bitmap );
				super.setContent( mc );

			} else
			{
				super.setContent( content );
			}
		}
		
		public function show() : void
		{
			if (_target != null )
			{
				if ( _index != -1 )
				{
					_target.addChildAt( getContent() as DisplayObject, _index );
					
				} else
				{
					_target.addChild( getContent() as DisplayObject );
				}

			} else
			{
				PixlibDebug.DEBUG( this + ".show() failed. No specified target." );
			}
		}
		
		public function hide() : void
		{
			if (_target != null && _target.contains(getContent() as DisplayObject)) 
				_target.removeChild( getContent() as DisplayObject );
		}
		
		public function isVisible() : Boolean
		{
			var result : Boolean;
			try
			{
				result = _target.contains( getContent() as DisplayObject );
			} 
			catch( e : Error )
			{
				result = false;
			}
			return result ;
		}
		
		public function setAutoShow( b : Boolean ) : void
		{
			_bAutoShow = b;
		}
		
		override public function release() : void
		{
			if ( getContent() && _target.contains( getContent() as DisplayObject ) ) _target.removeChild( getContent() as DisplayObject );

			if ( _bMustUnregister ) 
			{
				GraphicLoaderLocator.getInstance().unregister( getName() );
				_bMustUnregister = false;
			}

			super.release();
		}
		
		public function getView() : DisplayObjectContainer
		{
			return getContent() as DisplayObjectContainer;
		}
		
		public function getApplicationDomain() : ApplicationDomain
		{
			return ( getStrategy() as LoaderStrategy ).getContentLoaderInfo().applicationDomain;
		}
		
		final public function setContext ( context : LoaderContext ):void
		{
			_oContext = context;
		}
		
		final public function getContext () : LoaderContext
		{
			return _oContext;
		}
	}
}
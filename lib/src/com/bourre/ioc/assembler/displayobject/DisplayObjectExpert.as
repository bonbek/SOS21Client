package com.bourre.ioc.assembler.displayobject 
{
	/*
	 * Copyright the original author or authors.
	 * 
	 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
	 * you may not use this file except in compliance with the License.
	 * You may obtain a copy of the License at
	 * 
	 *      http://www.mozilla.org/MPL/MPL-1.1.html
	 * 
	 * Unless required by applicable law or agreed to in writing, software
	 * distributed under the License is distributed on an "AS IS" BASIS,
	 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 * See the License for the specific language governing permissions and
	 * limitations under the License.
	 */

	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	import com.bourre.collection.HashMap;
	import com.bourre.error.IllegalStateException;
	import com.bourre.events.EventBroadcaster;
	import com.bourre.ioc.bean.BeanFactory;
	import com.bourre.ioc.parser.ContextNodeNameList;
	import com.bourre.load.GraphicLoader;
	import com.bourre.load.GraphicLoaderLocator;
	import com.bourre.load.Loader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.QueueLoader;
	import com.bourre.load.QueueLoaderEvent;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;		

	public class DisplayObjectExpert 
	{
		private static var _oI					: DisplayObjectExpert;

		private var _target						: DisplayObjectContainer;
		private var _oEB 						: EventBroadcaster;
		private var _dllQueue 					: QueueLoader;
		private var _gfxQueue 					: QueueLoader;
		private var _mDisplayObject				: HashMap;

		public static const SPRITE : String = "Sprite";
		public static const MOVIECLIP : String = "MovieClip";

		public static function getInstance() : DisplayObjectExpert
		{
			if ( !(DisplayObjectExpert._oI is DisplayObjectExpert) )
			{
				DisplayObjectExpert._oI = new DisplayObjectExpert( new PrivateConstructorAccess() );
			}

			return DisplayObjectExpert._oI;
		}

		public static function release() : void
		{
			if ( DisplayObjectExpert._oI is DisplayObjectExpert ) 
			{
				if ( DisplayObjectExpert.getInstance().getRootTarget() != null ) BeanFactory.getInstance().unregister( ContextNodeNameList.ROOT );
				DisplayObjectExpert._oI = null;
			}
		}

		public function DisplayObjectExpert( access : PrivateConstructorAccess )
		{
			_dllQueue = new QueueLoader();
			_gfxQueue = new QueueLoader();
			_mDisplayObject = new HashMap();

			_oEB = new EventBroadcaster( this );
		}

		public function setRootTarget( target : DisplayObjectContainer ) : void
		{
			if ( BeanFactory.getInstance().isRegistered( ContextNodeNameList.ROOT ) )
			{
				var msg : String = this + ".setRootTarget call failed. Root is already registered.";
				PixlibDebug.ERROR( msg );
				throw( new IllegalStateException( msg ) );

			} else
			{
				_target = target;
				BeanFactory.getInstance().register( ContextNodeNameList.ROOT, _target );
				_mDisplayObject.put( ContextNodeNameList.ROOT, new DisplayObjectInfo ( ContextNodeNameList.ROOT ) );
			}
		}

		public function getRootTarget() : DisplayObjectContainer
		{
			return _target;
		}

		public function buildDLL ( url : String ) : void
		{
			var gl : GraphicLoader = new GraphicLoader( getRootTarget(), _dllQueue.size(), false );
			_dllQueue.add( gl, "DLL" + _dllQueue.size(), new URLRequest( url ) );
		}

		public function buildGraphicLoader ( 	ID 			: String, 
												url 		: URLRequest,
												parentID 	: String 	= null, 
												isVisible 	: Boolean 	= true, 
												type 		: String 	= "Movieclip" ) : void
		{
			var info : DisplayObjectInfo = new DisplayObjectInfo( ID, parentID, isVisible, url.url, type );

			var gl : GraphicLoader = new GraphicLoader( null, -1, isVisible );
			_gfxQueue.add( gl, ID, url ) ;

			_mDisplayObject.put( ID, info );

			if ( _mDisplayObject.containsKey( parentID ) ) _mDisplayObject.get( parentID ).addChild( info );
		}

		public function buildEmptyDisplayObject ( 	ID 			: String, 
													parentID 	: String 	= null, 
													isVisible 	: Boolean 	= true, 
													type 		: String 	= "Movieclip" ) : void
		{
			if ( parentID == null ) parentID = ContextNodeNameList.ROOT;

			var info : DisplayObjectInfo = new DisplayObjectInfo( ID, parentID, isVisible, null, type );
			_mDisplayObject.put( ID, info );
			if ( _mDisplayObject.containsKey( parentID ) ) _mDisplayObject.get( parentID ).addChild( info );
		}
		
		protected function fireEvent( type : String, loader : Loader = null ) : void
		{
			_oEB.broadcastEvent( new DisplayObjectExpertEvent( type, loader ) );
		}

		public function load () : void
		{
			fireEvent( DisplayObjectExpertEvent.onDisplayObjectExpertLoadStartEVENT );
			loadDLLQueue();
		}

		public function loadDLLQueue() : void
		{
			if ( !(_executeQueueLoader( _dllQueue, onDLLLoadStart, onDLLLoadInit )) ) loadDisplayObjectQueue();
		}

		public function onDLLLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onDLLLoadStartEVENT, e.getLoader() );
		}
		
		public function onDLLLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onDLLLoadInitEVENT, e.getLoader() );
		}

		public function loadDisplayObjectQueue() : void
		{
			if ( !(_executeQueueLoader( _gfxQueue, onDisplayObjectLoadStart, onDisplayObjectLoadInit )) ) buildDisplayList();
		}
		
		public function onDisplayObjectLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onDisplayObjectLoadStartEVENT, e.getLoader() );
		}
		
		public function onDisplayObjectLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onDisplayObjectLoadInitEVENT, e.getLoader() );

			buildDisplayList();
		}
		
		private function _executeQueueLoader( ql : QueueLoader, startCallback : Function, endCallback : Function ) : Boolean
		{
			if ( ql.size() > 0 )
			{
				ql.addEventListener( QueueLoaderEvent.onItemLoadStartEVENT, qlOnLoadStart );
				ql.addEventListener( QueueLoaderEvent.onItemLoadInitEVENT, qlOnLoadInit );
				ql.addEventListener( QueueLoaderEvent.onLoadProgressEVENT, qlOnLoadProgress );
				ql.addEventListener( QueueLoaderEvent.onLoadTimeOutEVENT, qlOnLoadTimeOut );
				ql.addEventListener( QueueLoaderEvent.onLoadErrorEVENT, qlOnLoadError );
				ql.addEventListener( QueueLoaderEvent.onLoadStartEVENT, startCallback );
				ql.addEventListener( QueueLoaderEvent.onLoadInitEVENT, endCallback );
				ql.execute();

				return true;

			} else
			{
				return false;
			}
		}
		
		public function buildDisplayList() : void
		{
			_buildDisplayList( ContextNodeNameList.ROOT );
			fireEvent( DisplayObjectExpertEvent.onDisplayObjectExpertLoadInitEVENT );
		}

		private function _buildDisplayList( ID : String ) : void
		{
			var info : DisplayObjectInfo = _mDisplayObject.get( ID );

			if ( info != null )
			{
				if ( ID != ContextNodeNameList.ROOT )
				{
					if ( info.isEmptyDisplayObject() )
					{
						if ( !_buildEmptyDisplayObject( info ) ) return ;

					} else
					{
						if ( !_buildDisplayObject( info ) ) return;
					}
				}

				// recursivity
				if ( info.hasChild() )
				{
					var aChild : Array = info.getChild();
					var l : int = aChild.length;
					for ( var i : int = 0 ; i < l ; i++ ) _buildDisplayList( aChild[i].ID );
				}
			}
		}

		protected function _buildEmptyDisplayObject( info : DisplayObjectInfo ) : Boolean
		{
			try
			{
				var oParent : DisplayObjectContainer = BeanFactory.getInstance().locate( info.parentID ) as DisplayObjectContainer;
				var oDo : Sprite = ( info.type == "Movieclip" ) ? new MovieClip() : new Sprite();
				oParent.addChild( oDo ) ;
				BeanFactory.getInstance().register( info.ID, oDo ) ;
	
				_oEB.broadcastEvent( new DisplayObjectEvent( DisplayObjectEvent.onBuildDisplayObjectEVENT, oDo ) );
				return true;

			} catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}

		protected function _buildDisplayObject( info : DisplayObjectInfo ) : Boolean
		{
			try
			{
				var gl : GraphicLoader = GraphicLoaderLocator.getInstance().getGraphicLoader( info.ID );
				var parent : DisplayObjectContainer = BeanFactory.getInstance().locate( info.parentID ) as DisplayObjectContainer;
				gl.setTarget( parent );
				if ( info.isVisible ) gl.show();
				BeanFactory.getInstance().register( info.ID, gl.getView() );
	
				_oEB.broadcastEvent( new DisplayObjectEvent( DisplayObjectEvent.onBuildDisplayObjectEVENT, gl.getView() ) );
				return true;

			} catch ( e : Error )
			{
				return false;
			}
			
			return false;
		}


		// QueueLoader callbacks
		public function qlOnLoadStart( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onLoadStartEVENT, e.getLoader() );
		}

		public function qlOnLoadInit( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onLoadInitEVENT, e.getLoader() );
		}

		public function qlOnLoadProgress( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onLoadProgressEVENT, e.getLoader() );
		}

		public function qlOnLoadTimeOut( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onLoadTimeOutEVENT, e.getLoader() );
		}

		public function qlOnLoadError( e : LoaderEvent ) : void
		{
			fireEvent( DisplayObjectExpertEvent.onLoadErrorEVENT, e.getLoader() );
		}

		/**
		 * Event system
		 */
		public function addListener( listener : DisplayObjectExpertListener ) : Boolean
		{
			return _oEB.addListener( listener );
		}

		public function removeListener( listener : DisplayObjectExpertListener ) : Boolean
		{
			return _oEB.removeListener( listener );
		}

		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return _oEB.addEventListener.apply( _oEB, rest.length > 0 ? [ type, listener ].concat( rest ) : [ type, listener ] );
		}

		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return _oEB.removeEventListener( type, listener );
		}

		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}

internal class PrivateConstructorAccess {}
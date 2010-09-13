package ddgame.client.proxy {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.DataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.system.Security;
	import ddgame.client.view.PNJHelper;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import com.sos21.proxy.AbstractProxy;
	import com.sos21.proxy.ConfigProxy;
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.MCTileView;
	
	import ddgame.client.events.EventList;
	import ddgame.client.view.IsosceneHelper;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class SocketProxy extends AbstractProxy {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = ProxyList.SOCKET_PROXY;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function SocketProxy()
		{
			super(NAME);
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _socket:XMLSocket;
		private var nick:String;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get socket():XMLSocket {
			return _socket;
		}
		
		private function get isoScene():IsosceneHelper
		{
			return facade.getObserver(IsosceneHelper.NAME) as IsosceneHelper;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function playerHandler(event:BaseEvent):void
		{
			var up:UPoint = UPoint(BaseEvent(event).content);
			socket.send('<p r="m1" x="' + up.xu + '" y="' + up.yu + '" z="' + up.zu + '" />');
		}
		
		private function dataHandler(event:DataEvent):void
		{
			var data:XML = new XML(DataEvent(event).data);				
			var sn:String = data[0].name();
			trace(data.toXMLString());
			switch (sn)
			{
				case "m" : 		// message
				{
					//var uname:String = data.@f;
					//var uavatar:PNJHelper = facade.getObserver(uname) as PNJHelper;
					//var st:String = data;										
					//uavatar.displayTalk(unescape(st), 10000);
					break;
				}
				case "p" : 		// déplacement
				{
					trace(data.toXMLString());
					var tx:int = data.@x;
					var ty:int = data.@y;
					var tz:int = data.@z;
					trace("AVATAR POS", tx, ty, tz);
					var uavatar:PNJHelper = facade.getObserver(data.@f) as PNJHelper;
					if (!uavatar)
					{
						createAvatar(data);		
					} else {
						uavatar.moveTo(tx, ty, tz);
					}
					break;
				}
				case "client" :
				{
					// test si user à déloggé
					if (data.(@name != nick))
					{
						var asLeft:String = data.@left;
						if (asLeft == "m1")
						{
							trace("user " + data.@name + " à quitter la room");
							uavatar = facade.getObserver(data.@name) as PNJHelper;
							if (uavatar)
							{
								facade.unregisterObserver(data.@name);
								isoScene.component.sceneLayer.removeTile(uavatar.component);	
							}							
						}
					}
					break;
				}
			}
		}
		
		private function socketHandler(event:Event):void
		{
			switch (event.type)
			{
				case Event.CONNECT :
				{
					// ajout pour validation de la connection (log + entrée dans la room)
					_socket.addEventListener(DataEvent.DATA, socketHandler);
					var d:Date = new Date();
					nick = "guest_" + d;
					socket.send('<connect nickname="' + nick + '" />');
					socket.send('<join room="m1" />');
					break;
				}
				case Event.CLOSE :
				{
					channel.removeEventListener(EventList.MOVE_PLAYER, playerHandler);
					if (ConfigProxy.getInstance().data.spy == "true")
						removeDataListener();
					break;
				}
				case DataEvent.DATA :
				{
					var data:XML = new XML(DataEvent(event).data);					
					var sn:String = data[0].name();
					switch (sn)
					{
						case "connect" : // retour de connection
						{
							if (int(data.@isok) == 1)
							{
								trace("> ", nick, " est loggé");
							} else {
								trace("echec à la tentative de connection > " + nick);
							}
							
							break;
						}
						case "joined" : // connection à la chambre
						{
							trace("> " + nick + " rejoint la room " + data.@room);
							_socket.removeEventListener(DataEvent.DATA, socketHandler);
							channel.addEventListener(EventList.MOVE_PLAYER, playerHandler);
							if (ConfigProxy.getInstance().data.spy == "true")
								addDataListener();
							break
						}
					}
					break;
				}
				default :
				{ break }
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function createAvatar(tdata:XML):void
		{			 
			var cl:Class = LibProxy(facade.getProxy(LibProxy.NAME)).getDefinitionFrom("sprites/TheBob.swf", "bob");
			var mc:MovieClip = new cl();
			var tx:int = tdata.@x;
			var ty:int = tdata.@y;
			var tz:int = tdata.@z;
			var aname:String = tdata.@f;
			var tile:AbstractTile = new AbstractTile(aname, new UPoint(tx, ty, tz, 60, 30, 30, 0, 0, 0), new MCTileView(mc));
			var avatar:PNJHelper = new PNJHelper(aname, tile);
			facade.registerObserver(aname, avatar);
			var tf:TextField = new TextField();
			tf.y = -70;
			tf.text = aname;
			avatar.component.addChild(tf);
		}
		
		private function addDataListener():void
		{
			_socket.addEventListener(DataEvent.DATA, dataHandler);
		}
		
		private function removeDataListener():void
		{
			_socket.removeEventListener(DataEvent.DATA, dataHandler);
		}
		
		override public function initialize():void
		{
			// connection
			_socket = new XMLSocket();
			_socket.addEventListener(Event.CLOSE, socketHandler);
			_socket.addEventListener(Event.CONNECT, socketHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, socketHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketHandler);
			
			Security.loadPolicyFile("xmlsocket://94.23.59.197:2468");
			socket.connect("94.23.59.197", 2468);
		}
	
	}

}


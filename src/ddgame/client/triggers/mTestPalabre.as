package ddgame.client.triggers {
	
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.Security;
	
	import com.sos21.events.BaseEvent;
	import com.sos21.tileengine.structures.UPoint;
	import com.sos21.tileengine.core.AbstractTile;
	import com.sos21.tileengine.display.MCTileView;
	import com.sos21.tileengine.events.TileEvent;
	import com.sos21.tileengine.structures.UPoint;
	
	import ddgame.client.triggers.ITrigger;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.triggers.AbstractExternalTrigger;
	import ddgame.client.view.IsosceneHelper;
	import ddgame.client.proxy.PlayerProxy;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.events.EventList;
	import ddgame.client.view.PlayerHelper;
	import ddgame.client.view.PNJHelper;
	import ddgame.client.proxy.LibProxy;
	import com.sos21.tileengine.structures.UPoint;


	/**
	 * Trigger map id 61 (commerce poissonnerie)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class mTestPalabre extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function mTestPalabre():void
		{
			super();			
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
				
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var socket:XMLSocket;
		private var nick:String;
		private var firstCheck:Boolean = true;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get playerHelper():PlayerHelper {
			return PlayerHelper(facade.getObserver(PlayerHelper.NAME));
		}
		
		public function get playerView():MCTileView {
			return MCTileView(playerHelper.component.getView());
		}
		
		private function get libProxy():LibProxy
		{
			return facade.getProxy(LibProxy.NAME) as LibProxy;
		}
		
		private function get isoScene():IsosceneHelper
		{
			return facade.getObserver(IsosceneHelper.NAME) as IsosceneHelper;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 *	
		 */
		override public function execute(event:Event = null):void
		{
			_init();
		}
				
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function socketHandler(event:Event)
		{
//			trace(event.type);
			switch (event.type)
			{
				case Event.CONNECT :
				{
					nick = "guest_" + int(Math.random() * 100);
					socket.send('<connect nickname="' + nick + '" />');
					socket.send('<join room="m1" />');
					break;
				}
				case DataEvent.DATA :
				{
					try
					{
						var data:XML = new XML(DataEvent(event).data);
//						trace("----------------")						
						var sn:String = data[0].name();
						trace("----------- " + nick + "-----------");
//						trace(data.toXMLString());
//						trace(sn);
						switch (sn)
						{
							case "m" : 		// message
							{
								var uname:String = data.@f;
								var uavatar:PNJHelper = facade.getObserver(uname) as PNJHelper;
								var st:String = data;										
								uavatar.displayTalk(unescape(st), 10000);
								break;
							}
							case "p" :
							{
								trace(data.toXMLString());
								var tx:int = data.@x;
								var ty:int = data.@y;
								var tz:int = data.@z;
								trace("AVATAR POS", tx, ty, tz);
								uavatar = facade.getObserver(data.@f) as PNJHelper;
								uavatar.moveTo(tx, ty, tz);
								break;
							}
							case "simplelogin" : 	// message du logger
							{
								break;
							}
							case "connect" : 			// retour de connection
							{
								if (int(data.@isok) == 1)
								{
									trace(nick + " est loggé");
								} else {
									trace("echec à la tentative de connection > " + nick);
								}
									
								break;
							}
							case "joined" :
							{
								trace(data.toXMLString());
								trace(nick + " rejoint la room " + data.@room);
								break
							}
							case "room" :
							{
								break;
							}
							case "childrooms" :
							{
								break;
							}
							case "clients" :
							{
								if (firstCheck)
								{
									var ulist:XMLList = data.client.(@name != nick)
									trace("first check ");
									var l:int = ulist.length();
									var tdata:XML;
									while (--l > -1)
									{
										tdata = ulist[l];
										var cl:Class = libProxy.getDefinitionFrom("sprites/TheBob.swf", "bob");
										var mc:MovieClip = new cl();
										var tile:AbstractTile = new AbstractTile(tdata.@name, new UPoint(19, 15, 0, 60, 30, 30, 0, 0, 0), new MCTileView(mc));
										var avatar:PNJHelper = new PNJHelper(tdata.@name, tile);
										facade.registerObserver(avatar.name, avatar);
										var tf:TextField = new TextField();
										tf.y = -70;
										tf.text = tdata.@name;
										avatar.component.addChild(tf);
									}
									trace(ulist.toXMLString());
									firstCheck = false;
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
										facade.unregisterObserver(data.@name);
										isoScene.component.sceneLayer.removeTile(uavatar.component);										
									} 	else if (data.(@joined == "m1")) {
											trace("user " + data.@name + " à rejoins la room");
											cl = libProxy.getDefinitionFrom("sprites/TheBob.swf", "bob");
											mc = new cl();
											tile = new AbstractTile(data.@name, new UPoint(19, 15, 0, 60, 30, 30, 0, 0, 0), new MCTileView(mc));
											avatar = new PNJHelper(data.@name, tile);
											trace("AVATAR ", avatar);
											facade.registerObserver(avatar.name, avatar);
											tf = new TextField();
											tf.y = -70;
											tf.text = avatar.name;
											avatar.component.addChild(tf);
									}
								}
								break;
							}
						}
					} catch (e:Error) {
						trace(e);
					}
					break;
				}
			}
		}
		
		private function stageHandler(event:MouseEvent):void
		{
			var p:Point = isoScene.component.sceneLayer.findGridPoint(new Point (stage.mouseX, stage.mouseY));
			var up:UPoint = new UPoint(p.x, p.y, 0);
			socket.send('<m r="m1" pos="' + up.xu + '/' + up.yu + '/' + up.yu + '" />');
		}
		
		protected function playerHandler(event:BaseEvent):void
		{
			var up:UPoint = UPoint(BaseEvent(event).content);
//			socket.send('<m r="m1" pos="' + up.xu + '/' + up.yu + '/' + up.yu + '" />');
			socket.send('<p r="m1" x="' + up.xu + '" y="' + up.yu + '" z="' + up.zu + '" />');
		}
		
//		private var pMsg:String = "";
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			var kc:Number = event.keyCode;
			if (kc == 13)
			{
				var sencode:String = escape(pMsg.text);
				socket.send('<m r="m1">' + sencode + '</m>');
				playerHelper.displayTalk(pMsg.text, 10000);
				pMsg.text = "";
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 */
		private function _init():void
		{
			trace("INIT ", this);
			
			socket = new XMLSocket();
			socket.addEventListener(Event.CLOSE, socketHandler);
			socket.addEventListener(Event.CONNECT, socketHandler);
			socket.addEventListener(DataEvent.DATA, socketHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, socketHandler);
			socket.addEventListener(ProgressEvent.PROGRESS, socketHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketHandler);
			
			Security.loadPolicyFile("xmlsocket://94.23.59.197:2468");
			socket.connect("94.23.59.197", 2468);
			
			channel.addEventListener(EventList.MOVE_PLAYER, playerHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
			
			stage.addChild(this);
			
			/*function debug (msg) {

				_root.txtdebug.htmlText = msg + "<br/>" +_root.txtdebug.htmlText  ;
			}

			function x2h(msg) {
				msg2='';
				msg = msg.split("<");
				for(p=0;p<msg.length;p++) 
				   msg2 += msg[p]+"&lt;";

				   msg2= msg2.substr(0,-4)
				 return msg2;
			}
			px.onXML = function  (msg) {
				node = msg.firstChild;
				if(msg.firstChild.nodeName == "m") {
					poss = msg.firstChild.firstChild.nodeValue;
					poss = poss.split("|");

					_root.dep++;;
					_root.attachMovie('mouse','mouse'+_root.dep,_root.dep);
					_root['mouse'+_root.dep]._x = poss[0];
					_root['mouse'+_root.dep]._y = poss[1];		
					debug(msg.firstChild.firstChild.value);
				}
				//debug('<font color="#007700">*'+getTimer()+'* <b>Incoming :</b> <br>'+x2h(msg.toString())+"</font>");
			}

			function mysend(msg) {

				_root.px.send(msg);
				//debug('<font color="#000077">*'+getTimer()+'* <b>Sending :</b><br>'+x2h(msg)+"</font><hr/>");	
			}*/


			//trace('Connecting : '+server_ip.text + '  '+server_port.text);

		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{

		}

	}

}


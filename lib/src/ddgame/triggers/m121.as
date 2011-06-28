package ddgame.triggers {
	
	import flash.events.*;
	import flash.display.*;
	
	import com.sos21.events.*;
	
	import ddgame.triggers.ITrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.events.EventList;
	import ddgame.proxy.ProxyList;
	import ddgame.helper.HelperList;
		
	import ddgame.triggers.AbstractExternalTrigger;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.net.URLVariables;
	import Date;
	import flash.net.URLRequest;
	import flash.net.sendToURL;

	/**
	 * Trigger map id 102 (HSBC espace étudiants)
	 *	
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class m121 extends AbstractExternalTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public function m121 () : void
		{ super(); }
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------

		public var playerProxy:Object;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var screen:MovieClip;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
				
		/**
		 *	@inheritDoc
		 *	
		 */
		override public function execute (event:Event = null) : void
		{
			_init();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function handleMouse (event:MouseEvent) : void
		{
			if (event.target is SimpleButton)
			{
				switch (screen.currentFrame)
				{
					case 1 :
						screen.nextFrame();
						break;
					case 2 :
						sendParticipation();
						screen.nextFrame();				
						break;
					case 3 :
						screen.nextFrame();					
						break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function sendParticipation () : void
		{
			// Récup IPlayerDocument du clientServer (LorealClientServer)
			var data:Object = playerProxy.getData();

			var url:String = "http://lejeu.sos-21.com/loreal/confirmParticipation.php";
			var variables:URLVariables = new URLVariables();
			variables.sessionId = new Date().getTime();
			variables.userName = data.pseudo.substring(data.pseudo.indexOf(" ") + 1);
			variables.userMail = data.email;
			variables.userScore = playerProxy.env;

			var request:URLRequest = new URLRequest(url);
			request.data = variables;
			trace("sendToURL: " + request.url + "?" + request.data);
			try {
			    sendToURL(request);
			}
			catch (e:Error) {
			    // handle error here
			}

		}
		
		/**
		 *	@private
		 */
		private function _init() : void
		{
			// refs utiles			
			playerProxy = facade.getProxy(ProxyList.PLAYER_PROXY);

			screen = new Outro();
			screen.stop()
			screen.x = 70;
			screen.y = 25;
			applicationStage.addChild(screen);
			
			screen.addEventListener(MouseEvent.CLICK, handleMouse);

			screen.score.text = playerProxy.env + " / " + 1500;
		}
		
		/**
		 *	@inheritDoc
		 */
		override protected function complete(event:Event = null):void
		{
			super.complete();
		}
		
	}

}
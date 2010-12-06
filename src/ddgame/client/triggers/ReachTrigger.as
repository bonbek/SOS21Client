package ddgame.client.triggers {
	
	import flash.events.Event;
	import flash.utils.*;
	import flash.display.Sprite;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import gs.TweenMax;
	import gs.easing.*;
	
	import com.sos21.events.BaseEvent;
	import ddgame.sound.SoundTrack;
	import ddgame.helper.HelperList;	
	import ddgame.view.UIHelper;
	import ddgame.sound.AudioHelper;
	import ddgame.client.events.EventList;
	import ddgame.client.triggers.AbstractTrigger;
	import ddgame.client.events.TriggerEvent;
	import ddgame.client.proxy.TileTriggersProxy;
	

	/**
	 *	Trigger executer et compléter un / des trigger(s) dans un
	 * temps imparti
	 *
	 * arguments
	 * time	temps imparti pour executer le(s) trigger(s) en secondes
	 * trig	liste des triggers à executer / compléter
	 * rcnt	nombre minimal de trigger(s) à exec / compléter. par defaut 1
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class ReachTrigger extends AbstractTrigger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 105;
			
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function execute (e:Event = null) : void
		{
			// recup liste des triggers à surveiller
			var sl:String = getPropertie("trig");
			if (!sl) super.cancel();
			
			tlist = sl.split(",");
			if (tlist.length == 0) super.cancel();
			
			var t:int = getPropertie("time");

			ltime = t ? t * 1000 : 1000;

			rcount = getPropertie("rcnt");
			if (!rcount) rcount = 1;
			
			if (getPropertie("txt")) createStickie();
			
			channel.addEventListener(TriggerEvent.EXECUTE, handleEvent);
			stage.addEventListener(Event.ENTER_FRAME, handleEvent);
			
			stime = getTimer();
			
			sndFx = AudioHelper(facade.getObserver(AudioHelper.NAME)).addSound(sndFxUrl, false);
			// option effet sonore
			if (getPropertie("fxs")) sndFx.play(0, -1);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cancel () : void
		{
			sndFx.stop();
			stage.removeChild(stickie);
			_release();
			super.cancel();
		}
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		// temps départ
		protected var stime:int;
		// temps limite
		protected var ltime:int;
		// liste des triggers à surveiller
		protected var tlist:Array;
		// nbr triggers executés
		protected var tcount:int = 0;
		// nbr triggers à éxecuter
		protected var rcount:int;
		// étiquette info
		protected var stickie:Sprite;
		protected var sndFx:SoundTrack;
		protected var sndFxUrl:String = "sounds/fx/alarm.mp3";
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * Réception events
		 *	@param e Event
		 */
		private function handleEvent (e:Event) : void
		{
			switch (e.type)
			{
				case TriggerEvent.EXECUTE :
				{
					if (tlist.indexOf(String(TriggerEvent(e).trigger.properties.id)) > -1) tcount++;			
					if (tcount >= rcount) complete();
					break;
				}
				case Event.ENTER_FRAME :
				{
					var etime:int = getTimer() - stime;
					if (etime >= ltime )
					{
						uncomplete();
					}
					else
					{
						var perc:Number = (etime / ltime) * 100;
						// option effet tremblement
						if (getPropertie("fxt"))
						{
							var nx:int = perc / 30;
							if (stt) stickie.x += nx;
							else
								stickie.x -= nx;
						}
						stt = !stt;
						uiHelper.component.timeBubbleWgt.percentFill = perc;
					}
					break;
				}
				default :
				{ break; }
			}
		}
		
		var stt:Boolean = false;
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		protected function createStickie () : void
		{
			var margin:int = 6;
			// text
			var t:TextField = new TextField();
			t.x = t.y = margin;
//			var otwidth:int = t.width = swidth > 0 ? swidth : maxWidth;
			t.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			t.autoSize = TextFieldAutoSize.LEFT;
			t.antiAliasType = "advanced";
			t.embedFonts = true;
			t.selectable = false;
			t.multiline = false;
			t.wordWrap = false;
			t.text = getPropertie("txt");
			t.width = t.textWidth + 5;
//			if (t.textWidth < otwidth) t.width = t.textWidth + 5;
			// fond
			var dmargin = margin * 2;
			stickie = new Sprite();
			stickie.graphics.beginFill(0xFF0092);
			stickie.graphics.drawRoundRect(0, 0, t.width + dmargin, t.height + dmargin, 6);
			stickie.graphics.moveTo(t.width + dmargin + 4, 0);
			stickie.graphics.lineTo(t.width + dmargin + 20, (t.height + dmargin) / 2);
			stickie.graphics.lineTo(t.width + dmargin + 4 , t.height + dmargin);
			stickie.graphics.endFill();
			stickie.filters = [new DropShadowFilter(4, 45, 0, .5)];
			stickie.addChild(t);
			var bnds:Object = UIHelper.VIEWPORT_AREA;
			stickie.x = bnds.right - 10 - stickie.width;
			stickie.y = bnds.y + 7;
			
			stage.addChild(stickie);

			TweenMax.from(stickie, 1, {y:stickie.y + 50, ease:Elastic.easeOut});
		}
		
		/**
		 * Relâche
		 *	@private
		 */
		protected function _release () : void
		{			
			AudioHelper(facade.getObserver(AudioHelper.NAME)).removeSound(sndFxUrl);
			stage.removeEventListener(Event.ENTER_FRAME, handleEvent);
			channel.removeEventListener(TriggerEvent.EXECUTE, handleEvent);
		}
		
		protected function uncomplete () : void
		{
			TweenMax.to(stickie, 0.2, {y:stickie.y - 30, rotation:10, ease:Strong.easeOut});
			TweenMax.to(stickie, 0.8, {delay:.2, y:stickie.y + 300, rotation:80, alpha:0, ease:Strong.easeIn, onComplete:stage.removeChild, onCompleteParams:[stickie]});
			uiHelper.component.timeBubbleWgt.empty();
			sndFx.stop();
			
			var proxy:TileTriggersProxy = triggerProxy;
			// annulation des triggers
			// patch quand un trigger à éxecuter prend en compte un déplacement de bob :
			// bob se déplace, il n'atteint pas le trigger à atteindre dans le temps imparti, le trigger d'annulation
			// se lance, mais aussi celui à atteindre
			var t:AbstractTrigger;
			for each (var tid:int in tlist)
			{
				t = triggerProxy.findActiveTrigger(tid) as AbstractTrigger;
				if (t) t.cancel();
			}			
			
			// lancement du trigger définit pour "le(s) action(s) n'ont pas été(s) effectuées"
			var tid:int = getPropertie("fail");
			if (tid)
				triggerProxy.launchTriggerByID(tid);

			_release();
			super.cancel();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function complete (event:Event = null) : void
		{
			sndFx.stop();
			TweenMax.to(stickie, .8, {alpha:0, ease:Strong.easeOut, onComplete:stage.removeChild, onCompleteParams:[stickie]});
			TweenMax.to(uiHelper.component.timeBubbleWgt, 2, {percentFill:0});
			_release();
			super.complete();
		}
		
		/**
		 * Ref TileTriggersProxy
		 */
		protected function get triggerProxy () : TileTriggersProxy
		{ return TileTriggersProxy(facade.getProxy(TileTriggersProxy.NAME)); }
		
		/**
		 * Ref UIHelper
		 */
		protected function get uiHelper () : UIHelper
		{ return UIHelper(facade.getObserver(HelperList.UI_HELPER)); }
		
	}

}


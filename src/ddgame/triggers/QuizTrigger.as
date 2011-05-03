package ddgame.triggers {
	import flash.geom.Point;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.filters.GlowFilter;
	import com.sos21.events.BaseEvent;
	import com.sos21.debug.log;
	import com.sos21.utils.Delegate;
	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.ApplicationChannel;
	import ddgame.triggers.AbstractTrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.proxy.LibProxy;
	import ddgame.events.ServerEventList;
	import ddgame.events.EventList;
	import ddgame.scene.PlayerHelper;
	import ddgame.ui.components.Panel;
	import ddgame.ui.components.Button;
	import ddgame.ui.UIHelper;
	import components.quiz.Quiz;
	import components.quiz.QuizEvent;
	
	/**
	 *	Trigger QCM
	 *	- propriétés -
	 *		mode : 2 pour choix aléatoire d'un seul qcm
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class QuizTrigger extends AbstractTrigger {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLASS_ID:int = 3;
		
		public static const NEXT:String = "nextQ";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function QuizTrigger()
		{ }

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var _panel:Panel;		// Conteneur Quiz
		private var _quiz:Quiz;			// composant Quiz
		private var _queue:Array;		// Liste des qcm
		private var _nextBtn:SimpleButton;
		private var _closeBtn:SimpleButton;
		private static var played:Array = [];
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------		
		
		public var data:Object;			// Data quiz
		
		public function get quiz():Quiz {
			return _quiz;
		}
		
		override public function get classID():int {
			return CLASS_ID;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override public function execute (event:Event = null) : void
		{
			if (!event)
			{
				// liste des qcm
				_queue = String(properties.arguments["id"]).split("#");
				if (isPropertie("mode") && _queue.length > 0)
				{
					// mode de tirage
					var qmode:int = getPropertie("mode");

					// ne pas réjouer qcm's déjà joués
					if (qmode & 1)
						removePlayedFromQueue();

					// mode tirage aléatoire un dans la liste
					if (qmode & 2)
					{
						var n:int = _queue.length;
						if (n > 1)
							_queue = [_queue[Math.ceil(Math.random() * n - 1)]];
					}
				}
			}	
			
			if (_queue.length > 0)
			{
				sendEvent(new Event(EventList.FREEZE_SCENE));
				callForData();
			}
			else
			{
				_release();	
			}
			
		}
		
		/**
		 *	Supprime les qcm déjà joués de la liste d'attente des qcm
		 */
		public function removePlayedFromQueue () : void
		{
			var l:int = played.length;
			var ind:int;
			while (--l > -1)
			{
				ind = _queue.indexOf(played[l]);
				if (ind > -1)
					_queue.splice(ind, 1);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/*
		*	Data event handler
		*/
		private function dataQuizHandler (event:BaseEvent) : void
		{
//			trace("data received");
//			sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, false));
			ApplicationChannel.getInstance().removeEventListener(ServerEventList.ON_DATAQUIZ, dataQuizHandler);
			// on stock les data brutes
			data = event.content;
			
			if (_quiz == null)
				_initDisplay();
				
			// on construit le qcm
			_quiz.clear();
			_quiz.questionTitle = data.question;
			_quiz.dataProvider = data.responses;
			_quiz.explanation = data.explanation;
			positionPanel();
		}
		
		/*
		*	Quiz events handlers
		*/
		private function quizEventHandler(event:QuizEvent):void
		{
			switch (event.type)
			{
				case QuizEvent.COMPLETE :
				{
					var classRef:Class;
					if (_queue.length > 0)
					{
						_nextBtn = new Button("suite");
						_nextBtn.y = _panel.content.height + 8;
						_nextBtn.x = _panel.content.width - _nextBtn.width;
						_nextBtn.addEventListener(MouseEvent.CLICK, panelHandler);
						_panel.content.addChild(_nextBtn);
					} else {
						_closeBtn = new Button("fermer");
						_closeBtn.y = _panel.content.height + 8;
						_closeBtn.x = _panel.content.width - _closeBtn.width;
						_closeBtn.addEventListener(MouseEvent.CLICK, _panel.close);
						_panel.content.addChild(_closeBtn);
//						complete();
					}
					break;
				}
				case QuizEvent.RESPONSE_SELECT :
				{
					if (played.indexOf(data.id) == -1)
					{
						played.push(data.id);
						if (event.bonus)
						{
							var blist:Array = String(event.bonus).split("_");
							var st:String;
							var ind:int;
							for (var i:int = 0; i < blist.length; i++) {
								st = blist[i];
								ind = st.indexOf("#");
								sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:int(st.substring(0, ind)), theme:int(st.substring(ind + 1))}));
							}
						}
					} else {
//						trace("Quiz déjà joué @" + toString());
					}
					break;
				}
			}
		}
		
		/*
		*	Panel events handler
		*/
		private function panelHandler(event:Event):void
		{
			switch (event.type)
			{
				case MouseEvent.CLICK :
				{
					if (event.target == _nextBtn)
					{
						_panel.content.removeChild(_nextBtn);
						_nextBtn.removeEventListener(MouseEvent.CLICK, panelHandler);
						_nextBtn = null;
						execute(new Event(NEXT));
					}
					break;
				}
				case Panel.CLOSE :
				{
					//trace("close");
					_release();
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					break;
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Lance la récupération des data d'un Qcm
		 */
		private function callForData():void
		{
			var quizId:int = _queue.shift();
			if (quizId > 0)
			{
				// Patch de transition avant que tous les quiz soient
				// passés dans les data triggers
				if (isPropertie("qzl"))
				{
					for each (data in getPropertie("qzl"))
					{
						if (data.id == quizId)
						{
							if (_quiz == null)
								_initDisplay();

							// on construit le qcm
							_quiz.clear();
							_quiz.questionTitle = data.question;
							_quiz.dataProvider = data.responses;
							_quiz.explanation = data.explanation;
							positionPanel();
							break;
						}
					}
				}
				else {
					ApplicationChannel.getInstance().addEventListener(ServerEventList.ON_DATAQUIZ, dataQuizHandler);
					sendPublicEvent(new BaseEvent(ServerEventList.GET_DATAQUIZ, quizId));
				}
			}
			else
			{
				if (sourceTarget)
				{
					sourceTarget.mouseEnabled = true;
				}
					
				sendEvent(new Event(EventList.UNFREEZE_SCENE));
				sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, false));
				super.complete();
			}
				
		}
		
		/*
		*	Initialize display and Event listeners
		*/
		private function _initDisplay():void
		{
				// create Panel display
			_panel = new Panel(stage);
			_quiz = new Quiz(300);
				// add listeners
			_panel.addEventListener(Panel.CLOSE, panelHandler, false);
			_quiz.addEventListener(QuizEvent.COMPLETE, quizEventHandler, false, 0, true);
			_quiz.addEventListener(QuizEvent.RESPONSE_SELECT, quizEventHandler, false, 0, true);
				// add Quiz display to Panel
			_panel.content.addChild(_quiz);			
		}
		
		/*
		*	Place the Panel to correct position
		*/
		private function positionPanel():void
		{
			if (properties.arguments["x"] != undefined && properties.arguments["y"] != undefined)
			{
				_panel.x = int(properties.arguments["x"]);
				_panel.y = int(properties.arguments["y"]);
			} else {
				var p:Point;		// coordonnées objet source
				var margin:Point;	// marge entre la popup et l'objet source

				// on test si le déclencheur est lié à un tile sinon on prend le perso
				// comme point coordonnée
				if (sourceTarget)
				{
					var b:Object = sourceTarget.getBounds(stage);
					p = new Point(b.x, b.y);
					margin = new Point(b.width, b.height);
					// on en profite pour mettre un effet sur le tile
					sourceTarget.mouseEnabled = false;
//					sourceTarget.filters = [new GlowFilter(0x990000, 1, 10, 10)];
				} else {
					p = PlayerHelper(facade.getObserver(PlayerHelper.NAME)).stagePosition;
					margin = new Point(10, 10);
				}
				
				//	placement en x
				if (p.x + _panel.width > (UIHelper.VIEWPORT_AREA.x + UIHelper.VIEWPORT_AREA.width))
				{
					_panel.x = p.x - _panel.width - 6;
				} else {
					_panel.x = p.x + margin.x + 6;
				}
				// placement en y
				if (p.y + _panel.height > (UIHelper.VIEWPORT_AREA.y + UIHelper.VIEWPORT_AREA.height))
				{
					_panel.y = UIHelper.VIEWPORT_AREA.height - _panel.height - 6;
				} else {
					_panel.y = p.y;
				}
			}
		}
		
		/*
		*	Remove all listener and data reference
		*/
		private function _release():void
		{
			if (_panel)
			{
				_panel.removeEventListener(Panel.CLOSE, panelHandler);
				_quiz.removeEventListener(QuizEvent.COMPLETE, quizEventHandler);
				_quiz.removeEventListener(QuizEvent.RESPONSE_SELECT, quizEventHandler);
				if (_closeBtn != null)
				{
					_closeBtn.removeEventListener(MouseEvent.CLICK, _panel.close);
					_closeBtn = null;
				}
				if (_nextBtn != null)
				{
					_nextBtn.removeEventListener(MouseEvent.CLICK, panelHandler);
					_nextBtn = null;
				}
				_quiz = null;
				_panel = null;				
			}
			
			data = null;
			_queue = null;
			
			if (sourceTarget)
			{
				sourceTarget.mouseEnabled = true;
//				sourceTarget.filters = [];
			}
			super.complete();
		}
		
		override protected function onDiffer():void
		{
			sendEvent(new Event(EventList.FREEZE_SCENE));
			sendEvent(new BaseEvent(EventList.DISPLAY_HOURGLASS, true));
		}
		
		/*
		*	Return lib proxy reference
		*/
		protected function get libProxy():LibProxy
		{
			return LibProxy(facade.getProxy(LibProxy.NAME));
		}
				
	}
	
}

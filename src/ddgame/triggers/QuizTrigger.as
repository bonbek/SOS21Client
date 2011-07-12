package ddgame.triggers {
	
	import flash.geom.Point;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.filters.GlowFilter;
	import com.sos21.events.BaseEvent;
	import com.sos21.utils.Delegate;
	import com.sos21.helper.AbstractHelper;
	import com.sos21.events.ApplicationChannel;
	import ddgame.triggers.AbstractTrigger;
	import ddgame.events.TriggerEvent;
	import ddgame.proxy.*;
	import ddgame.server.IClientServer;	;
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
		
		// ?
		public function get quiz() : Quiz
		{ return _quiz; }
		
		// ?
		override public function get classID() : int
		{ return CLASS_ID; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@inheritDoc
		 */
		override public function execute (event:Event = null) : void
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
			
			nextQuiz();
		}		
		
		/**
		 *	Passe au quiz suivant
		 */
		public function nextQuiz () : void
		{
			if (_queue.length > 0)
			{
				sendEvent(new Event(EventList.FREEZE_SCENE));
				callForData();
			}
			else
			{
				complete();
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		/*
		*	Réception events Quiz's
		*/
		private function quizEventHandler (event:QuizEvent) : void
		{
			switch (event.type)
			{
				case QuizEvent.COMPLETE :
				{
					if (_queue.length > 0)
					{
						_nextBtn = new Button("suite");
						_nextBtn.y = _panel.content.height + 8;
						_nextBtn.x = _panel.content.width - _nextBtn.width;
						_nextBtn.addEventListener(MouseEvent.CLICK, panelHandler);
						_panel.content.addChild(_nextBtn);
					}
					else
					{
						_closeBtn = new Button("fermer");
						_closeBtn.y = _panel.content.height + 8;
						_closeBtn.x = _panel.content.width - _closeBtn.width;
						_closeBtn.addEventListener(MouseEvent.CLICK, _panel.close);
						_panel.content.addChild(_closeBtn);
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
							for (var i:int = 0; i < blist.length; i++)
							{
								st = blist[i];
								ind = st.indexOf("#");
								sendEvent(new BaseEvent(EventList.ADD_BONUS, {value:int(st.substring(0, ind)), index:int(st.substring(ind + 1))}));
							}
						}
					}
					break;
				}
			}
		}
		
		
		/**
		 * Réception events panneau affichage quiz
		 *	@param event Event
		 */
		private function panelHandler (event:Event) : void
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
						// on passe au quiz suivant
						nextQuiz();
					}
					break;
				}
				case Panel.CLOSE :
				{
					complete();
					sendEvent(new Event(EventList.UNFREEZE_SCENE));
					break;
				}
			}
		}
		
		/**
		 * Réception données de quiz
		 *	@param result Object
		 */
		private function handleDataQuiz (result:Object) : void
		{
			if (!result) nextQuiz();
			
			// on stock les data brutes
			data = result;

			if (_quiz == null) _initDisplay();

			// on construit le qcm
			_quiz.clear();
			_quiz.questionTitle = data.question;
			_quiz.dataProvider = data.responses;
			_quiz.explanation = data.explanation;
			positionPanel();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@private
		 *	Lance la récupération des data d'un Qcm
		 */
		private function callForData () : void
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
							handleDataQuiz(data);
							break;
						}
					}
				}
				else
				{
					// Récup data depuis serveur
					IClientServer(facade.getProxy(ProxyList.SERVER_PROXY)).getServices("quiz").load({keys:quizId},
																																handleDataQuiz,
																																handleDataQuiz);
				}
			}
			else
			{
				sendEvent(new Event(EventList.UNFREEZE_SCENE));
				complete();
			}
				
		}
		
		/**
		 *	Supprime les qcm déjà joués de la liste
		 * d'attente des qcm
		 */
		private function removePlayedFromQueue () : void
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
		
		/**
		 * @inheritDoc
		 */
		override public function release() : void
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
				sourceTarget.mouseEnabled = true;

			super.release();
		}
		
		override protected function onDiffer():void
		{
			sendEvent(new Event(EventList.FREEZE_SCENE));
		}
		
		/*
		*	Return lib proxy reference
		*/
		protected function get libProxy() : LibProxy
		{ return LibProxy(facade.getProxy(LibProxy.NAME)); }
				
	}
	
}

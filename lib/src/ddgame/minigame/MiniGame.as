package ddgame.minigame {
		
	import flash.events.*;
//	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.display.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import gs.TweenMax;
	import gs.easing.*
	
	import org.osflash.signals.*;
	import br.com.stimuli.loading.BulkLoader;
	
	import ddgame.client.events.EventList;
	import com.sos21.events.BaseEvent;
	import ddgame.minigame.*
	
	/**
	 *	Classe de base pour les mini-jeux
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public class MiniGame extends Sprite {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		public function MiniGame ()
		{
			super();
			
			_loader = BulkLoader.getLoader("minigame");
			
			// TODO check des paramètres
			/*var params:Object = loaderInfo.parameters;
			if (params.hasOwnProperty("autoStart"))
			{
				if (params.autoStart) {					
					trace(this, "AUTOSTART");
				}
			}*/
		}
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		// ?
		public var tween:Class = TweenMax;
		public var ease:Object = {
			Back:gs.easing.Back,
			Strong:gs.easing.Strong,
			Bounce:gs.easing.Bounce,
			Elastic:gs.easing.Elastic,
			Quint:gs.easing.Quint			
		}
		
		//
		protected var _init:Boolean = false;
		// objet _configuration ()
		protected var _config:Object;
		// objet _data
		protected var _data:Object;
		// _data pour le niveau de difficulté en cours
		protected var _levelData:Object;
		// trigger / controleur
		protected var trigger:Object;
		// état en jeu
		protected var _playing:Boolean = false;
		// état en pause
		protected var _paused:Boolean = false;
		// état en cours
		protected var _currentState:String;
		// interface graphique principale
		protected var _gui:Object;
		// popup
		protected var _popup:Object;
		// conteneur de la partie jeu
		protected var _screen:Object;
		//fond de jeu
		protected var background:Object;
		// timer compte à rebours
		protected var _tCountdown:Timer;
		
		// niveau de difficulté
		private var _level:int;
		
		protected var _leave:Signal = new Signal();
		protected var _loader:BulkLoader;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne le titre du jeu.
		 * Le titre renseigné dans la balise titre  du niveau en
		 * cours, sinon le titre principal
		 */
		public function get title () : String
		{
			if (_data)
			{
				var t:String;
				if (_levelData)
				{
					t = _levelData.title;
						if (!t) t = _data.title;
				}
			}
			return t;
		}
		
		/**
		 * Retourne le texte d'aide du jeu.
		 * Le texte renseigné dans la balise help du niveau en
		 * cours, sinon le texte principal
		 */
		public function get help () : Object
		{
			if (_data)
			{
				var t:Object;
				if (_levelData)
				{
					t = _levelData.help[0];
						if (!t) t = _data.help[0];
				}
			}
			return t;
		}
		
		/**
		 * Retourne le texte d'intro du jeu.
		 * Le texte renseigné dans la balise intro du niveau en
		 * cours, sinon le texte principal
		 */
		public function get intro () : Object
		{
			if (_data)
			{
				var t:Object;
				if (_levelData)
				{
					t = _levelData.intro[0];
						if (!t) t = _data.intro[0];
				}
			}
			return t;
		}
		
		/**
		 * Retourne le texte temps limite dépassé du jeu.
		 * Le texte renseigné dans la balise du niveau en
		 * cours, sinon le texte principal
		 */
		public function get timeOut () : Object
		{
			if (_data)
			{
				var t:Object;
				if (_levelData)
				{
					t = _levelData.timeOut[0];
						if (!t) t = _data.timeOut[0];
				}
			}
			return t;			
		}
		
		
		/**
		 * Retourne le nombre de secondes si un temps
		 * limité est définit pour le niveau en cours
		 */
		public function get timeLimit () : int
		{
			return int(_levelData.timeLimit);
		}
		
		/**
		 * Niveau de difficulté 
		 */
		public function set level (val:int) : void
		{
			_level = val;
			
			if (_data)
			{
				var ld:Object = _data.level.(@id == val)[0];
				if (ld) _levelData = ld;
			}
		}
		
		public function get level () : int
		{
			return _level;
		}
		
		/**
		 * Data pour le niveau en cours
		 */
		public function get levelData () : Object
		{
			return _levelData;
		}
		
		/**
		 * Retourne l'état en cours
		 */
		public function get currentState () : String
		{
			return _currentState;
		}
		
		/**
		 * Retourne la vue
		 */
		public function get view () : Sprite {
			return this;
		}
		
		/**
		 * Retourne le signal quitter le jeu
		 */
		public function get leave () : ISignal
		{
			return _leave;
		}
		
		/**
		 * Retourne la saison actuelle
		 * @return entier entre 0 et 4 (hiver, printemps, été, automne)
		 */
		/*public function get currentSeason () : int
		{
			var d:Date = new Date();
			var m:int = d.month;
			return 
		}*/
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Retounrne un decripteur d'asset
		 *	@param id *	identifiant de l'asset
		 *	@return Object
		 */
		public function getAssetDescriptor (id:*) : Object
		{
			return _data.assets.a.(@id == id);
		}
		
		/**
		 * Retourne un asset
		 * Une copie encapsulée dans un Loader si l'asset à été loader sous forme
		 * binaire, une classe si le param def est stipulé et si l'asset à été chargé
		 * dans son format natif (non binaire)
		 *	@param id *	identifiant de l'asset
		 *	@param def définition de classe
		 *	@return Object
		 */
		public function getAsset (id:*, def:String = null) : Object
		{
			var f:String = getAssetDescriptor(id).@f;

			// on est sur la recup d'une classe
			var ass:Object;
			if (def)
			{
				ass = _loader.getContent(f).loaderInfo.applicationDomain.getDefinition(def) as Class;
			}
			else
			{
				ass = new Loader();
				ass.loadBytes(_loader.getBinary(f));
			}
			
			return ass;
		}
				
		public function getInfo (id:*) : Object
		{
			if (_data)
			{
				var t:Object;
				if (_levelData)
				{
					t = _levelData.info.(@id == id)[0];
						if (!t) t = _data.info.(@id == id)[0];
				}
			}
			return t;
		}
		
		/**
		 * Démarre le jeu
		 */
		public function start (conf:Object = null) : void
		{
			if (conf) setConfig(conf);

			// check si un level est définit
			if (!_levelData)
			{
				// aucun _levelData, veut dire que _level n'à pas été définit,
				// on définit niveau 1 par défaut
				level = 1;
				if (!_levelData)
				{
					trace(this, "fatal error : Aucun descripteur de niveau");
					return;
				}
			}
			
			// première initialisation
			if (!_init) init();
			
			// if ("@nogui" in _levelData) return;

			/*// check si l'interface principale est là
			if (_gui)
				if (!contains(DisplayObject(_gui))) init();
			
			// affichage compte à rebours ou pas
			var cd:int = timeLimit;
			if (cd > 1)
			{
				_gui.showCountDown = true;
				_gui.countDownValue = cd;
				_tCountdown = new Timer(1000, cd);
				_tCountdown.addEventListener(TimerEvent.TIMER, handleTimer);
				_tCountdown.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
			}*/
		}
		
		/**
		 * Définit un état du jeu
		 *	@param state String
		 */
		public function setState (state:String) : void
		{
			if (_currentState == state) return;
			
			switch (state)
			{
				case MiniGameState.INTRO :
				{
					displayIntro();
					break;
				}
				case MiniGameState.HELP :
				{
					pause();
					displayHelp();
					break;
				}
				case MiniGameState.TIME_OUT :
				{
					displayTimeOut();
					break;
				}
				case MiniGameState.END :
					pause();
					break;
			}
			
			_currentState = state;
		}
		
		/**
		 * Stop le jeu
		 */
		public function stop () : void
		{
			
		}
		
		/**
		 * Met en pause le jeu
		 */
		public function pause () : void
		{
			if (timeLimit) _tCountdown.stop();
			_paused = true;
		}
		
		/**
		 * Reprend le jeu
		 */
		public function resume () : void
		{
			if (timeLimit) _tCountdown.start();
			_paused = false;
		}
		
		/**
		 * Définit la configuration
		 *	@param val Object
		 */
		public function setConfig (conf:Object) : void
		{
			for (var p:String in conf)
			{
				if (hasOwnProperty(p)) this[p] = conf[p];
			}
			
			_config = conf;
		}
		
		/**
		 * Définit les données
		 *	@param val Object
		 */
		public function setData (val:Object) : void
		{
			_data = val;
			if (_level) level = _level;
		}
		
		/**
		 *	@private
		 */
		public function setTrigger (val:Object) : void
		{
			trigger = val;
		}
		
		public function quit () : void
		{
			_leave.dispatch();
		}
		
		/**
		 *	Relâche / nettoyage
		 */
		public function release () : void
		{
			if (_tCountdown)
			{
				_tCountdown.stop();
				_tCountdown.removeEventListener(TimerEvent.TIMER, handleTimer);
				_tCountdown.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
				_tCountdown = null;
			}
			
			if (_popup)
			{
				_popup.validated.removeAll();
				_popup.canceled.removeAll();
				_popup.closed.removeAll();
				_popup = null;
			}
			
			_gui.buttonClicked.removeAll();
			_leave.removeAll();
			
			trigger = null;
			_config = null;
			_data = null;
			_popup = null;
			_gui = null;
			_screen = null;
			_tCountdown = null;
			_leave = null;
			_loader.removeAll();
			_loader = null;
		}
		
		public function dispatchBonus (b:int, t:int) : void
		{
			trigger.sendEvent(new BaseEvent(EventList.ADD_BONUS, {bonus:b, theme:t}));
		}
		
		/**
		 *	@param a Array
		 * Mélange un tableau
		 */
		public function shuffleArray (a:Array) : void
		{
			var n:int = a.length;
			var nn:int = n;
			while (--n > -1)
				a.splice(Math.random() * nn, 0, a.shift());
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * Réception cliques sur boutons de la popup principale
		 *	@param btn String
		 */
		/*protected function onClickPopup (btn:String) : void
		{
			switch (btn)
			{
				case "close" :
				{
					closePopup();
					break;
				}
				case "validate" :
				{					
					closePopup();
					break;
				}
				case "cancel" :
				{
					closePopup();
					break;
				}
			}
			

		}*/
		
		protected function onValidatePopup () : void
		{
			closePopup();
			switch (_currentState)
			{
				case MiniGameState.INTRO :					
					setState(null);
					if (timeLimit) _tCountdown.start();
					unfreezeScreen();
					break;
				case MiniGameState.HELP :
					setState(null);
					unfreezeScreen();
					resume();
					break;
				case MiniGameState.TIME_OUT :
					quit()
					break;
				case MiniGameState.END :
					quit();
					break;
			}
		}
		
		protected function onCancelPopup () : void
		{
			closePopup();
		}
		
		protected function onClosePopup () : void
		{
			if (_paused) resume();
		}
		
		/**
		 * Réception cliques dans l'interface principale
		 *	@param btn String
		 */
		protected function onClickGui (btn:String) : void
		{
			switch (btn)
			{
				case "help" :
					setState(MiniGameState.HELP);
					break;
				case "quit" :
					quit();
					break;
			}
		}
		
		/**
		 * Réception events des timers
		 *	@param e TimerEvent
		 */
		protected function handleTimer (e:TimerEvent) : void
		{
			// on est sur le timer du temps limite
			if (e.target == _tCountdown)
			{
				if (e.type == TimerEvent.TIMER) _gui.countDownValue -= 1;
				else
				{
					_tCountdown.removeEventListener(TimerEvent.TIMER, handleTimer);
					_tCountdown.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
					setState(MiniGameState.TIME_OUT);
				}
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Affiche l'intro de base (popup de texte)
		 *	@private
		 */
		protected function displayIntro () : void
		{
			if (!intro) return;
			var dt:Object = intro.pop;
			if (!dt) return;
			openPopup(dt.children());
			freezeScreen();
		}
		
		/**
		 * Affiche l'aide
		 *	@private
		 */
		protected function displayHelp () : void
		{
			if (!help) return;
			var dt:Object = help.pop;
			if (!dt) return;
			openPopup(dt.children());
			freezeScreen();
		}

		protected function displayTimeOut () : void
		{
			if (!timeOut) return;
			var dt:Object = timeOut.pop;
			if (!dt) return;
			openPopup(dt.children());
			freezeScreen();			
		}
		
		/**
		 * Affiche la popup de texte principale.
		 * Si modal est passé à true, l'interface utilisateur et l'écran de jeu seront figés
		 *	@param descriptor Object descripteur propriétés de la popup
		 *	@param modal Boolean
		 */
		public function openPopup (descriptor:Object = null, modal:Boolean = true) : void
		{
			_gui.resetPopup(_popup);
			
			addChild(DisplayObject(_popup));

			for each (var n:XML in descriptor) {
				_popup[n.name()] = n;
			}
			
			_popup.modal = modal;

			if (modal)
			{
				_gui.enabled = false;
				freezeScreen();
				// centrage quand on est en modal
				_popup.x = (840 - _popup.width) / 2;
				_popup.y = (480 - _popup.height) / 2;
			}
			
			TweenMax.from(_popup, 0.3, {y:_popup.y + 30, ease:Back.easeOut});
		}
		
		/**
		 * Ferme la popup de texte principale, la popup était affiché
		 * en mode modale, l'interface utilisateur du jeu est dé-figée
		 *	@private
		 */
		protected function closePopup () : void
		{
			if (_popup.modal) _gui.enabled = true;
			if (contains(DisplayObject(_popup)));
				removeChild(DisplayObject(_popup));
		}
		
		/**
		 * Fige l'aire de jeu, pas d'intercation souris dessus
		 * et ajout effet de transparence
		 *	@private
		 */
		protected function freezeScreen () : void {
			_screen.alpha = 0.8;
			_screen.mouseEnabled = _screen.mouseChildren = false;
		}
		
		/**
		 * Dé fige l'aire de jeu
		 *	@private
		 */
		protected function unfreezeScreen () : void {
			_screen.alpha = 1;
			_screen.mouseEnabled = _screen.mouseChildren = true;
		}
		
		/**
		 *	@private
		 * Mets en place le fond de jeu (si référencé) dans
		 * le data level en cours
		 */
		protected function drawBackground () : void
		{
			if (background)
				if (contains(DisplayObject(background))) removeChild(DisplayObject(background));
				
			if ("background" in _levelData)
			{
				var o:Object;
				var n:Object = _levelData.background[0];
				var a:Object = getAssetDescriptor(n.@a);
				// on a un identifiant de classe
				if ("@c" in n) {
					var c:Class = getAsset(n.@a, n.@c) as Class;
					o = new c;
				} else {
					// TODO voir getAsset, le loader n'à pas eut le temps de charger, il faudrait
					// pouvoir recup le Loader.content...
					o = new MovieClip();
					o.addChild(getAsset(n.@a));
				}
				
				o.x = n.@x;
				o.y = n.@y;
				addChildAt(DisplayObject(o), 0);
				background = o;
			}
		}
		
		/**
		 *	@private
		 * Première initialisation
		 */
		protected function init () : void
		{
			// temps limite
			var tl:int = timeLimit;
			var ctdown:Boolean = tl > 1;
			if (ctdown)
			{
				_tCountdown = new Timer(1000, tl);
				_tCountdown.addEventListener(TimerEvent.TIMER, handleTimer);
				_tCountdown.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);
			}

			if (_gui)
			{
				// pop pricipale
				_popup = _gui.createPopup();
				_popup.validated.add(onValidatePopup);
				_popup.canceled.add(onCancelPopup);
				_popup.closed.add(onClosePopup);
				// affichage compte à rebours ou pas
				if (ctdown)
				{
					_gui.showCountDown = true;
					_gui.countDownValue = tl;
				}
			}
			
			// affichage si interface
			if (trigger.getPropertie("gui"))
			{
				_gui.title = title;
				_gui.buttonClicked.add(onClickGui);
				addChild(DisplayObject(_gui));
			}

			_init = true;
		}
		
	}

}


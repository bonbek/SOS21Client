package ddgame.minigame {
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	
	import org.osflash.signals.*;
	import org.osflash.signals.natives.*;
	
	import gs.TweenMax;
	import gs.easing.*
	
	import ddgame.minigame.*;
	
	/**
	 *	Interface graphique mini-jeux par défaut
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	[Embed(source="../../assets/commons.swf", symbol="MainGui")]
	public class MiniGameGUI extends MovieClip implements IMiniGameGUI {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function MiniGameGUI ()
		{
			super();

			_nSignal = new NativeSignal(this, Event.ADDED_TO_STAGE, Event);
			_nSignal.addOnce(handleAdded);
			_btnCliked = new Signal();

			// police par défaut pour les composant de l'interface
			Font.registerFont(MgUIFont);
			MiniGameUIComponent.defaultFont = "MgUIFont";
			// formatage textfield titre du jeu
			var tf:TextFormat = fTitle.defaultTextFormat;
			fTitle.embedFonts = true;
			tf.font = "MgUIFont";
			fTitle.defaultTextFormat = tf;
			
			// masquage compte à rebours
			showCountDown = false;
			enabled = true;
		}
		
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		// instances posées
		public var fTitle:TextField;
		public var countDown:MovieClip;
		public var helpBtn:SimpleButton;
		public var quitBtn:SimpleButton;
		public var cornertop:MovieClip;
		public var cornerbottom:MovieClip;
		
		[Embed(source="../../assets/CooperBlackStd.otf", fontName="MgUIFont", fontWeight="Black", mimeType="application/x-font-truetype")]
		public static var MgUIFont:Class;

		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		protected var _theme:Object;
		protected var _btnCliked:Signal;
		protected var _nSignal:NativeSignal;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Définit le titre
		 */
		public function set title (val:String) : void
		{
			fTitle.text = val;
		}
		
		/**
		 * Etat activé / désactivé de cette interface utilisateur
		 */		
		override public function set enabled (val:Boolean) : void
		{
			if (val)
			{
				addEventListener(MouseEvent.MOUSE_UP, handleMouse);
				addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
				mouseChildren = mouseEnabled = true;
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_UP, handleMouse);
				removeEventListener(MouseEvent.MOUSE_OVER, handleMouse);
				removeEventListener(MouseEvent.MOUSE_OUT, handleMouse);				
				mouseChildren = mouseEnabled = false;
			}
				
			super.enabled = val;
		}
		
		/**
		 * Affichage / masquage du compteur
		 */
		public function get showCountDown () : Boolean
		{
			return countDown.visible;
		}
		
		public function set showCountDown (val:Boolean) : void
		{
			countDown.visible = val;
		}
		
		/**
		 * Retourne la conversion en secondes de la valeur
		 * affichée par le compteur
		 */
		public function get countDownValue () : int
		{
			var v:int = int(countDown.m.text * 60) + int(countDown.s.text);
			return v;
		}
		
		/**
		 * Définit la valeur affichée du compteur (minutes : secondes)
		 * @param	int	nombre de secondes
		 */
		public function set countDownValue (val:int) : void
		{
			countDown.m.text = int(val / 60);
			countDown.s.text = val % 60;
		}
		
		public function get theme () : Object
		{
			return _theme;
		}

		public function set theme (val:Object) : void
		{
			_theme = val;
		}
		
		public function get sprite () : Sprite
		{
			return this;
		}
		
		public function get buttonClicked () : ISignal
		{
			return _btnCliked;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		/**
		 * Crée une popup
		 */
		public function createPopup (descriptor:Object = null) : IMiniGamePopup
		{			
			return new MiniGamePopup();
		}
		
		/**
		 * Reset une popup
		 */
		public function resetPopup (popup:Object) : void
		{
			popup.title = popup.text = "";
			popup.validateLabel = popup.cancelLabel = null;
			popup.showCloseButton = false;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function handleMouse (e:MouseEvent) : void
		{
			switch (e.target)
			{
				case helpBtn :
					if (e.type == MouseEvent.MOUSE_UP)
						_btnCliked.dispatch("help");
					break;
				case quitBtn :
					switch (e.type)
					{
						case MouseEvent.MOUSE_OVER :
							TweenMax.to(cornerbottom, 0.3, {scaleX:1, scaleY:1, ease:Back.easeOut});
							break;
						case MouseEvent.MOUSE_OUT :
							TweenMax.to(cornerbottom, 0.3, {scaleX:0.6, scaleY:0.6, ease:Back.easeOut});
							break;
						default :
							_btnCliked.dispatch("quit");
							break;
					}
					break;
			}
		}
		
		protected function handleAdded (e:Event) : void
		{
			TweenMax.from(cornertop, 1, {width:0, height:0, ease:Back.easeOut});
			cornerbottom.scaleX = 0.6;
			cornerbottom.scaleY = 0.6;
			TweenMax.from(cornerbottom, 1, {width:0, height:0, ease:Back.easeOut});
			TweenMax.from(helpBtn, 1, {alpha:0, ease:Strong.easeOut});
			TweenMax.from(fTitle, 1, {alpha:0, x:fTitle.x - 50, delay:1.5, ease:Strong.easeOut});
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
	}

}


package ddgame.minigame {
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;

	import org.osflash.signals.*;
	import org.osflash.signals.natives.*;
	
	import ddgame.minigame.*;
	
	/**
	 *	Popup dans mini-jeux par défaut
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	public class MiniGamePopup extends MiniGameBox implements IMiniGamePopup {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function MiniGamePopup (w:int = 400, shcb:Boolean = false, styles:Object = null)
		{			
			super(w, 0, styles);
			_click = new NativeSignal(this, MouseEvent.MOUSE_UP, MouseEvent);
			_click.add(onClick);
//			_btnClicked = new Signal();
			validated = new Signal();
			canceled = new Signal();
			closed = new Signal();
			if (shcb) showCloseButton = true;
		}
	
		//---------------------------------------
		// PUBLIC VARIABLES
		//---------------------------------------
		
		// barre de bouton
		public var buttonBar:MiniGameBox;
		// bouton valider
		public var validateButton:MiniGameButton;
		// bouton annuler
		public var cancelButton:MiniGameButton;
		// bouton fermer
		public var closeButton:MiniGameButton;
		
		public var modal:Boolean = false;
		
		//--------------------------------------
		//  PRIVATE & PROTECTED VARIABLES
		//--------------------------------------
		
		// champ texte pour titre
		protected var _titleField:TextField;
		// champ texte pour texte
		protected var _textField:TextField;
		//
		protected var _click:NativeSignal;
		// Signal click sur bouton
		protected var _btnClicked:Signal;
		
		
		public var validated:Signal;
		public var canceled:Signal;
		public var closed:Signal;
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		/**
		 * titre
		 */
		public function set title (val:String) : void
		{
			_titleField.text = val;
			invalidateSize();
		}
		
		/**
		 * définit le texte
		 */
		public function set text (val:String) : void
		{
			_textField.htmlText = val;
			
			// kk, sinon la hauteur du textField n'est pas prise en compte pour le calcul de la hauteur
			// de ce composant...
			validate();
			if (parent)
				if (parent is MiniGameUIComponent) invalidateSize();
		}
		
		/**
		 * label du bouton valider
		 */
		public function set validateLabel (val:String) : void
		{
			if (val)
			{
				if (!validateButton)
				{
					validateButton = new MiniGameButton();
					buttonBar.addChild(validateButton);
				}

				validateButton.label = val;				
			}
			else
			{
				if (validateButton)
				{
					buttonBar.removeChild(validateButton);
					validateButton = null;
				}
			}
			
			invalidateSize();
		}
		
		/**
		 * label du bouton annuler
		 */
		public function set cancelLabel (val:String) : void
		{
			if (val)
			{
				if (!cancelButton)
				{
					cancelButton = new MiniGameButton();
					buttonBar.addChildAt(cancelButton, 0);
				}

				cancelButton.label = val;				
			}
			else
			{
				if (cancelButton)
				{
					buttonBar.removeChild(cancelButton);
					cancelButton = null;
				}
			}
			
			invalidateSize();
		}
		
		/**
		 * Affichage du bouton fermer
		 */
		public function set showCloseButton (val:Boolean) : void
		{
			if (val && !closeButton)
			{
				closeButton = new MiniGameButton(22,22, {cornerRadius:22});
				var cross:Shape = new Shape();
				cross.graphics.lineStyle(3, 0xFFFFFF);
				cross.graphics.moveTo(1, 1);
				cross.graphics.lineTo(7, 7);
				cross.graphics.moveTo(7, 1);
				cross.graphics.lineTo(1, 7);
				cross.graphics.endFill();
				
				closeButton.setStyle("icon", cross);
				closeButton.includeInLayout = false;
				addChild(closeButton);
//				addEventListener(MouseEvent.MOUSE_UP, handleCloseButton);
				invalidateSize();
			}
			else if (closeButton)				
			{
				removeChild(closeButton);
				closeButton = null;
			}
		}
		
		public function get theme () : Object
		{
			return {};
		}
		
		public function set theme (val : Object) : void
		{
			
		}
		
		/**
		 * Retourne la vue
		 */
		public function get sprite () : Sprite
		{
			return this;
		}
		
		public function get buttonClicked () : ISignal
		{
			return _btnClicked;
		}
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
	
		/**
		 * Ajoute un contenu
		 */
		public function addContent (val:Object) : void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validate (e:Event = null) : Boolean
		{
			// redimensionement des champs textes
			var tw:int = _width ? _width : width;
			tw -= whiteSpacesWidth;
			_titleField.width = tw;
			_textField.width = tw;
			
			// callage position du bouton fermer
			if (closeButton)
			{
				closeButton.x = tw;
				closeButton.y = 10;
			}
			
			return super.validate(e);
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		protected function onClick (e:MouseEvent) : void
		{
			switch (e.target)
			{
				case closeButton :
					parent.removeChild(this);
					closed.dispatch();
					break;
				case validateButton :
					validated.dispatch();
					break;
				case cancelButton :
					canceled.dispatch();
					break;
			}
		}
		
		/**
		 * Réception events du bouton fermer
		 *	@param e MouseEvent
		 */
		protected function handleCloseButton (e:MouseEvent) : void
		{
			removeEventListener(MouseEvent.MOUSE_UP, handleCloseButton);
			parent.removeChild(this);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function drawChildren () : void
		{
			// check des styles
			_styles.direction = "vertical";
			_styles.verticalAlign = "top";
			if (!("backgroundColor" in _styles)) 	_styles.backgroundColor = 0xFFFFFF;
			if (!("fontFamily" in _styles)) 			_styles.fontFamily = "Arial";
			if (!("fontSize" in _styles))				_styles.fontSize = 16;
			if (!("fontColor" in _styles))			_styles.fontColor = 0x000000;
			if (!_styles.paddingLeft)					_styles.paddingLeft = 20;
			if (!_styles.paddingRight)					_styles.paddingRight = 20;
			if (!_styles.paddingTop)					_styles.paddingTop = 20;
			if (!_styles.paddingBottom)				_styles.paddingBottom = 20;
			
			// TODO à passer de manière inteligente dans setStyle ?
			var tf:TextFormat = new TextFormat(_styles.fontFamily, _styles.fontSize, _styles.fontColor);
			
			// champ titre
			_titleField = new TextField();
			_titleField.autoSize = TextFieldAutoSize.LEFT;
			_titleField. multiline = true;
			_titleField.wordWrap = true;
//			_titleField.embedFonts = true;
			_titleField.selectable = false;
			
			// champ texte
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = true;
			_textField.wordWrap = true;
//			_textField.embedFonts = true;
			_textField.selectable = false;
			
			_textField.defaultTextFormat = tf;
			tf.bold = true;
			_titleField.defaultTextFormat = tf;
			
			// barre de boutons
			buttonBar = new MiniGameBox();
			buttonBar.percentWidth = 100;
			
			//addChild(_titleBar);
			addChild(_titleField);
			addChild(_textField);
			addChild(buttonBar);
		}
		
		/**
		 * @inheritDoc // TODO TEMP
		 */
		override protected function drawBackGround (w:int, h:int) : void
		{
//			var w:int = width;
//			var h:int = height;

			// on dessine l'ombre
			graphics.clear();
			graphics.beginFill(0x000000, 0.4);
			graphics.moveTo(0, 2);
			graphics.lineTo(w - 1, 0);
			graphics.curveTo(w - 1, int(h / 3), w + 6, h + 3);
			graphics.lineTo(6, h + 8);
			// on dessine le fond
			graphics.beginFill(_styles.backgroundColor);
			graphics.moveTo(0, 2);
			graphics.lineTo(w - 2, 0);
			graphics.curveTo(w - 4, int(h / 3), w, h - 5);
			graphics.lineTo(1, h);
			graphics.endFill();		
		}
	
	}

}
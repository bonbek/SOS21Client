package ddgame.minigame {
	
	import flash.events.Event;
	import flash.display.*;
	import flash.text.Font;
	
	/**
	 *	Composant interface utilisateur abstrait
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	public class MiniGameUIComponent extends Sprite {
		
		/*[Embed(source="../../assets/CooperBlackStd.otf", fontName="miniGameUIFont", fontWeight="black", mimeType="application/x-font")]
		public static var mguiFont:Class;

		Font.registerFont(mguiFont);*/
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function MiniGameUIComponent (w:int = 0, h:int = 0, styles:Object = null) : void
		{
			super();
			_width = w;
			_height = h;
			_styles = styles ? styles : {};
			
			// padding par defaut
			if (!("paddingLeft" in _styles))		_styles.paddingLeft = 0;
			if (!("paddingRight" in _styles))	_styles.paddingRight = 0;
			if (!("paddingTop" in _styles))		_styles.paddingTop = 0;
			if (!("paddingBottom" in _styles)) 	_styles.paddingBottom = 0;
					
			drawChildren();
			invalidateSize();
		}
		
		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		public static var defaultFont:String = "Arial";
		
		// TODO temp
		public var includeInLayout:Boolean = true;
		
		// styles
		protected var _styles:Object;
		// largeur en pixels
		protected var _width:Number;
		// hauteur en pixels
		protected var _height:Number;
		// largeur en pourcentage
		protected var _percentWidth:Number = 0;
		// hauteur en pourcentage
		protected var _percentHeight:Number = 0;
		// ...
		protected var _invalidateSize:Boolean;
		protected var _invalidateStyle:Boolean;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 * Si une largeur à été fixée, retourne celle-ci.
		 * Si un pourcentage d'ocupation largeur à été définit retourne
		 * la dimension calculée d'après le 'conteneur' de ce composant.
		 * Sinon retourne 0, valeur à considérer comme une dimension non définie.
		 */
		override public function get width () : Number
		{
			if (_width)
			{
				return _width;
			}
			else if (_percentWidth && parent)
			{
				var p:Object = Object(parent);
				var w:Number;
				if (p == root) w = stage.stageWidth * _percentWidth / 100;
				else if (p is MiniGameUIComponent) w = p.computeWidth(this);
				else
					w = p.width * _percentWidth / 100;

				return w;
			}

			return 0;
		}
		
		/**
		 * @inheritDoc
		 * Définit la largeur fixée en pixels du composant.
		 * Définir cette propriété à une valeur positive annule la prise
		 * en compte d'un dimensionnement calculé sur le pourcentage (voir percentWidth).
		 * Passer cette propriété à 0 pour annuler la prise en compte de
		 * celle-ci dans le calcule des redimensionements.
		 */
		override public function set width (val:Number) : void
		{
			if (_width != val)
			{
				_width = val;
				_percentWidth = 0;
				invalidateSize();
			}
		}
		
		/**
		 * @inheritDoc
		 * Si une hauteur à été fixée, retourne celle-ci.
		 * Si un pourcentage d'ocupation hauteur à été définit retourne la
		 * dimension calculée d'après le 'conteneur' de ce composant.
		 * Sinon retourne 0, valeur à considérer comme une dimension non définie.
		 */
		override public function get height () : Number
		{
			if (_height)
			{
				return _height;
			}
			else if (_percentHeight && parent)
			{
				var p:Object = Object(parent);
				var h:Number;
				if (p == root) h = stage.stageHeight * _percentHeight / 100;
				else if (p is MiniGameUIComponent) h = p.computeHeight(this);
				else
					h = p.height * _percentHeight / 100;

				return h;
			}
			
			return 0;
		}
		
		/**
		 * @inheritDoc
		 * Définit la hauteur fixée en pixels du composant.
		 * Définir cette propriété à une valeur positive annule la prise
		 * en compte d'un dimensionnement calculé sur le pourcentage (voir percentHeight).
		 * Passer cette propriété à 0 pour annuler la prise en compte de
		 * celle-ci dans le calcule des redimensionements.
		 */
		override public function set height (val:Number) : void
		{
			if (_height != val)
			{
				_height = val;
				_percentHeight = 0;
				invalidateSize();
			}
		}
		
		/**
		 * Retourne le pourcentage d'occupation en largeur du conteneur de ce composant.
		 * Une valeur de 0 pour cette propriété est à considérer comme propriété null
		 * ou non définie.
		 */
		public function get percentWidth () : Number
		{
			return _percentWidth;
		}
		
		/**
		 * Définit le pourcentage d'occupation en largeur du conteneur de ce composant.
		 * Définir cette propriété à une valeur positive annule la prise
		 * en compte d'un dimensionnement fixé (voir width).
		 * Passer cette propriété à 0 pour annuler la prise en compte de
		 * celle-ci dans le calcule des redimensionements.
		 */
		public function set percentWidth (val:Number) : void
		{
			if (_percentWidth != val)
			{
				_percentWidth = val;
				_width = 0;
				invalidateSize();
			}			
		}
		
		/**
		 * Retourne le pourcentage d'occupation en hauteur du conteneur de ce composant.
		 * Une valeur de 0 pour cette propriété est à considérer comme propriété null
		 * ou non définie.
		 */
		public function get percentHeight () : Number
		{
			return _percentHeight;
		}
		
		/**
		 * Définit le pourcentage d'occupation en hauteur du conteneur de ce composant.
		 * Définir cette propriété à une valeur positive annule la prise
		 * en compte d'un dimensionnement fixé (voir height).
		 * Passer cette propriété à 0 pour annuler la prise en compte de
		 * celle-ci dans le calcule des redimensionements.
		 */
		public function set percentHeight (val:Number) : void
		{
			if (_percentHeight != val)
			{
				_percentHeight = val;
				_height = 0;
				invalidateSize();
			}			
		}
		
		/**
		 * Retourne la mesure des espaces blancs en largeur de ce composant
		 */
		public function get whiteSpacesWidth () : Number
		{
			return _styles.paddingLeft + _styles.paddingRight;
		}

		/**
		 * Retourne la mesure des espaces blancs en hauteur de ce composant
		 */
		public function get whiteSpacesHeight () : Number
		{
			return _styles.paddingTop + _styles.paddingBottom;
		}
		
		public function get enabled () : Boolean
		{
			return (buttonMode && mouseEnabled);
		}
		
		public function set enabled (val:Boolean) : void
		{
			if (val)
			{
				alpha = 1;
				buttonMode = mouseEnabled = true;
			}
			else
			{
				alpha = 0.9;
				buttonMode = mouseEnabled = false;
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * TODO documenter
		 *	@param o Object
		 *	@return Number
		 */
		public function computeWidth (o:Object) : Number
		{
			trace("UIComponent computeWidth", o);
			return o.width;
		}
		
		/**
		 * TODO documenter
		 *	@param o Object
		 *	@return Number
		 */
		public function computeHeight (o:Object) : Number
		{
			return o.height;
		}
		
		/**
		 * Redimensionne le composant.
		 *	@param w int	largeur
		 *	@param h int	hauteur
		 */
		public function setSize (w:Number, h:Number) : void
		{
			width = w;
			height = h;
		}
		
		/**
		 * Retourne un style du composant
		 *	@private
		 *	@return 
		 */
		public function getStyle (prop:String) : *
		{
			return _styles.hasOwnProperty(prop) ? _styles[prop] : null;
		}
		
		/**
		 * Définition d'un style du composant
		 *	@param prop String
		 *	@param val *
		 */
		public function setStyle (prop:String, val:*) : void
		{
			_styles[prop] = val;
			invalidateStyle();
		}
		
		/**
		 *	Mise en validation du composant pour un changement
		 * de taille
		 */
		public function invalidateSize () : void
		{
			// si le parent est un MiniGameUIComponent, celui-ci prend
			// la main sur la validation
			if (parent)
			{
				if (parent is MiniGameUIComponent)
				{
					_invalidateSize = true;
					MiniGameUIComponent(parent).invalidateSize();
					return;
				}
			}
			
			if (_invalidateSize) return;	
			
			_invalidateSize = true;
			invalidate();
		}
		
		/**
		 *	Mise en validation du composant pour un changement
		 * de style
		 */
		public function invalidateStyle () : void
		{
			if (_invalidateStyle) return;
			
			// si le parent est un MiniGameUIComponent, celui-ci prend
			// la main sur la validation
			if (parent)
			{
				if (parent is MiniGameUIComponent)
				{
					_invalidateStyle = true;
					MiniGameUIComponent(parent).invalidateStyle();
					return;
				}
			}
			
			_invalidateStyle = true;
			invalidate();
		}
		
		/**
		 *	Mise en validation
		 */
		public function invalidate () : void
		{
			addEventListener(Event.ENTER_FRAME, validate);
		}
		
		/**
		 * Méthode de validation à ovverider
		 *	@param e Event
		 *	@return Boolean
		 */
		public function validate (e:Event = null) : Boolean
		{
//			trace(this, "validate");
			if (!parent) return false;

			removeEventListener(Event.ENTER_FRAME, validate);
			
			return true;
		}
		
		/**
		 * @inheritDoc
		 * TODO pas très jojo
		 */
		override public function toString () : String
		{
			return super.toString() + "[" + name + "]";
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 *	Méthode initialisation à overrider;
		 */
		protected function drawChildren () : void {
		}
		
	}

}
package ddgame.minigame {
	
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.MouseEvent;
	
	/**
	 *	Composant interface utilisateur abstrait
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	public class MiniGameButton extends MiniGameUIComponent {
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function MiniGameButton (w:int = 0, h:int = 0, styles:Object = null) : void
		{
			super(w, !h ? 30 : h, styles);
			
			mouseChildren = false;
			enabled = true;
		}

		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		protected var _label:TextField;
		protected var _icon:DisplayObject;
		protected var _overStyles:Object;
		protected var mouseOver:Boolean = false;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		override public function get width () : Number
		{
			var w:int = super.width;
			if (!w)
			{
				w = whiteSpacesWidth;
				if (label.length > 0)
					w += _label.textWidth;
				if (_icon != null)
					w += _icon.width + 10;
			}
			
			return w;
		}
		
		/**
		 * Retourne l'intitulé du bouton
		 */
		public function get label () : String
		{
			return _label.text;
		}
		
		/**
		 * Définit l'intitulé du bouton
		 */
		public function set label (val:String) : void
		{
			_label.text = val;
			invalidateSize();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled (val:Boolean) : void
		{
			super.enabled = val;

			if (val)
			{
				addEventListener(MouseEvent.MOUSE_OVER, handleMouse, false, 0);
				addEventListener(MouseEvent.MOUSE_OUT, handleMouse, false, 0);
			}
			else
			{
				removeEventListener(MouseEvent.MOUSE_OVER, handleMouse, false);
				removeEventListener(MouseEvent.MOUSE_OUT, handleMouse, false);
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function setStyle (prop:String, val:*) : void
		{
			if (prop == "icon" && _icon != val)
			{
				if (_icon) removeChild(_icon);
				
				if (val is DisplayObject)
				{
					_icon = val;
					addChild(_icon);
				}
			}

			super.setStyle(prop, val);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validate (e:Event = null) : Boolean
		{
			if (!super.validate(e)) return false;
			
			var hsLabel:Boolean = label.length > 0;		// on a un label
			var hsIcon:Boolean = _icon != null;				// on a un icon

			// dimensions
			var w:int = width;
			var h:int = height;
			// radius coins
			var cr:int = _styles.cornerRadius;
			// conteneur gfx
			var bck:Shape = getChildAt(0) as Shape;
			var brd:Shape = getChildAt(1) as Shape;
			// couleur fond
			var bgCol:uint = mouseOver ? _overStyles.backgroundColor : _styles.backgroundColor;
			// couleur bordure
			var bdCol:uint = mouseOver ? _overStyles.borderColor : _styles.borderColor;
			// alpha bordure
			var bdAlpha:Number = mouseOver ? _overStyles.borderAlpha : _styles.borderAlpha;
			
			// > ombre et fond
			bck.graphics.clear();
			bck.graphics.beginFill(0x000000, 0.2);
			bck.graphics.drawRoundRect(0, 0, w, h, cr);
			bck.graphics.beginFill(bgCol);
			bck.graphics.drawRoundRect(2, 2, w - 4, h - 4, cr);
			bck.graphics.endFill();
			// > bordure
			brd.graphics.clear();
			brd.graphics.beginFill(bdCol, bdAlpha);
			brd.graphics.drawRoundRect(2, 2, w - 3, h - 3, cr);
			brd.graphics.drawRoundRect(3, 3, w - 6, h - 6, cr);
			brd.graphics.endFill();
			
			// demi largeur et demi hauteur
			var wd:Number = w * .5;
			var hd:Number = h * .5;
			
			// > label & icon TODO quand on à une icone + un label
			if (hsIcon && !hsLabel)
			{
				_icon.x = wd - int(_icon.width * .5);
				_icon.y = hd - int(_icon.height * .5);	
			}
			else
			{
				_label.x = int(wd - (_label.width * .5));
				_label.y = int(hd - (_label.height * .5));
			}

			_invalidateSize = false;
			_invalidateStyle = false;
			
			return true;
		}
		
		//---------------------------------------
		// EVENT HANDLERS
		//---------------------------------------
		
		/**
		 * Réception event souris
		 *	@param event MouseEvent
		 */
		protected function handleMouse (event:MouseEvent) : void
		{
			if (event.type == MouseEvent.MOUSE_OVER) mouseOver = true;
			else
				mouseOver = false;
			
			invalidateStyle();
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override protected function drawChildren () : void
		{
			// Styles par défaut
			if (!_styles.paddingLeft)	 				_styles.paddingLeft = 15;
			if (!_styles.paddingRight) 				_styles.paddingRight = 15;
			if (!("align" in _styles)) 				_styles.align = "center";
			if (!("gap" in _styles)) 					_styles.gap = 6;
			if (!("backgroundColor" in _styles))	_styles.backgroundColor = 0xED2187;
			if (!("bordeColor" in _styles))			_styles.borderColor = 0x000000;
			if (!("bordeAlpha" in _styles))			_styles.borderAlpha = .4;
			if (!("fontFamily" in _styles))			_styles.fontFamily = defaultFont;
			if (!("fontSize" in _styles))				_styles.fontSize = 16;
			if (!("fontColor" in _styles))			_styles.fontColor = 0xFFFFFF;
			if (!("cornerRadius" in _styles))		_styles.cornerRadius = 10;
			
			// styles sur roll over
			if (!("over" in _styles))						_overStyles = {};
			else
				_overStyles = _styles.over;

			if (!("backgroundColor" in _overStyles))	_overStyles.backgroundColor = _styles.backgroundColor;
			if (!("bordeColor" in _overStyles))			_overStyles.borderColor = _styles.borderColor;
			if (!("bordeAlpha" in _overStyles))			_overStyles.borderAlpha = 0.6;
			
			// skin
			addChild(new Shape());
			addChild(new Shape());

			// label
			_label = new TextField();
			_label.embedFonts = true;
			_label.multiline = false;
			_label.wordWrap = false;
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;

			var tf:TextFormat = new TextFormat();
			tf.font = _styles.fontFamily;
			tf.size = _styles.fontSize;
			tf.color = _styles.fontColor;
			tf.align = "center";
			_label.defaultTextFormat = tf;
			
			addChild(_label);
		}
		
	}

}
package ddgame.minigame {
	
	import flash.events.Event;
	import flash.display.*;
	
	/**
	 *	Composant conteneur boite
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	public class MiniGameBox extends MiniGameUIContainer {
		
		//---------------------------------------
		// CLASS CONSTANTS
		//---------------------------------------
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function MiniGameBox (w:int = 0, h:int = 0, styles:Object = null) : void
		{
			super(w, h, styles);
			
			// direction par defaut
			if (!("direction" in _styles)) _styles.direction = HORIZONTAL;
			
			// direction par defaut
			if (!("horizontalAlign" in _styles)) _styles.horizontalAlign = CENTER;
			if (!("verticalAlign" in _styles)) _styles.verticalAlign = CENTER;
		}
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 * TODO explicatif
		 * Sinon retourne 0, valeur à considérer comme une dimension non définie.
		 */
		override public function get width () : Number
		{
			var w:Number = super.width;
			if (w <= 0)
			{

				if (!numChildren) return 0;

				if (_styles.direction == HORIZONTAL) w = _childsWidth + whiteSpacesWidth;
				else
					w = bigestChildWidth + _styles.paddingLeft + _styles.paddingRight;
			}
			
			return w;
		}
		
		/**
		 * @inheritDoc
		 * TODO explicatif
		 * Sinon retourne 0, valeur à considérer comme une dimension non définie.
		 */
		override public function get height () : Number
		{
			var h:Number = super.height;
			if (h <= 0)
			{
				if (!numChildren) return 0;
				
				if (_styles.direction == VERTICAL) h = _childsHeight + whiteSpacesHeight;
				else
					h = bigestChildHeight  + _styles.paddingTop + _styles.paddingBottom;
			}
			
			return h;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get whiteSpacesWidth () : Number
		{
			return _styles.direction == HORIZONTAL	? super.whiteSpacesWidth
																: _styles.paddingLeft + _styles.paddingRight;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get whiteSpacesHeight () : Number
		{
			return _styles.direction == VERTICAL	? super.whiteSpacesHeight
																: _styles.paddingTop + _styles.paddingBottom;
		}
			
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function computeWidth (o:Object) : Number
		{
			if (!("percentWidth" in o)) return super.computeWidth(o);

			var cw:Number;
			var w:Number = width;
			
			if (_styles.direction == HORIZONTAL)
			{
				// pourcentage largeur obj à calculer
				var opw:Number = o.percentWidth;
				// somme des pourcentages largeur enfants
				var cpw:Number = opw;
				// somme des largeur fixes enfants
				var csw:Number = 0;
				for each (var c:Object in _childs)
				{
					if (c != o)
					{
						if ("percentWidth" in c) cpw += c.percentWidth;
						else
							csw += c.width;
					}
				}
				
				// largeur prise par les enfants à taille fixes
				var wr:Number = w - csw - whiteSpacesWidth;
				// si la somme des pourcentage enfants depasse 100
				if (cpw > 100) opw = opw * (100 / cpw);
				cw = wr * opw / 100;
			}
			else
			{
				cw = w - (_styles.paddingLeft + _styles.paddingRight);
			}
			
			return cw;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function computeHeight (o:Object) : Number
		{
			if (!("percentHeight" in o)) return super.computeHeight(o);
			
			var ch:Number;
			var h:Number = height;
			
			if (_styles.direction == VERTICAL)
			{
				// pourcentage hauteur obj à calculer
				var oph:Number = o.percentHeight;
				// somme des pourcentages hauteur enfants
				var cph:Number = oph;
				// somme des hauteurs fixes enfants
				var csh:Number = 0;
				for each (var c:Object in _childs)
				{
					if (c != o)
					{
						if ("percentHeight" in c) cph += c.percentHeight;
						else
							csh += c.height;
					}
				}
				
				// hauteur prise par les enfants à taille fixes			
				var wh:Number = h - csh - whiteSpacesHeight;
				// si la somme des pourcentage enfants depasse 100
				if (cph > 100) oph = oph * (100 / cph);
				ch = wh * oph / 100;
			}
			else
			{
				ch = h - (_styles.paddingTop + _styles.paddingBottom);
			}
			
			return ch;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validate (e:Event = null) : Boolean
		{
			if (!super.validate(e)) return false;
			
			var n:int = _childs.length;
			if (n)
			{
				var pt:Number = _styles.paddingTop;
				var pl:Number = _styles.paddingLeft;
				var pb:Number = _styles.paddingBottom;
				var pr:Number = _styles.paddingRight;
				var ha:String = _styles.horizontalAlign;
				var va:String = _styles.verticalAlign;
				var gap:int;
				var xofs:int = 0;
				var yofs:int = 0;
				var c:DisplayObject;
				var measWidth:Number = width;
				var measHeight:Number = height;
				var nChilds:int = _childs.length > 0 ? _childs.length - 1 : 0;
				
				// TODO gros kk les switch, voir à implémenter des méthodes
				// genre alignLeft(), alignCenter()...
				// > affichage des enfants en horizontal
				if (_styles.direction == HORIZONTAL)
				{
					gap = _styles.horizontalGap;
					// Calcul de l'offset suivant l'alignement
					switch (ha)
					{
						case LEFT :
							xofs = pl;
							break;
						case RIGHT :
							xofs = measWidth - (_childsWidth + ((nChilds) * gap)) - pr;
							break;
						case CENTER :
							xofs = (measWidth - (_childsWidth + ((nChilds) * gap))) / 2;
							break;
					}
					
					var ch:Number;
					for (var i:int = 0; i < n; i++)
					{					
						c = _childs[i];
						c.x = xofs;
						xofs += c.width + gap;
						ch = c.height;
						switch (va)
						{
							case TOP :
								c.y = pt;
								break;
							case BOTTOM :
								c.y = measHeight - pb - ch;
								break;
							case CENTER :
								c.y = (measHeight - ch) / 2;
								break;
						}
					}
				}				
				else // > Affichage des enfants en vertical
				{
					gap = _styles.verticalGap;
					// Calcul de l'offset suivant l'alignement
					switch (va)
					{
						case TOP :
							yofs = pt;
							break;
						case BOTTOM :
							yofs = measHeight - (_childsHeight + ((nChilds) * gap)) - pb;
							break;
						case CENTER :
							yofs = (measHeight - (_childsHeight + ((nChilds) * gap))) / 2;
							break;
					}
										
					var cw:Number;
					for (i = 0; i < n; i++)
					{					
						c = _childs[i];
						c.y = yofs;
						yofs += c.height + gap;
						cw = c.width;
						switch (ha)
						{
							case LEFT :
								c.x = pl;
								break;
							case RIGHT :
								c.x = measWidth - pr - cw;
								break;
							case CENTER :
								c.x = (measWidth - cw) / 2;
								break;
						}
					}
				}				
			}
			
			// pour test ?
			if (getStyle("backgroundColor"))	drawBackGround(measWidth, measHeight);
			
			_invalidateSize = false;
			_invalidateStyle = false;

			return true;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		protected function drawBackGround (w:int, h:int) : void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(_styles.backgroundColor, 0.1);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
		}
		
	}

}
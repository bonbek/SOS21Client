package ddgame.minigame {
	
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	/**
	 *	Composant conteneur abstrait
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	
	public class MiniGameUIContainer extends MiniGameUIComponent {
		
		//---------------------------------------
		// CONSTRUCTOR
		//---------------------------------------
		
		public function MiniGameUIContainer (w:int = 0, h:int = 0, styles:Object = null) : void
		{
			super(w, h, styles);
			
			// espacement entre enfant
			if (!("horizontalGap" in _styles))	_styles.horizontalGap = 10;
			if (!("verticalGap" in _styles))		_styles.verticalGap = 10;
		}

		//---------------------------------------
		// PRIVATE & PROTECTED INSTANCE VARIABLES
		//---------------------------------------
		
		// largeur total des enfants
		protected var _childsWidth:Number = 0;
		// hauteur total des enfants
		protected var _childsHeight:Number = 0;
		// liste des enfants ?
		protected var _childs:Array = [];
		// dimension enfant le plus large
		protected var _bigestChildWidth:Number = 0;
		// dimension enfant le plus haut
		protected var _bigestChildHeight:Number = 0;
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * Retourne la largeur de l'enfant le plus large
		 */
		public function get bigestChildWidth () : Number
		{
			return _bigestChildWidth;
		}
		
		/**
		 * Retourne la hauteur de l'enfant le plus haut
		 */
		public function get bigestChildHeight () : Number
		{
			return _bigestChildHeight;
		}		
		
		/**
		 * @inheritDoc
		 * Inclus les espacements entre les enfants horizontalGap
		 */
		override public function get whiteSpacesWidth () : Number
		{
			return numChildren 	? super.whiteSpacesWidth + ((numChildren - 1) * _styles.horizontalGap)
										: super.whiteSpacesWidth;
		}
		
		/**
		 * @inheritDoc
		 * Inclus les espacements entre les enfants verticalGap
		 */
		override public function get whiteSpacesHeight () : Number
		{
				return numChildren	? super.whiteSpacesHeight + ((numChildren - 1) * _styles.verticalGap)
											: super.whiteSpacesHeight;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 *	@private
		 */
		override public function invalidateSize () : void
		{
			super.invalidateSize();
			
			var cw:int;
			var ch:int;
			_childsWidth = 0;
			_childsHeight = 0;
			_bigestChildWidth = 0;
			_bigestChildHeight = 0;
			for each (var child:Object in _childs)
			{
				cw = child.width;
				ch = child.height;
				if (cw > _bigestChildWidth) _bigestChildWidth = cw;
				_childsWidth += cw;
				if (ch > _bigestChildHeight) _bigestChildHeight = ch;
				_childsHeight += ch;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChild (child:DisplayObject) : DisplayObject
		{
			if (_childs.indexOf(child) == -1)
			{
				var inl:Boolean = true;
				if ("includeInLayout" in child)
				{
					if (Object(child).includeInLayout == false) inl = false;					
				}
				
				if (inl) _childs.push(child);
			}
				
			invalidateSize();

			return super.addChild(child);
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function addChildAt (child:DisplayObject, index:int) : DisplayObject
		{
			if (_childs.indexOf(child) == -1)
			{
				var inl:Boolean = true;
				if ("includeInLayout" in child)
				{
					if (Object(child).includeInLayout == false) inl = false;					
				}
				
				if (inl) _childs.splice(index, 0, child);
			}
				
			invalidateSize();

			return super.addChildAt(child, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChild (child:DisplayObject) : DisplayObject
		{
			var ind:int = _childs.indexOf(child);
			if (ind > -1) _childs.splice(ind, 1);
			invalidateSize();
			
			return super.removeChild(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt (index:int) : DisplayObject
		{
			_childs.splice(index, 1);
			invalidateSize();
			
			return super.removeChildAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validate (e:Event = null) : Boolean
		{
			if (!super.validate(e)) return false;

			// reset des calculs antérieurs
			_childsWidth = _childsHeight = 0;
			var maxw:Number;
			var maxh:Number;
			for each (var c:Object in _childs)
			{
				// TODO avoir un système pour checker les validations
				// car la on revalide tout les enfants alors que certains n'en
				// n'ont peut être pas besoin
				if (c is MiniGameUIComponent)
				{
					c.validate(e);
				}
				// stockage largeur hauteur cumulées des enfants
				// plus dimension enfant le plus large et enfant le plus haut
				maxw = c.width;
				_childsWidth += maxw;
				if (maxw > _bigestChildWidth) _bigestChildWidth = maxw;
				
				maxh = c.height;
				_childsHeight += maxh;
				if (maxh > _bigestChildHeight) _bigestChildHeight = maxh;
			}
			
			// TODO pourquoi déjà ?
			if (parent is MiniGameUIComponent)
			{
				var container:MiniGameUIComponent = MiniGameUIComponent(parent);
				if (container.percentWidth && !container.width) return false;
			}
			
			return true;
		}
		
	}

}
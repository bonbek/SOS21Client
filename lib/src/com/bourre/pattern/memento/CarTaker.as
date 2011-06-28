package com.bourre.pattern.memento
{
	import com.bourre.log.PixlibStringifier;
	
	/**
	 * <code>CarTaker</code> is the class used to store states of an object and to redo and undo state of the object
	 * 
	 * @author  Aigret Axel
	 */
	public class CarTaker
	{
		/**The stack. */
		protected var	_aStack : Array ;
		/* The current index. */
		protected var	_curIndex : uint ;
		/** The maximun size of the stack, can be null */
		protected var	_maxSize : uint ;
		/** The originator */
		protected var	_originator : IOriginator ;
		
		
		/**
		 * Creates a new <code>CarTaker</code>
		 *  
		 */
		public function CarTaker(originator : IOriginator = null, maxSize : uint = 0)
		{
			_aStack = new Array() ;
			_originator = originator ;
			_curIndex = 0 ;
			_maxSize = maxSize ;
		}
		
		/**
		 * store a new <code>IMemento</code> in the list
		 *  
		 * @param 	m 	the new memento to save
		 * 
		 * <p>if the memento is null creates a new memento with the originator</p>
		 */
		public function saveMemento(m : IMemento = null) : void
		{
			var memento : IMemento = m ? m : _originator.createMemento() ;
			
			if(_curIndex < _aStack.length)
			{
				_aStack = _aStack.slice(0, _curIndex) ;
			}
			
			if(_maxSize && _aStack.length == _maxSize)
			{
				_aStack = _aStack.slice(1, _maxSize - 1) ;
			}
			
			_aStack.push(m) ;
			_curIndex = _aStack.length ;
		}
		
		/**
		 * return the <code>IMemento</code> at the index in the list
		 * 
		 * @param	index 	The index in the list. 
		 */
		public function getMemento(index : uint) : IMemento
		{
			if(index < _aStack.length)
			{
				return _aStack[index] ;
			}
			
			return null ;
		}
		
		/**
		 * Return the size of the stack
		 * 
		 * @return The size of the stack. 
		 */
		public function size() : uint
		{
			return _aStack.length ;
		}
		
		/**
		 * Return the current index
		 * 
		 * @return The current index in the list. 
		 */
		public function getIndex() : uint
		{
			return _curIndex ;
		}
		
		/**
		 * Set the current index
		 * 
		 * @param	index 	The new current index in the list. 
		 */
		public function setIndex(index : uint) : void
		{
			if(index >= 0 && index < _aStack.length)
			{
				_curIndex = index
			}
		}
		
		/**
		 * Clear the <code>IMemento</code> list
		 *  
		 */
		public function clear() : void
		{
			_curIndex = 0 ;
			_aStack = new Array() ;
		}
		
		/**
		 * Redo the state of the <code>IMemento</code>
		 *  
		 */
		public function redo() : void
		{
			if(_curIndex < _aStack.length)
			{
				_originator.setMemento( _aStack[_curIndex] ) ;
				_curIndex++ ;
			}
		}
		
		/**
		 * Undo the state of the <code>IMemento</code>
		 *  
		 */
		public function undo() : void
		{
			if(_curIndex)
			{
				_curIndex-- ;
				_originator.setMemento( _aStack[_curIndex] ) ;
			}
		}
				
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
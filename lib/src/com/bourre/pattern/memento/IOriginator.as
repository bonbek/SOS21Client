package com.bourre.pattern.memento
{
	/**
	 * <code>IOriginator</code> is an interface used to save and set the state of an object
	 * 
	 * <p>Implements this interface to define specific originator for specific object.</p>
	 * 
	 * @author  Aigret Axel
	 */
	public interface IOriginator
	{
		/**
		 * Create a new Memento
		 *  
		 * @return	The new memento created.
		 */
		function createMemento() : IMemento ;
		
		/**
		 * Set the memento
		 *  
		 * @param	The memento to set.
		 */
		function setMemento( m : IMemento) : void ;
	}
}
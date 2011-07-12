/* AS3
	Copyright 2008 __MyCompanyName__.
*/
package com.sos21.proxy {
	import com.sos21.proxy.IProxy;
	import com.sos21.facade.Facade;
	import com.sos21.observer.Notifier;
	
	/**	
	 *	TODO documenter son rôle et son implémentation
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 *	@since  23.01.2008
	 */
	public class AbstractProxy extends Notifier implements IProxy {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const NAME:String = "AbstractProxy";
		
		/**
		 *	@Constructor
		 */
		public function AbstractProxy(sname:String = null, odata:Object = null)
		{
			sname == null ? _name = NAME : _name = sname;
			if (odata != null)
				_data = odata;
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var _name:String;
		protected var _data:Object;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/*
		*	Return the name identifier of this instance or sub
		*	a unique name should be given for all sub classes of this
		*	@return	string identifier of this instance
		*/
		final public function get name():String
		{ return _name; }
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/* 
		*	Return the data of this AbstractProxy
		*	additionaly, a getter that return the right type of data or
		*	handled data should be implemented in the sub classes of this
		*	ex :
		*	Class MyProxy extends AbstractProxy {
		*		public function get data() : XML
		*		{
		*			return _data as XML;
		*	...
		*	@return	Object
		*/
		final public function getData():Object
		{
			return _data;
		}
		
		/*
		*	Method called by Facade when 
		*	override this method in your sub class to do some initialization stuff
		*	ex : cache references to needed AbstractHelper/AbstractProxy 
		*	override public function initialize():void
		*	{
		*		cachedProxyReference:MyProxy = MyProxy(facade.getProxy(MyProxy.NAME));
		*	...
		*/
		public function initialize():void
		{}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}

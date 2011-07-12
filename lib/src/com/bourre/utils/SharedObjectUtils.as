package com.bourre.utils {
	import flash.net.SharedObject;		import com.bourre.log.PixlibDebug;	
	/**
	 * The original <code>SharedObjectUtils</code> class provide simple methods 
	 * to save data on the local machine.
	 * 
	 * <p>The AS3 version don't handle remote SharedObject. It's not in its main goal.</p>
	 * 
	 * @author	Francis Bourre
	 * @author	Cédric Néhémie
	 * @version 1.0
	 * @see		http://livedocs.macromedia.com/flex/2/langref/flash/net/SharedObject.html
	 */
	public class SharedObjectUtils
	{
		public function SharedObjectUtils( access : PrivateConstructorAccess )
		{
			
		}
		
		/**
		 * Get a value stored in a local SharedObject.
		 * 
		 * <p>If an error occurs the function return a null value.</p>
		 * 
		 * @param	 sCookieName	Name of the cookie.
		 * @param	 sObjectName	Field to retreive.
		 * @return	 The value stored in the field or <code>null</code>.
		 */
		public static function loadLocal( sCookieName : String, sObjectName : String ) : *
		{	
			try
			{
				var save:SharedObject = SharedObject.getLocal(sCookieName, "/");
				return save.data[sObjectName];
			}
			catch(e:Error)
			{
				PixlibDebug.ERROR ( e );
				return null;
			}
		}
		/**
		 * Save a data in a local SharedObject.
		 * 
		 * <p>If an error occurs the function die silently and no value is saved.</p>
		 * 
		 * @param	sCookieName	Name of the cookie.
		 * @param	sObjectName	Field to retreive.
		 * @param	refValue	Value to save.
		 * @return	<code>true</code> if the data have been saved.
		 */
		public static function saveLocal( 	sCookieName : String, sObjectName : String, refValue : * ) : Boolean
		{
			try
			{
				var save:SharedObject = SharedObject.getLocal(sCookieName, "/");
				save.data[sObjectName] = refValue;
				save.flush();
				return true;
			}
			catch(e:Error)
			{
				PixlibDebug.ERROR ( e );
			}
			return false;
		}
		/**
		 * Clear the value stored in a local SharedObject.
		 * 
		 * <p>If an error occurs the function die silently.</p>
		 * 
		 * @param	sCookieName Name of the cookie.
		 * @param	sObjectName	Field to retreive.
		 * @return	<code>true</code> if the data have been cleared.
		 */
		public static function clearLocal( sCookieName : String, sObjectName : String) : Boolean
		{
			try
			{
				var save:SharedObject = SharedObject.getLocal( sCookieName, "/" );
				save.clear();
				return true;
			}
			catch( e : Error )
			{
				PixlibDebug.ERROR ( e );
			}
			return false;
		}
	}
}

internal class PrivateConstructorAccess {}
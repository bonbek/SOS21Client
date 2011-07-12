package com.bourre.ioc.assembler.displayobject
{
	/*
	 * Copyright the original author or authors.
	 * 
	 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
	 * you may not use this file except in compliance with the License.
	 * You may obtain a copy of the License at
	 * 
	 *      http://www.mozilla.org/MPL/MPL-1.1.html
	 * 
	 * Unless required by applicable law or agreed to in writing, software
	 * distributed under the License is distributed on an "AS IS" BASIS,
	 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	 * See the License for the specific language governing permissions and
	 * limitations under the License.
	 */
	 
	/**
	 * @author Francis Bourre
	 * @version 1.0
	 */
	import com.bourre.log.PixlibDebug;	
	import com.bourre.log.PixlibStringifier;

	public class DisplayObjectInfo
	{
		public var ID 		: String;
		public var parentID : String;
		public var isVisible: Boolean;
		public var type		: String;
		private var _sURL	: String;
		private var _aChilds: Array;
		
		public function DisplayObjectInfo ( ID			: String, 
											parentID	: String	= null, 
											isVisible	: Boolean 	= true, 
											url			: String 	= null, 
											type		: String 	= "Movieclip" )
		{
			this.ID 		= ID;
			this.parentID 	= parentID;
			this.isVisible 	= isVisible;
			this.type 		= type;
			_sURL 			= url;
			_aChilds 		= new Array();
		}
		
		public function addChild( o : DisplayObjectInfo ) : void
		{
			PixlibDebug.INFO( "addChild to " +  this );			PixlibDebug.INFO( "child is " +  o );
			_aChilds.push( o );
		}
		
		public function getChild() : Array
		{
			return _aChilds.concat();
		}
		
		public function hasChild() : Boolean
		{
			return getNumChild() > 0;
		}
		
		public function getNumChild() : int
		{
			return _aChilds.length;
		}
		
		public function isEmptyDisplayObject() : Boolean
		{
			return ( _sURL == null );
		}
		
		/**
		 * Returns the string representation of this instance.
		 * @return the string representation of this instance
		 */
		public function toString() : String 
		{
			var s : String = " ";
			s += "ID:" + ID + ", ";			s += "url:" + _sURL + ", ";
			s += "parentID:" + parentID + ", ";			s += "isVisible:" + isVisible + ", ";			s += "url:" + type + ", ";			s += "hasChild:" + hasChild() + ", ";			s += "numChild:" + getNumChild();
			
			return PixlibStringifier.stringify( this ) + s;
		}
	}
}

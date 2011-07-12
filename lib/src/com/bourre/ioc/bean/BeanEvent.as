package com.bourre.ioc.bean
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

	import com.bourre.events.BasicEvent;
	import com.bourre.log.*;

	public class BeanEvent 
		extends BasicEvent
	{
		private var _sID	: String;
		private var _oBean 	: Object;
		
		public function BeanEvent( type : String, id : String, bean : Object )
		{
			super( type, bean );
			_sID = id;
			_oBean = bean;
		}
		
		public function getID() : String
		{
			return _sID ;
		}
		
		public function getBean() : Object
		{
			return _oBean ;
		}
		
		public override function toString() : String
		{
			return PixlibStringifier.stringify( this );
		}
	}
}
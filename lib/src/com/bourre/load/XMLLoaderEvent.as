package com.bourre.load
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

	public class XMLLoaderEvent
		extends LoaderEvent
	{
		public static const onLoadStartEVENT : String = LoaderEvent.onLoadStartEVENT;
		public static const onLoadInitEVENT : String = LoaderEvent.onLoadInitEVENT;
		public static const onLoadProgressEVENT : String = LoaderEvent.onLoadProgressEVENT;
		public static const onLoadTimeOutEVENT : String = LoaderEvent.onLoadTimeOutEVENT;
		public static const onLoadErrorEVENT : String = LoaderEvent.onLoadErrorEVENT;
		
		public function XMLLoaderEvent( type : String, xl : XMLLoader )
		{
			super( type, xl );
		}
		
		public function getXMLLoader() : XMLLoader
		{
			return getLoader() as XMLLoader;
		}
		
		public function getXML() : XML
		{
			return getXMLLoader().getXML();
		}
	}
}
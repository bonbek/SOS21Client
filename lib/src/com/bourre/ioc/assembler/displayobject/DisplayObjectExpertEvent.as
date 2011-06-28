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
	import com.bourre.load.Loader;
	import com.bourre.load.LoaderEvent;
	import com.bourre.load.QueueLoaderEvent;		

	public class DisplayObjectExpertEvent 
		extends LoaderEvent
	{
		public static const onLoadStartEVENT 		: String = QueueLoaderEvent.onLoadStartEVENT;
		public static var onLoadInitEVENT			: String = QueueLoaderEvent.onLoadInitEVENT; 
		public static var onLoadProgressEVENT		: String = QueueLoaderEvent.onLoadProgressEVENT; 
		public static const onLoadTimeOutEVENT		: String = QueueLoaderEvent.onLoadTimeOutEVENT;
		public static const onLoadErrorEVENT 		: String = QueueLoaderEvent.onLoadErrorEVENT;

		public static const onDisplayObjectExpertLoadStartEVENT 	: String = "onDisplayObjectExpertLoadStart"; 
		public static const onDLLLoadStartEVENT 					: String = "onDLLLoadStart";	
		public static const onDLLLoadInitEVENT 						: String = "onDLLLoadInit";	
		public static const onDisplayObjectLoadStartEVENT 			: String = "onDisplayObjectLoadStart"; 
		public static const onDisplayObjectLoadInitEVENT 			: String = "onDisplayObjectLoadInit"; 
		public static const onDisplayObjectExpertLoadInitEVENT 		: String = "onDisplayObjectExpertLoadInit";

		public function DisplayObjectExpertEvent( type : String, loader : Loader = null ) 
		{
			super( type, loader );
		}
	}}
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
	import com.bourre.load.LoaderListener;					

	public interface DisplayObjectExpertListener extends LoaderListener
	{
		function onDisplayObjectExpertLoadStart ( e : DisplayObjectExpertEvent ) : void;
		function onDLLLoadStart ( e : DisplayObjectExpertEvent ) : void;	
		function onDLLLoadInit ( e : DisplayObjectExpertEvent ) : void;
		function onDisplayObjectLoadStart ( e : DisplayObjectExpertEvent ) : void;
		function onDisplayObjectLoadInit ( e : DisplayObjectExpertEvent ) : void;
		function onDisplayObjectExpertLoadInit ( e : DisplayObjectExpertEvent ) : void;

		function onBuildDisplayObject ( e : DisplayObjectEvent ) : void;
	}
}
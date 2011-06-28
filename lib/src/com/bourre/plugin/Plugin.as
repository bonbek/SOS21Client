package com.bourre.plugin
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
	import flash.events.Event;
	
	import com.bourre.events.EventChannel;
	import com.bourre.model.ModelLocator;
	import com.bourre.view.ViewLocator;	

	public interface Plugin 
	{
		function  fireOnInitPlugin() : void;
		function  fireOnReleasePlugin() : void;
		
		
		function fireExternalEvent( e : Event, channel : EventChannel ) : void;
		function firePublicEvent( e : Event ) : void;
		function firePrivateEvent( e : Event ) : void;
		
		function getChannel() : EventChannel;
		function getLogger() : PluginDebug;

		function getModelLocator() : ModelLocator;
		function getViewLocator() : ViewLocator;
	}
}
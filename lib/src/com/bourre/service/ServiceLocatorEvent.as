package com.bourre.service 
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

	public class ServiceLocatorEvent 
		extends BasicEvent
	{
		public static const onRegisterServiceEVENT : String = "onRegisterService";		public static const onUnregisterServiceEVENT : String = "onUnregisterService";

		protected var _key : String;
		protected var _service : Service;		protected var _serviceClass : Class;
		protected var _serviceLocator : ServiceLocator;

		public function ServiceLocatorEvent( type : String, key : String, serviceLocator : ServiceLocator ) 
		{
			super( type );
			
			_key = key;
			_serviceLocator = serviceLocator;
		}

		public function getKey() : String
		{
			return _key;
		}

		public function getService() : Service
		{
			return _service is Class ? null : _service as Service;
		}

		public function setService( service : Service ) : void
		{
			_service = service;
		}
		
		public function getServiceClass() : Class
		{
			return _service is Class ? _service as Class : null;
		}

		public function setServiceClass( serviceClass : Class ) : void
		{
			_serviceClass = serviceClass;
		}

		public function getServiceLocator() : ServiceLocator
		{
			return _serviceLocator as ServiceLocator;
		}	}}
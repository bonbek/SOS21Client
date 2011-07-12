package com.bourre.service 
{	/*
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

	import com.bourre.collection.Collection;
	import com.bourre.commands.ASyncCommand;
	import com.bourre.service.ServiceListener;

	public interface Service extends ASyncCommand
	{
		function setResult( result : Object ) : void;
		function getResult() : Object;
		function addServiceListener( listener : ServiceListener ) : Boolean;
		function removeServiceListener( listener : ServiceListener ) : Boolean;
		function getServiceListener() : Collection;
		function setArguments( ... rest ) : void;
		function getArguments() : Object;
		function fireResult() : void;
		function fireError() : void;
		function release() : void;
	}}
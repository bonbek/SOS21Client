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
package com.bourre.events
{
	/**
	 * Some entities contain a group of attributes that are always
	 * accessed together. Accessing these attributes in a fine-grained
	 * manner through a remote interface causes network traffic and high
	 * latency, and consumes server resources unnecessarily.
	 * <p>
	 * A value object (also known as transfer object) is a serializable
	 * class that groups related attributes, forming a composite value.
	 * This class is used as the return type of a remote business method.
	 * Clients receive instances of this class by calling coarse-grained
	 * business methods, and then locally access the fine-grained values
	 * within the value object. Fetching multiple values in one server
	 * roundtrip decreases network traffic and minimizes latency and
	 * server resource usage.
	 * </p><p>
	 * When a web-service uses a Value Object, the client makes
	 * a single remote method invocation to the web-service to request
	 * the Value Object instead of numerous remote method calls to get
	 * individual attribute values. The web-service then constructs
	 * a new Value Object instance, copies values into the object
	 * and returns it to the client. The client receives the Value Object
	 * and can then invoke accessor (or getter) methods on the Value Object
	 * to get the individual attribute values from the Transfer Object.
	 * Or, the implementation of the Value Object may be such that it makes
	 * all attributes public. Because the Value Object is passed by value
	 * to the client, all calls to the Value Object instance are local
	 * calls instead of remote method invocations.
	 * </p>
	 * 
	 * @author	Francis Bourre
	 */
	public interface ValueObject
	{}
}
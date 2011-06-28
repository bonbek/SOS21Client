package com.bourre.ioc.parser 
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

	import com.bourre.ioc.assembler.ApplicationAssembler;
	public class DLLParser 
		extends AbstractParser
	{
		public function DLLParser( assembler : ApplicationAssembler = null )
		{
			super( assembler );
		}

		public override function parse( xml : * ) : void
		{
			var dllXML : XMLList = xml[ ContextNodeNameList.DLL ];
			for each ( var node : XML in dllXML.* ) _parseNode( node );
			delete xml[ ContextNodeNameList.DLL ];
			
//			delete thePeople.person.bio; //delete all <bio> tags
//delete thePeople..bio; //Doesn't work but no error. Why?!?
//delete thePeople.person.@suffix; //deletes all suffix attributes of <person> tags
//delete thePeople.person.(@name == "Roger Braunstein").*; //clears out children of my node
		}

		protected function _parseNode( node : XML ) : void
		{
			getAssembler().buildDLL( ContextAttributeList.getURL( node ) );
		}	}}
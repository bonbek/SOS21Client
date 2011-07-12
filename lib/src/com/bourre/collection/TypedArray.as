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
package com.bourre.collection 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import com.bourre.log.PixlibStringifier;	

	/**
	 * <code>TypedArray</code> work the same way than a classical <code>Array</code>
	 * but all elements in a <code>TypedArray</code> have to be of the same type.
	 * <p>
	 * The type of array's elements is set at creation, then you cannot change it
	 * after. Every time you try to insert data in the array the type of the element
	 * is checked, and an error is thrown if the type doesn't match the 
	 * <code>TypedArray</code> one.
	 * </p><p>
	 * The <code>TypedArray</code> is final, you cannot extend it.
	 * </p>
	 * @author Cédric Néhémie
	 * @example Using a <code>TypedArray</code> directly
	 * <listing>var a : TypedArray = new TypedArray ( Number );
	 * a[ 0 ] = 20; // no error
	 * a[ 1 ] = "20"; // throw an error
	 * </listing>
	 */
	dynamic final public class TypedArray extends Proxy
						 implements TypedContainer
	{
		private var _a : Array;
		private var _t : Class;
		
		/**
		 * Create a new <code>TypedArray</code> instance.
		 * <p>
		 * Besides type the constructor works as the <code>Array</code>
		 * one, if only one additional arguments is passed to the function and
		 * if its type is Number then this argument is used to set the length
		 * of the <code>TypedArray</code>
		 * </p>
		 * 
		 * @param 	t			Type of elements in the array. The type is a <code>Class</code>
		 * 						instance witch is used with the <code>is</code> operator.
		 * @param 	args		You can use the array constructor in two different ways : 
		 * 						<ul>
		 * 						<li>If only one <code>int</code> is passed to the function
		 * 						then it defines the number of elements in the array.</li>
		 * 						<li>If several arguments is passed to the function those
		 * 						values are used to fill the array.</li></ul>
		 * @throws 	<code>TypeError</code> — If one or more of optionnal arguments are not of the
		 * 						same type than the array one. 
		 */
		public function TypedArray ( t : Class = null, ... args )
		{
			_t = t != null ? t : Object ;
			
			if( args.length == 1 && args[0] is uint )
			{
				_a = new Array ( args[ 0 ] );
			}
			else
			{
				_a = new Array ();
				var item : *;
				var b : Boolean = false;
				for each ( item in args )
	            {
	            	if( !matchType( item ) )
	            	{
	            		b = true;
	            		break;
	            	}
	            }
	            if( b )
	            {
	            	_throwTypeError( "Arguments contains elements of a type different than " +
	            					 _t + " in new TypedArray( "+_t+", "+args+" )" );
	            }
	            _a.unshift.apply ( _a, args );
			}
		}
		
		/**
	     * Adds one or more elements to the end of an array and returns
	     * the new length of the array.
	     * 
	     * @param 	args	One or more values to append to the array.
	     * @return 	An integer representing the length of the new array.
	     * @example	The following code creates an empty TypedArray object
	     * letters and then populates the array with the elements
	     * a, b, and c using the push() method.
	     * <listing>var letters:TypedArray = new TypedArray( String );
	     * 
	     * letters.push("a");
	     * letters.push("b");
	     * letters.push("c");
	     * 
	     * trace( letters.toString() ); // a,b,c</listing>
	     * @throws 	<code>TypeError</code> — If one or more arguments are not of the same type than
	     * 						the array one.
	     */
	    public function push ( ... args ) : Number
	    {
	    	var b : Boolean = false;
        	for each ( var item : * in args )
        	{
        		if( !matchType( item ) )
            	{
            		b = true;
            		break;
            	}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".unshift( "+ args + " )" );
        	}

        	return _a.push.apply ( _a, args );	
	    }
	    
	   
	    /**
	     * Adds one or more elements to the beginning of an array
	     * and returns the new length of the array. The other elements
	     * in the array are moved from their original position, i, to i+1.
	     * 
	     * @param	args	One or more numbers, elements, or variables
	     * 					to be inserted at the beginning of the array.
	     * @return	An integer representing the new length of the array.
	     * @throws 	<code>TypeError</code> — If one or more arguments are not of the same type than
	     * 						the array one.
	     */
	    public function unshift ( ... args ) : Number
	    {
	    	var b : Boolean = false;
        	for each ( var item : * in args )
        	{
        		if( !matchType( item ) )
            	{
            		b = true;
            		break;
            	}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".unshift( "+ args + " )" );
        	}

        	return _a.unshift.apply ( _a, args );	
	    }
	    
	    
	    /**
	     * Adds elements to and removes elements from an array.
	     * This method modifies the array without making a copy.
	     * 
	     * @param	startIndex	An integer that specifies the index of
	     * 						the element in the array where the insertion
	     * 						or deletion begins. You can use a negative integer
	     * 						to specify a position relative to the end of the array
	     * 						(for example, -1 is the last element of the array).
	     * @param	deleteCount	An integer that specifies the number of elements
	     * 						to be deleted. This number includes the element specified
	     * 						in the startIndex parameter. If you do not specify a value
	     * 						for the deleteCount parameter, the method deletes all of
	     * 						the values from the startIndex  element to the last element
	     * 						in the array. If the value is 0, no elements are deleted.
	     * @param	values		An optional list of one or more comma-separated values,
	     * 						or an array, to insert into the array at the position specified
	     * 						in the startIndex parameter.
	     * @return	An array containing the elements that were removed from the original array.	
	     * @throws 	<code>TypeError</code> — If one or more additional arguments are not of the same type than
	     * 						the array one.
	     */
	    public function splice ( startIndex : int, deleteCount : int, ... values ) : TypedArray
	    {
        	var b : Boolean = false;
        	for each ( var item : * in values )
        	{
        		if( !matchType( item ) )
            	{
            		b = true;
            		break;
            	}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".splice( "+ startIndex +", "+ deleteCount +", "+ values + " )" );
        	}
        	
        	return _fromArray( _a.splice.apply( _a, [ startIndex, deleteCount ].concat(values) ) );
	    }
	    
	    
	    /**
	     * Concatenates the elements specified in the parameters with
	     * the elements in an array and creates a new array. If the
	     * parameters specify an array, the elements of that array are concatenated.
	     * 
	     * 
	     * @param	args	A value of any data type (such as numbers, elements, or strings)
	     * 					to be concatenated in a new array. If you don't pass any values,
	     * 					the new array is a duplicate of the original array.
	     * @return 	An array that contains the elements from this array followed by elements from the parameters.
	     * @throws 	<code>TypeError</code> — If one or more arguments are not of the same type that the array one.
	     */
	    public function concat ( ... args ) : TypedArray
	    {
	    	var b : Boolean = false;
			
        	mainloop: for each ( var arg : * in args )
        	{
        		if( arg is Array )
        		{
        			for each ( var item : * in arg )
        			{
        				if( !matchType( item ) )
            			{
            				b = true;
            				break mainloop;
            			}
        			}
        		}
        		else
        		{
        			if( !matchType( arg ) )
        			{
        				b = true;
            			break mainloop;
        			}
        		}
        	}
        	if( b )
        	{
        		_throwTypeError( "Arguments contains elements of a type different than " +
        						 _t + " in " + this + ".concat( "+ args + " )" );
        	}
        	    		    		
    		return _fromArray ( _a.concat.apply( _a, args ) );
	    } 
	    
	    /**
	     * Returns a new array that consists of a range of elements from the original array,
	     * without modifying the original array. The returned array includes the startIndex
	     * element and all elements up to, but not including, the endIndex element.
	     * <p>
	     * If you don't pass any parameters, a duplicate of the original array is created.
	     * </p>
	     * 
	     * @param 	startIndex	A number specifying the index of the starting point for the slice.
	     * 						If start is a negative number, the starting point begins at the end
	     * 						of the array, where -1 is the last element.
	     * @param 	endIndex	A number specifying the index of the ending point for the slice.
	     * 						If you omit this parameter, the slice includes all elements from
	     * 						the starting point to the end of the array. If end is a negative
	     * 						number, the ending point is specified from the end of the array,
	     * 						where -1 is the last element.	
	     * @return 	An array that consists of a range of elements from the original array.
	     */
	    public function slice ( startIndex : int, endIndex : int ) : TypedArray
	    {	
    		return _fromArray ( _a.slice( startIndex, endIndex ) );
	    }
	    
	    /**
	     * Executes a test function on each item in the array and constructs a new array
	     * for all items that return true for the specified function. If an item returns
	     * false, it is not included in the new array.
	     * <p>
	     * For this method, the second parameter, thisObject, must be null if the first
	     * parameter, callback, is a method closure. Suppose you create a function in a
	     * movie clip called me:
	     * <listing>
	     * function myFunction()
	     * {
	     * 	//your code here
	     * }</listing>
	     * </p><p>
	     * Suppose you then use the filter() method on an array called myArray:
	     * <listing>myArray.filter(myFunction, me);</listing>
	     * </p><p>
	     * Because myFunction is a member of the Timeline class, which cannot
	     * be overridden by me, Flash Player will throw an exception.
	     * You can avoid this runtime error by assigning the function to
	     * a variable, as follows:
	     * <listing>var foo:Function = myFunction() {
	     *      //your code here
	     * };
	     * myArray.filter(foo, me);</listing>
	     * </p>
	     * 
	     * @param 	callback	The function to run on each item in the array.
	     * 						This function can contain a simple comparison
	     * 						(for example, item < 20) or a more complex operation,
	     * 						and is invoked with three arguments; the value of an item,
	     * 						the index of an item, and the Array object:
	     * 						<listing>function callback(item:*, index:int, array:Array):void;</listing>
	     * @param 	thisObject	An object to use as this for the function.
	     * @return 	A new array that contains all items from the original array that returned true.
	     * 
	     */
	    public function filter ( callback : Function, thisObject : * = null ) : TypedArray
	    {
	    	return _fromArray( _a.filter( callback, thisObject ) );
	    }
	    
	    /**
	     * Executes a function on each item in an array, and constructs a new array
	     * of items corresponding to the results of the function on each item in the original array.
	     * <p>
	     * For this method, the second parameter, thisObject, must be null if the first parameter,
	     * callback, is a method closure. Suppose you create a function in a movie clip called me:
	     * <listing>
	     * function myFunction()
	     * {
	     * 	//your code here
	     * }</listing>
	     * </p><p>
	     * Suppose you then use the map() method on an array called myArray:
	     * <listing>myArray.map(myFunction, me);</listing>
	     * </p><p>
	     * Because myFunction is a member of the Timeline class,
	     * which cannot be overridden by me, Flash Player will throw
	     * an exception. You can avoid this runtime error by assigning
	     * the function to a variable, as follows:
	     * <listing>var foo:Function = myFunction() {
	     *      //your code here
	     * };
	     * myArray.map(foo, me);</listing>
	     * </p>
	     * 
	     * @param	callback	The function to run on each item in the array.
	     * 						This function can contain a simple command (such as
	     * 						changing the case of an array of strings) or a more complex
	     * 						operation, and is invoked with three arguments; the value
	     * 						of an item, the index of an item, and the Array object:
	     * 						<listing>function callback(item:*, index:int, array:Array):void;</listing>
	     * @param 	thisObject	An object to use as this for the function
	     * @return 	A new array that contains the results of the function on each item in the original array.
	     */
	    public function map ( callback : Function, thisObject : * = null ) : TypedArray
	    {
	    	return _fromArray( _a.map( callback, thisObject ) );
	    }
	    
	    /**
	     * Sorts the elements in an array. This method sorts according to Unicode values.
	     * ASCII is a subset of Unicode.)
	     * <p>
	     * By default, Array.sort() works in the following way:
	     * <ul>
	     * <li>Sorting is case-sensitive (Z precedes a).</li>
	     * <li>Sorting is ascending (a precedes b).</li>
	     * <li>The array is modified to reflect the sort order; multiple elements
	     * that have identical sort fields are placed consecutively in the sorted
	     * array in no particular order.</li>
	     * <li>All elements, regardless of data type, are sorted as if they were strings,
	     * so 100 precedes 99, because "1" is a lower string value than "9".</li>
	     * </ul></p><p>
	     * To sort an array by using settings that deviate from the default settings, 
	     * you can either use one of the sorting options described in the sortOptions
	     * portion of the ...args parameter description, or you can create your own custom
	     * function to do the sorting. If you create a custom function, you call the sort()
	     * method, and use the name of your custom function as the first argument (compareFunction). 
	     * @param args	The arguments specifying a comparison function and one or more values that
	     * determine the behavior of the sort.
	     * </p><p><ul>
	     * <li>compareFunction - A comparison function used to determine the sorting order
	     * of elements in an array. This argument is optional. A comparison function
	     * should take two arguments to compare. Given the elements A and B, the
	     * result of compareFunction can have one of the following three values:
	     * <ul>
	     * <li>1, if A should appear before B in the sorted sequence</li>
	     * <li>0, if A equals B</li>
	     * <li>1, if A should appear after B in the sorted sequence</li>
	     * </ul></li>
	     * <li>sortOptions - One or more numbers or defined constants, separated by the | (bitwise OR) operator, that change the behavior of the sort from the default. This argument is optional. The following values are acceptable for sortOptions:
	     * <ul>
	     * <li>1 or Array.CASEINSENSITIVE</li>
	     * <li>2 or Array.DESCENDING</li>
	     * <li>4 or Array.UNIQUESORT</li>
	     * <li>8 or Array.RETURNINDEXEDARRAY</li>
	     * <li>16 or Array.NUMERIC</li>
	     * </ul>
	     * For more information, see the Array.sortOn() method.</li>
	     * </ul>
	     * </p>
	     * 
	     * @return The return value depends on whether you pass any arguments,
	     * as described in the following list:
	     * <ul>
	     * <li>If you specify a value of 4 or Array.UNIQUESORT for the
	     * sortOptions argument of the ...args parameter and two or more
	     * elements being sorted have identical sort fields, Flash returns
	     * a value of 0 and does not modify the array.</li>
    	 * <li>If you specify a value of 8 or Array.RETURNINDEXEDARRAY
    	 * for the sortOptions argument of the ...args parameter,
    	 * Flash returns a sorted numeric array of the indices that reflects
    	 * the results of the sort and does not modify the array.</li>
    	 * <li>Otherwise, Flash returns nothing and modifies the array to reflect the sort order.</li>
    	 * </ul>
	     */
	    public function sort ( ... args ) : TypedArray
	    {
	    	return _fromArray( _a.sort.apply( _a, args ) );
	    }
	    

	    /**
	     * Sorts the elements in an array according to one or more fields in the array.
	     * The array should have the following characteristics:
	     * <ul>
	     * <li>The array is an indexed array, not an associative array.</li>
	     * <li>Each element of the array holds an object with one or more properties.</li>
	     * <li>All of the objects have at least one property in common, the values
	     * of which can be used to sort the array. Such a property is called a field.</li>
	     * </ul> 
	     * <p>
	     * If you pass multiple fieldName parameters, the first field represents
	     * the primary sort field, the second represents the next sort field, and so on.
	     * Flash sorts according to Unicode values. (ASCII is a subset of Unicode.)
	     * If either of the elements being compared does not contain the field that
	     * is specified in the fieldName parameter, the field is assumed to be set
	     * to undefined, and the elements are placed consecutively in the sorted array
	     * in no particular order.
	     * </p><p>
	     * By default, Array.sortOn() works in the following way:
	     * <ul>
	     * <li>Sorting is case-sensitive (Z precedes a).</li>
	     * <li>Sorting is ascending (a precedes b).</li>
	     * <li>The array is modified to reflect the sort order;
	     * multiple elements that have identical sort fields are
	     * placed consecutively in the sorted array in no particular order.</li>
	     * <li>Numeric fields are sorted as if they were strings, so 100 precedes 99,
	     * because "1" is a lower string value than "9".</li>
	     * </ul>
	     * <p>
	     * Flash Player 7 added the options parameter, which you can use
	     * to override the default sort behavior. To sort a simple array
	     * (for example, an array with only one field), or to specify a
	     * sort order that the options parameter doesn't support, use Array.sort().
	     * </p><p>
	     * To pass multiple flags, separate them with the bitwise OR (|) operator: 
	     * <listing>my_array.sortOn(someFieldName, Array.DESCENDING | Array.NUMERIC);</listing>
	     * </p><p>
	     * Flash Player 8 added the ability to specify a different sorting option
	     * for each field when you sort by more than one field. In Flash Player 8 and later,
	     * the options parameter accepts an array of sort options such that each sort option
	     * corresponds to a sort field in the fieldName parameter. The following
	     * example sorts the primary sort field, a, using a descending sort;
	     * the secondary sort field, b, using a numeric sort; and the tertiary sort field,
	     * c, using a case-insensitive sort:
	     *  
 	     * <listing>Array.sortOn (["a", "b", "c"], [Array.DESCENDING, Array.NUMERIC, Array.CASEINSENSITIVE]);
 	     * </listing>
 	     * </p>
 	     *   
	     * @param 	fieldName	A string that identifies a field to be used as the sort value,
	     * 						or an array in which the first element represents the primary
	     * 						sort field, the second represents the secondary sort field, and so on.
	     * @param 	options		One or more numbers or names of defined constants, separated by the
	     * 						bitwise OR (|) operator, that change the sorting behavior. The following
	     * 						values are acceptable for the options parameter:
	     * 						<ul>
	     * 						<li>Array.CASEINSENSITIVE or 1</li>
	     * 						<li>Array.DESCENDING or 2</li>
	     * 						<li>Array.UNIQUESORT or 4</li>
	     * 						<li>Array.RETURNINDEXEDARRAY or 8</li>
	     * 						<li>Array.NUMERIC or 16</li>
	     * 						</ul>
	     * @return 	The return value depends on whether you pass any parameters:
	     * 			<ul>
	     * 			<li>If you specify a value of 4 or Array.UNIQUESORT for the options parameter,
	     * 			and two or more elements being sorted have identical sort fields, a value of 0 is
	     * 			returned and the array is not modified.</li>
	     * 			<li>If you specify a value of 8 or Array.RETURNINDEXEDARRAY for the options
	     * 			parameter, an array is returned that reflects the results of the sort and the
	     * 			array is not modified.</li>
	     * 			<li>Otherwise, nothing is returned and the array is modified to reflect the sort order.</li>
	     * 			</ul>
	     */
	    public function sortOn ( fieldName : String, options : Object = null ) : TypedArray
	    {
	    	return _fromArray( _a.sortOn( fieldName, options ) );
	    }
	    
	    /**
	     * Reverses the array in place.
	     * 
	     * @return The new array
	     * @example The following code creates a TypedArray object letters with 
	     * elements a, b, and c. The order of the array elements is then reversed
	     * using the reverse() method to produce the array [c,b,a].
	     * <listing>
	     * var letters:TypedArray = new TypedArray( String, "a", "b", "c");
	     * trace(letters); // com.bourre.collection.TypedArray [a,b,c]
	     * letters.reverse();
	     * trace(letters); // com.bourre.collection.TypedArray [c,b,a]
	     * </listing>
	     */
	    public function reverse () : TypedArray
	    {
	    	return _fromArray( _a.reverse() );
	    }
		
		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>TypedArray</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * 			the <code>TypedArray</code>, either <code>false</code>.
		 */
		public function matchType( o : * ) : Boolean
	    {
	    	return ( o is _t || o == null );
	    }
	    
	    /**
	     * Return the current type allowed in the <code>TypedArray</code>
	     * 
	     * @return <code>Class</code> used to type checking.
	     */
	    public function getType () : Class
	    {
	    	return _t;
	    }
	    
	    /**
		 * Returns <code>true</code> if this array perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this array perform a verification
		 * 			of the type of elements.
		 */
		public function isTyped () : Boolean
		{
			return _t != null;
		}
	    
	     /**
	    * Returns the <code>String</code> representation of the object.
	    */
	    public function toString () : String
	    {
	    	return PixlibStringifier.stringify( this ) + " [" + _a + "]";
	    }
	    
		/**
		 * @private
		 */
		override flash_proxy function callProperty( methodName : *, ... args) : * 
		{
	        return _a[ methodName ].apply( _a , args );
	    }
	
		/**
		 * @private
		 */
	    override flash_proxy function getProperty( name : * ) : * 
	    {
	        return _a[ name ];
	    }
	
		/**
		 * @private
		 */
	    override flash_proxy function setProperty( name : *, value : * ) : void 
	    {
	    	if( !matchType ( value ) )
	    	{
	        	_throwTypeError( value + " is not of type " + _t + " in " + this + "[" + name + "]" );
	     	}
	     	_a[ name ] = value;
	    }
	    
	    /**
		 * @private
		 */
	    private function _throwTypeError ( m : String ) : void
	    {
	    	//PixlibDebug.ERROR( m );
	    	throw new TypeError ( m );
	    }
	    
	    /**
	     * Speed conversion of an array to a typed one.
	     * @private
	     */
	    private function _fromArray( a : Array ) : TypedArray
	    {
	    	var res : TypedArray = new TypedArray ( _t );
    		res._fill ( a );
    		    		
    		return res;
	    }
	    
	     /**
	     * Speed fill with no type checking.
	     * @private
	     */
	    private function _fill ( a : Array ) : void
	    {
	    	_a = a;
	    }
	    
	    
	    /**
	     * Return a copy of the internal untyped Array <code>TypedArray</code>
	     * 
	     * @return a copy of type Array.
	     */
	    public function toArray():Array
	    {
	    	return _a.concat();
	    }
	    
	   /*override flash_proxy function nextNameIndex (index:int):int
	    {
	    	
	    }
	    
		override flash_proxy function nextName(index:int):String
	    {
	    	
    	}
    	
    	override flash_proxy function nextValue(index:int):*
    	{
    	}*/
	}
}
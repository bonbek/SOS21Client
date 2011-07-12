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
 
package com.bourre.structures
{
	import com.bourre.log.PixlibStringifier;
	
	/**
	 * A range represent a space of numeric values.
	 * 
	 * @author Francis Bourre
	 * @author Cédric Néhémie
	 * @example Simple examples of <code>Range</code> usage
	 * <listing>
	 *   var r1 : Range = new Range(10, 100);
	 *   var r2 : Range = new Range(5, 50);
	 *   var r3 : Range = new Range(60, 600);
	 *   
	 *   var b1 : Boolean = r1.overlap(r2); //true
	 *   var b2 : Boolean = r2.overlap(r3); //false
	 *   var b3 : Boolean = r1.overlap(r3); //true
	 * </listing>
	 */
	public class Range
	{
		//-------------------------------------------------------------------------
		// Public Properties
		//-------------------------------------------------------------------------
		/**
		 * Lower limit of the range.
		 */
		public var min : Number;
		
		/**
		 * Upper limit of the range.
		 */
		public var max : Number;
		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new <code>Range</code> instance.
		 * 
		 * <p>Warning : parameter order is important.
		 * 
		 * @param min minimum <code>Number</code> value
		 * @param max maximum <code>Number</code> value
		 */
		public function Range( min : Number = Number.NEGATIVE_INFINITY, 
							   max : Number = Number.POSITIVE_INFINITY ) 
		{
			this.min = min;
			this.max = max;
		}
		
		/**
		 * Returns a copy of the current <code>Range</code> object. 
		 * 
		 * @return A <code>Range</code> object.
		 */
		public function clone () : Range
		{
			return new Range ( min, max );
		}
		
		/**
		 * Indicates if passed-in range overlap the current range.
		 * 
		 * @return 	<code>true</code> if passed-in <code>Range</code> overload this one, 
		 * 			either <code>false</code>
		 * @example
		 * <listing>
		 *   var r1 : Range = new Range(10, 100);
		 *   var r2 : Range = new Range(5, 50);
		 *   var r3 : Range = new Range(60, 600);
		 *   
		 *   var b1 : Boolean = r1.overlap(r2); //true
		 *   var b2 : Boolean = r2.overlap(r3); //false
		 *   var b3 : Boolean = r1.overlap(r3); //true
		 * </listing>
		 */
		public function overlap( r : Range ) : Boolean
		{
			return ( this.max > r.min && r.max > this.min );
		}
			
		/**
		 * Indicates if passed-in value <code>Number</code> is inside range values.
		 * 
		 * @return	 <code>true</code> if passed-in <code>Number</code> is inside range,
		 * 			either <code>false</code>
		 * @example
		 * <listing>
		 *   var r : Range = new Range(10, 100);
		 * 
		 *   var b1 : Boolean = r.surround(35); //true
		 *   var b2 : Boolean = r.surround(127); //false
		 *   var b3 : Boolean = r.surround(10); //true
		 *   var b4 : Boolean = r.surround(100); //true
		 *   var b5 : Boolean = r.surround(5); //false
		 * </listing>
		 */
		public function surround( n : Number ) : Boolean
		{
			return ( max >= n && min <= n );
		}
		
		/**
		 * Indicates if passed-in <code>Range</code> instance contain the 
		 * current instance.
		 * 
		 * @return 	<code>true</code> if passed-in <code>Range</code> contain this one, 
		 * 			either <code>false</code>
		 * @example
		 * <listing>
		 *   var r1 : Range = new Range(10, 100);
		 *   var r2 : Range = new Range(5, 50);
		 *   var r3 : Range = new Range(40, 80);
		 *   
		 *   var b2 : Boolean = r2.inside( r1 ); //false
		 *   var b3 : Boolean = r3.inside( r1 ); //true
		 * </listing>
		 */		
		public function inside ( r : Range ) : Boolean
		{
			return ( max < r.max && min > r.min );
		}
		
		/**
		 * Compares the passed-in <code>Range</code> object with the current one.
		 * 
		 * @param	r 	A <code>Range</code> to compare.
		 * @return 	<code>true</code> if passed-in <code>Range</code> is equals to this one, 
		 * 			either <code>false</code>
		 * 
		 */
		public function equals ( r : Range ) : Boolean
		{
			return ( max == r.max && min == r.min ); 
		}
		
		/**
		 * Returns the size, or length, of the current range.
		 * 
		 * @return	 size, or length, of the current range.
		 */
		public function size() : Number
		{
			return max-min;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return <code>String</code> representation of this instance
		 */
		public function toString() : String
		{
			return PixlibStringifier.stringify( this ) + " : [" + min + ", " + max + "]";
		}
		
		
	}
}
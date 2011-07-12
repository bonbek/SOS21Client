
package com.bourre.structures 
{
	import com.bourre.error.IndexOutOfBoundsException;	
	import com.bourre.collection.WeakCollection;	
	
	import flash.geom.Point;
	
	import com.bourre.collection.Collection;
	import com.bourre.collection.Iterator;
	import com.bourre.collection.TypedArray;
	import com.bourre.collection.TypedContainer;
	import com.bourre.error.NullPointerException;
	import com.bourre.error.UnsupportedOperationException;
	import com.bourre.log.PixlibDebug;
	import com.bourre.log.PixlibStringifier;
	import com.bourre.error.ClassCastException;
	import com.bourre.error.IllegalArgumentException;	

	/** 
	 * A <code>Grid</code> is basically a two dimensionnal data structure
	 * based on the <code>Collection</code> interface.
	 * <p>
	 * By default a <code>Grid</code> object is an untyped collection that
	 * allow duplicate and <code>null</code> elements. You can set your own
	 * default value instead of <code>null</code> by passing it to the grid
	 * constructor.
	 * </p><p>
	 * Its also possible to restrict the type of grid elements in the constructor
	 * as defined by the <code>TypedContainer</code> interface.
	 * </p><p>
	 * The <code>Grid</code> class don't support all the methods of the <code>Collection</code>
	 * interface. Here the list of the unsupported methods : 
	 * <ul>
	 * 	<li><code>add</code></li>
	 * 	<li><code>addAll</code></li>
	 * 	<li><code>isEmpty</code></li>
	 * </ul>
	 * </p><p>
	 * Instead of using the methods above there are several specific methods to insert data in the
	 * grid : 
	 * <ul>
	 * 	<li><code>setVal</code> : Use it to insert value in the grid</li>
	 * 	<li><code>setContent</code> : Use it to set the grid with the passed-in array.</li>
	 * 	<li><code>fill</code> : Use it to fill the grid with the same value in all cells.</li>
	 * </ul>
	 * </p> 
	 * @author	Cédric Néhémie
	 * @see		com.bourre.collection.Collection	 * @see		com.bourre.collection.TypedContainer
	 */
	public class Grid implements Collection, TypedContainer
	{
	
		protected var _vSize : Point;
		protected var _aContent : Array;
		protected var _oDefaultValue : Object;
		protected var _cType : Class;
		
		/**
		 * Create a new grid of size <code>x * y</code>.
		 * <p>
		 * If <code>a</code> is set, and if it have the same size that the grid, 
		 * it's used to fill the collection at creation.
		 * </p><p>
		 * If <code>dV</code> is set, all <code>null</code> elements in the grid
		 * will be replaced by <code>dV</code> value.
		 * </p>
		 * 
		 * @param	x	Width of the grid.
		 * @param	y	Height of the grid.
		 * @param	a	An array to fill the grid with.
		 * @param 	dV 	The default value for null elements.
		 * @throws 	<code>ArgumentError</code> — Invalid size passed in Grid constructor.
		 */
		public function Grid ( x : uint = 1, 
							   y : uint = 1, 
							   a : Array = null, 
							   dV : Object = null, 
							   t : Class = null )
		{
			if( isNaN ( x ) || isNaN ( y ) )
			{
				PixlibDebug.ERROR( "Invalid size in Grid constructor : [" + x + ", " + y + "]" );
				throw new ArgumentError ( "Invalid size in Grid constructor : [" + x + ", " + y + "]" );
			}
			
			_vSize = new Point ( x, y );
			_oDefaultValue = dV;
			_cType = t;
			
			initContent();
			 
			if( a != null )
			{
				setContent ( a );
			}
			else if( _oDefaultValue != null )
			{
				fill( _oDefaultValue );
			}
		}
		
		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * <p>
		 * The function return a string like
		 * <code>com.bourre.structures::Grid&lt;String&gt;</code>
		 * for a typed collection. The string between the &lt;
		 * and &gt; is the name of the type of the collection's
		 * elements. If the collection is an untyped collection
		 * the function will simply return the result of the
		 * <code>PixlibStringifier.stringify</code> call.
		 * </p>
		 * @return <code>String</code> representation of
		 * 		   this object.
		 */
		public function toString () : String
		{
			var hasType : Boolean = getType() != null;
			var parameter : String = "";
			
			if( hasType )
			{
				parameter = getType().toString();
				parameter = "<" + parameter.substr( 7, parameter.length - 8 ) + ">";
			}
			
			return PixlibStringifier.stringify( this ) + parameter + " [" + _vSize.x + ", " + _vSize.y + "]";
		}
		
		/*
		 * Collection interface API implementation
		 */
		
		/**
		 * Returns <code>true</code> if this grid contains at least
		 * one occurence of the specified element. Moreformally,
		 * returns <code>true</code> if and only if this grid contains
		 * at least an element <code>e</code> such that <code>o === e</code>.
		 *
		 * @param	o	<code>Object</code> whose presence in this grid
		 * 			  	is to be tested.
		 * @return 	<code>true</code> if this grid contains the specified
		 * 			element.
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 */
		public function contains( o : Object ) : Boolean
		{
			isValidType( o );
			
			var i : Iterator = iterator();
			
			while( i.hasNext() )
			{
				if( i.next() === o )
					return true;
			}
			return false;
		}
		
		/**
		 * Returns an array containing all the elements in this grid.
		 * Obeys the general contract of the <code>Collection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements
		 * 			in this grid.
		 * @see		Collection#toArray() Collection.toArray()
		 */
		public function toArray() : Array
		{
			var a : Array = [];
			var i : Iterator = iterator();
			
			while ( i.hasNext() ) a.push( i.next() );
			
			return a;
		}
		
		/**
		 * A <code>Grid</code> object is considered as empty if and only if all its cells
		 * contains <code>null</code> or the default value for the current <code>Grid</code>.
		 * 
		 * @return 	<code>true</code> if the grid is empty, either <code>false</code>.
		 */
		public function isEmpty() : Boolean
		{
			var b : Boolean = false;
			var i : Iterator = iterator();
			
			while ( i.hasNext() )
			{
				b = ( i.next() != _oDefaultValue ) || b;
			}
			return !b;
		}
		
		/**
		 * Removes a single instance of the specified element from this
	     * grid, if this grid contains one or more such elements.
	     * Returns <code>true</code> if this grid contained the specified
	     * element (or equivalently, if this collection changed as a result
	     * of the call).
	     * <p>
	     * In order to remove all occurences of an element you have to call
	     * the <code>remove</code> method as long as the grid contains an
	     * occurrence of the passed-in element. Typically, the construct to
	     * remove all occurrences of an element should look like that :
	     * <listing>
	     * while( grid.contains( element ) ) grid.remove( element );
	     * </listing>
	     * </p><p>
		 * If the current grid object is typed and if the passed-in object's  
		 * type prevents it to be added (and then removed) in this grid,
		 * the function throws a <code>ClassCastException</code>.
		 * </p><p>
		 * The <code>Grid</code> introduce a specific behavior for its default
		 * value, if the passed-in element is the default value for this grid
		 * the function return <code>null</code> and isnt't modified as result
		 * of the call.
		 * </p>
	     * @param	o <code>object</code> to be removed from this grid,
	     * 			  if present.
		 * @return 	<code>true</code> if the grid contained the 
		 * 			specified element.
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 */
		public function remove( o : Object ) : Boolean
		{
			isValidType( o );
			
			if( o === _oDefaultValue ) 
				return false;
			
			var i : Iterator = iterator ();

			while( i.hasNext() )
			{
				var e : Object = i.next ();
				if( e === o )
				{
					i.remove();
					return true;
				}
			}
			return false;
		}
				
		/**
		 * Removes all of the elements from this collection.
	     * This collection will not be empty after this method.
	     * <p>
	     * If a default value have been defined for the grid
	     * then all cells of the grid contains that value.
	     * </p>
		 */
		public function clear() : void
		{
			fill ( _oDefaultValue );
		}
		
		/**
		 * Returns an iterator over the elements in this collection. Iterations
		 * are performed in the following order : columns first, rows after. 
		 * <p>
		 * Result for a 2x2 grid : 
		 * <ul>
		 * 	<li>Cell 0, 0</li>
		 *  <li>Cell 1, 0</li>
		 * 	<li>Cell 0, 1</li>
		 * 	<li>Cell 1, 1</li>
		 * </ul>
		 * </p> 
	     * @return 	an <code>Iterator</code> over the elements in this collection.
		 */
		public function iterator() : Iterator
		{
			return new GridIterator( this );
		}
		
		/** 
		 * Removes from this grid all of its elements that are contained
		 * in the specified collection (optional operation). At the end
		 * of the call there's no occurences of any elements contained
		 * in the passed-in collection.
		 * </p><p>
		 * The only values which cannot be removed by a call to <code>removeAll</code>
		 * is the default value for this grid. It result that all cells which contained
		 * a value also contained in the passed-in collection are filled with the grid's
		 * default value.
		 * </p><p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>removeAll</code> method.
		 * </p>
		 * @param	c 	<code>Collection</code> that defines which elements will be
		 * 			  	removed from this grid.
		 * @return 	<code>true</code> if this grid changed as a result
		 * 			of the call.
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.	
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 */
		public function removeAll( c : Collection ) : Boolean
		{
			isValidCollection( c );
			
			var b : Boolean = false;
			var i : Iterator = c.iterator();
			while( i.hasNext() )
			{
				var o : Object = i.next();
				if( o != _oDefaultValue )
					while( contains( o ) ) b = remove( o ) || b;
			} 
			return b;
		}
		
		/**
		 * Returns <code>true</code> if this grid contains
		 * all of the elements of the specified collection. If the specified
		 * collection is also a <code>Grid</code>, this method returns <code>true</code>
		 * if it is a <i>subliset</i> of this queue.
		 * <p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>Collection</code> type is different than the current
		 * one the function will throw an <code>IllegalArgumentException</code>.
		 * However, if the type of this grid is <code>null</code>, 
		 * the passed-in <code>Collection</code> can have any type. 
		 * </p><p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>containsAll</code> method.
		 * </p>
	     * @param  	c 	collection to be checked for containment in this collection.
	     * @return 	<code>true</code> if this collection contains all of the elements
	     *	       	in the specified collection
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.	
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
	     * @see   	#contains(Object)
		 */
		public function containsAll( c : Collection ) : Boolean
		{
			isValidCollection( c );
			
			var i : Iterator = c.iterator();
			while( i.hasNext() ) if( !contains( i.next() ) ) return false;
			return true;
		}
		
		/**
		 * The <code>addAll</code> method is unsupported by the <code>Grid</code> class.
		 * 
		 * @throws 	<code>UnsupportedOperationException</code> — The addAll method of the Collection interface is unsupported by the Grid Class
		 */
		public function addAll( c : Collection ) : Boolean
		{
			PixlibDebug.ERROR( this + ".addAll() method is unsupported." );
			throw new UnsupportedOperationException ( "The addAll method of the Collection interface is unsupported by the Grid class" );
			return false;
		}
		
		/**
		 * Retains only the elements in this queue that are contained
		 * in the specified collection (optional operation). In other words,
		 * removes from this queue all of its elements that are not
		 * contained in the specified collection.
		 * <p>
		 * The only values which cannot be removed by a call to <code>retainAll</code>
		 * is the default value for this grid. It result that all cells which contained
		 * a value that are not contained in the passed-in collection are filled with
		 * the grid's default value.
		 * </p><p>
		 * The rules which govern collaboration between typed and untyped <code>Collection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>retainAll</code> method.
		 * </p>
	     * @param 	c 	elements to be retained in this collection.
	     * @return 	<code>true</code> if this collection changed as a result of the
	     *         	call
	     * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one.	
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
	     * @see 	#remove(Object)
	     * @see 	#contains(Object)
		 */
		public function retainAll( c : Collection ) : Boolean
		{
			isValidCollection( c );
			
			var b : Boolean = false;
			var i : Iterator = iterator();
			
			while( i.hasNext() )
			{
				var o : Object = i.next();	
				if ( o != _oDefaultValue && !(c.contains( o )) ) b = remove( o ) || b;
			}
			return b;
			
		}
		
		/**
		 * The <code>add</code> method is unsupported by the <code>Grid</code> class.
		 * 
		 * @throws 	<code>UnsupportedOperationException</code> — The add method of the Collection interface is unsupported by the Grid Class
		 */
		public function add( o : Object ) : Boolean
		{
			PixlibDebug.ERROR( this + ".add() method is unsupported." );
			throw new UnsupportedOperationException ( "The add method of the Collection interface is unsupported by the Grid class" );
			return false;
		}
		
		/**
	     * Returns the number of elements this collection can contains.
	     * 
	     * @return the number of elements this collection can contains.
	     */
		public function size() : uint
		{
			return _vSize.x * _vSize.y;
		}
		
		/*
		 * Grid specific API
		 */
		
		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>Grid</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * the <code>Grid</code>, either <code>false</code>.
		 */
		public function matchType( o : * ) : Boolean
	    {
	    	return ( o is _cType || o == null );
	    }
	    
	    /**
		 * Returns <code>true</code> if this grid perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this grid perform a verification
		 * 			of the type of elements.
		 */
		public function isTyped () : Boolean
		{
			return _cType != null;
		}
	    
	    /**
	     * Return the current type allowed in the <code>Grid</code>
	     * 
	     * @return <code>Class</code> used to type checking.
	     */
	    public function getType () : Class
	    {
	    	return _cType;
	    }
	    
	    /**
		 * Verify that the passed-in <code>Collection</code> is a valid
		 * collection for use with the <code>addAll</code>, <code>removeAll</code>,
		 * <code>retainAll</code> and <code>containsAll</code> methods.
		 * <p>
		 * When dealing with typed and untyped collection, the following rules apply : 
		 * <ul>
		 * <li>Two typed collection, which have the same type, can collaborate each other.</li>
		 * <li>Two untyped collection can collaborate each other.</li>
		 * <li>An untyped collection can add, remove, retain or contains any typed collection
		 * of any type without throwing errors.</li>
		 * <li>A typed collection will always fail when attempting to add, remove, retain
		 * or contains an untyped collection.</li>
		 * </ul></p><p>
		 * If the passed-in <code>Collection</code> is null the method throw a
		 * <code>NullPointerException</code> error.
		 * </p>
		 * 
		 * @param	c <code>Collection</code> to verify
		 * @return 	boolean <code>true</code> if the collection is valid, 
		 * 			either <code>false</code> 			
		 * @throws 	<code>NullPointerException</code> — If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	<code>IllegalArgumentException</code> — If the passed-in collection
		 * 			type is not the same that the current one
		 * @see		#addAll() addAll()
		 * @see		#removeAll() removeAll()
		 * @see		#retainAll() retainAll()
		 * @see		#containsAll() containsAll()
		 */
		public function isValidCollection ( c : Collection ) : Boolean
		{
			if( c == null ) 
			{
				PixlibDebug.ERROR( "The passed-in collection is null in " + this );
				throw new NullPointerException( "The passed-in collection is null in " + this );
			}
			else if( getType() != null )
			{
				if( c is TypedContainer && ( c as TypedContainer ).getType() != getType() )
				{
					PixlibDebug.ERROR( "The passed-in collection is not of the same type than " + this );
					throw new IllegalArgumentException( "The passed-in collection is not of the same type than " + this );
				}
				else
				{
					return true;
				}
			}
			else
			{
				return true;
			}
		}
		
		/**
		 * Verify that the passed-in object type match the current 
		 * <code>Grid</code> element's type. 
		 * <p>
		 * In the case that the grid is untyped the function
		 * will always returns <code>true</code>.
		 * </p><p>
		 * In the case that the object's type prevents it to be added
		 * as element for this grid the method will throw
		 * a <code>ClassCastException</code>.
		 * </p> 
		 * @param	o <code>Object</code> to verify
		 * @return  <code>true</code> if the object is elligible for this
		 * 			grid object, either <cod>false</code>
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 */
		public function isValidType ( o : Object ) : Boolean
		{
			if ( getType() != null)
			{
				if ( matchType( o ) )
				{
					return true;
				}
				else
				{
					PixlibDebug.ERROR( o + " has a wrong type for " + this );
					throw new ClassCastException( o + " has a wrong type for " + this ) ;
				}
			}
			else
				return true ;
		}
	    
		/**
		 * Creates the internal two dimensional array used to store
		 * data of the grid.
		 */
		protected function initContent() : void 
		{
			_aContent  = new Array( _vSize.x );
			for ( var x : Number = 0; x < _vSize.x; x++ ) 
				_aContent[ x ] = new Array( _vSize.y );
		}
		
		/**
		 * Fill the current grid with the passed-in value.
		 * <p>
		 * If the passed-in value is a "real" object (not a primitive) then
		 * all cells contains a reference to the same object.
		 * </p>
		 * @param	o	Value used to fill the grid
		 */
		public function fill ( o : Object ) : void
		{
			isValidType( o );
			
			var i : Iterator = iterator ();
			
			while ( i.hasNext() )
			{
				i.next();
				
				setVal ( i as GridIterator, o );
			}
		}
		
		/**
		 * Removes the value located at the passed-in coordinate.
		 * <p>
		 * If the grid changed after the call the function returns
		 * <code>true</code>. If the passed-in <code>Point</code> isn't
		 * a valid coordinate for this grid the function failed and return
		 * <code>false</code>.
		 * </p><p>
		 * If a default value is set, the cell contains that value instead
		 * of <code>null</code> after the call.
		 * </p>
		 * @param	p	<code>Point</code> position of the value to remove
		 * @return 	<code>true</code> if the grid changed as result of the call
		 * @throws 	<code>IndexOutOfBoundsException</code> — the passed-in point
		 * 			is not a valid coordinates for this grid
		 */
		public function removeAt ( p : Point ) : Boolean
		{			
			return setVal ( p, _oDefaultValue );			
		}
		
		/**
		 * Check if a <code>Point</code> object is a valid coordinate
		 * in the current grid.
		 * 
		 * @param	p	<code>Point</code> object to check
		 * @return 	<code>true</code> if passed-in <code>Point</code> is a valid
		 * 			coordinate for the current grid
		 * @throws 	<code>IndexOutOfBoundsException</code> — the passed-in point
		 * 			is not a valid coordinates for this grid
		 */
		public function isGridCoords ( p : Point ) : Boolean
		{
			if ( !( p.x >= 0 && p.x < _vSize.x && p.y >= 0 && p.y < _vSize.y ) )
				throw new IndexOutOfBoundsException ( p + " is not a valid grid coordinates for " + this );
				
			return true;
		}

		/**
		 * Returns the size of the grid as <code>Point</code>.
		 * <p>
		 * The returned <code>Point</code> is a clone of the
		 * internal one.
		 * </p>
		 * @return 	the dimensions of the grid as <code>Point</code>
		 */
		public function getSize () : Point
		{
			return _vSize.clone(); 
		}
		
		/**
		 * Returns a <code>Point</code> witch is the corresponding
		 * position of the passed-in value.
		 * 
		 * @param 	id	<code>uint</code> to convert in a two dimension location
		 * @return 	<code>Point</code> corresponding location
		 * @throws 	<code>IndexOutOfBoundsException</code> — the passed-in index
		 * 			is not a valid coordinates for this grid
		 */
		public function getCoordinates ( id : uint ) : Point
		{
			var nY : Number = Math.floor( id / _vSize.x );
			var p : Point = new Point( id - ( nY * _vSize.x ), nY );
			
			isGridCoords( p );
			
			return p;
		}
		
		/**
		 * Returns the current default value of this grid used
		 * to replace value when removing an element.
		 * 
		 * @return	element used as default value for the grid's cells
		 */
		public function getDefaulValue () : Object
		{
			return _oDefaultValue;
		}
		
		/**
		 * Defines the default value for this grid's cells content. 
		 * When changing the default value of a grid, the cells which
		 * previously contains the old default value will contains the
		 * new one at the end of the call.
		 * 
		 * @param	o	new default value for this grid's cells
		 * @return	<code>true</code> if the grid have change as result
		 * 			of the call
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 */
		public function setDefaultValue ( o : Object ) : Boolean
		{
			isValidType( o );
			
			var oldDV : Object = _oDefaultValue;
			_oDefaultValue = o;
			
			return removeAll( new WeakCollection( [ oldDV ] ) );
		}

		/**
		 * Returns the element stored at the passed-in coordinate of the
		 * grid.
		 * 
		 * @param 	p	Coordinates <code>Point</code> in the grid
		 * @return  Value stored at the coorespoding location or <code>null</code>
		 * 			if the passed-in coordinates is not a valid coordinates
		 * 			for this grid
		 * @throws 	<code>IndexOutOfBoundsException</code> — the passed-in point
		 * 			is not a valid coordinates for this grid
		 */
		public function getVal ( p : Point ) : Object
		{
			isGridCoords ( p );
			
			return _aContent [ p.x ][ p.y ];
		}
			
		/**
		 * Defines value of grid cell defining by passed-in <code>Point</code> 
	 	 * coordinate.
	 	 * <p>
	 	 * The call return <code>true</code> only if the <code>Grid</code>
	 	 * changed as results of the call.
	 	 * </p> 
		 * @param 	p	<code>Point</code> position of the cell
		 * @param 	o	value to store in the grid
		 * @return  <code>true</code> if the <code>Grid</code> changed as results of the call
		 * @throws 	<code>IndexOutOfBoundsException</code> — the passed-in point
		 * 			is not a valid coordinates for this grid
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 */
		public function setVal ( p : Point, o : Object ) : Boolean
		{
			isValidType( o );
			isGridCoords ( p );
			
			if( o === _aContent [ p.x ][ p.y ])
			{
				return false;
			}
			
			if( o == null && _oDefaultValue != null ) 
				o = _oDefaultValue;
			
			
			_aContent [ p.x ][ p.y ] = o;
			return true;
		}
		
		/**
		 * Fill the content with an array of witch length is equal to
		 * the grid <code>size()</code>.
		 * <p>
		 * The call return <code>true</code> only if the <code>Grid</code>
	 	 * changed as results of the call.
	 	 * </p>
		 * @param 	a	<code>Array</code> to fill the <code>Grid</code>
		 * @return 	<code>true</code> if the <code>Grid</code> changed as results of the call
		 * @throws 	<code>ClassCastException</code> — If the object's type
		 * 			prevents it to be added into this grid
		 */
		public function setContent ( a : Array ) : Boolean
		{
			if( a.length != size () )
			{
				PixlibDebug.ERROR( "Passed-in array doesn't match " + this + ".size()");
				return false;
			}
			var l : Number = a.length;
			var b : Boolean = false;
			while (--l-(-1))
			{
				var p : Point = getCoordinates ( l );
				b = setVal ( p, a[ l ] ) || b;
			}
			
			return true;
		}
	}
}

import flash.geom.Point;

import com.bourre.collection.Iterator;
import com.bourre.error.IllegalStateException;
import com.bourre.error.NoSuchElementException;
import com.bourre.structures.Grid;

internal class GridIterator extends Point implements Iterator
{
	
	private var _nIndex : Number;
	private var _nLength : Number;
	private var _oGrid : Grid;	
	private var _bRemoved : Boolean;

	public function GridIterator ( g : Grid )
	{
		_oGrid = g;
		_nIndex = -1;
		_nLength = _oGrid.size();
		_bRemoved = false;
	}
	
	public function hasNext() : Boolean
	{
		return ( _nIndex + 1 ) < _nLength;
	}
 	public function next() : *
 	{
 		if( !hasNext() )
			throw new NoSuchElementException ( this + " has no more elements at " + ( _nIndex ) );
 		
 		var p : Point = _oGrid.getCoordinates( ++_nIndex );
 		x = p.x;
 		y = p.y;
 		_bRemoved = false;
		return _oGrid.getVal( this );
 	}
    public function remove() : void
    {
    	if( !_bRemoved )
    	{
	    	_oGrid.removeAt( this );
	    	_bRemoved = true;
    	}
    	else
		{
			throw new IllegalStateException ( this + ".remove() have been already called for this iteration" );
		}
    }
}
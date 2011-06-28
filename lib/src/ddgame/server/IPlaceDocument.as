package ddgame.server {

	/**
	 *	Interface des données pour les documents de type scène
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Christopher Corbin
	 *	@since  31.03.2011
	 */
	public interface IPlaceDocument extends IDatabaseDocument {
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		/**
		 * Intitulé de la scène
		 */
		function get title () : String;
		function set title (val:String) : void;

		/**
		 * Etat de publication
		 */
		function get hidden () : Boolean;
		function set hidden (val:Boolean) : void;

		/**
		 * Fichier arrière, avant plan et fond sonore
		 * Définit en tant qu'objet pour assurer la
		 * compatibilé des versions avant bascule vers
		 * système définitif
		 */
		function get background () : Object;
		function set background (val:Object) : void;
		function get foreground () : Object;
		function set foreground (val:Object) : void
		function get music () : Object;
		function set music (val:Object) : void;

		/**
		 * Dimension de la grille, nombre de cellules
		 * en largeur, hauteur et profondeur
		 * { x:int, y:int, z:int }
		 */
		function get cellsNumber () : Object;
		function set cellsNumber (val:Object) : void;

		/**
		 * Pas de la grille. Dimension des cellules
		 * en largeur, hauteur et profondeur
		 * { width:int, height:int, depth:int }
		 */
		function get cellsSize () : Object;
		function set cellsSize (val:Object) : void;		

		/**
		 * Position du point de vue sur la scène
		 * Regroupe actuelement le décalage x / y des calques
		 * de la scène et facteur de redimensionnement de la scène.
		 * A terme devra au moins définir une coordonnée céllule (ex:{x:int,y:int,z:int}).
		 * { xOffset:int, yOffset:int }
		 */
		function get camera () : Object;
		function set camera (val:Object) : void;

		/**
		 * Point d'entrée dans la scène
		 * { x:Number, y:Number, z:Number }
		 */
		function get entrance () : Object;
		function set entrance (val:Object) : void;		
		
		/**
		 * Grille de collisions
		 */
		function get collisions () : Array;
		function set collisions (val:Array) : void;
		
		/**
		 * Models des objets, librairie des descripteurs
		 * d'objets.
		 * TODO documenter plus en profondeur.
		 */
		function get objectsModels () : Object;
		
		/**
		 * Liste des objets
		 */
		function get objects () : Array;
		function set objects (val:Array) : void;		
		
		/**
		 * Liste des actions
		 */
		function get actions () : Array;
		function set actions (val:Array) : void;		
		
		/**
		 * Localisation
		 * { address:String, lat:Number, lon:Number }
		 */
		function get location () : Object;
		function set location (val:Object) : void;		
		
		/**
		 * Variables / pointeurs
		 */
		function get variables () : Object;
		function set variables (val:Object) : void;
	
	}

}


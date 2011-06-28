package com.sos21.tileengine.display {

	import flash.events.IEventDispatcher;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import com.sos21.tileengine.core.ITile;
	import com.sos21.tileengine.core.AbstractTile;
	
	/*
	 *	Description
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author toffer
	 */
	public interface ITileView {
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Définit le model au quel
		 * est rattachée cette instance
		 */
		function setModel(m:DisplayObjectContainer):void
		
		/**
		 *	Retourne le model au quel
		 * est rattachée cette instance
		 */
		function getModel():DisplayObjectContainer
				
		/**
		 *	Affiche la prochaine image de l'ation encours
		 */
		function nextFrame():void

		/**
		 *	Affiche l'image précédente de l'ation encours
		 */
		function prevFrame():void

		/**
		 *	Dessine l'action correspondante à
		 * l'étiquette passée en param
		 * param		label		étiquette de l'action
		 */
		function draw(label:Object):void
		
		/**
		 *	Ajoute une ressource graphique
		 */
		function addAsset(dO:DisplayObject):void
		
		/**
		 *	Relache de la vue
		 */
		function release():void;
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * Retourne la liste des angles de l'animation
		 * courante
		 */
		function get angles () : Array;
		
		/**
		 * Retourne le tableau d'animations
		 */
		function get animations () : Array;
		
		/**
		 *	Affiche une l'image de l'action en cours
		 * @param	val	numéro de l'image à afficher
		 */
		function set frame(val:int):void
		
		/**
		 *	Retourne le numéro d'image actuel de l'action en cours
		 */
		function get frame():int
		
		/**
		 *	Retourne l'étiquette de l'action en cours
		 */
		function get label():Object
		
		/**
		 *	Retourne le nombre d'images total de l'action
		 * en cours 
		 */
		function get totalFrames():int
	}
	
}

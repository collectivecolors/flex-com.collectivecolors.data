package com.collectivecolors.data
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.errors.InvalidInputError;
  import com.collectivecolors.validators.URLValidator;
  
  import mx.events.ValidationResultEvent;
  import mx.utils.StringUtil;
	  
  //----------------------------------------------------------------------------
  
  public class URLSet
  {
    //--------------------------------------------------------------------------
    // Properties
    
    private var _urls : Object = { };
		private var urlCache : Array;
		
		private var validator : URLValidator;
    
    //--------------------------------------------------------------------------
    // Constructor
    
    public function URLSet( )
    {
      validator = new URLValidator( );
      
      // Initialize URL validator
			validator.triggerEvent     = '';
			validator.required         = true;
			validator.allowedProtocols = [ 'http', 'https' ];
    }
    
    //--------------------------------------------------------------------------
    // Accessor / modifiers
    
    /**
     * Set allowed protocols for URLs in this set.
     */ 
    public function set allowedProtocols( values : Array ) : void
    {
      validator.allowedProtocols = values;  
    }
    
    /**
     * Set allowed file extensions for URLs in this set.
     */ 
    public function set allowedFileExtensions( values : Array ) : void
    {
      validator.allowedFileExtensions = values;
    }
    
    /**
     * Get all URLs in this set.
     */ 
		public function get urls( ) : Array
		{
		  if ( urlCache == null ) {
			  urlCache = [ ];
			
			  for ( var url : String in _urls )
			  {
				  urlCache.push( url );
			  }
		  }
			
			return urlCache;
		}
		
		/**
		 * Set all URLs in this set.
		 */
		public function set urls( value : Array ) : void
		{
		  _urls = { };
		  
		  for each( var url : String in value )
		  {
		    addUrl( url );
		  }  
		}
		
		/**
		 * Add a single URL to this set.
		 */
		public function addUrl( url : String ) : void
		{
			// Clean url.
			url = StringUtil.trim( url );
			
			// Validate url.
			var urlError : ValidationResultEvent = validator.validate( url, true );
			
			if ( urlError.type == ValidationResultEvent.INVALID )
			{			
				// Bad url input.
				throw new InvalidInputError( urlError.message );
			}
			
			// Add url to collection.
			_urls[ url ] = url;
			
			// Clear cache.
			urlCache = null;
		}
		
		/**
		 * Remove an eexisting URL from this set.
		 */
		public function removeUrl( url : String ) : void
		{
		  // Remove url from collection.
		  delete _urls[ url ];
		  
		  // Clear cache.
		  urlCache = null;
		}
	}
}
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
		
		private var deletedUrlsCache : Array;
    
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
    public function set allowedProtocols( values : Array ):void
    {
      validator.allowedProtocols = values;
            
      checkUrls( );
    }
    
    /**
     * Set allowed file extensions for URLs in this set.
     */ 
    public function set allowedFileExtensions( values : Array ):void
    {
      validator.allowedFileExtensions = values;
      
      checkUrls( );
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
		 * Get all URLs that were deleted upon last protocol/extension update
		 */
		 public function get deletedUrls( ) : Array
		 {
		 	return deletedUrlsCache;
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
		 * Remove an existing URL from this set.
		 */
		public function removeUrl( url : String ) : void
		{
		  // Remove url from collection.
		  delete _urls[ url ];
		  
		  // Clear cache.
		  urlCache = null;
		}
		
		/**
		 * Make sure all URLs in this set are of the correct protocol and extension.
		 * 
		 * This is called when these settings change.
		 */
		private function checkUrls( ) : void
		{
		  // Create an array to house the deleted URLs
		  deletedUrlsCache = [ ];	
			
		  // Go through all existing urls.
		  for each ( var url : String in urls )
		  {
		    // Validate url.
			  var urlError : ValidationResultEvent = validator.validate( url, true );
			
			  if ( urlError.type == ValidationResultEvent.INVALID )
			  {	  
			  	  // Add deleted URL to deletedUrls array
			  	  deletedUrlsCache.push(url);		
				  // Bad url input.  Remove from this set.
				  removeUrl( url );
			  }
		  }
		}
	}
}
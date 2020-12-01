({
    afterRender : function( component, helper ) {
        
        this.superAfterRender();
        
        // this is done in renderer because we don't get
        // access to the window element in the helper js.
        
        // per John Resig, we should not take action on every scroll event
        // as that has poor performance but rather we should take action periodically.
        // http://ejohn.org/blog/learning-from-twitter/
        
        var didScroll = false;
        
        
        window.onscroll = function() {
            didScroll = true;
            if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                document.getElementById("BackToTop").style.display = "block";
            } else {
                document.getElementById("BackToTop").style.display = "none";
            }
        };
        var scrollCheckIntervalId = setInterval( $A.getCallback( function() {
            // since this function is called asynchronously outside the component's lifecycle
            // we need to check if the component still exists before trying to do anything else
            if ( didScroll && component.isValid() ) {     
                didScroll = false;
            
                var min=4; 
                var max=5;  
                var random = Math.random() * (+max - +min) + +min; 
                 component.set('v.scrollCheckIntervalId', random );
            }
            }), 1000 );
        
    }
})
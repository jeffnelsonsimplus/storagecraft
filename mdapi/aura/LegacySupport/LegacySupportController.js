({
	doInit : function(component, event, helper) {
        var hash = window.location.hash.substring(1);
        console.log(hash);
        if(hash.length == 0 || hash.indexOf('/support') != 0){
            hash = "/support/forum";
        }
		component.set("v.srcUrl","https://oldsite.storagecraft.com"+hash);
		
        // I was trying to add a search function here but it wouldn't work so I commented this out for now.
        // var searchtext = component.search;
        // console.log(searchtext);
        // if(searchtext.length != 0){
        //    hash = "/support/search/node/"+searchtext;
        // }
        // component.set("v.srcUrl","http://10.2.1.15"+hash);
         
        window.addEventListener("message", function(event)
        {
            var loc = new URL(event.data.url);
            window.location.hash = '#'+encodeURI(loc.pathname + loc.search + loc.hash);
        }, false);

    }
})
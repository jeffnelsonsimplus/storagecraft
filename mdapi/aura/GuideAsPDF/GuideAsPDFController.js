({
    
    doInit : function(component, event) {
        var action = component.get("c.getNextArticle");
        
        action.setParams({
        	articleId : component.get("v.recordId")
    	});
        action.setCallback(this, function(a) {
            component.set("v.me", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
    }
}
})
({
    
    doInit : function(component, event) {
        var action = component.get("c.getNextArticle");
        
        action.setParams({
        	articleId : component.get("v.recordId"),
            lang : component.get("v.languageVal")
    	});
        action.setCallback(this, function(a) {
            component.set("v.next", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var pAction = component.get("c.getPrevArticle");
        
        pAction.setParams({
        	articleId : component.get("v.recordId"),
            lang : component.get("v.languageVal")
    	});
        pAction.setCallback(this, function(a) {
            component.set("v.prev", a.getReturnValue());
        });
        $A.enqueueAction(pAction);
        
        
    }
}
})
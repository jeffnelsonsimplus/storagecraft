({
    
    doInit : function(component, event) {
        var action = component.get("c.findAllLandingPages");
        
        action.setParams({
            lang : component.get("v.languageVal")
    	});
        
        action.setCallback(this, function(a) {
            component.set("v.guidesections", a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var nAction = component.get("c.getFieldLabels");

        nAction.setCallback(this, function(a) {
            component.set('v.fieldLabelMap', a.getReturnValue());
        });

        $A.enqueueAction(nAction);
        
    }
}
})
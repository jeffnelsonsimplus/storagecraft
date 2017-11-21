({
	getReportResponse : function(component, event, helper) {
        var action = component.get("c.getReportResponse");
		//var report = event.getParam("report");
        
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-show"); 
        //clear the matched list of report search results
		component.set("v.reportResponse", []);        
        component.set("v.period",component.find('periodId').get('v.value'));
        action.setParams({"period": component.find('periodId').get('v.value')});
        action.setCallback(this, function(a){
            
            
			var reportResponseObj = JSON.parse(a.getReturnValue());
            component.set("v.reportResponse", reportResponseObj);
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            
        });
        $A.enqueueAction(action);
        
    },
    toggleClass: function(component,componentId,className) {
    var modal = component.find(componentId);
    $A.util.removeClass(modal,className+'hide');
    $A.util.addClass(modal,className+'open');
},

toggleClassInverse: function(component,componentId,className) {
    var modal = component.find(componentId);
    $A.util.addClass(modal,className+'hide');
    $A.util.removeClass(modal,className+'open');
    
 },
 getactdetails: function(component, event, helper)
{
    var action = component.get("c.getactivitydetails");

        //clear the matched list of report search results
		component.set("v.details", []);        
        
        action.setParams({"uId": event.getParam("uId"),
                          "reportField": event.getParam("reportField"),
    					  "period": event.getParam("period")});
        action.setCallback(this, function(a){
			var detailsObj = JSON.parse(a.getReturnValue());

            component.set("v.details", detailsObj);
            //var spinner = component.find("dSpinner");
            //$A.util.toggleClass(spinner, "slds-hide");
        });
        $A.enqueueAction(action);
    }
})
({
    displayModal: function(component, event, helper)
    {
       var userevent = $A.get("e.c:SalesActivityandLoginhistoryAppEvent");
       userevent.setParams({ "uId": component.get("v.row").uid,
                          "reportField": component.get("v.row").reportField,
    					  "period": component.get("v.period")});
       userevent.fire(); 
    }
 })
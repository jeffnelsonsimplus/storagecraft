({
	doInit : function(component, event, helper) {
        
        var cmp = component.find('periodId');
        cmp.set('v.value','LAST_N_DAYS:7');
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
		helper.getReportResponse(component, event, helper);
        
	},
    changeperiod : function(component, event, helper) {
        
		helper.getReportResponse(component, event, helper);
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
	},

showModal: function(component, event, helper) {
     //Toggle CSS styles for opening Modal
    
    
    helper.toggleClass(component,'backdrop','slds-backdrop--');
    helper.toggleClass(component,'modaldialog','slds-fade-in-');
    helper.getactdetails(component,event,helper);
    
},

hideModal : function(component, event, helper) {
     //Toggle CSS styles for hiding Modal

    helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
    helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
  },
    export : function(component, event, helper) {
        var reportresp = component.get("v.reportResponse");
        var reportFields=reportresp.reportFields;
        var dataList=reportresp.fieldDataList;
        var data = [];
        var headerArray = [];
        var csvContentArray = [];
        //Provide the title 
        var CSV = 'rncsvfilern';
        //console.log(reportFields);
        //console.log(dataList);
        //Fill out the Header of CSV
        for(var i=0;i<reportFields.length;i++)
        {
        	headerArray.push(reportFields[i]);
        }

        data.push(headerArray);
        //console.log(data);
        
        for(var i=0;i<dataList.length;i++){
            
            //Check for records selected by the user
            
                //Initialize the temperory array
                var tempArray = [];
                tempArray=dataList[i];
                //console.log(tempArray);
                var dataValue=[];
                for(var j=0;j<tempArray.length;j++)
                {
                dataValue.push('"'+tempArray[j].value+'"');
                
                }
                data.push(dataValue);
            }
            //console.log(data);
        
        
        for(var j=0;j<data.length;j++){
            var dataString = data[j].join(",");
            csvContentArray.push(dataString);
        }
        var csvContent = csvContentArray.join("\r\n");
        
        //Generate a file name
        var fileName = "SalesRepActivtityReport";
        //this will remove the blank-spaces from the title and replace it with an underscore
           
        fileName += ".csv";
        //Initialize file format you want csv or xls
        var uri = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent);
        
        if (navigator.msSaveBlob) { // IE 10+
            console.log('----------------if-----------');
            var blob = new Blob([csvContent],{type: "text/csv;charset=utf-8;"});
            console.log('----------------if-----------'+blob);
        	navigator.msSaveBlob(blob, fileName);
        }
        else{
            // Download file
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension    
            var link = document.createElement("a");

            //link.download to give filename with extension
            //link.download = fileName;
            link.setAttribute('download',fileName);
            //To set the content of the file
            link.href = uri;
            
            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            
            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
          
    	}
    }
})
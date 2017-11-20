public class SalesActivityandLoginhistoryreport { 
    
	public class SalesActLogdtl
	{
	    @AuraEnabled
		public String Name {get;set;}
		@AuraEnabled
		public Map<String,Integer> actdtls {get;set;}
		@AuraEnabled
		public Map<String,Integer> logindtls {get;set;}

		public SalesActLogdtl()
		{
			Name='';
			actdtls = new Map<String,Integer>();
			logindtls = new Map<String,Integer>();

		}
	}
    
	/*@AuraEnabled
	public tabularReportResponse tabResp {get; set;}*/

	public class tabularReportResponse {
    public List<String> reportFields {get; set;}
    public Integer noactivityFields {get; set;}
    public List<List<fieldDetails>> fieldDataList {get; set;}
    public Integer nooflogfields {get; set;}
    public tabularReportResponse(){}
    }
    
    public class fieldDetails 
    {
        public String uid {get;set;}
        public String reportField {get;set;}
        public String value {get;set;}
        
        public fieldDetails(String uid,String type,String value)
        {
            this.uid=uid;
            this.reportField=type;
            this.value=value;
            
        }
    }
    /*@AuraEnabled
    public Activityloghistorydts alhd {get;set;}*/
    public class Activityloghistorydts
    {
        public List<Task> listofTasks {get;set;}
        public List<Event> listofEvents {get;set;}
        public List<LoginHistory> listofloginHistories {get;set;}
        
        public Activityloghistorydts()
        {
            listofTasks = new List<Task>();
            listofEvents = new List<Event>();
            listofloginHistories = new List<LoginHistory>();
        }
    }
    @AuraEnabled
	public static String getReportResponse(String period) {
    	return JSON.serialize(SalesActivityandLoginhistoryreport.getSalesActLogdtls(period));    
	}
	public static tabularReportResponse getSalesActLogdtls(String period)
	{
	   Map<Id,SalesActLogdtl> msalesactlogdtls= new Map<Id,SalesActLogdtl>();

	   Set<String> sreportFields = new Set<String>();
	   Set<String> slogreportFields = new Set<String>();
	   sreportFields.add('Full Name');
	   List<AggregateResult> lataskdtls = Database.Query('SELECT CreatedById,CreatedBy.Name name ,Type,Count(Id)'+
	   								' FROM Task where CreatedBy.SalesRep__c=true and DAY_ONLY(convertTimezone(createdDate))='+period+
	   								' GROUP BY Type, CreatedById,CreatedBy.Name');
	   if(!lataskdtls.isempty())
	   {
	      SalesActLogdtl sald;
	      for(AggregateResult ar: lataskdtls)
	      {
	         sald= new SalesActLogdtl();
             Id uid=Id.valueOf(String.valueof(ar.get('CreatedById')));
	      	 sald.Name=String.valueOf(ar.get('name'));
	      	 if(msalesactlogdtls.containskey(uid))
	      	 {
	      	 	sald=msalesactlogdtls.get(uid);
	      	 } 
	         String Type=String.valueOf(ar.get('Type'));
	         if(Type==null)
	         	Type='None';
	         sald.actdtls.put(Type,Integer.valueOf(ar.get('expr0')));
	         sreportFields.add(Type);
	         msalesactlogdtls.put(uid,sald);
	      }

	   }

	   List<AggregateResult> laeventdtls =Database.query('SELECT CreatedById,CreatedBy.Name name ,Type,Count(Id) '+
	   								' FROM Event where CreatedBy.SalesRep__c=true and DAY_ONLY(convertTimezone(createdDate))='+period +
	   								' GROUP BY Type, CreatedById,CreatedBy.Name');
	   if(!laeventdtls.isempty())
	   {
	      SalesActLogdtl sald;
	      for(AggregateResult ar: laeventdtls)
	      {
	         sald = new SalesActLogdtl();
             String uid=Id.valueOf(String.valueOf(ar.get('CreatedById')));
	      	 sald.Name=String.valueOf(ar.get('name'));
	      	 if(msalesactlogdtls.containskey(uid))
	      	 {
	      	 	sald=msalesactlogdtls.get(uid);
	      	 } 
	      	 String Type=String.valueOf(ar.get('Type'));
	         if(Type==null)
	         	Type='None';
	      	 Map<String,Integer> mactdtls = new Map<String,Integer>();
	      	 mactdtls=sald.actdtls;
	         if(mactdtls.containskey(Type))
	         {
	         	sald.actdtls.put(Type,(Integer.valueOf(ar.get('expr0'))+sald.actdtls.get(Type)));
             }
	         else
	         {
	         	sald.actdtls.put(Type,Integer.valueOf(ar.get('expr0')));
	         }
	         sreportFields.add(Type);
	         msalesactlogdtls.put(uid,sald);

	      }

	   }
       Map<Id,User> musers = new Map<Id,User>([Select Id,Name from User 
	      							       where IsActive=true and SalesRep__c=true]);
	   Set<Id> suserids = new Set<Id>();
        suserids.addall(musers.keyset());
        List<AggregateResult> laloginhistory =Database.query('SELECT UserId,DAY_ONLY(convertTimezone(LoginTime)),Count(Id) '+
	   								' FROM LoginHistory where UserId in: suserids and DAY_ONLY(convertTimezone(LoginTime))='+period +
	   								' GROUP BY DAY_ONLY(convertTimezone(LoginTime)), UserId');
	   if(!laloginhistory.isempty())
	   {
	      SalesActLogdtl sald;
	      
	      for(AggregateResult ar: laloginhistory)
	      {
	      	 Id uid=Id.valueOf(String.valueof(ar.get('UserId')));
             sald=new SalesActLogdtl();
       
	      	 String dt =String.valueOf(Date.valueOf(ar.get('expr0')));
	      	 if(musers.containskey(uid))
	      	 {
	      	 	
		      	 if(msalesactlogdtls.containskey(uid))
		      	 {
		      	 	sald=msalesactlogdtls.get(uid);
		      	 } 
                 sald.Name=musers.get(uid).Name;
		      	 sald.logindtls.put(dt,Integer.valueOf(ar.get('expr1')));
		         
		         msalesactlogdtls.put(uid,sald);
	      	 }
	      	 slogreportFields.add(dt);

	      }

	   }
	   System.debug(msalesactlogdtls.values());
	   List<String> lreportFields = new List<String>();
	   lreportFields.addAll(sreportFields);
	   List<String> llogreportFields= new List<String>();
	   llogreportFields.addAll(slogreportFields);
	   llogreportFields.sort();
	   lreportFields.addAll(llogreportFields);
	   List<List<fieldDetails>> fieldDataList = new List<List<fieldDetails>>();
	   for(Id uid: msalesactlogdtls.keyset())
	   {
	      List<fieldDetails> dataList = new List<fieldDetails>();
	      Map<String,Integer> mdatalist = new Map<String,Integer>();
          SalesActLogdtl sal=msalesactlogdtls.get(uid);
	      mdatalist.putAll(sal.actdtls);
	      mdatalist.putAll(sal.logindtls);
	      for(String rps:lreportFields)
	      {
	      	if(mdatalist.containsKey(rps))
	      	{
	      	  dataList.add(new fieldDetails(uid,rps,String.valueOf(mdatalist.get(rps))));
	      	}
	        else if(rps=='Full Name')
	        {
	          dataList.add(new fieldDetails(uid,rps,sal.name));
	        }
	        else
	        {
	        	dataList.add(new fieldDetails(uid,rps,'0'));
	        }
	      }
	      fieldDataList.add(dataList);
	   }
	   tabularReportResponse tr = new tabularReportResponse();
	   tr.reportFields = lreportFields;
	   tr.fieldDataList = fieldDataList;
	   tr.nooflogfields=llogreportFields.size();
	   tr.noactivityFields=lreportFields.size()-tr.nooflogfields-1;
	   System.debug(tr);
	   return tr;
	}
	
    @AuraEnabled
    public static String getactivitydetails(String uId, String reportField, String period) {
        //System.debug(period);
    	return JSON.serialize(SalesActivityandLoginhistoryreport.getdetails(uId,reportField,period));    
	}
    public static Activityloghistorydts getdetails(String uId, String reportField, String period)
    {
        Activityloghistorydts als = new Activityloghistorydts();
        Date dt;
        if(reportField=='None')
            reportField='';
        try
        {
            dt =date.valueOf(reportField);
        }
        catch(Exception e)
        {
            system.debug(e.getMessage());
        }
        
        List<Task> ltasks = Database.Query('Select Id, Description,Subject,ActivityDate from Task where createdDate='+period+' AND CreatedById=\''+uid+'\' AND Type=\''+reportField+'\'');
        
        
        
        List<LoginHistory> lloginhistory = new List<LoginHistory>();
        if(dt!=null)
        {
            lloginhistory = Database.query('Select Id,Status,Platform,LoginUrl,LoginTime from LoginHistory where DAY_ONLY(convertTimezone(LoginTime))='+reportField+' AND UserId=\''+uid+'\'');
        }
        
        
        List<Event> levents = Database.Query('Select Id, Description,Subject,ActivityDate from Event where DAY_ONLY(convertTimezone(createdDate))='+period+' AND CreatedById=\''+uid+'\' AND Type=\''+reportField+'\'');
        
        als.listofTasks = ltasks;
        als.listofEvents = levents;
        als.listofloginHistories = lloginhistory;
        return als;
    }
}
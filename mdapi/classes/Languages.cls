public class Languages {    
    public static String determineName(Integer num) {
        for (Languages__c l : Languages__c.getAll().values()) {
            if (l.Number__c == num) {
                return l.Name;
            }
        }
        return null;
    }
    
    public static Integer determineNumber(String name) {
        for (Languages__c l : Languages__c.getAll().values()) {
            if (name.Equals(l.Name)) {
                return (Integer)l.Number__c;
            }
        }
        return -1;
    }    
    
	public static List<SelectOption> selectOptions(Boolean valueAsNumber) { 
        List<SelectOption> options = new List<SelectOption>();

        for(Languages__c option : Languages__c.getAll().values()){
            if (valueAsNumber) {
            	options.add(new SelectOption(option.Number__c.format(), option.Name));
            } else {
            	options.add(new SelectOption(option.Name, option.Name));
            }
        }

        return options;
    }
}
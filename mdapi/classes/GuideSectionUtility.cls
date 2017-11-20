public class GuideSectionUtility {

    public static List<User_Guide__kav> sortGuideSections(List<User_Guide__kav> sections){
        List<GuideSectionWrapper> sectionWrappers = new List<GuideSectionWrapper>();
System.debug('Utlity sections.size' + sections.size());
        for(User_Guide__kav g : sections){
            sectionWrappers.add(new GuideSectionWrapper(g));
        }
        
        sectionWrappers.sort();
System.debug('Utlity sectionWrappers.size' + sectionWrappers.size());
        List<User_Guide__kav> guides = new List<User_Guide__kav>();
        for(GuideSectionWrapper g : sectionWrappers){
            guides.add(g.section);
        }
System.debug('Utlity guides.size' + guides.size());
	    return guides;
    }
    
    public class GuideSectionWrapper implements Comparable {
        
        public User_Guide__kav section;
        
        // Constructor
        public GuideSectionWrapper(User_Guide__kav section) {
            this.section = section;
        }
        
        // Compare opportunities based on the opportunity amount.
        public Integer compareTo(Object compareTo) {
            // Cast argument to OpportunityWrapper
            GuideSectionWrapper compareToSection = (GuideSectionWrapper)compareTo;
            if(section.Section__c == compareToSection.section.Section__c){
                return 0;
            }
            // The return value of 0 indicates that both elements are equal.
            if(String.isBlank(compareToSection.section.Section__c)){
                return 1;
            }
            if(String.isBlank(section.Section__c)){
                return -1;
            }
            List<String> mNums = section.Section__c.split('\\.');
            List<String> compNums = compareToSection.section.Section__c.split('\\.');
            // System.debug(compNums);
            for(Integer i = 0; i < mNums.size(); i++){
                // If both have digit, compare
                // Lower value wins
                // 
                // If one side is missing digit, return shorter list
                
                if(compNums.size() < i+1){

                    return 1;
                }
                
                if(mNums[i] > compNums[i]){
                	return 1;
                } else if(mNums[i] < compNums[i]){
                    return -1;
                }
            }
            if(mNums.size() < compNums.size()){
                return -1;
            }
            
            return 0;      
        }
    }
}
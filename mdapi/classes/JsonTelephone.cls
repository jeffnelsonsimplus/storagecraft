/**
  \file         
  \brief        This class will parse a string and return a JSON document of telephone number formats
  \details      JIRA ticket(s): SSF-62, SSF-65
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         22 June 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
public class JsonTelephone
{
    public String        isoCode;
    public String        countryCode;
    public String        trunkPrefix;
    public String        exampleLandline;
    public String        exampleMobile;
  
    public List<Formats> formats;


    public class Formats {
        public Boolean isLandLine;
        public Boolean isMobile;
        
        public Integer minLength;
        public Integer maxLength;
        
        public String  deconstructor;
        public String  constructor;
    }
  

    public static JsonTelephone parse(String json)
    {
        return (JsonTelephone)System.JSON.deserialize(json, JsonTelephone.class);
    }
}
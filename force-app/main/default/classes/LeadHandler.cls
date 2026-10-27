public class LeadHandler {
    public static void beforeInsert(List<Lead> newLeads){
        for(Lead LeadRecord : newLeads){
            if(LeadRecord.LeadSource == 'Web'){
                LeadRecord.Rating ='Cold';
            }else{
               LeadRecord.Rating ='Hot'; 
            }
                
            }
        }
    }
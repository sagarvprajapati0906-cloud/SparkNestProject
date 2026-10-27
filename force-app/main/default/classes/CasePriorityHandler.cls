public class CasePriorityHandler {
    public static void BeforeInsert(List<Case> Cases){
        for(Case CaseRecord : Cases){
            if(CaseRecord.Origin == 'Email'){
                CaseRecord.Status = 'New'; CaseRecord.Priority = 'Normal';
            }
        }
    }
}
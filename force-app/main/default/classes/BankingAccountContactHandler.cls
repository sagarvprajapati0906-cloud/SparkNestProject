public class BankingAccountContactHandler {
    public static void BeforeInsert(List<Account> Accounts){
        List<Contact> CreateContact = new List<Contact>();
        For(Account Account : Accounts){
            if(Account.Industry == 'Banking'){
                CreateContact.add(new Contact(LastName = Account.Name, Phone = Account.Phone, AccountId = Account.Id));
            }            
        }
        if(!CreateContact.isEmpty()){
            insert CreateContact;
        }
        
    }
}
public class AccountRestAPIOutBoundCallWrapper {
    
    public string message;
    public account ac;
    public list<contactlist> contactlist;
    public list<caselist> caselist;
    
    public class contactlist {
		public String Name;	  
		public String phone;
		public String email;
		public String accountId;
		public String Id;
	}

	public class caselist {
		public String caseNumber;
		public String subject;
		public String description;
		public String accountId;
		public String Id;
	}

	public class ac {
		public String Id;
		public String name;	
        public String rating;	
		public String industry;
        public String phone;	
	}
    

}
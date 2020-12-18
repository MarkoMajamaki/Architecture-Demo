using System;

namespace CustomerApi
{
    public class CreateCustomerModel
    {
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public DateTime? Birthday { get; set; }
            public int? Age { get; set; }
    }
}

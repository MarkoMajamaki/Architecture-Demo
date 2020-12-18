using CustomerApi.Domain;
using CustomerApi.Infrastructure;

namespace CustomerApi.Infrastructure
{
    public class CustomerRepository : Repository<Customer>, ICustomerRepository
    {
        public CustomerRepository(CustomerContext customerContext) : base(customerContext)
        {
            
        }
    }
}
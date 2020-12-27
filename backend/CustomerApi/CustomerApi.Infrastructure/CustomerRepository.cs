using CustomerApi.Domain;

namespace CustomerApi.Infrastructure
{
    public class CustomerRepository : Repository<Customer>, ICustomerRepository
    {
        public CustomerRepository(CustomerContext customerContext) : base(customerContext)
        {
        }
    }
}
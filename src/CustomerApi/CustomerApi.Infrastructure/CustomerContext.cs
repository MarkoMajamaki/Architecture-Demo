using Microsoft.AspNetCore.Identity.EntityFrameworkCore;  
using Microsoft.EntityFrameworkCore;
using CustomerApi.Domain;

namespace CustomerApi.Infrastructure
{  
    public class CustomerContext : DbContext
    {
        public DbSet<Customer> Customer { get; set; }
        public CustomerContext(DbContextOptions<CustomerContext> options)
            : base(options)
        {
        }
    }
}  
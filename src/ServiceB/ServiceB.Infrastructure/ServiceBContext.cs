using Microsoft.AspNetCore.Identity.EntityFrameworkCore;  
using Microsoft.EntityFrameworkCore;  
  
namespace ServiceB.Infrastructure
{  
    public class ServiceBContext : DbContext
    {
        public ServiceBContext(DbContextOptions<ServiceBContext> options)
            : base(options)
        {
        }
    }
}  
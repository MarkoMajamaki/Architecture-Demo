using Microsoft.AspNetCore.Identity.EntityFrameworkCore;  
using Microsoft.EntityFrameworkCore;  
  
namespace ServiceA.Infrastructure
{  
    public class ServiceAContext : DbContext
    {
        public ServiceAContext(DbContextOptions<ServiceAContext> options)
            : base(options)
        {
        }
    }
}  
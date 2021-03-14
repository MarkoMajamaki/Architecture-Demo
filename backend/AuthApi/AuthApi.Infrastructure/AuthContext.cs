using Microsoft.AspNetCore.Identity.EntityFrameworkCore;  
using Microsoft.EntityFrameworkCore;  

using AuthApi.Domain;  

namespace AuthApi.Infrastructure
{  
    public class AuthContext : IdentityDbContext<ApplicationUser>  
    {  
        public AuthContext(DbContextOptions<AuthContext> options) : base(options)  
        {  
        }  
        
        protected override void OnModelCreating(ModelBuilder builder)  
        {  
            base.OnModelCreating(builder);  
        }  
    }  
}  
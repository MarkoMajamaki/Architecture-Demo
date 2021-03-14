using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace AuthApi.Infrastructure
{
    public class AuthContextSeed
    {
        public static Task SeedAsync(AuthContext context)
        {
            try
            {
                context.Database.Migrate();
            }
            catch (Exception x)
            {
                Console.WriteLine(x.Message);
            }
            
            return Task.FromResult(true);
        }
    }
}

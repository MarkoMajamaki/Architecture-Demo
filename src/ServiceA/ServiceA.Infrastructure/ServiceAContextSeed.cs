using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace ServiceA.Infrastructure
{
    public class ServiceAContextSeed
    {
        public static async Task SeedAsync(ServiceAContext economyContext)
        {
            economyContext.Database.Migrate();
            await Task.Delay(10);
        }
    }
}

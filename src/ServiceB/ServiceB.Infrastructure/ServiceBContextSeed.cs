using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace ServiceB.Infrastructure
{
    public class ServiceBContextSeed
    {
        public static async Task SeedAsync(ServiceBContext economyContext)
        {
            economyContext.Database.Migrate();
            await Task.Delay(10);
        }
    }
}

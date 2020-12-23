using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace OrderApi.Infrastructure
{
    public class OrderContextSeed
    {
        public static async Task SeedAsync(OrderContext orderContext)
        {
            orderContext.Database.Migrate();
            await Task.Delay(10);
        }
    }
}

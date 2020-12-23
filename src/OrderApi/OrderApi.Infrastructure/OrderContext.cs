using Microsoft.EntityFrameworkCore;
using OrderApi.Domain;

namespace OrderApi.Infrastructure
{  
    public class OrderContext : DbContext
    {
        public DbSet<Order> Order { get; set; }

        public OrderContext(DbContextOptions<OrderContext> options)
            : base(options)
        {
        }
    }
}  
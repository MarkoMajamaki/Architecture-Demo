using OrderApi.Domain;

namespace OrderApi.Infrastructure
{
    public class OrderRepository : Repository<Order>, IOrderRepository
    {
        public OrderRepository(OrderContext OrderContext) : base(OrderContext)
        {
        }
    }
}
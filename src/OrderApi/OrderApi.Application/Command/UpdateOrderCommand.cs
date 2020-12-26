using System;
using System.Threading;
using System.Threading.Tasks;
using OrderApi.Domain;
using MediatR;

namespace OrderApi.Application
{
    public class UpdateOrderCommand : IRequest<Order>
    {
        public Order Order { get; private set; }
        public UpdateOrderCommand(Order order)
        {
            Order = order;
        }
    }

    public class UpdateOrderCommandHandler : IRequestHandler<UpdateOrderCommand, Order>
    {
        private readonly IOrderRepository _repository;

        public UpdateOrderCommandHandler(IOrderRepository OrderRepository)
        {
            _repository = OrderRepository;
        }

        public async Task<Order> Handle(UpdateOrderCommand request, CancellationToken cancellationToken)
        {
            return await _repository.UpdateAsync(request.Order);
        }
    }
}
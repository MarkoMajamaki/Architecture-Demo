using System;
using System.Threading;
using System.Threading.Tasks;
using OrderApi.Domain;
using MediatR;

namespace OrderApi.Application
{
    public class CreateOrderCommand : IRequest<Order>
    {
        public Order Order { get; private set; }
        public CreateOrderCommand(Order order)
        {
            Order = order;
        }
    }

    public interface ICreateOrderCommandHandler : IRequestHandler<CreateOrderCommand, Order> {}

    public class CreateOrderCommandHandler : ICreateOrderCommandHandler
    {
        private readonly IOrderRepository _repository;
        public CreateOrderCommandHandler(IOrderRepository repository)
        {
            _repository = repository;
        }
        
        public async Task<Order> Handle(CreateOrderCommand request, CancellationToken cancellationToken)
        {
            return await _repository.AddAsync(request.Order);
        }
    }
}
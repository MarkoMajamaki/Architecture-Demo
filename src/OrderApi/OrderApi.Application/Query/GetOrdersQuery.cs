using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using OrderApi.Domain;

namespace OrderApi.Application
{
    public class GetOrdersQuery : IRequest<IEnumerable<Order>>
    {   
    }

    public class GetOrdersQueryHandler : IRequestHandler<GetOrdersQuery, IEnumerable<Order>>
    {
        private readonly IOrderRepository _repository;
        public GetOrdersQueryHandler(IOrderRepository repository)
        {
            _repository = repository;   
        }

        public Task<IEnumerable<Order>> Handle(GetOrdersQuery request, CancellationToken cancellationToken)
        {
            var orders = _repository.GetAll();
            return Task.FromResult(orders);
        }
    }
}
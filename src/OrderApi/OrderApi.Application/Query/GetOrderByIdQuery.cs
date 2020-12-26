using System;
using System.Threading;
using System.Threading.Tasks;
using OrderApi.Domain;
using MediatR;

namespace OrderApi.Application
{
    public class GetOrderByIdQuery : IRequest<Order>
    {
        public Guid Id { get; private set; }

        public GetOrderByIdQuery(Guid id)
        {
            Id = Id;
        }
    }

    public class GetOrderByIdQueryHandler : IRequestHandler<GetOrderByIdQuery, Order>
    {
        private readonly IOrderRepository _repository;
        public GetOrderByIdQueryHandler(IOrderRepository repository)
        {
            _repository = repository;
        }

        public async Task<Order> Handle(GetOrderByIdQuery request, CancellationToken cancellationToken)
        {
            return await _repository.GetSingleAsync(request.Id);
        }
    }
}
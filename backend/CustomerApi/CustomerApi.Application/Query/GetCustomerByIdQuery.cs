using System;
using System.Threading;
using System.Threading.Tasks;
using CustomerApi.Domain;
using MediatR;

namespace CustomerApi.Application
{
    public class GetCustomerByIdQuery : IRequest<Customer>
    {
        public Guid Id { get; private set; }

        public GetCustomerByIdQuery(Guid id)
        {
            Id = Id;
        }
    }

    public interface IGetCustomerByIdQueryHandler : IRequestHandler<GetCustomerByIdQuery, Customer> {}

    public class GetCustomerByIdQueryHandler : IGetCustomerByIdQueryHandler
    {
        private readonly ICustomerRepository _repository;
        public GetCustomerByIdQueryHandler(ICustomerRepository repository)
        {
            _repository = repository;
        }

        public async Task<Customer> Handle(GetCustomerByIdQuery request, CancellationToken cancellationToken)
        {
            return await _repository.GetSingleAsync(request.Id);
        }
    }
}
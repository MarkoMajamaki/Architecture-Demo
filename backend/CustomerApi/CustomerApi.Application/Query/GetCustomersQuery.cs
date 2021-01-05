using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using CustomerApi.Domain;
using MediatR;

namespace CustomerApi.Application
{
    public class GetCustomersQuery : IRequest<IEnumerable<Customer>>
    {
    }

    public interface IGetCustomersQueryHandler : IRequestHandler<GetCustomersQuery, IEnumerable<Customer>> {}

    public class GetCustomersQueryHandler : IGetCustomersQueryHandler
    {
        private readonly ICustomerRepository _repository;
        public GetCustomersQueryHandler(ICustomerRepository repository)
        {
            _repository = repository;
        }

        public Task<IEnumerable<Customer>> Handle(GetCustomersQuery request, CancellationToken cancellationToken)
        {
            return Task.FromResult(_repository.GetAll());
        }
    }
}
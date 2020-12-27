using System;
using System.Threading;
using System.Threading.Tasks;
using CustomerApi.Domain;
using MediatR;

namespace CustomerApi.Application
{
    public class CreateCustomerCommand : IRequest<Customer>
    {
        public Customer Customer { get; private set; }
        public CreateCustomerCommand(Customer customer)
        {
            Customer = customer;
        }
    }

    public class CreateCustomerCommandHandler : IRequestHandler<CreateCustomerCommand, Customer>
    {
        private readonly ICustomerRepository _repository;
        private readonly ICustomerUpdateSender _customerUpdateSender;

        public CreateCustomerCommandHandler(
            ICustomerRepository repository,
            ICustomerUpdateSender customerUpdateSender)
        {
            _repository = repository;
            _customerUpdateSender = customerUpdateSender;
        }
        
        public async Task<Customer> Handle(CreateCustomerCommand request, CancellationToken cancellationToken)
        {
            Customer customer = await _repository.AddAsync(request.Customer);
            _customerUpdateSender.SendCustomer(customer);
            return customer;
        }
    }
}
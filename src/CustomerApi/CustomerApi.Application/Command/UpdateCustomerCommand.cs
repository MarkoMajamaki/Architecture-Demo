using System;
using System.Threading;
using System.Threading.Tasks;
using CustomerApi.Domain;
using MediatR;

namespace CustomerApi.Application
{
    public class UpdateCustomerCommand : IRequest<Customer>
    {
        public Customer Customer { get; private set; }
        public UpdateCustomerCommand(Customer customer)
        {
            Customer = customer;
        }
    }

    public interface IUpdateCustomerCommandHandler : IRequestHandler<UpdateCustomerCommand, Customer> {}
    
    public class UpdateCustomerCommandHandler : IUpdateCustomerCommandHandler
    {
        private readonly ICustomerRepository _repository;
        private readonly ICustomerUpdateSender _customerUpdateSender;

        public UpdateCustomerCommandHandler(
            ICustomerRepository customerRepository,
            ICustomerUpdateSender customerUpdateSender)
        {
            _customerUpdateSender = customerUpdateSender;
            _repository = customerRepository;
        }

        public async Task<Customer> Handle(UpdateCustomerCommand request, CancellationToken cancellationToken)
        {
            var customer = await _repository.UpdateAsync(request.Customer);
            _customerUpdateSender.SendCustomer(customer);
            return customer;
        }
    }
}
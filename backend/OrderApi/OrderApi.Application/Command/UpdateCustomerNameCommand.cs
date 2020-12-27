using System;
using System.Threading;
using System.Threading.Tasks;
using OrderApi.Domain;
using MediatR;

namespace OrderApi.Application
{
    public class UpdateCustomerNameCommand : IRequest
    {
        public Guid CustomerId { get; private set; }
        public string Name { get; private set; }
        public UpdateCustomerNameCommand(Guid customerId, string name)
        {
            CustomerId = customerId;
            Name = name;
        }
    }

    public class UpdateCustomerNameCommandHandler : IRequestHandler<UpdateCustomerNameCommand, Unit>
    {
        public UpdateCustomerNameCommandHandler()
        {
        }
        
        public Task<Unit> Handle(UpdateCustomerNameCommand request, CancellationToken cancellationToken)
        {
            // throw new NotImplementedException();
            return Task.FromResult<Unit>(Unit.Value);
        }
    }
}
using System;
using System.Threading;
using System.Threading.Tasks;
using CustomerApi.Domain;
using MediatR;

namespace CustomerApi.Application
{
    public class CreateCustomerCommand : IRequest
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? Birthday { get; set; }
        public int? Age { get; set; }
    }

    public interface ICreateCustomerCommandHandler : IRequestHandler<CreateCustomerCommand> {}

    public class CreateCustomerCommandHandler : ICreateCustomerCommandHandler
    {
        private ICustomerRepository _repository;

        public CreateCustomerCommandHandler(ICustomerRepository repository)
        {
            _repository = repository;
        }
        
        public async Task<Unit> Handle(CreateCustomerCommand request, CancellationToken cancellationToken)
        {
            await _repository.AddAsync(new Customer
            {
                Id = request.Id,
                FirstName = request.FirstName,
                LastName = request.LastName,
                Birthday = request.Birthday,
                Age = request.Age,
            });

            return Unit.Value;
        }
    }
}
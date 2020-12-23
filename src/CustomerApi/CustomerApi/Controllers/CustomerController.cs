using System;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.AspNetCore.Mvc;
using AutoMapper;
using MediatR;
using CustomerApi.Application;
using CustomerApi.Domain;

namespace CustomerApi
{
    [ApiController]
    [Route("[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IMapper _mapper;

        public CustomerController(IMediator mediator, IMapper mapper)
        {
            _mediator = mediator;
            _mapper = mapper;
        }

        /// <summary>
        /// Add new customer
        /// </summary>
        [HttpPost]
        public async Task<ActionResult> Customer([FromBody]CreateCustomerModel customer)
        {
            try
            {
                await _mediator.Send(new CreateCustomerCommand(_mapper.Map<Customer>(customer)), new CancellationToken());
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut]
        public async Task<ActionResult> Customer([FromBody]UpdateCustomerModel customerToUpdate)
        {
            try
            {
                Customer customer = await _mediator.Send(new GetCustomerByIdQuery(customerToUpdate.Id));

                if (customer == null)
                {
                    return BadRequest($"No customer found with the id {customer.Id}");
                }

                await _mediator.Send(new UpdateCustomerCommand(_mapper.Map<Customer>(customerToUpdate)), new CancellationToken());
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
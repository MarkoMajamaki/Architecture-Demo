using Microsoft.AspNetCore.Mvc;
using MediatR;
using System.Threading.Tasks;
using System.Threading;
using CustomerApi.Application;
using System;

namespace CustomerApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CustomerController(IMediator mediator)
        {
            _mediator = mediator;
        }

        /// <summary>
        /// Add new customer
        /// </summary>
        [HttpPost]
        public async Task<ActionResult> Customer([FromBody]CreateCustomerModel customer)
        {
            try
            {
                await _mediator.Send(new CreateCustomerCommand(), new CancellationToken());
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
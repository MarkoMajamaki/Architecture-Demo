using System;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.AspNetCore.Mvc;
using AutoMapper;
using MediatR;
using OrderApi.Application;
using OrderApi.Domain;
using System.Collections.Generic;

namespace OrderApi
{
    [ApiController]
    [Route("[controller]")]
    public class OrderController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IMapper _mapper;

        public OrderController(IMediator mediator, IMapper mapper)
        {
            _mediator = mediator;
            _mapper = mapper;
        }

        [HttpGet("Orders")]
        public async Task<ActionResult> GetCustomers()
        {
            try
            {
                IEnumerable<Order> result = await _mediator.Send(new GetOrdersQuery(), new CancellationToken());
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
using Microsoft.AspNetCore.Mvc;

namespace CustomerApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TestController : ControllerBase
    {
        [HttpGet("Test")]
        public string Test()
        {
            return "Order Api test succeeded!";
        }
    }
}

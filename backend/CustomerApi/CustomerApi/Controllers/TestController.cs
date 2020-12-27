using Microsoft.AspNetCore.Mvc;

namespace CustomerApi
{
    [ApiController]
    [Route("[controller]")]
    public class TestController : ControllerBase
    {
        [HttpGet("Test")]
        public string Test()
        {
            return "Customer Api test succeeded!";
        }
    }
}

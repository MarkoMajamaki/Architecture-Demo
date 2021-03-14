using Microsoft.AspNetCore.Mvc;

using MediatR;
using System.Threading.Tasks;
using System.Threading;
using AuthApi.Application;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authorization;
using System;

namespace AuthApi
{
    [ApiController]
    [Route("[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AuthController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost]  
        [Route("login")]  
        public async Task<IActionResult> Login([FromBody] LoginModel model)  
        { 
            try 
            {
                JwtSecurityToken token = await _mediator.Send(new LoginCommand(model.Username, model.Password), new CancellationToken());
                
                return Ok(new {
                    token = new JwtSecurityTokenHandler().WriteToken(token),  
                    expiration = token.ValidTo  
                });
            }
            catch (InvalidPasswordException)
            {
                return Unauthorized();  
            }
            catch (UserNotFoundException)
            {
                return Unauthorized();
            }
        }

        [HttpPost]  
        [Route("register")]  
        public async Task<IActionResult> Register([FromBody] RegisterModel model)  
        {  
            try 
            {
                await _mediator.Send(new RegisterCommand(model.Username, model.Email, model.Password), new CancellationToken());
                
                return Ok(new {
                    Status = "Success", 
                    Message = "User created successfully!"
                });  
            }
            catch (UserAlreadyExistException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User already exists!" 
                });
            }
            catch (UserCreationFailedException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User creation failed! Please check user details and try again.!" 
                });  
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = e.Message 
                });
            }
        }

        [HttpPost]  
        [Route("register-admin")]  
        public async Task<IActionResult> RegisterAdmin([FromBody] RegisterModel model)  
        {  
            try 
            {
                await _mediator.Send(new RegisterAdminCommand(model.Username, model.Email, model.Password), new CancellationToken());
                
                return Ok(new {
                    Status = "Success", 
                    Message = "User created successfully!"
                });  
            }
            catch (UserAlreadyExistException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User already exists!" 
                });  
            }
            catch (UserCreationFailedException)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = "User creation failed! Please check user details and try again.!" 
                });  
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { 
                    Status = "Error", 
                    Message = e.Message 
                });
            }
        }  
        
        /// <summary>
        /// Login with facebook token. If user is not registered do registering automatically.
        /// </summary>
        [HttpPost]  
        [Route("login-facebook")]  
        public async Task<IActionResult> LoginFacebook([FromBody] AccessTokenModel model)  
        { 
            try 
            {
                JwtSecurityToken token = await _mediator.Send(new LoginFacebookCommand(model.Token), new CancellationToken());
                
                return Ok(new {
                    token = new JwtSecurityTokenHandler().WriteToken(token),  
                    expiration = token.ValidTo  
                });
            }
            catch (InvalidPasswordException)
            {
                return Unauthorized();  
            }
            catch 
            {
                return Unauthorized("Something go wrong!");
            }
        }

        [HttpGet]
        [Route("Test")]  
        [Authorize]
        public string Test()
        {
            return "Test";
        } 
    }
}
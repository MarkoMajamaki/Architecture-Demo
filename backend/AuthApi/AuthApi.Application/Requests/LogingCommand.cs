using MediatR;
using System.IdentityModel.Tokens.Jwt;  

namespace AuthApi.Application
{
    public class LoginCommand : IRequest<JwtSecurityToken>
    {
        public string Username { get; private set; }    
        public string Password { get; private set; }  

        public LoginCommand(string userName, string password)
        {
            Username = userName;
            Password = password;
        }
    }
}
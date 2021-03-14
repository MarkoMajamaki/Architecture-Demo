using System.IdentityModel.Tokens.Jwt;
using MediatR;

namespace AuthApi.Application
{
    public class LoginFacebookCommand : IRequest<JwtSecurityToken>
    {
        public string Token { get; set; }  

        public LoginFacebookCommand(string token)
        {
            Token = token;
        }
    }
}
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using AuthApi.Domain;

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
    
    public interface ILoginCommandHandler : IRequestHandler<LoginCommand, JwtSecurityToken>
    {
    }

    public class LoginCommandHandler : ILoginCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private readonly IConfiguration _configuration;  

        public LoginCommandHandler(
            UserManager<ApplicationUser> userManager,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _configuration = configuration;
        }

        public async Task<JwtSecurityToken> Handle(LoginCommand request, CancellationToken cancellationToken)
        {
            var user = await _userManager.FindByNameAsync(request.Username);  
            if (user == null)
            {
                throw new UserNotFoundException();
            }
            bool isPasswordValid = await _userManager.CheckPasswordAsync(user, request.Password);
            if (isPasswordValid == false)
            {
                throw new InvalidPasswordException();
            }
            var userRoles = await _userManager.GetRolesAsync(user);  

            var authClaims = new List<Claim>  
            {  
                new Claim(ClaimTypes.Name, user.UserName),  
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),  
            };  

            foreach (var userRole in userRoles)  
            {  
                authClaims.Add(new Claim(ClaimTypes.Role, userRole));  
            }  

            string jwtSected = _configuration["JWT:Secret"];

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSected));  

            return new JwtSecurityToken(  
                issuer: _configuration["JWT:ValidIssuer"],  
                audience: _configuration["JWT:ValidAudience"],  
                expires: DateTime.Now.AddHours(3),  
                claims: authClaims,  
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)  
                );  
        }
    }
}
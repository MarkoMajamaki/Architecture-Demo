using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

using AuthApi.Domain;

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
    
    public interface ILoginFacebookCommandHandler : IRequestHandler<LoginFacebookCommand, JwtSecurityToken>
    {
    }

    public class LoginFacebookCommandHandler : ILoginFacebookCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  
        private readonly IFacebookAuthenticationService _facebookAuthenticationSercice;
        private readonly IConfiguration _configuration;  

        public LoginFacebookCommandHandler(
            UserManager<ApplicationUser> userManager, 
            IFacebookAuthenticationService facebookAuthenticationSercice,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _facebookAuthenticationSercice = facebookAuthenticationSercice;
            _configuration = configuration;
        }

        /// <summary>
        /// Login with facebook token. If user is not created then create new without password
        /// </summary>
        public async Task<JwtSecurityToken> Handle(LoginFacebookCommand request, CancellationToken cancellationToken)
        {
            var validatedTokenResult = await _facebookAuthenticationSercice.ValidateAccessTokenAsync(request.Token);

            if (!validatedTokenResult.Data.IsValid)
            {
                throw new InvalidFacebookTokenException();
            }

            var userInfo = await _facebookAuthenticationSercice.GetUserInfoAsync(request.Token);
            
            var user = await _userManager.FindByEmailAsync(userInfo.Email);

            if (user == null)
            {
                var identityUser = new ApplicationUser
                {
                    Id = Guid.NewGuid().ToString(),
                    Email = userInfo.Email,
                    UserName = userInfo.Email
                };

                var createdResult = await _userManager.CreateAsync(identityUser);

                if (createdResult.Succeeded == false)
                {
                    throw new Exception();
                }

                return await GenerateAuthenticationResultForUserAsync(identityUser);
            }

            return await GenerateAuthenticationResultForUserAsync(user);            
        }

        /// <summary>
        /// Create JWT token for user
        /// </summary>
        private async Task<JwtSecurityToken> GenerateAuthenticationResultForUserAsync(ApplicationUser user)
        {
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
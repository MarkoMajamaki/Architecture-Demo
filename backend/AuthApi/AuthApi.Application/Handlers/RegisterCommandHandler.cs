using System;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Identity;

using AuthApi.Domain;

namespace AuthApi.Application
{
    public interface IRegisterCommandHandler : IRequestHandler<RegisterCommand, bool>
    {
    }

    public class RegisterCommandHandler : IRegisterCommandHandler
    {
        private readonly UserManager<ApplicationUser> _userManager;  

        public RegisterCommandHandler(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<bool> Handle(RegisterCommand request, CancellationToken cancellationToken)
        {
            var userExists = await _userManager.FindByNameAsync(request.Username);  
            if (userExists != null)  
            {
                throw new UserAlreadyExistException();
            }
            ApplicationUser user = new ApplicationUser()  
            {  
                Email = request.Email,  
                SecurityStamp = Guid.NewGuid().ToString(),  
                UserName = request.Username  
            };  
            var result = await _userManager.CreateAsync(user, request.Password);  
            if (!result.Succeeded)  
            {
                throw new UserCreationFailedException();
            }
  
            return true;
        }
    }
}
using MediatR;

namespace AuthApi.Application
{
    public class RegisterCommand : IRequest<bool>
    {
        public string Username { get; set; }  
        public string Email { get; set; }    
        public string Password { get; set; }  

        public RegisterCommand(string userName, string emain, string password)
        {
            Username = userName;
            Email = emain;
            Password = password;
        }
    }
}
using System.ComponentModel.DataAnnotations;  
  
namespace AuthApi.Application  
{  
    public class AccessTokenModel  
    {  
        [Required(ErrorMessage = "Token is required")]  
        public string Token { get; set; }    
    }  
}
using Xunit;
using AuthApi.Infrastructure;
using SharedApi.IntegrationTest;
using System.Text;
using System.Net.Http;
using Newtonsoft.Json;

namespace AuthApi.IntegrationTest
{
    public class AuthController_Tests : IClassFixture<TestApplicationFactory<Startup, AuthContext>>
    {
        private readonly TestApplicationFactory<Startup, AuthContext> _factory;

        public AuthController_Tests(TestApplicationFactory<Startup, AuthContext> factory)
        {
            _factory = factory;
        }

        [Fact]
        public async void Login_WithUnregisteredUser()
        {            
            // Arrange
            var client = _factory.CreateClient();
            var data = new 
            { 
                Username = "user", 
                Password = "password"
            };

            // Act
            StringContent content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
            var response = client.PostAsync("auth/login", content);

            // Assert

            // Handle response
            var responseJson = await response.Result.Content.ReadAsStringAsync();
            var responseTyped = JsonConvert.DeserializeAnonymousType(responseJson, new { Token = string.Empty });
            // TODO
        }

        [Fact]
        public async void Register_WithNewUser()
        {
            // Arrange
            var client = _factory.CreateClient();

            var data = new 
            { 
                Email = "testuser@test.com",
                Username = "user", 
                Password = "password" 
            };
            
            // Act
            StringContent content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");
            var response = await client.PostAsync("auth/register", content);

            // Assert

        }
    }
}

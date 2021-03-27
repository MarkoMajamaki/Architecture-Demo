using Xunit;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.TestHost;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;

using CustomerApi.Infrastructure;
using SharedApi.IntegrationTest;
using CustomerApi.Domain;
using System.Collections.Generic;
using System;
using System.Net;
using Newtonsoft.Json;
using System.Linq;

namespace CustomerApi.IntegrationTest
{
    public class CustomerController_Test : IClassFixture<TestApplicationFactory<Startup, CustomerContext>>
    {
        private readonly TestApplicationFactory<Startup, CustomerContext> _factory;

        public CustomerController_Test(TestApplicationFactory<Startup, CustomerContext> factory)
        {
            _factory = factory;
        }

        [Fact]
        public async void Get_Customers()
        {
            // Arrange
            var client = _factory.WithWebHostBuilder(builder =>
            {
                builder.ConfigureTestServices(services =>
                {
                    services.AddAuthentication("Test")
                        .AddScheme<AuthenticationSchemeOptions, TestAuthHandler>(
                            "Test", options => {});

                    using (var scope = services.BuildServiceProvider().CreateScope())
                    {
                        var scopedServices = scope.ServiceProvider;
                        var db = scopedServices.GetRequiredService<CustomerContext>();

                         db.Customer.AddRange(new List<Customer>()
                        {
                            new Customer(){ Id = Guid.NewGuid(), FirstName = "Firstname1", LastName = "LastName1", Age = 30 },
                            new Customer(){ Id = Guid.NewGuid(), FirstName = "Firstname2", LastName = "LastName2", Age = 30 },
                            new Customer(){ Id = Guid.NewGuid(), FirstName = "Firstname3", LastName = "LastName3", Age = 30 },
                        });

                        db.SaveChanges();
                    }
                });
            })
            .CreateClient(new WebApplicationFactoryClientOptions
            {
                AllowAutoRedirect = false,
            });

            // Act
            var response = await client.GetAsync("customer");            

            var responseJson = await response.Content.ReadAsStringAsync();
            List<Customer> customers = JsonConvert.DeserializeObject<List<Customer>>(responseJson);
        
            // Assert
            Assert.Equal(response.StatusCode, HttpStatusCode.OK);
            Assert.Equal(customers.Count, 3);
            Assert.Equal(customers.First().FirstName, "Firstname1");
        }
    }
}
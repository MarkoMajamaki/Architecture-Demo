using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using CustomerApi.Domain;

namespace CustomerApi.Infrastructure
{
    public class CustomerContextSeed
    {
        public static async Task SeedAsync(CustomerContext customerContext)
        {
            customerContext.Database.Migrate();

            if (!customerContext.Customer.Any())
            {
                customerContext.Customer.AddRange(GetPreconfiguredCustomers());
                await customerContext.SaveChangesAsync();
            }    
        }

        private static IEnumerable<Customer> GetPreconfiguredCustomers()
        {
            return new List<Customer>()
            {
                new Customer
                {
                    Id = Guid.NewGuid(),
                    FirstName = "Adam",
                    LastName = "Smith",
                    Birthday = new DateTime(1989, 11, 23),
                    Age = 30
                }
            };
        }
    }
}

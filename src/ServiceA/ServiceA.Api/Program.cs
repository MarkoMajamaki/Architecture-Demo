using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using ServiceA.Infrastructure;

namespace ServiceA.Api
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();
            CreateAndSeedDatabase(host);
            host.Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) 
        {
            return Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingcontext, config) =>
                {
                    config
                    .AddJsonFile("appsettings.json", false, true)
                    .AddJsonFile($"appsettings.{hostingcontext.HostingEnvironment.EnvironmentName}.json", true, true);
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
        }

        private static void CreateAndSeedDatabase(IHost host)
        {
            using (var scope = host.Services.CreateScope())
            {
                var services = scope.ServiceProvider;
                var aspnetRunContext = services.GetRequiredService<ServiceAContext>();
                ServiceAContextSeed.SeedAsync(aspnetRunContext).Wait();
            }
        }    
    }
}

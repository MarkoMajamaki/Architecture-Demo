using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using CustomerApi.Application;
using CustomerApi.Domain;
using CustomerApi.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;

namespace CustomerApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "CustomerApi", Version = "v1" });
            });

            services.AddMediatR(Assembly.GetExecutingAssembly());

            string server = Configuration["DatabaseServer"] ?? "localhost";
            string port = Configuration["DatabasePort"] ?? "1433";
            string user = Configuration["DatabaseUser"] ?? "sa";
            string password = Configuration["DatabasePassword"] ?? "mssQlp4ssword#";
            string database = Configuration["DatabaseName"] ?? "customer";

            string connectionString = $"Server={server},{port};Initial Catalog={database};User={user};Password={password}";

            // For Entity Framework  
            services.AddDbContext<CustomerContext>(options => options.UseSqlServer(connectionString, x => x.MigrationsAssembly("CustomerApi.Infrastructure")));

            services.AddScoped(typeof(ICustomerRepository), typeof(CustomerRepository));
            services.AddScoped(typeof(ICreateCustomerCommandHandler), typeof(CreateCustomerCommandHandler));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "CustomerApi v1"));
            }
            
            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}

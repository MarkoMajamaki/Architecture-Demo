using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using AutoMapper;
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

using SharedApi;
using CustomerApi.Application;
using CustomerApi.Domain;
using CustomerApi.Infrastructure;

namespace CustomerApi
{
    public class Startup
    {
        private const string _corsPolicyName = "DevelopmentPolicy";

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddOptions();
            services.AddControllers();
            services.AddAutoMapper(typeof(Startup));
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "CustomerApi", Version = "v1" });
            });

            services.AddCors(options => 
            {
                options.AddPolicy(_corsPolicyName, builder => 
                {
                    builder.AllowAnyOrigin();
                });
            });

            DatabaseSettings dbSettings = Configuration.GetSection("Database").Get<DatabaseSettings>();
            string connectionString = $"Server={dbSettings.Server},{dbSettings.Port};Initial Catalog={dbSettings.Name};User={dbSettings.User};Password={dbSettings.Password}";
            
            // For Entity Framework  
            services.AddDbContext<CustomerContext>(options => options.UseSqlServer(connectionString, x => x.MigrationsAssembly("CustomerApi.Infrastructure")));

            services.Configure<RabbitMqSettings>(Configuration.GetSection("RabbitMq"));  

            services.AddMediatR(Assembly.GetExecutingAssembly());
            services.AddTransient(typeof(IRepository<>), typeof(Repository<>));
            services.AddTransient<ICustomerRepository, CustomerRepository>();

            services.AddSingleton<ICustomerUpdateSender, CustomerUpdateSender>();  
            services.AddTransient<IRequestHandler<UpdateCustomerCommand, Customer>, UpdateCustomerCommandHandler>();
            services.AddTransient<IRequestHandler<CreateCustomerCommand, Customer>, CreateCustomerCommandHandler>();
            services.AddTransient<IRequestHandler<GetCustomersQuery, IEnumerable<Customer>>, GetCustomersQueryHandler>();
            services.AddTransient<IRequestHandler<GetCustomerByIdQuery, Customer>, GetCustomerByIdQueryHandler>();
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

            if (env.IsDevelopment())
            {
                app.UseCors(_corsPolicyName);
            }

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}

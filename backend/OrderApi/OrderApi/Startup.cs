using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
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
using OrderApi.Application;
using OrderApi.Domain;
using OrderApi.Infrastructure;
using Shared;

namespace OrderApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {            
            services.AddOptions();
            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "OrderApi", Version = "v1" });
            });

            services.AddMediatR(Assembly.GetExecutingAssembly());

            services.AddHostedService<CustomerUpdateReceiver>();

            DatabaseConfiguration dbSettings = Configuration.GetSection("Database").Get<DatabaseConfiguration>();
            string connectionString = $"Server={dbSettings.Server},{dbSettings.Port};Initial Catalog={dbSettings.Name};User={dbSettings.User};Password={dbSettings.Password}";
            
            // For Entity Framework  
            services.AddDbContext<OrderContext>(options => options.UseSqlServer(connectionString, x => x.MigrationsAssembly("OrderApi.Infrastructure")));

            services.Configure<RabbitMqConfiguration>(Configuration.GetSection("RabbitMq"));

            services.AddMediatR(Assembly.GetExecutingAssembly(), typeof(CustomerUpdateReceiver).Assembly);
            services.AddTransient(typeof(IRepository<>), typeof(Repository<>));
            services.AddTransient<IOrderRepository, OrderRepository>();

            services.AddTransient<IRequestHandler<UpdateOrderCommand, Order>, UpdateOrderCommandHandler>();
            services.AddTransient<IRequestHandler<CreateOrderCommand, Order>, CreateOrderCommandHandler>();
            services.AddTransient<IRequestHandler<GetOrderByIdQuery, Order>, GetOrderByIdQueryHandler>();    
            services.AddTransient<IRequestHandler<UpdateCustomerNameCommand, Unit>, UpdateCustomerNameCommandHandler>();                        
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "OrderApi v1"));
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

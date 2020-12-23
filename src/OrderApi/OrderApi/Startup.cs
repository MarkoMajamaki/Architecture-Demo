using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
using OrderApi.Infrastructure;

namespace OrderApi
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
            services.AddOptions();
            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "OrderApi", Version = "v1" });
            });

            services.Configure<RabbitMqConfiguration>(Configuration.GetSection("RabbitMq"));

            String server = Configuration["DatabaseServer"] ?? "localhost";
            string port = Configuration["DatabasePort"] ?? "1433";
            string user = Configuration["DatabaseUser"] ?? "sa";
            string password = Configuration["DatabasePassword"] ?? "mssQlp4ssword#";
            string database = Configuration["DatabaseName"] ?? "order";

            string connectionString = $"Server={server},{port};Initial Catalog={database};User={user};Password={password}";

            // For Entity Framework  
            services.AddDbContext<OrderContext>(options => options.UseSqlServer(connectionString, x => x.MigrationsAssembly("OrderApi.Infrastructure")));
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
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

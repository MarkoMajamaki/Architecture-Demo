using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

using AuthApi.Domain;
using AuthApi.Application;
using AuthApi.Infrastructure;

namespace AuthApi
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            services.AddMediatR(Assembly.GetExecutingAssembly());
            services.AddMediatR(typeof(LoginCommand).GetTypeInfo().Assembly);
            services.AddMediatR(typeof(RegisterCommand).GetTypeInfo().Assembly);
            services.AddMediatR(typeof(RegisterAdminCommand).GetTypeInfo().Assembly);

            services.AddHttpClient();
            services.AddScoped<IFacebookAuthenticationService, FacebookAuthenticationService>();

            services.AddSingleton<IFacebookAuthSettings>(x 
                => new FacebookAuthSettings(
                    Configuration["Authentication:Facebook:AppId"], 
                    Configuration["Authentication:Facebook:AppSecret"]));

            string server = Configuration["DatabaseServer"] ?? "localhost";
            string port = Configuration["DatabasePort"] ?? "1433";
            string user = Configuration["DatabaseUser"] ?? "sa";
            string password = Configuration["DatabasePassword"] ?? "mssQlp4ssword#";
            string database = Configuration["DatabaseName"] ?? "auth";

            string connectionString = $"Server={server},{port};Initial Catalog={database};User={user};Password={password}";

            System.Console.WriteLine(connectionString);

            // For Entity Framework  
            services.AddDbContext<AuthContext>(options => options.UseSqlServer(connectionString, x => x.MigrationsAssembly("AuthApi.Infrastructure")));

            // For Identity  
            services.AddIdentity<ApplicationUser, IdentityRole>()  
                .AddEntityFrameworkStores<AuthContext>()  
                .AddDefaultTokenProviders();  
  
            string validAudience = Configuration["JWT:ValidAudience"];
            string validIssuer = Configuration["JWT:ValidIssuer"];
            string secret = Configuration["JWT:Secret"];

            // Adding Authentication  c
            services.AddAuthentication(options =>  
            {  
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;  
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;  
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;  
            }).AddFacebook(facebookOptions => 
            {
                facebookOptions.AppId = Configuration["Authentication:Facebook:AppId"];
                facebookOptions.AppSecret = Configuration["Authentication:Facebook:AppSecret"];
            })
            // Adding Jwt Bearer  
            .AddJwtBearer(options =>  
            {  
                options.SaveToken = true;  
                options.RequireHttpsMetadata = false;  
                options.TokenValidationParameters = new TokenValidationParameters()  
                {  
                    ValidateIssuer = true,  
                    ValidateAudience = true,  
                    ValidAudience = validAudience,  
                    ValidIssuer = validIssuer,  
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret))  
                };  
            }); 
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "AuthApi", Version = "v1" });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "AuthApi v1"));
            }

            app.UseHttpsRedirection();

            app.UseRouting();
  
            app.UseAuthentication();  
            app.UseAuthorization();  

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}

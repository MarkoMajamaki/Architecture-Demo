using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Azure.Services.AppAuthentication;
using Microsoft.Azure.KeyVault;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.AzureKeyVault;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using AuthApi.Infrastructure;
using System;

namespace AuthApi
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
                    var env = hostingcontext.HostingEnvironment;

                    // find the shared folder in the parent folder
                    var sharedFolder = Path.Combine(env.ContentRootPath, "../../SharedApi", "Shared");

                    config
                    .AddJsonFile(Path.Combine(sharedFolder, "sharedsettings.json"), optional: true)
                    .AddJsonFile(Path.Combine(sharedFolder, $"sharedsettings.{env.EnvironmentName}.json"), optional: true)
                    .AddJsonFile("appsettings.json", false, true)
                    .AddJsonFile($"appsettings.{env.EnvironmentName}.json", true, true)
                    .AddEnvironmentVariables();

                    // Configure Hashicorp Vault
                    var vaultFolder = "/vault/secrets";
                    if (Directory.Exists(vaultFolder))
                    {
                        var vaultFiles = Directory.GetFiles(vaultFolder); 
                        foreach (string path in vaultFiles)
                        {
                            if (path.EndsWith(".json"))
                            {
                                System.Console.WriteLine($"Vault json file found from path: {path}");
                                config.AddJsonFile(path, true, true);
                            }
                        }
                    }
                    else
                    {
                        System.Console.WriteLine($"Hashicorp Vault folder not found from path: {vaultFolder}");
                    }

                    // Configure Azure Key Vault
                    var vaultName = config.Build()["KeyVaultName"];    
                    if (string.IsNullOrEmpty(vaultName) == false)
                    {              
                        var azureServiceTokenProvider = new AzureServiceTokenProvider("RunAs=Developer; DeveloperTool=AzureCli");
                        var keyVaultClient = new KeyVaultClient(
                            new KeyVaultClient.AuthenticationCallback(azureServiceTokenProvider.KeyVaultTokenCallback));
                        config.AddAzureKeyVault($"https://{vaultName}.vault.azure.net/", keyVaultClient, new DefaultKeyVaultSecretManager());
                    }
                    else
                    {
                        System.Console.WriteLine("Azure Key Vault name is not found from any config file");
                    }
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
                var aspnetRunContext = services.GetRequiredService<AuthContext>();
                AuthContextSeed.SeedAsync(aspnetRunContext).Wait();
            }
        }
    }
}

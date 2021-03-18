using System;
using System.Text;
using CustomerApi.Domain;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using RabbitMQ.Client;

using Shared;

// Copy from: https://www.programmingwithwolfgang.com/rabbitmq-in-an-asp-net-core-3-1-microservice/

namespace CustomerApi.Application
{    
    public interface ICustomerUpdateSender
    {
        void SendCustomer(Customer customer);
    }

    public class CustomerUpdateSender : ICustomerUpdateSender
    {
        private RabbitMqSettings _rabbitMqOptions;
        private IConnection _connection;

        public CustomerUpdateSender(IOptions<RabbitMqSettings> rabbitMqOptions)
        {
            _rabbitMqOptions = rabbitMqOptions.Value;
            CreateConnection();
        }

        public void SendCustomer(Customer customer)
        {
            Console.WriteLine("RabbitMq start sending message!");

            if (ConnectionExists())
            {
                using (var channel = _connection.CreateModel())
                {
                    channel.QueueDeclare(queue: _rabbitMqOptions.QueueName, durable: false, exclusive: false, autoDelete: false, arguments: null);

                    var json = JsonConvert.SerializeObject(customer);
                    var body = Encoding.UTF8.GetBytes(json);

                    channel.BasicPublish(exchange: "", routingKey: _rabbitMqOptions.QueueName, basicProperties: null, body: body);
                }
            }

            Console.WriteLine("RabbitMq message send!");
        }

        private void CreateConnection()
        {
            // Use this with kind
            string connectionUrl = "amqp://" + _rabbitMqOptions.UserName + ":" + _rabbitMqOptions.Password + "@" + _rabbitMqOptions.HostName + ":" + _rabbitMqOptions.Port + "/";
                        
            // Use this with Bridge to Kubernetes after opening port with command:
            // kubectl -n architecture-demo port-forward rabbitmq-0 8001:5672
            // string connectionUrl = "amqp://guest:guest@localhost:8001/";

            try
            {
                ConnectionFactory factory = new ConnectionFactory();
                factory.Uri = new Uri(connectionUrl);
                _connection = factory.CreateConnection();

                Console.WriteLine("RabbitMq connection created");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"RabbitMq could not create connection to uri: {connectionUrl}" + Environment.NewLine + "message: " + ex.Message);
            }
        }

        private bool ConnectionExists()
        {
            if (_connection != null)
            {
                return true;
            }

            CreateConnection();

            return _connection != null;
        }
    }
}
using System;
using System.Text;
using CustomerApi.Domain;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using RabbitMQ.Client;

// Copy from: https://www.programmingwithwolfgang.com/rabbitmq-in-an-asp-net-core-3-1-microservice/

namespace CustomerApi.Application
{    
    public interface ICustomerUpdateSender
    {
        void SendCustomer(Customer customer);
    }

    public class CustomerUpdateSender : ICustomerUpdateSender
    {
        private RabbitMqConfiguration _rabbitMqOptions;
        private IConnection _connection;

        public CustomerUpdateSender(IOptions<RabbitMqConfiguration> rabbitMqOptions)
        {
            _rabbitMqOptions = rabbitMqOptions.Value;
            CreateConnection();
        }

        public void SendCustomer(Customer customer)
        {
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
        }

        private void CreateConnection()
        {
            try
            {
                ConnectionFactory factory = new ConnectionFactory();
                factory.Uri = new Uri("amqp://" + _rabbitMqOptions.UserName + ":" + _rabbitMqOptions.Password + "@" + _rabbitMqOptions.HostName + ".svc.cluster.local:5672/");
                _connection = factory.CreateConnection();

                Console.WriteLine("RabbitMq connection created");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"RabbitMq could not create connection: {ex.Message}");
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
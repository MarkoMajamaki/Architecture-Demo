using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;

namespace OrderApi.Application
{
    public class CustomerUpdateReceiver : BackgroundService
    {
        private readonly RabbitMqConfiguration _rabbitMqConfiguration; 
        private IConnection _connection;
        private IModel _channel;
        private readonly IMediator _mediator;

        public CustomerUpdateReceiver(
            IMediator mediator, 
            IOptions<RabbitMqConfiguration> rabbitMqOptions)
        {
            _rabbitMqConfiguration = rabbitMqOptions.Value;
            _mediator = mediator;

            InitializeRabbitMqListener();
        }

        public override void Dispose()
        {
            _channel.Close();
            _connection.Close();
            base.Dispose();
        }

        protected override Task ExecuteAsync(CancellationToken stoppingToken)
        {
            stoppingToken.ThrowIfCancellationRequested();

            var consumer = new EventingBasicConsumer(_channel);
            consumer.Received += /*async*/ (object sender, BasicDeliverEventArgs ea) =>
            {
                /*
                var content = Encoding.UTF8.GetString(ea.Body);
                var updateCustomerModel = JsonConvert.DeserializeObject<UpdateCustomerModel>(content);

                var order = await _mediator.Send(new GetOrderByIdQuery(updateCustomerModel.Id));

                order.CustomerFullName = updateCustomerModel.
                await _mediator.Send(new UpdateOrderCommand(), new CancellationToken());
                */
                _channel.BasicAck(ea.DeliveryTag, false);
            };

            _channel.BasicConsume(_rabbitMqConfiguration.QueueName, false, consumer);

            return Task.CompletedTask;        }

        private void InitializeRabbitMqListener()
        {
            var factory = new ConnectionFactory
            {
                HostName = _rabbitMqConfiguration.Hostname,
                UserName = _rabbitMqConfiguration.UserName,
                Password = _rabbitMqConfiguration.Password
            };

            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.QueueDeclare(queue: _rabbitMqConfiguration.QueueName, durable: false, exclusive: false, autoDelete: false, arguments: null);
        } 
    }
}
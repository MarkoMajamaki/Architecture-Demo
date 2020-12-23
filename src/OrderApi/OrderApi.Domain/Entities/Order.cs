using System;

namespace OrderApi.Domain
{
    public class Order
    {
        public Guid Id { get; set; }
        public string Product { get; set; }
        public Guid CustomerGuid { get; set; }
        public string CustomerFullName { get; set; }
    }
}
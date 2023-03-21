using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FashionShops.Models.CheckOut;

namespace FashionShops.Models.OrderTracking
{
    public class OrderTracking
    {
        public Order orderInfo { get; set; }
        public List<InfoProductCheckOut> orderitems { get; set; }
    }
}
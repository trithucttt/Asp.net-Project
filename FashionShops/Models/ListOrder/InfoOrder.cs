using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.ListOrder
{
    public class InfoOrder
    {
        public long order_id { get; set; }
        public long customer_id { get; set; }
        public int firtProductID{ get; set; }
        public string proName { get; set; }
        public int quantity { get; set; }
        public float totalPrice { get; set; }
        public string imgUrl { get; set; }
    }
}
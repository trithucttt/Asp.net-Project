using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models
{
    public class addProduct 
    {
        public long cart_id { get; set; }
        public long user_id { get; set; }
        public long product_id { get; set; }
        public short quantity { get; set; }
        public long size { get; set; }
        public long color { get; set; }
        public double total_price { get; set; }
    }
}
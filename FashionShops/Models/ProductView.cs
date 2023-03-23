using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models
{
    public class ProductView
    {
         public int productID { get; set; }
        public string productName { get; set; }
        public double productPrice { get; set; }
        public string imageUrl { get; set; }
        public string content { get; set; }
        public int QuantityPro { get; set; }
    }
}
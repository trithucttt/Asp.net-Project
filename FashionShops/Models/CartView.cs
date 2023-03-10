using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models
{
    public class CartView
    {
        public int productID { get; set; }
        public string productName { get; set; }
        public double productPrice { get; set; }
        public int proudctQuantity { get; set; }
        public string productColor { get; set; }
        public string productSize { get; set; }
        public string productImage { get; set; }
    }
}
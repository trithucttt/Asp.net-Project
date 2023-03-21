using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.CheckOut
{
    public class InfoProductCheckOut
    {
        public int cartID { get; set; }
        public int productID { get; set; }
        public string productName { get; set; }
        public double productPrice { get; set; }
        public string sizeName { get; set; }
        public string colorName { get; set; }
        public string imgUrl { get; set; }
        public int productQuantiyInCart { get; set; }
        public float pricexquantity { get; set; }
    }
}
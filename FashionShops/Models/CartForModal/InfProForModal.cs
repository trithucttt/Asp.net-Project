using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.CartForModal
{
    public class InfProForModal
    {
        public int productID { get; set; }
        public string productName { get; set; }
        public double productPrice { get; set; }
        public string urlImage { get; set; }
        public int productQuantiyInCart { get; set; }
    }
}


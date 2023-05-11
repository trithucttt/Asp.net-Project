using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Areas.Admin.Models
{
    public class Dashboard
    {
        public List<Order> orders { get; set; }
        public List<Product_Reviewing> comments { get; set; }
    }
}
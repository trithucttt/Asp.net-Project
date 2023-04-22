using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Areas.Admin.Models
{
    public class AddProduct
    {
        //public Product product { get; set; }
        public List<Size> size { get; set; }
        public List<Color> color { get; set; }
        public List<Tag> tag { get; set; }
        public List<Category> category { get; set; }
    }
}
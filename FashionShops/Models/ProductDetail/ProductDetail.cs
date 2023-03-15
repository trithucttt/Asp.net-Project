using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FashionShops.Models;

namespace FashionShops.Models.ProductDetail
{
    public class ProductDetail
    {
        public List<ImagesForProduct> imagesForProduct { get; set; }
        public ProductView infProduct { get; set; }
    }
}
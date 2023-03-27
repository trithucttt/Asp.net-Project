using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FashionShops.Models;
using FashionShops.Models.CartForModal;

namespace FashionShops.Models.ProductDetail
{
    public class ProductDetail
    {
        public List<SizesProForModal> sizesForDetailPage { get; set; }
        public List<ColorsProForModal> colorsForDetailPage { get; set; }
        public List<ImagesForProduct> imagesForProduct { get; set; }
        public List<ProductReview> review { get; set; }
        public ProductView infProduct { get; set; }
    }
}
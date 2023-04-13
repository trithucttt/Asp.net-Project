using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.ProductDetail
{
    public class ProductReview
    {
        public int pReviewID { get; set; }
        public int user_id { get; set; }
        public string username { get; set; }
        public int product_id { get; set; }
        public int rating { get; set; }
        public string content { get; set; }
        public DateTime publishedAt { get; set; }
    }
}
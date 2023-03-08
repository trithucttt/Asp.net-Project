using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Models;
namespace FashionShops.Controllers.Products
{
    public class ProductController : Controller
    {
        // GET: Product
        FashionShopEntities data = new FashionShopEntities();
        public ActionResult Index()
        {

            var query = from product in data.Products
                        join proImage in data.Product_Image on product.product_id equals proImage.product_id
                        join Img in data.Images on proImage.image_id equals Img.image_id
                        where Img.image_id == (product.product_id - 1) * 3 + product.product_id
                        select new ProductView
                        {
                            productName = product.name,
                            productPrice = product.price,
                            imageUrl = Img.imgae_url
                        };
            var model = query.ToList();
            return View(model);
        }
    }
}
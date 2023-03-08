using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Models;

namespace FashionShops.Controllers.Cart
{
    public class CartController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: Cart
        public ActionResult Index()
        {
            var carts = from product in db.Products
                        join cart in db.Carts on product.product_id equals cart.product_id
                        join color in db.Colors on cart.color equals color.color_id
                        join size in db.Sizes on cart.size equals size.size_id
                        join proImg in db.Product_Image on product.product_id equals proImg.product_id
                        join Img in db.Images on proImg.image_id equals Img.image_id
                        where Img.image_id == (cart.product_id - 1) * 3 + cart.product_id
                        select new CartView {
                            productName = product.name,
                            productPrice = product.price,
                            proudctQuantity = cart.quantity, 
                            productColor = color.color1, 
                            productSize = size.size1,
                            productImage = Img.imgae_url
                        };
            var results = carts.ToList();
            return View(results);
        }
    }
}
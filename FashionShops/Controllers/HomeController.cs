using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using FashionShops.Models;


namespace FashionShops.Controllers
{
    public class HomeController : Controller
    {
        FashionShopEntities data = new FashionShopEntities();
        public ActionResult Index()
        {
            if (TempData["LoginStatus"] != null)
            {
                ViewBag.LoginSuccessMsg = TempData["LoginStatus"];
            }
            else
            {
                ViewBag.LoginSuccessMsg = "";
            }
            return View(GetProducts());
        }

        [HttpGet]
        public int NumberOfProdcutInCart()
        {
            int count = 0;
            if (Membership.GetUser() != null)
            {
                var userName = Membership.GetUser().UserName;
                var query = from us in data.Users where us.username == userName select us;
                var user = query.FirstOrDefault();
                var query1 = from c in data.Carts where c.user_id == user.user_id select c;
                var cart = query1.ToList();
                foreach (var item in cart)
                {
                    count += item.quantity;
                }
            }
            return count;
        }

        public IEnumerable<ProductView> GetProducts()
        {
            var products = (from product in data.Products
                            join pImg in data.Product_Image on product.product_id equals pImg.product_id
                            join Img in data.Images on pImg.image_id equals Img.image_id
                            where Img.image_id == (product.product_id - 1) * 3 + product.product_id
                            select new ProductView
                            {
                                productID = (int)product.product_id,
                                productName = product.name,
                                productPrice = product.price,
                                imageUrl = Img.imgae_url,
                                brandPro = product.brand
                            });
            return products;
        }
    }
}
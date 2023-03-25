using FashionShops.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Net.Mail;
using System.Net;

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

            if (TempData["NotLogin"] != null)
            {
                ViewBag.NotLogin = TempData["NotLogin"];
            }
            else
            {
                ViewBag.NotLogin = "";
            }
            return View();
            var query = from product in data.Products
                        join proImage in data.Product_Image on product.product_id equals proImage.product_id
                        join Img in data.Images on proImage.image_id equals Img.image_id
                        where Img.image_id == (product.product_id - 1) * 3 + product.product_id
                        select new ProductView
                        {
                            productID = (int)product.product_id,
                            productName = product.name,
                            productPrice = product.price,
                            imageUrl = Img.imgae_url
                        };
            var model = query.ToList();
            return View(model);
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
        public ActionResult Register()
        {
            return View();
        }
    }
}
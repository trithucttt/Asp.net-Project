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
        FashionShopEntities db = new FashionShopEntities();
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
            var listProduct = from p in db.Products select p;
            return View(listProduct);
        }

        [HttpGet]
        public int NumberOfProdcutInCart()
        {
            int count = 0;
            if (Membership.GetUser() != null)
            {
                var userName = Membership.GetUser().UserName;
                int userID = (int)db.Users.Where(x => x.username == userName).FirstOrDefault().user_id;
                var query1 = from c in db.Carts where c.user_id == userID select c;
                var cart = query1.ToList();
                foreach (var item in cart)
                {
                    count += item.quantity;
                }
            }
            return count;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

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
            } else
            {
                ViewBag.LoginSuccessMsg = "";
            }
            return View();
        }

        [HttpGet]
        public int NumberOfProdcutInCart()
        {
            int count = 0;
            if (Membership.GetUser() != null)
            {
                var userName = Membership.GetUser().UserName;
                var query = from us in db.Users where us.username == userName select us;
                var user = query.FirstOrDefault();
                var query1 = from c in db.Carts where c.user_id == user.user_id select c;
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
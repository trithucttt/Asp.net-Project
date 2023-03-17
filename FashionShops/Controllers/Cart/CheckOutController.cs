using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FashionShops.Controllers.Cart
{
    public class CheckOutController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: CheckOut
        public ActionResult Index()
        {
            return View();
        }
    }
}
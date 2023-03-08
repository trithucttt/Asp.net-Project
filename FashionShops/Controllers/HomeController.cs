using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FashionShops.Controllers
{
    public class HomeController : Controller
    {
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
    }
}
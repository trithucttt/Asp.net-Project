using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FashionShops.Controllers.Auth
{
    public class LoginController : Controller
    {
        // GET: Login

        public ActionResult showFormLogin()
        {
            return View("~/Views/Login/showFormLogin.cshtml");
        }

        public ActionResult Check(string username, string password)
        {
            if (username.Length == 0)
            {
                username = "";
            }
            if (password.Length == 0)
            {
                password = "";
            }
            if (username.Equals("admin") && password.Equals("12345"))
                return View("~/Views/Home/Index.cshtml");
            else
            {
                ViewBag.error = "The account or password is incorrect!\nPlease try again";
                return View("~/Views/Login/showFormLogin.cshtml");
            }
        }
    }
}
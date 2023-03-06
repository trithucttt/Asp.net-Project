using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Code;
using System.Web.Security;


namespace FashionShops.Controllers.Auth
{
    public class LoginController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: Login

        public ActionResult showFormLogin()
        {
            return View();
        }
        
        public bool validationLogin(string username, string password)
        {
            var users = from s in db.Users
                        where s.username.Equals(username)
                        where s.password.Equals(password)
                        select s;
            if (users.Count() != 0)
            {
                return true;
            }
            return false;
        }

        public ActionResult Check(User client)
        {
            if (Membership.ValidateUser(client.username, client.password))
            {
                FormsAuthentication.SetAuthCookie(client.username, client.rememberme);
                TempData["LoginStatus"] = "Login successfully! Enjoy shopping!";
                return RedirectToAction("Index", "Home");
                //return Content("success");
            } else
            {
                ModelState.AddModelError("", "The account or password is incorrect! Please try again");
            }
            return View("~/Views/Login/showFormLogin.cshtml");
            //return Content("fail");
        }

        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("showFormLogin", "Login");
        }

    }
}
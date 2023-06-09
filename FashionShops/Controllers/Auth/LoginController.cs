﻿using System;
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
            if (TempData["notLogin"] != null)
                ViewBag.NotLogin = TempData["notLogin"];
            if (TempData["Register"] != null)
                ViewBag.Register = TempData["Register"];
            return View();
        }

        public bool validationLogin(string username, string password)
        {
            var users = from s in db.Users
                        where s.username.Equals(username)
                        select s;
            var temp = users.FirstOrDefault();
            if (temp == null) return false;
            return Encrypt.VerifyMD5Hash(password, temp.password);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Check(User client, string preUrl)
        {
            if (Membership.ValidateUser(client.username, client.password))
            {
                FormsAuthentication.SetAuthCookie(client.username, client.rememberme);
                TempData["LoginStatus"] = "Login successfully! Enjoy shopping!";
                //if (preUrl != null)
                //{
                //    int bf = preUrl.IndexOf("/");
                //    string action = preUrl.Substring(0, bf);
                //    string containCtl = preUrl.Substring(bf + 1);
                //    return RedirectToAction(containCtl, action);
                //}
                return RedirectToAction("Index", "Home");
                //return Content("success");
                //https://bbbootstrap.com/snippets/bootstrap-tracking-order-purchase-reciept-progress-86201225
                //https://bbbootstrap.com/snippets/order-tracking-progressbar-icons-22484204
            }
            else
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
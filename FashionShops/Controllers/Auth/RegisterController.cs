using FashionShops.Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FashionShops.Controllers.Auth
{
    public class RegisterController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: Register
        public ActionResult Register()
        {
            if (TempData["Accountexists"] != null)
                ViewBag.Account = TempData["Accountexists"];
            return View();
        }

        [HttpPost]
        public ActionResult Register(string userName, string passWord, string email)
        {
            string HashPassword = "";
            var querry = from user in db.Users where user.username == userName select user;
            var userExists = querry.FirstOrDefault();
            if (userExists == null)
            {
                var newUser = new User();
                newUser.firstName = null;
                newUser.lastName = null;
                newUser.phoneNumber = null;
                newUser.email = email;
                newUser.username = userName;
                HashPassword = Encrypt.HashPassword(passWord);
                newUser.password = HashPassword;
                newUser.admin = 0;
                newUser.address = null;
                newUser.province = null;
                newUser.city = null;
                newUser.country = null;
                db.Users.Add(newUser);
                if (db.SaveChanges() != 0)
                {
                    TempData["Register"] = "Register successfully";
                }
            }
            else
            {
                TempData["Accountexists"] = "Account already exists";
                return RedirectToAction("Register", "Register");
            }
            return RedirectToAction("showFormLogin", "Login");
        }
    }
}
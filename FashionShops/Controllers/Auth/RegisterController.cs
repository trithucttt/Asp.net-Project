using FashionShops.Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
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
        public ActionResult Register(User newUser)
        {
            string HashPassword = "";
            var querry = from user in db.Users where user.username == newUser.username select user;
            var userExists = querry.FirstOrDefault();
            if (userExists == null)
            {
                if (Regex.IsMatch(newUser.password, "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$"))
                {
                    HashPassword = Encrypt.HashPassword(newUser.password);
                    newUser.password = HashPassword;
                    newUser.confirmpassword = HashPassword;
                    newUser.admin = 0;
                    db.Users.Add(newUser);
                    if (db.SaveChanges() != 0)
                    {
                        TempData["Register"] = "Register successfully";
                    }
                } else
                {
                    ModelState.AddModelError("Password", "The password should have lowercase letters, uppercase letters, at least one number, at least one special character, and at least 8 characters.");
                    return View("Register", newUser);
                }
            }
            else
            {
                TempData["Accountexists"] = "Account already exists";
                return RedirectToAction("Register", "Register", newUser);
            }
            return RedirectToAction("showFormLogin", "Login");
        }
    }
}
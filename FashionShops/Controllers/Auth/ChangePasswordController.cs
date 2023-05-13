using FashionShops.Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace FashionShops.Controllers.Auth
{
    public class ChangePasswordController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: ChangePassword
        public ActionResult Index()
        {
            if (Membership.GetUser() == null)
            {
                TempData["notLogin"] = "You need to login to change your password!";
                return RedirectToAction("showFormLogin", "Login");
            }
            return View();
        }

        [HttpPost]
        public ActionResult Change(User userEdit)
        {
            if (Membership.GetUser() != null)
            {
                if (userEdit.newpassword == null)
                {
                    ModelState.AddModelError("newpassword", "New password is required!");
                    return View("Index", userEdit);
                }
                if (!Regex.IsMatch(userEdit.newpassword, "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#$^+=!*()@%&]).{8,}$"))
                {
                    ModelState.AddModelError("newpassword", "The password should have lowercase letters, uppercase letters, at least one number, at least one special character, and at least 8 characters.");
                    return View("Index", userEdit);
                }
                var userName = Membership.GetUser().UserName;
                var userExists = db.Users.FirstOrDefault(x => x.username == userName);
                if (userExists != null)
                {
                    if (Encrypt.VerifyMD5Hash(userEdit.password, userExists.password)) {
                        userExists.password = Encrypt.HashPassword(userEdit.newpassword);
                        userExists.confirmpassword = userExists.password;
                        db.SaveChanges();
                        TempData["LoginStatus"] = "Change password successfully!";
                    }
                    else
                    {
                        ViewBag.CurrentPassIncorrect = "Current password incorrect";
                        return View("~/Views/ChangePassword/Index.cshtml");
                    }

                }
            } else
            {
                TempData["notLogin"] = "You need to login to change your password!";
                return RedirectToAction("showFormLogin", "Login");
            }
            return RedirectToAction("Index", "Home");
        }   

    }
}
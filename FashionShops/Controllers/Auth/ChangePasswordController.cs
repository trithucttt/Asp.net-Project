using FashionShops.Code;
using System;
using System.Collections.Generic;
using System.Linq;
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
        public ActionResult Change(string currentpassword, string newpassword)
        {
            if (Membership.GetUser() != null)
            {
                var userName = Membership.GetUser().UserName;
                var userExists = db.Users.FirstOrDefault(x => x.username == userName);
                if (userExists != null)
                {
                    if (Encrypt.VerifyMD5Hash(currentpassword, userExists.password)) {
                        userExists.password = Encrypt.HashPassword(newpassword);
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
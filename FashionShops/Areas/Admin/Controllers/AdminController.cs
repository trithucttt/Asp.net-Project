using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace FashionShops.Areas.Admin.Controllers
{
    public class AdminController : Controller
    {
        static String LoginStatusE = "";
        static bool firstLogin = true;
        FashionShopEntities db = new FashionShopEntities();
        // GET: Admin/Admin
        public ActionResult Index()
        {
            if (Membership.GetUser() != null)
            {
                string userName = Membership.GetUser().UserName;
                if (isAdmin(userName))
                {
                    if (firstLogin)
                    {
                        ViewBag.LoginAdminS = "Login successfully! Welcome to Admin page!";
                        firstLogin = false;
                    }
                    return View();
                }
                else
                {
                    FormsAuthentication.SignOut();
                    LoginStatusE = "Sorry! Looks like you're not an admin!";
                    return RedirectToAction("LoginAdmin", "Admin");
                }
            }
            return RedirectToAction("LoginAdmin", "Admin");
        }

        public ActionResult LoginAdmin()
        {
            ViewBag.LoginAdminE = LoginStatusE;
            return View();
        }

        [HttpPost]
        public ActionResult LoginAdmin(User adminUser)
        {
            if (Membership.ValidateUser(adminUser.username, adminUser.password))
            {
                FormsAuthentication.SetAuthCookie(adminUser.username, false);
            } else
            {
                LoginStatusE = "The account or password is incorrect! Please try again";
                ModelState.AddModelError("", "The account or password is incorrect! Please try again");
                return RedirectToAction("LoginAdmin", "Admin");
            }
            return RedirectToAction("Index", "Admin");
        }

        public bool isAdmin(string userName)
        {
            int userAdmin = db.Users.SingleOrDefault(x => x.username == userName).admin;
            if (userAdmin == 1)
                return true;
            else 
                return false;
        }
    }
}
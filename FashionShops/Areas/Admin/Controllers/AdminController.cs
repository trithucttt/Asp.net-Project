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
        FashionShopEntities db = new FashionShopEntities();
        // GET: Admin/Admin
        public ActionResult Index()
        {
            if (Membership.GetUser() != null)
            {
                string userName = Membership.GetUser().UserName;
                if (isAdmin(userName))
                    return View();
                else
                {
                    FormsAuthentication.SignOut();
                    return RedirectToAction("LoginAdmin", "Admin");
                }
            }
            return RedirectToAction("LoginAdmin", "Admin");
        }

        public ActionResult LoginAdmin()
        {
            return View();
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
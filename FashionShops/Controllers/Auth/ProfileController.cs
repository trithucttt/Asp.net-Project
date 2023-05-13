using FashionShops.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace FashionShops.Controllers.Auth
{
    public class ProfileController : Controller
    {
        FashionShopEntities data = new FashionShopEntities();
        public ActionResult Index()
        {
            if (Membership.GetUser() != null)
            {
                string userName = Membership.GetUser().UserName;
                var user = data.Users.FirstOrDefault(x => x.username.Equals(userName));
                return View(user);
            }
            return View("~/Views/Login/showFormLogin.cshtml");
        }

        [HttpPost]
        public ActionResult UpdateProfile(User profile)
        {
            var user = data.Users.FirstOrDefault(x => x.user_id == profile.user_id);
            user.confirmpassword = profile.password;
            user.firstName = profile.firstName;
            user.lastName = profile.lastName;
            user.address = profile.address;
            user.province = profile.province;
            user.city = profile.city;
            user.country = profile.country;
            user.phoneNumber = profile.phoneNumber;
            if (data.SaveChanges() != 0)
            {
                return RedirectToAction("Index");
            }
            else
            {
                ModelState.AddModelError("", "There was an error saving, or nothing changed!");
                string userName = Membership.GetUser().UserName;
                var users = data.Users.FirstOrDefault(x => x.username.Equals(userName));
                return View("Index", users);
            }
        }
    }
}
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
                int userId = (int)data.Users.FirstOrDefault(x => x.username == userName).user_id;
                return View(GetProfile(userId));
            }
            return View("~/Views/Login/showFormLogin.cshtml");
        }

        public Profile GetProfile(int userID)
        {
            var profile = (from p in data.Users
                           where p.user_id == userID
                           select new Profile
                           {
                               firstname = p.firstName,
                               lastname = p.lastName,
                               phonenumber = p.phoneNumber,
                               email = p.email,
                               username = p.username,
                               address = p.address,
                               province = p.province,
                               city = p.city,
                               country = p.country
                           }).FirstOrDefault();
            return profile;
        }
    }
}
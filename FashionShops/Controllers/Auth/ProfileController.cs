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
                               userId = (int)p.user_id,
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

        [HttpPost]
        public ActionResult UpdateProfile(int userid, string firstname, string lastname, string email, string country,
            string phonenumber, string address, string province, string city)
        {
            var user = data.Users.FirstOrDefault(x => x.user_id == userid);
            user.firstName = firstname;
            user.lastName = lastname;
            user.email = email;
            user.country = country;
            user.phoneNumber = phonenumber;
            user.address = address;
            user.province = province;
            user.city = city;
            if (data.SaveChanges() != 0)
            {
                return Content("Update profile successfully!");
            }
            else
            {
                return Content("Sorry, something went wrong, please try again later!");
            }
        }
    }
}
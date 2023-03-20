using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using FashionShops.Models.CheckOut;

namespace FashionShops.Controllers.Cart
{
    public class CheckOutController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: CheckOut
        public ActionResult Index()
        {
            string userName = Membership.GetUser().UserName;
            var user = db.Users.SingleOrDefault(x => x.username == userName);
            var userInfo = new InfoUserCheckOut
            {
                user_id = user.user_id,
                firstName = user.firstName,
                lastName = user.lastName,
                phoneNumber = user.phoneNumber,
                email = user.email,
                province = user.province,
                city = user.city,
                country = user.country,
                address = user.address
            };

            var query = from v in db.Vouchers
                        where v.voucher_id > 1
                        select new VoucherAvailable
                        {
                            voucher_id = v.voucher_id,
                            code = v.code,
                            discount_percentage = v.discount_percentage,
                            voucher_status = v.voucher_status,
                            start_date = v.start_date,
                            end_date = v.end_date
                        };
            var voucher = query.ToList();

            var query1 = from payment in db.Payment_Methods
                         select new PaymentMethods
                         {
                             id = payment.id,
                             name_methods = payment.name_methods
                         };
            var paymentMethods = query1.ToList();
            var allNeedsForCheckOutPage = new AllNeedForCheckOut
            {
                infoUserCheckOut = userInfo,
                voucherAvailable = voucher,
                paymentMethods = paymentMethods
            };
            return View(allNeedsForCheckOutPage);
        }
    }
}
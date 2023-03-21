using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using FashionShops.Models.CheckOut;
using FashionShops.Models.ListOrder;
using Newtonsoft.Json;

namespace FashionShops.Controllers.Cart
{
    public class CheckOutController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: CheckOut
        public string getUserName()
        {
            return Membership.GetUser().UserName;
        }
        public ActionResult Index(string arrProducts = "[1]")
        {
            string temp = arrProducts;
            int[] arrPro = JsonConvert.DeserializeObject<int[]>(arrProducts);
            var query2 = from c in db.Carts
                         join p in db.Products on c.product_id equals p.product_id
                         join cl in db.Colors on c.color equals cl.color_id
                         join sz in db.Sizes on c.size equals sz.size_id
                         join pi in db.Product_Image on c.product_id equals pi.product_id
                         join i in db.Images on pi.image_id equals i.image_id
                         where i.image_id == (c.product_id - 1) * 3 + c.product_id
                         select new InfoProductCheckOut
                         {
                             cartID = (int)c.cart_id,
                             productID = (int)c.product_id,
                             productName = p.name,
                             productPrice = p.price,
                             colorName = cl.color1,
                             sizeName = sz.size1,
                             imgUrl = i.imgae_url,
                             productQuantiyInCart = c.quantity,
                             pricexquantity = (float)c.total_price
                         };
            var products = query2.Where(p => arrPro.Contains(p.cartID)).ToList();
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
                paymentMethods = paymentMethods,
                infoProductCheckOut = products
            };
            return View(allNeedsForCheckOutPage);
        }

        public ActionResult OrderList()
        {
            string userName = getUserName();
            int userID = (int)db.Users.SingleOrDefault(x => x.username == userName).user_id;
            var query = from o in db.Orders
                        join oi in db.Order_Item on o.order_id equals oi.order_id
                        where o.customer_id == userID
                        select new InfoOrder
                        {
                            order_id = o.order_id,
                            firtProductID = (int)oi.product_id
                        };
            var orderList = query.ToList();
            return View();
        }

        public ActionResult OrderTracking()
        {
            return View();
        }
    }
}
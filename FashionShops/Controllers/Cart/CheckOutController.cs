﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using FashionShops.Models.CheckOut;
using FashionShops.Models.OrderTracking;
using Newtonsoft.Json;
using MailKit;
using MimeKit;
using MailKit.Net.Smtp;

namespace FashionShops.Controllers.Cart
{
    public class CheckOutController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: CheckOut
        public ActionResult Index(string arrProducts = "[1]")
        {
            string temp = arrProducts;
            int[] arrPro = JsonConvert.DeserializeObject<int[]>(arrProducts);
            //var query2 = from c in db.Carts
            //             join p in db.Products on c.product_id equals p.product_id
            //             join cl in db.Colors on c.color equals cl.color_id
            //             join sz in db.Sizes on c.size equals sz.size_id
            //             join pi in db.Product_Image on c.product_id equals pi.product_id
            //             join i in db.Images on pi.image_id equals i.image_id
            //             where i.image_id == (c.product_id - 1) * 3 + c.product_id
            //             select new InfoProductCheckOut
            //             {
            //                 cartID = (int)c.cart_id,
            //                 productID = (int)c.product_id,
            //                 productName = p.name,
            //                 productPrice = p.price,
            //                 colorName = cl.color1,
            //                 sizeName = sz.size1,
            //                 imgUrl = i.imgae_url,
            //                 productQuantiyInCart = c.quantity,
            //                 pricexquantity = (float)c.total_price
            //             };
            var query2 = from c in db.Carts select c;
            var products = query2.Where(p => arrPro.Contains((int)p.cart_id)).ToList();
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
            if (Membership.GetUser() != null)
            {
                string userName = Membership.GetUser().UserName;
                int userID = (int)db.Users.SingleOrDefault(x => x.username == userName).user_id;
                var orderList = from o in db.Orders
                                where o.customer_id == userID
                                select o;
                if (!orderList.Any())
                {
                    TempData["notLogin"] = "You have no order, shopping now!";
                    return RedirectToAction("Index", "Product");
                }
                return View(orderList);
            } else
            {
                TempData["notLogin"] = "You need to login to see your list order!";
                return RedirectToAction("showFormLogin", "Login");
            }
        }

        public void autoSendEmail()
        {
            var email = new MimeMessage();

            email.From.Add(new MailboxAddress("Sender Name", "thuongb2014795@student.ctu.edu.vn"));
            email.To.Add(new MailboxAddress("Receiver Name", "thuongb2014795@student.ctu.edu.vn"));

            email.Subject = "Testing out email sending";
            email.Body = new TextPart(MimeKit.Text.TextFormat.Plain)
            {
                Text = "Thank you to shopping in FashionShops!!!"
            };
            using (var smtp = new SmtpClient())
            {
                smtp.Connect("smtp.gmail.com", 587, false);

                // Note: only needed if the SMTP server requires authentication
                smtp.Authenticate("asdfasdf", "adsfasd");

                smtp.Send(email);
                smtp.Disconnect(true);
            }
        }

        [HttpPost]
        public ActionResult OrderDetail(int userid, long orderid, string orderdate, 
            float originprice, float reduceprice, float transpotfee, float totalprice, 
            int voucherid, string arrayProducts, int paymentmethod)
        {
            DateTime now = DateTime.Now;
            string formattedDate = now.ToString("yyyy-MM-dd HH:mm:ss.fff");
            var newOrder = new Order
            {
                order_id = orderid,
                customer_id = userid,
                order_date = now,
                original_price = originprice,
                reduced_price = reduceprice,
                transport_fee = transpotfee,
                total_price = totalprice,
                voucher_id = voucherid,
                order_status = "accepted"
            };
            db.Orders.Add(newOrder);
            string temp = arrayProducts;
            int[] arrPro = JsonConvert.DeserializeObject<int[]>(arrayProducts);
            var products = db.Carts.Where(p => arrPro.Contains((int)p.cart_id)).ToList();
            List<Order_Item> listproduct = new List<Order_Item>();
            foreach(var item in products)
            {
                db.Order_Item.Add(new Order_Item
                {
                    order_id = orderid,
                    product_id = item.product_id,
                    quantity = item.quantity,
                    size = item.size,
                    color = item.color,
                    total_price = item.total_price
                });
            }
            int idPayMentDetail = (from py in db.Payment_Detail select py).Count() + 1;
            var paymentdetail = new Payment_Detail
            {
                id = idPayMentDetail,
                order_id = orderid,
                amount = totalprice,
                payment_method = paymentmethod,
                payment_status = 2
            };
            db.Payment_Detail.Add(paymentdetail);
            var productsToRemove = from p in db.Carts
                                   where arrPro.Contains((int)p.cart_id)
                                   select p;
            db.Carts.RemoveRange(productsToRemove);
            //autoSendEmail();
            if (db.SaveChanges() != 0)
            {
                return Content("Successfully!");
            }
            return Content("Something went wrong!");
        }

        public ActionResult OrderTracking(long orderid)
        {
            var orderItem = db.Orders.FirstOrDefault(x => x.order_id == orderid);
            var querry = from oi in db.Order_Item
                         join p in db.Products on oi.product_id equals p.product_id
                         join c in db.Colors on oi.color equals c.color_id
                         join sz in db.Sizes on oi.size equals sz.size_id
                         where oi.order_id == orderid
                         select new InfoProductCheckOut
                         {
                             productID = (int)p.product_id,
                             productName = p.name,
                             colorName = c.color1,
                             sizeName = sz.size1,
                             pricexquantity = (float)oi.total_price
                         };
            var orderitems = querry.ToList();
            var order = new OrderTracking
            {
                orderInfo = orderItem,
                orderitems = orderitems
            };
            return View(order);
        }
    }
}
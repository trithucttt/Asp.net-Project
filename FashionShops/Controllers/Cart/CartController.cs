﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Models;
using FashionShops.Models.CartForModal;
using FashionShops.Models.CheckOut;
using System.Web.Security;
using Newtonsoft.Json;

namespace FashionShops.Controllers.Cart
{
    public class CartController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: Cart
        public ActionResult Index()
        {
            
            if (Membership.GetUser() != null)
            {
                var userName = Membership.GetUser().UserName;
                var query = from us in db.Users where us.username == userName select us;
                var user = query.FirstOrDefault();
                var results = from cart in db.Carts where cart.user_id == user.user_id select cart;
                return View(results);
            }
            TempData["notLogin"] = "You need to log in to see your cart!";
            return RedirectToAction("showFormLogin", "Login");
        }

        [HttpGet]
        public ActionResult DataForModal(int id, int sizeid, int colorid, int cartid, int quantity)
        {
            var querry1 = from product in db.Products
                          join cart in db.Carts on product.product_id equals cart.product_id
                          join color in db.Colors on cart.color equals color.color_id
                          join size in db.Sizes on cart.size equals size.size_id
                          join proImg in db.Product_Image on product.product_id equals proImg.product_id
                          join Img in db.Images on proImg.image_id equals Img.image_id
                          //where Img.image_id == (cart.product_id - 1) * 3 + cart.product_id
                          where cart.product_id == id
                          where cart.size == sizeid
                          where cart.color == colorid
                          select new InfProForModal
                          {
                              productID = (int)cart.product_id,
                              productQuantiyInCart = cart.quantity,
                              productName = product.name,
                              productPrice = (float)product.price,
                              urlImage = product.Product_Image.FirstOrDefault().Image.imgae_url
                          };
            var infPro = querry1.ToList();

            var querry2 = (from product in db.Products
                           join pQ in db.Product_Quantity on product.product_id equals pQ.product_id
                           join cl in db.Colors on pQ.color_id equals cl.color_id
                           where product.product_id == id
                           select new ColorsProForModal
                           {
                               colorID = (int)pQ.color_id,
                               colorName = cl.color1
                           });
            var colors = querry2.Distinct().ToList();

            var querry3 = (from product in db.Products
                           join pQ in db.Product_Quantity on product.product_id equals pQ.product_id
                           join sz in db.Sizes on pQ.size_id equals sz.size_id
                           where product.product_id == id
                           select new SizesProForModal
                           {
                               sizeID = (int)pQ.size_id,
                               sizeName = sz.size1
                           });
            var sizes = querry3.Distinct().OrderBy(s => s.sizeID).ToList();

            var querry4 = from cart in db.Carts
                          where cart.product_id == id
                          select cart;
            var currentStateOfProInCart = querry4.ToList();
            var modalProduct = new AllNeedsForModal
            {
                cartID = cartid,
                sizeActive = sizeid,
                colorActive = colorid,
                currentQuantity = quantity,
                infProduct = infPro,
                colorsProduct = colors,
                sizesProduct = sizes
            };
            return PartialView("DataForModal", modalProduct);
        }

        [HttpPost]
        public ActionResult UpdateInfProduct(int productid, int proSize, int proColor, int quantity, int cartid, int proPrice)
        {
            // check neu co nhieu hon 1 san pham co cung id, size, color
            // xoa 1 cai va cong so luong trong gio hang cua hai cai lai
            // truong hop khong trung thi chinh sua binh thuong
            // them roi moi check
            // them vo binh thuong
            bool changed = false;
            var product = db.Carts.FirstOrDefault(x => x.cart_id == cartid);
            if (product != null)
            {
                product.color = proColor;
                product.size = proSize;
                product.quantity = (short)quantity;
                product.total_price = proPrice * quantity;
                if (db.SaveChanges() != 0)
                {
                    changed = true;
                } else
                {
                    changed = false;
                } 
            }
            // sau khi them kiem tra neu co hai sp cung ip, size, color thi cong quantity lai xoa 1 cai di
            if (changed)
            {
                var temp = from cart in db.Carts
                           where cart.product_id == productid
                           where cart.size == proSize
                           where cart.color == proColor
                           select cart;
                var multiSameProduct = temp.ToList();
                if (multiSameProduct.Count > 1)
                {
                    multiSameProduct[0].quantity += multiSameProduct[1].quantity;
                    db.Carts.Remove(multiSameProduct[1]);
                    if (db.SaveChanges() != 0)
                    {
                        return Content("Product update successful!");
                    }
                    else
                    {
                        return Content("No changes or something went wrong! Please review!");
                    }
                }
            }
            return Content("Product update successful!");
        }


        public ActionResult JustUpdateQuantity(int cartid, int quantity)
        {
            var product = db.Carts.FirstOrDefault(x => x.cart_id == cartid);
            double tempCost = (product.total_price / product.quantity) * quantity;
            if (product != null)
            {
                product.quantity = (short)quantity;
                product.total_price = tempCost;
                if (db.SaveChanges() != 0)
                {
                    return Content("Product update successful!");
                }
                else
                {
                        return Content("No changes or something went wrong! Please review!");
                }
            }
            return Content("Product update successful!");
        }

        [HttpPost]
        public ActionResult RemoveProduct(int cartid)
        {
            var product = db.Carts.FirstOrDefault(x => x.cart_id == cartid);
            if (product != null)
            {
                db.Carts.Remove(product);
                if (db.SaveChanges() != 0)
                {
                    return Content("The product has been successfully deleted!");
                }
                else
                {
                    return Content("No changes or something went wrong! Please review!");
                }
            }
            return Content("The product has been successfully deleted!");
        }

        [HttpPost]
        public ActionResult CheckOut(string arrProduct)
        {
            string temp = arrProduct;
            int[] arrPro = JsonConvert.DeserializeObject<int[]>(arrProduct);
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
            //                 productQuantiyInCart = c.quantity
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
    }
} 
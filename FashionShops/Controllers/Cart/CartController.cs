using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Models;
using FashionShops.Models.CartForModal;


namespace FashionShops.Controllers.Cart
{
    public class CartController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: Cart
        public ActionResult Index()
        {
            var carts = from product in db.Products
                        join cart in db.Carts on product.product_id equals cart.product_id
                        join color in db.Colors on cart.color equals color.color_id
                        join size in db.Sizes on cart.size equals size.size_id
                        join proImg in db.Product_Image on product.product_id equals proImg.product_id
                        join Img in db.Images on proImg.image_id equals Img.image_id
                        where Img.image_id == (cart.product_id - 1) * 3 + cart.product_id
                        select new CartView {
                            productID = (int)cart.product_id,
                            productName = product.name,
                            productPrice = product.price,
                            proudctQuantity = cart.quantity, 
                            productColor = color.color1, 
                            productSize = size.size1,
                            productImage = Img.imgae_url
                        };
            var results = carts.ToList();
            return View(results);
        }

        public ActionResult DataForModal(int id)
        {
            var querry1 = from product in db.Products
                        join cart in db.Carts on product.product_id equals cart.product_id
                        join color in db.Colors on cart.color equals color.color_id
                        join size in db.Sizes on cart.size equals size.size_id
                        join proImg in db.Product_Image on product.product_id equals proImg.product_id
                        join Img in db.Images on proImg.image_id equals Img.image_id
                        where Img.image_id == (cart.product_id - 1) * 3 + cart.product_id
                        where cart.product_id == id
                        select new InfProForModal
                        {
                              productName = product.name,
                              productPrice = (float)product.price,
                              urlImage = Img.imgae_url
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
            var sizes = querry3.Distinct().ToList();

            var modalProduct = new AllNeedsForModal
            {
                infProduct = infPro,
                colorsProduct = colors,
                sizesProduct = sizes
            };
            return PartialView("DataForModal", modalProduct);
        }
    }
}
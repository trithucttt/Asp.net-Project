using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Models;
using FashionShops.Models.CartForModal;
using FashionShops.Models.ProductDetail;
using System.Web.Security;

namespace FashionShops.Controllers.Products
{
    public class ProductController : Controller
    {
        // GET: Product
        FashionShopEntities data = new FashionShopEntities();
        public ActionResult Index()
        {
            var query = from p in data.Products select p;
            var infProduct = query.Take(12).ToList();
            return View(infProduct);
        }

        public ActionResult Pagination(int pageNumber, int pageSize)
        {
            int productsToSkip = (pageNumber - 1) * pageSize;
            var query = from p in data.Products select p;
            var listProduct = query.ToList().Skip(productsToSkip).Take(pageSize);
            return PartialView("Pagination", listProduct);
        }

        public int totalPage(int pageSize)
        {
            var product = from p in data.Products select p;
            int totalProduct = product.Count();
            int totalPage = (int)Math.Round((double)totalProduct / pageSize, MidpointRounding.AwayFromZero) + 1;
            return totalPage;
        }
        public ActionResult Detail(int id)
        {
            var querry1 = from product in data.Products
                          join proImage in data.Product_Image on product.product_id equals proImage.product_id
                          join Img in data.Images on proImage.image_id equals Img.image_id
                          join Q in data.Product_Quantity on product.product_id equals Q.product_id
                          where Img.image_id == (product.product_id - 1) * 3 + product.product_id
                          where product.product_id == id
                          select new ProductView
                          {
                              productID = (int)product.product_id,
                              productName = product.name,
                              productPrice = product.price,
                              content = product.describe,
                              imageUrl = Img.imgae_url,
                              QuantityPro =(int) Q.quantity
                          };
            var infProduct = querry1.ToList();
            var querry2 = from product in data.Products
                          join pI in data.Product_Image on product.product_id equals pI.product_id
                          join I in data.Images on pI.image_id equals I.image_id
                          where product.product_id == id
                          select new ImagesForProduct
                          {
                              productImgID = (int)I.image_id,
                              productUrlImg = I.imgae_url
                          };
            var imagesForPro = querry2.ToList();

            var querry4 = (from product in data.Products
                           join pQ in data.Product_Quantity on product.product_id equals pQ.product_id
                           join cor in data.Colors on pQ.color_id equals cor.color_id
                           where product.product_id == id
                           select new ColorsProForModal
                           {
                               colorID = (int)pQ.color_id,
                               colorName = cor.color1,
                               rgb = cor.rgb
                           });
            var colors = querry4.Distinct().ToList();

            var querry3 = (from product in data.Products
                           join pQ in data.Product_Quantity on product.product_id equals pQ.product_id
                           join sz in data.Sizes on pQ.size_id equals sz.size_id
                           where product.product_id == id
                           select new SizesProForModal
                           {
                               sizeID = (int)pQ.size_id,
                               sizeName = sz.size1
                           });
            var sizes = querry3.Distinct().OrderBy(s => s.sizeID).ToList();

            var detailPro = new ProductDetail
            {
                colorsForDetailPage = colors,
                sizesForDetailPage = sizes,
                infProduct = infProduct[0],
                imagesForProduct = imagesForPro
            };


            return View(detailPro);
        }
<<<<<<< HEAD
=======

        [HttpPost]
        public ActionResult AddToCart(FashionShops.Cart item)
        {
            if (Membership.GetUser() != null)
            {



                string userName = Membership.GetUser().UserName;
                int userId = (int)data.Users.FirstOrDefault(x => x.username == userName).user_id;




                //var query = from pe in data.Carts
                //                   where pe.product_id == item.product_id
                //                   where pe.size == item.size
                //                   where pe.color == item.color
                //                   select pe;


                //var product = data.Carts.FirstOrDefault(p => p.product_id == item.product_id).product_id;
                //var size = data.Carts.FirstOrDefault(s => s.size == item.size).size;
                //var color = data.Carts.FirstOrDefault(cl => cl.size == item.color).color;
                //    if(product != item.product_id && size != item.size && color != item.color)
                //    {
                //        var newPro = new FashionShops.Cart
                //        {
                //            user_id = userId,
                //            product_id = item.product_id,
                //            size = item.size,
                //            color = item.color,
                //            quantity = item.quantity,
                //            total_price = item.total_price
                //        };
                //        data.Carts.Add(newPro);
                //        if (data.SaveChanges() != 0)
                //        {
                //            return Content("Add product successfully!ff");
                //        }
                //        else
                //        {
                //            return Content("Add product failed !");
                //        }
                //    }
                //    item.quantity++;
                //}

                var existingItem = data.Carts.FirstOrDefault(c => c.user_id == userId && c.product_id == item.product_id && c.size == item.size && c.color == item.color);
                if (existingItem != null)
                {
                    
                    existingItem.quantity += item.quantity;
                }
                else
                {
                    
                    var newCartItem = new FashionShops.Cart
                    {
                        user_id = userId,
                        product_id = item.product_id,
                        size = item.size,
                        color = item.color,
                        quantity = item.quantity,
                        total_price = item.total_price
                    };
                    data.Carts.Add(newCartItem);
                }
                data.SaveChanges();
                return Content("Add product successfully!");

            }
            return Content("error");
        }
               




       
>>>>>>> a9f6118a4d007862025c6a84a3976f6292517dec
    }
}





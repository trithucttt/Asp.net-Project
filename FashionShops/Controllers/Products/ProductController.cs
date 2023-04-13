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
            int totalPage = (int)Math.Ceiling((double)totalProduct / pageSize);
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

<<<<<<< HEAD
            var reviews = (from rev in data.Product_Reviewing where rev.product_id == id select rev).ToList();
=======
            var review_querry = (from product in data.Products
                                 join pReview in data.Product_Reviewing on product.product_id equals pReview.product_id
                                 join user in data.Users on pReview.user_id equals user.user_id
                                 where pReview.product_id == id
                                 select new ProductReview
                                 {
                                     pReviewID = (int)pReview.id,
                                     product_id = (int)pReview.product_id,
                                     username = user.username,
                                     rating = pReview.rating,
                                     content = pReview.content,
                                     publishedAt = (DateTime)pReview.publishedAt
                                 }
                ).ToList();
>>>>>>> c6b8a21941e8b263f784fdcc778873b3961102ef

            var detailPro = new ProductDetail
            {
                colorsForDetailPage = colors,
                sizesForDetailPage = sizes,
                infProduct = infProduct[0],
                imagesForProduct = imagesForPro,
<<<<<<< HEAD
                reviewings = reviews
=======
                review = review_querry
>>>>>>> c6b8a21941e8b263f784fdcc778873b3961102ef
            };
            return View(detailPro);
        }

        [HttpPost]
        public ActionResult AddToCart(FashionShops.Cart item)
        {
            if (Membership.GetUser() != null)
            {
                string userName = Membership.GetUser().UserName;
                int userId = (int)data.Users.FirstOrDefault(x => x.username == userName).user_id;

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

        [HttpPost]
        public ActionResult AddReview(int productid, int rate, string content)
        {
            string userName = Membership.GetUser().UserName;
            int userId = (int)data.Users.FirstOrDefault(x => x.username == userName).user_id;
            int id = data.Product_Reviewing.Count() + 1;

            var newReview = new Product_Reviewing
            {
                id = id,
                user_id = userId,
                product_id = productid,
                rating = (short)rate,
                content = content,
                publishedAt = DateTime.Now
            };
            data.Product_Reviewing.Add(newReview);
<<<<<<< HEAD
            if(data.SaveChanges() != 0)
            {
                return Content("Thank you for rating!");
            } else
=======
            if (data.SaveChanges() != 0)
            {
                return Content("Thank you for rating!");
            }
            else
>>>>>>> c6b8a21941e8b263f784fdcc778873b3961102ef
            {
                return Content("Sorry, something went wrong, please try again later!");
            }
        }
    }
}





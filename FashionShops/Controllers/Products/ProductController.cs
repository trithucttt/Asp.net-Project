using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Models;
using FashionShops.Models.CartForModal;
using FashionShops.Models.ProductDetail;

namespace FashionShops.Controllers.Products
{
    public class ProductController : Controller
    {
        // GET: Product
        FashionShopEntities data = new FashionShopEntities();
        public ActionResult Index()
        {

            var query = from product in data.Products
                        join proImage in data.Product_Image on product.product_id equals proImage.product_id
                        join Img in data.Images on proImage.image_id equals Img.image_id
                        where Img.image_id == (product.product_id - 1) * 3 + product.product_id
                        select new ProductView
                        {
                            productID = (int)product.product_id,
                            productName = product.name,
                            productPrice = product.price,
                            imageUrl = Img.imgae_url
                        };
            var model = query.ToList();
            return View(model);
        }

        public ActionResult Detail(int id)
        {
            var querry1 = from product in data.Products
                          join proImage in data.Product_Image on product.product_id equals proImage.product_id
                          join Img in data.Images on proImage.image_id equals Img.image_id
                          where Img.image_id == (product.product_id - 1) * 3 + product.product_id
                          where product.product_id == id
                          select new ProductView
                          {
                              productID = (int)product.product_id,
                              productName = product.name,
                              productPrice = product.price,
                              imageUrl = Img.imgae_url,
                              content = product.describe
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
                           join cl in data.Colors on pQ.color_id equals cl.color_id
                           where product.product_id == id
                           select new ColorsProForModal
                           {
                               colorID = (int)pQ.color_id,
                               colorName = cl.color1,
                               rgb = cl.rgb
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



    }
}
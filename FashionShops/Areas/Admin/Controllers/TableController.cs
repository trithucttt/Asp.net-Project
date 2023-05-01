using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FashionShops.Areas.Admin.Models;
using Newtonsoft.Json;

namespace FashionShops.Areas.Admin.Controllers
{
    public class TableController : Controller
    {
        FashionShopEntities db = new FashionShopEntities();
        // GET: Admin/Table
        public ActionResult ProductTable()
        {
            var products = from p in db.Products select p;
            return View(products);
        }

        public ActionResult AddProduct()
        {
            var size = from s in db.Sizes select s;
            var color = from c in db.Colors select c;
            var category = from ct in db.Categories select ct;
            var tag = from t in db.Tags select t;
            var addProduct = new AddProduct
            {
                size = size.ToList(),
                color = color.ToList(),
                category = category.ToList(),
                tag = tag.ToList()
            };
            return View(addProduct);
        }

        [HttpPost]
        public ActionResult AddProductSubmit()
        {
            // add to product table
            Product newProduct = new Product
            {
                user_id = 1,
                name = Request.Form["product_name"],
                describe = Request.Form["product_describe"],
                price = Double.Parse(Request.Form["product_price"]),
                brand = Request.Form["product_brand"],
                product_availability = Request.Form["product_available"]
            };
            db.Products.Add(newProduct);
            db.SaveChanges();

            // get id product
            var a = db.Products.Where(x => x.name.Equals(newProduct.name)).FirstOrDefault();
            int proid = (int)a.product_id;

            // save Image
            var image1 = Request.Files["image1"];
            var fileName1 = Path.GetFileName(image1.FileName);
            var image2 = Request.Files["image2"];
            var fileName2 = Path.GetFileName(image2.FileName);
            var image3 = Request.Files["image3"];
            var fileName3 = Path.GetFileName(image3.FileName);
            var image4 = Request.Files["image4"];
            var fileName4 = Path.GetFileName(image4.FileName);
            var path1 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName1);
            var path2 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName2);
            var path3 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName3);
            var path4 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName4);

            if (System.IO.File.Exists(path1) && System.IO.File.Exists(path2) && System.IO.File.Exists(path3) && System.IO.File.Exists(path4))
            {
                return Content("One of the images already exists!");
            }
            else
            {
                image1.SaveAs(path1);
                image2.SaveAs(path2);
                image3.SaveAs(path3);
                image4.SaveAs(path4);
            }
            string[] arrNameImage = { fileName1, fileName2, fileName3, fileName4 };
            for (int i = 0; i < 4; i++)
            {
                db.Images.Add(new Image
                {
                    imgae_url = "../../Content/images/products/" + arrNameImage[i]
                });
            }
            db.SaveChanges();

            // get id image
            int idFilenName1 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName1)).FirstOrDefault().image_id;
            int idFilenName2 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName2)).FirstOrDefault().image_id;
            int idFilenName3 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName3)).FirstOrDefault().image_id;
            int idFilenName4 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName4)).FirstOrDefault().image_id;
            db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName1 });
            db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName2 });
            db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName3 });
            db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName4 });


            // save quantity
            string arrQuantityJson = Request.Form["arrQuantity"];
            int[] arrQuantity = JsonConvert.DeserializeObject<int[]>(arrQuantityJson);
            for (int i = 0; i < arrQuantity.Length; i+=3)
            {
                db.Product_Quantity.Add(new Product_Quantity
                {
                    product_id = proid,
                    size_id = arrQuantity[i],
                    color_id = arrQuantity[i+1],
                    quantity = arrQuantity[i+2]
                });
            }

            //save category
            string arrCategoryJson = Request.Form["arrCategory"];
            int[] arrCategory = JsonConvert.DeserializeObject<int[]>(arrCategoryJson);
            for (int i = 0; i < arrCategory.Length; i++)
            {
                db.Product_Category.Add(new Product_Category
                {
                    product_id = proid,
                    category_id = arrCategory[i]
                });
            }

            // save tag
            string arrTagJson = Request.Form["arrTag"];
            int[] arrTag = JsonConvert.DeserializeObject<int[]>(arrTagJson);
            for (int i = 0; i < arrTag.Length; i++)
            {
                db.Product_Tag.Add(new Product_Tag
                {
                    product_id = proid,
                    tag_id = arrTag[i]
                });
            }
            db.SaveChanges();
            return Content("Add product successfully!");
        }

        public ActionResult EditProduct(int id_product)
        {
            var product = db.Products.FirstOrDefault(x => x.product_id == id_product);
            var size = (from s in db.Sizes select s).ToList();
            var color = from c in db.Colors select c;
            var category = from ct in db.Categories select ct;
            var tag = from t in db.Tags select t;
            AddProduct addProduct = new AddProduct
            {
                product = product,
                size = size,
                color = color.ToList(),
                category = category.ToList(),
                tag = tag.ToList()
            };
            return View(addProduct);
        }

        [HttpPost]
        public ActionResult EditProduct()
        {
            // get id product
            //string temp = Request.Form["product_id"];
            int proid = Int32.Parse(Request.Form["product_id"]);

            // add to product table
            var productEdit = db.Products.FirstOrDefault(x => x.product_id == proid);
            productEdit.name = Request.Form["product_name"];
            productEdit.describe = Request.Form["product_describe"];
            productEdit.price = Double.Parse(Request.Form["product_price"]);
            productEdit.brand = Request.Form["product_brand"];
            productEdit.product_availability = Request.Form["product_available"];

            // save Image
            if (Request.Form["isClickEditImage"].Equals("true"))
            {
                // delete old Imgage
                string im1 = db.Product_Image.Where(x => x.product_id == proid).ToList()[0].Image.imgae_url.Substring(30);
                string im2 = db.Product_Image.Where(x => x.product_id == proid).ToList()[1].Image.imgae_url.Substring(30);
                string im3 = db.Product_Image.Where(x => x.product_id == proid).ToList()[2].Image.imgae_url.Substring(30);
                string im4 = db.Product_Image.Where(x => x.product_id == proid).ToList()[3].Image.imgae_url.Substring(30);
                var path11 = Path.Combine(Server.MapPath("~/Content/images/products"), im1);
                var path22 = Path.Combine(Server.MapPath("~/Content/images/products"), im2);
                var path33 = Path.Combine(Server.MapPath("~/Content/images/products"), im3);
                var path44 = Path.Combine(Server.MapPath("~/Content/images/products"), im4);
                System.IO.File.Delete(path11);
                System.IO.File.Delete(path22);
                System.IO.File.Delete(path33);
                System.IO.File.Delete(path44);

                int idIm1 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[0].Image.image_id;
                int idIm2 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[1].Image.image_id;
                int idIm3 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[2].Image.image_id;
                int idIm4 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[3].Image.image_id;

                var idList = new List<int> { idIm1, idIm2, idIm3, idIm4 };
                var oldProImage = db.Product_Image.Where(x => x.product_id == proid);
                var oldImage = db.Images.Where(x => idList.Contains((int)x.image_id));
                db.Images.RemoveRange(oldImage);
                db.Product_Image.RemoveRange(oldProImage);
                db.SaveChanges();

                var image1 = Request.Files["image1"];
                var fileName1 = Path.GetFileName(image1.FileName);
                var image2 = Request.Files["image2"];
                var fileName2 = Path.GetFileName(image2.FileName);
                var image3 = Request.Files["image3"];
                var fileName3 = Path.GetFileName(image3.FileName);
                var image4 = Request.Files["image4"];
                var fileName4 = Path.GetFileName(image4.FileName);
                var path1 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName1);
                var path2 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName2);
                var path3 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName3);
                var path4 = Path.Combine(Server.MapPath("~/Content/images/products"), fileName4);

                if (System.IO.File.Exists(path1) && System.IO.File.Exists(path2) && System.IO.File.Exists(path3) && System.IO.File.Exists(path4))
                {
                    return Content("One of the images already exists!");
                }
                else
                {
                    image1.SaveAs(path1);
                    image2.SaveAs(path2);
                    image3.SaveAs(path3);
                    image4.SaveAs(path4);
                }
                string[] arrNameImage = { fileName1, fileName2, fileName3, fileName4 };
                for (int i = 0; i < 4; i++)
                {
                    db.Images.Add(new Image
                    {
                        imgae_url = "../../Content/images/products/" + arrNameImage[i]
                    });
                }
                db.SaveChanges();

                // get id image and add file
                int idFilenName1 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName1)).FirstOrDefault().image_id;
                int idFilenName2 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName2)).FirstOrDefault().image_id;
                int idFilenName3 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName3)).FirstOrDefault().image_id;
                int idFilenName4 = (int)db.Images.Where(x => x.imgae_url.Equals("../../Content/images/products/" + fileName4)).FirstOrDefault().image_id;
                db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName1 });
                db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName2 });
                db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName3 });
                db.Product_Image.Add(new Product_Image { product_id = proid, image_id = idFilenName4 });
            }

           


            // delete old data
            var oldQuantity = db.Product_Quantity.Where(x => x.product_id == proid);
            var oldProductCategory = db.Product_Category.Where(x => x.product_id == proid);
            var oldProductTag = db.Product_Tag.Where(x => x.product_id == proid);
            db.Product_Quantity.RemoveRange(oldQuantity);
            db.Product_Tag.RemoveRange(oldProductTag);
            db.Product_Category.RemoveRange(oldProductCategory);
            db.SaveChanges();


            // save new quantity
            string arrQuantityJson = Request.Form["arrQuantity"];
            int[] arrQuantity = JsonConvert.DeserializeObject<int[]>(arrQuantityJson);
            for (int i = 0; i < arrQuantity.Length; i += 3)
            {
                db.Product_Quantity.Add(new Product_Quantity
                {
                    product_id = proid,
                    size_id = arrQuantity[i],
                    color_id = arrQuantity[i + 1],
                    quantity = arrQuantity[i + 2]
                });
            }


            //save bew category
            string arrCategoryJson = Request.Form["arrCategory"];
            int[] arrCategory = JsonConvert.DeserializeObject<int[]>(arrCategoryJson);
            for (int i = 0; i < arrCategory.Length; i++)
            {
                db.Product_Category.Add(new Product_Category
                {
                    product_id = proid,
                    category_id = arrCategory[i]
                });
            }

            // save new tag
            string arrTagJson = Request.Form["arrTag"];
            int[] arrTag = JsonConvert.DeserializeObject<int[]>(arrTagJson);
            for (int i = 0; i < arrTag.Length; i++)
            {
                db.Product_Tag.Add(new Product_Tag
                {
                    product_id = proid,
                    tag_id = arrTag[i]
                });
            }
            db.SaveChanges();
            return Content("Edit product successfully!");
        }

        [HttpPost]
        public ActionResult DeleteProduct(int proid)
        {
            // delete Image file
            string im1 = db.Product_Image.Where(x => x.product_id == proid).ToList()[0].Image.imgae_url.Substring(30);
            string im2 = db.Product_Image.Where(x => x.product_id == proid).ToList()[1].Image.imgae_url.Substring(30);
            string im3 = db.Product_Image.Where(x => x.product_id == proid).ToList()[2].Image.imgae_url.Substring(30);
            string im4 = db.Product_Image.Where(x => x.product_id == proid).ToList()[3].Image.imgae_url.Substring(30);
            var path11 = Path.Combine(Server.MapPath("~/Content/images/products"), im1);
            var path22 = Path.Combine(Server.MapPath("~/Content/images/products"), im2);
            var path33 = Path.Combine(Server.MapPath("~/Content/images/products"), im3);
            var path44 = Path.Combine(Server.MapPath("~/Content/images/products"), im4);
            System.IO.File.Delete(path11);
            System.IO.File.Delete(path22);
            System.IO.File.Delete(path33);
            System.IO.File.Delete(path44);


            // delete old data
            int idIm1 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[0].Image.image_id;
            int idIm2 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[1].Image.image_id;
            int idIm3 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[2].Image.image_id;
            int idIm4 = (int)db.Product_Image.Where(x => x.product_id == proid).ToList()[3].Image.image_id;
            var oldQuantity = db.Product_Quantity.Where(x => x.product_id == proid);
            var oldProductCategory = db.Product_Category.Where(x => x.product_id == proid);
            var oldProductTag = db.Product_Tag.Where(x => x.product_id == proid);
            var idList = new List<int> { idIm1, idIm2, idIm3, idIm4 };
            var oldProImage = db.Product_Image.Where(x => x.product_id == proid);
            var oldImage = db.Images.Where(x => idList.Contains((int)x.image_id));
            var oldReViewing = db.Product_Reviewing.Where(x => x.product_id == proid);
            var productDelete = db.Products.FirstOrDefault(x => x.product_id == proid);
            var oldProInCart = db.Carts.Where(x => x.product_id == proid);
            var oldOrderItems = db.Order_Item.Where(x => x.product_id == proid);
            db.Product_Quantity.RemoveRange(oldQuantity);
            db.Product_Tag.RemoveRange(oldProductTag);
            db.Product_Category.RemoveRange(oldProductCategory);
            db.Images.RemoveRange(oldImage);
            db.Product_Image.RemoveRange(oldProImage);
            db.Product_Reviewing.RemoveRange(oldReViewing);
            db.Carts.RemoveRange(oldProInCart);
            db.Order_Item.RemoveRange(oldOrderItems);
            db.SaveChanges();
            db.Products.Remove(productDelete);
            db.SaveChanges();
            return RedirectToAction("ProductTable");
        }
    }
}